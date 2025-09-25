*&---------------------------------------------------------------------*
*&  Include          ZQTCN_BKORDS_SAP_TO_UKCORE_SUB                    *
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_BKORDS_SAP_TO_UKCORE_SUB(Include Program for Methods)
* PROGRAM DESCRIPTION: Send Back Orders file to UK CORE
* DEVELOPER: Sivarami Reddy (SISIREDDY)
* CREATION DATE:   05/04/2022
* OBJECT ID:  I0516
* TRANSPORT NUMBER(S):ED2K926235
*----------------------------------------------------------------------*
*** Methods--------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*----------------------------------------------------------------------*
*       CLASS cl_main DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_main DEFINITION FINAL. " Main class
  PUBLIC SECTION.
* Type Declaration
    TYPES: BEGIN OF ty_file_txt,
             ean      TYPE char13,
             vchboqty TYPE char8,
             ismtitle TYPE char30,
             date     TYPE char8,
           END OF ty_file_txt.
    DATA: i_final_txt  TYPE STANDARD TABLE OF ty_file_txt INITIAL SIZE 0,
          i_final_csv  TYPE STANDARD TABLE OF ty_file_txt INITIAL SIZE 0,
          st_final_txt TYPE ty_file_txt,
          st_final_csv TYPE ty_file_txt.

    CLASS-METHODS: get_file_path  EXPORTING ex_file_path TYPE localfile.            "To get the File name
***************************************************************************
*Object Declaration                                                       *
***************************************************************************
    DATA :sel_obj       TYPE REF TO   lcl_sel .
***************************************************************************
*Methods Declaration                                                       *
***************************************************************************
    METHODS:constructor IMPORTING ref_sel TYPE REF TO lcl_sel .
*TO fetch STO Back Order Qty
    METHODS:fetch_backorders_po_data.
*To fetch SO Back Order Qty
    METHODS:fetch_backorders_so_data.
*To Process the file to UK Core through Application Server
    METHODS:send_backordersfile_to_ukcore.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION. " Main class
  METHOD constructor.
    me->sel_obj = ref_sel .
  ENDMETHOD .
  METHOD: get_file_path.
    CONSTANTS: lc_i0516        TYPE zdevid     VALUE 'I0516',     " Development ID
               lc_param1_fpath TYPE rvari_vnam VALUE 'FILE_PATH', " ABAP: Name of Variant Variable
               lc_logical_path TYPE rvari_vnam VALUE 'LOGICAL_PATH'. " Logical Path "NPOLINA ERP6378 ED2K913631

    DATA: lv_system_id TYPE rvari_vnam. " ABAP: Name of Variant Variable

*** fetch Data from ZCACONSTANT Table
    SELECT devid,    " Development ID
           param1,   " ABAP: Name of Variant Variable
           param2,   " ABAP: Name of Variant Variable
           srno,     " ABAP: Current selection number
           sign,     " ABAP: ID: I/E (include/exclude values)
           opti,     " ABAP: Selection option (EQ/BT/CP/...)
           low,      " Lower Value of Selection Condition
           high      " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE @DATA(li_constant)
    WHERE devid    = @lc_i0516
    AND   activate = @abap_true.

    IF sy-subrc = 0.
      SORT li_constant BY param1.
      DATA(lst_constant) = li_constant[ devid = lc_i0516 param1 = lc_logical_path  ].
      v_file_path = lst_constant-low.
    ENDIF.
  ENDMETHOD.
  METHOD fetch_backorders_so_data.
    DATA:lv_ismidentcode TYPE ismidentcode.
    CONSTANTS: lc_a TYPE char1     VALUE 'A',     " A
               lc_c TYPE char1     VALUE 'C',     " C
               lc_d TYPE char1     VALUE 'D'.     " D

**To get SO Backorder quantity
    SELECT a~vbeln,
           b~posnr,
           a~erdat,
           b~matnr,
           c~ismtitle
    INTO TABLE @DATA(li_sodata)
    FROM vbak AS a INNER JOIN vbap AS b
      ON a~vbeln = b~vbeln
      INNER JOIN mara AS c
      ON b~matnr = c~matnr
      INNER JOIN vbuk AS d
      ON a~vbeln = d~vbeln
    WHERE a~erdat IN @me->sel_obj->s_erdat
      AND a~auart IN @me->sel_obj->s_auart
      AND a~vkorg IN @me->sel_obj->s_vkorg
      AND a~vtweg IN @me->sel_obj->s_vtweg
      AND a~spart IN @me->sel_obj->s_spart
      AND b~matnr IN @me->sel_obj->s_matnr
      AND b~werks IN @me->sel_obj->s_werks
      AND c~mtart IN @me->sel_obj->s_mtart
      AND b~abgru EQ @space
      AND d~cmgst IN ( @lc_d,@lc_a ).
    IF sy-subrc EQ 0.
      SORT  :li_sodata BY vbeln posnr.
      IF li_sodata[] IS NOT INITIAL.
*Pass Sales Order Number (VBAP-VBELN), Item Number (VBAP-POSNR) into VBUP table where
*Confirmed Status (VBUP-BESTA NE ‘C’), Delivery status (VBUP-LFSTA NE 'C'), Overall Delivery
*status (VBUP-LFGSA NE ‘C’), Delivery block (VBUP-LSSTA EQ ‘blank’). Fetch the resultant Sales order lines
*Pass Sales Order Number (VBAP-VBLEN), Item Number (VBAP-POSNR)
*into VBEP table where VBAP-VBELN = VBEP-VBELN & VBAP-POSNR = VBEP-POSNR, then get the total
*cumulative ordered quantity of each item (VBEP-WMENG) and total cumulative confirmed quantity (VBEP-BMENG).
        SELECT a~vbeln,
               a~posnr,
               b~wmeng,
               b~bmeng
         INTO TABLE @DATA(li_soqty)
         FROM vbup AS a INNER JOIN vbep AS b
         ON  a~vbeln = b~vbeln
         AND a~posnr = b~posnr
         FOR ALL ENTRIES IN @li_sodata
         WHERE a~vbeln = @li_sodata-vbeln
         AND   a~posnr = @li_sodata-posnr
         AND   a~besta NE @lc_c  " Confirmed Status
         AND   a~lfsta NOT IN ( @lc_c,@space )  " Delivery status
         AND   a~lfgsa NE @lc_c  " Overall Delivery status
         AND   a~lssta NE @lc_c. " Delivery block
        IF sy-subrc EQ 0.
          SORT:li_soqty BY vbeln posnr.
        ENDIF.
      ENDIF.
    ENDIF.
* Process the Data to final Table.
    LOOP AT li_sodata INTO DATA(lst_sodata).
      LOOP AT li_soqty INTO DATA(lst_soqty) WHERE  vbeln = lst_sodata-vbeln
                                              AND  posnr = lst_sodata-posnr.
*      IF sy-subrc EQ 0.
*        EAN
        CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
          EXPORTING
            im_idcodetype      = c_zean
            im_sap_material    = lst_sodata-matnr
          IMPORTING
*           ex_sap_material    =
            ex_legacy_material = lv_ismidentcode
          EXCEPTIONS
            wrong_input_values = 1
            OTHERS             = 2.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        st_final_txt-ean =  lv_ismidentcode.
*        ISM Title
        st_final_txt-ismtitle =  lst_sodata-ismtitle.
        st_final_txt-date     =  sy-datum.
*      Calculate the difference between Total Cumulative Ordered Quantity
*      (VBEP-WMENG) minus total Cumulative Confirmed Quantity (VBEP-BMENG) as ‘VCH SO Backorder Quantity’
        DATA(lv_qty) = ( lst_soqty-wmeng - lst_soqty-bmeng ).
*        IF lv_qty GT 0.
        WRITE  lv_qty TO st_final_txt-vchboqty.
        CONDENSE st_final_txt-vchboqty.
        APPEND  st_final_txt TO i_final_txt.
*        ENDIF.
        CLEAR:st_final_txt.
*      ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
  METHOD fetch_backorders_po_data.
    DATA:lv_ismidentcode TYPE ismidentcode.
* To get PO Backorder quantity
    SELECT a~aedat,
           b~matnr,
           c~ismtitle,
           d~menge,
           d~mng02
     INTO TABLE @DATA(li_podata)
     FROM ekko AS a INNER JOIN ekpo AS b
      ON a~ebeln = b~ebeln
      INNER JOIN mara AS c
      ON b~matnr = c~matnr
      INNER JOIN eket AS d
      ON b~ebeln = d~ebeln
      AND b~ebelp = d~ebelp
     WHERE a~aedat IN @me->sel_obj->s_erdat
      AND  a~bsart IN @me->sel_obj->s_bsart
      AND  a~bukrs IN @me->sel_obj->s_bukrs
      AND  a~ekorg IN @me->sel_obj->s_ekorg
      AND  a~ekgrp IN @me->sel_obj->s_ekgrp
      AND  a~reswk IN @me->sel_obj->s_werks
      AND  b~matnr IN @me->sel_obj->s_matnr
      AND  c~mtart IN @me->sel_obj->s_mtart
      AND  b~loekz EQ @space.
* Process the Data to final Table.
    LOOP AT li_podata INTO DATA(lst_podata).
*   EAN
      CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
        EXPORTING
          im_idcodetype      = c_zean
          im_sap_material    = lst_podata-matnr
        IMPORTING
*         ex_sap_material    =
          ex_legacy_material = lv_ismidentcode
        EXCEPTIONS
          wrong_input_values = 1
          OTHERS             = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      st_final_txt-ean =  lv_ismidentcode.
*       ISM Title
      st_final_txt-ismtitle =  lst_podata-ismtitle.
      st_final_txt-date     =  sy-datum.
*Calculate the difference between total Scheduled Qty (EKET- MENGE) minus
*total committed quantity (EKET-MNG02) as ‘VCH STO Backorder Quantity’
      DATA(lv_qty) = ( lst_podata-menge - lst_podata-mng02 ).
*      IF lv_qty GT 0 .
      WRITE  lv_qty TO st_final_txt-vchboqty.
      CONDENSE st_final_txt-vchboqty.
      APPEND  st_final_txt TO i_final_txt.
*      ENDIF.
      CLEAR:st_final_txt.
    ENDLOOP.

  ENDMETHOD.

  METHOD send_backordersfile_to_ukcore.
*  *To get SO Backorder quantity and PO Backorder quantity
    IF me->sel_obj->ch_sos IS NOT INITIAL.
      CALL METHOD me->fetch_backorders_so_data( ).
    ENDIF.
    IF me->sel_obj->ch_pos IS NOT INITIAL.
      CALL METHOD me->fetch_backorders_po_data( ).
    ENDIF.
    DATA: lv_fname       TYPE aco_string,  " String
          lv_file        TYPE localfile,
          lv_length      TYPE i,           " Length of type Integers
          lv_path        TYPE filepath-pathintern,
          lv_final_csv   TYPE char100,
          lv_path_fname  TYPE string,
          lst_final_head TYPE char100.

    CONSTANTS: lc_vchboqty  TYPE char8  VALUE 'VCHBOQty', "
               lc_udrscore  TYPE char1  VALUE '_',     " Udrscore of type CHAR1
               lc_extension TYPE char4  VALUE '.CSV',  "
               lc_csv       TYPE c      VALUE ',',     " cama of type Character
               lc_doubleq   TYPE char1  VALUE '"', " Semico of type CHAR1
               lc_e         TYPE char1  VALUE 'E'.     "
*VCH Backorder Quantity per EAN
*VCHBOQty per EAN = Add the above calculated values for ‘VCH SO Backorder Quantity’ & ‘VCH STO Backorder Quantity’
    SORT:i_final_txt BY ean.
    DELETE i_final_txt WHERE ean = space.
    DATA:lv_qty TYPE char8.

    LOOP AT i_final_txt  INTO st_final_txt.
      st_final_csv-ean      = st_final_txt-ean.
      st_final_csv-ismtitle = st_final_txt-ismtitle.
      st_final_csv-date     = st_final_txt-date.
      lv_qty = lv_qty + st_final_txt-vchboqty.
      AT END OF ean.
        IF lv_qty GT 0.
          st_final_csv-vchboqty = lv_qty.
          CONDENSE st_final_csv-vchboqty.
          APPEND st_final_csv TO i_final_csv.
        ENDIF.
        CLEAR:st_final_txt,
              st_final_csv,
              lv_qty.
      ENDAT.
    ENDLOOP.
  CONCATENATE lc_vchboqty sy-datum INTO lv_file SEPARATED BY lc_udrscore.
    CLEAR:lv_path_fname,
          lv_path.
    lv_path = v_file_path.
    CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
      EXPORTING
        client                     = sy-mandt
        logical_path               = lv_path
        operating_system           = sy-opsys
        file_name                  = lv_file
        eleminate_blanks           = abap_true
      IMPORTING
        file_name_with_path        = lv_path_fname
      EXCEPTIONS
        path_not_found             = 1
        missing_parameter          = 2
        operating_system_not_found = 3
        file_system_not_found      = 4
        OTHERS                     = 5.
    IF sy-subrc <> 0.
      v_log = 'ERROR : File path not found.'(064).
      MESSAGE v_log TYPE lc_e.
      LEAVE LIST-PROCESSING.
    ELSE.
      lv_file = lv_path_fname.
    ENDIF.

*** Preparing file name
    CONCATENATE lv_file lc_extension INTO lv_fname.

    OPEN DATASET lv_fname FOR OUTPUT IN TEXT  MODE ENCODING UTF-8. " Output type
    " opening file
    IF sy-subrc NE 0. " if file not opened showing error message
      MESSAGE e045(zqtc_r2). " File cannot be opened.
      RETURN.
    ENDIF.

    CONCATENATE '"EAN",'(027) 'VCHBOQty,'(026) '"ShortTitle",'(028) '"Date"'(029) INTO lst_final_head.
    TRANSFER lst_final_head TO lv_fname.
    LOOP AT i_final_csv  INTO DATA(lst_final_csv).
      CONCATENATE    lc_doubleq lst_final_csv-ean lc_doubleq lc_csv
                     lst_final_csv-vchboqty lc_csv
                     lc_doubleq lst_final_csv-ismtitle lc_doubleq lc_csv
                     lc_doubleq lst_final_csv-date lc_doubleq INTO lv_final_csv.
      TRANSFER lv_final_csv TO lv_fname. " transfering data
    ENDLOOP.

    CLOSE DATASET  lv_fname. " closing file
    MESSAGE s203(zqtc_r2) WITH lv_fname.

  ENDMETHOD.
ENDCLASS.
