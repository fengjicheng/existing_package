*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SALES_REP_ASSNT (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used for changes or checks,
*                      before a document is saved.
* DEVELOPER: Sarada Mukherjee (SARMUKHERJ)
* CREATION DATE:   11/09/2016
* OBJECT ID: E130
* TRANSPORT NUMBER(S): ED2K903282
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907442
* REFERENCE NO: CR#606
* DEVELOPER: Writtick Roy (WROY)
* DATE:  08/16/2017
* DESCRIPTION: BOM Components should have Sales Reps from BOM Header
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909565
* REFERENCE NO: ERP-4832
* DEVELOPER: Writtick Roy (WROY)
* DATE:  11/27/2017
* DESCRIPTION: Check Personnel No (Sales Rep) against HR Master Record
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909565
* REFERENCE NO: ERP-7764
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE:  11/19/2018
* DESCRIPTION: New Logic for Sales Rep determination
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K919012
* REFERENCE NO: ERPM-15005
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 28-JULY-2020
* DESCRIPTION: Sales Territory/Credit Alignment
* Aviod the Sales Rep from incoming Orders and Trigger the Sales Rep
* determination from PIGS table if the PO Type of the incoming order is
* active in ZCACONSTANT table
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SALES_REP_ASSNT
*&---------------------------------------------------------------------*

  " Local Types
*** BOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012
  TYPES: BEGIN OF ty_const_e130,
           devid  TYPE zdevid,              " Development ID
           param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
           param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
           low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         END OF ty_const_e130,
         BEGIN OF ty_vbpa,
           vbeln TYPE vbeln,
           posnr TYPE posnr,
           parvw TYPE parvw,
           kunnr TYPE kunnr,
           pernr TYPE pernr_d,
         END OF ty_vbpa,
         tt_const_e130 TYPE STANDARD TABLE OF ty_const_e130 INITIAL SIZE 0,
         tt_vbpa       TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0.
*** EOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012

* Local work area declaration
  DATA:
    lst_xvbak   TYPE zstqtc_salesrep,
    lst_so_item TYPE vbapvb,
    lst_xvbpa   TYPE vbpavb.

* Local variable declaration
  DATA:
    lv_sls_rep1        TYPE zzsrep1,                                     " Sales Representative 1
    lv_sls_rep2        TYPE zzsrep2,                                     " Sales Representative 2
    lv_potype          TYPE salv_de_selopt_low,       "ADD:CR#7764  KKRAVURI20190128
    lv_salesrep_det    TYPE boolean VALUE abap_false, "ADD:CR#7764  KKRAVURI20190128
    lv_potype_new      TYPE salv_de_selopt_low,       "ADD:CR#7764  KKRAVURI20190128
    lv_salesrep_pigs   TYPE abap_bool VALUE abap_false, " ++ ERPM-15005
    i_const_e130       TYPE tt_const_e130,              " ++ ERPM-15005
    li_vbpa            TYPE tt_vbpa,                    " ++ ERPM-15005
    lr_param2          TYPE RANGE OF rvari_vnam,        " ++ ERPM-15005
    lr_devid           TYPE RANGE OF zdevid,            " ++ ERPM-15005
    lv_vbeln           TYPE vbeln,                      " ++ ERPM-15005
    lv_aflag_erpm15005 TYPE zactive_flag.               " ++ ERPM-15005

* Local constant declaration
  CONSTANTS:
    lc_change_v   TYPE trtyp   VALUE 'V',     " ++ ERPM-15005       " Tx Type: Change
    lc_parvw_ve   TYPE parvw   VALUE 'VE',                          " Partner function 'Sales Rep-1'
    lc_parvw_ze   TYPE parvw   VALUE 'ZE',                          " Partner function 'Sales Rep-2'
    lc_parvw_ag   TYPE parvw   VALUE 'AG',                          " Partner function 'Sold-to'
*** BOC: CR7764 KKRAVURI20181119  ED2K913891
    lc_parvw_we   TYPE parvw   VALUE 'WE',                          " Partner function 'Ship-to'
    lc_param1     TYPE rvari_vnam VALUE 'PO_TYPE',
    lc_param2     TYPE rvari_vnam VALUE 'BSARK',
    lc_devid_e129 TYPE zdevid     VALUE 'E129',
*** EOC: CR7764 KKRAVURI20181119  ED2K913891
*** BOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012
    lc_devid_e130 TYPE zdevid     VALUE 'E130',
    lc_e130_p2    TYPE rvari_vnam VALUE 'CLEAR_SLSREP',
    lc_snum_2     TYPE zsno     VALUE '002',
    lc_vkey       TYPE zvar_key VALUE 'ERPM15005'.
*** EOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012

  FIELD-SYMBOLS:
    <lst_xvbpa> TYPE vbpavb.

* Populating FM importing parameter data
  lst_xvbak-vkorg = vbak-vkorg.                                   " sales Org.
  lst_xvbak-vtweg = vbak-vtweg.                                   " Distribution Channel
  lst_xvbak-spart = vbak-spart.                                   " Division
  lst_xvbak-kunnr = vbak-kunnr.                                   " Customer Number
  lst_xvbak-kvgr1 = vbak-kvgr1.                                   " Customer Group
  lst_xvbak-erdat = vbak-erdat.                                   " Date on Which Record Was Created
*** BOC: CR7764 KKRAVURI20181119  ED2K913891
  lst_xvbak-bsark = vbak-bsark.
*** EOC: CR7764 KKRAVURI20181119  ED2K913891


*** BOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012
  " Build Range for DevId, and Parameter-2
  lr_devid = VALUE #(
                  ( sign = 'I' option = 'EQ' low = lc_devid_e129 )
                  ( sign = 'I' option = 'EQ' low = lc_devid_e130 ) ).

  lr_param2 = VALUE #(
                  ( sign = 'I' option = 'EQ' low = lc_param2 )
                  ( sign = 'I' option = 'EQ' low = lc_e130_p2 ) ).

  " Fetch the PO Type from ZCACONSTANT table
  " If Order PO Type is active in ZCACONSTANT, then only Sales Rep determination
  " logic will be triggered
  SELECT devid param1 param2 low FROM zcaconstant INTO TABLE i_const_e130
                                  WHERE devid IN lr_devid AND
                                        param1 = lc_param1 AND
                                        param2 IN lr_param2 AND
                                        low = lst_xvbak-bsark AND
                                        activate = abap_true.
  IF sy-subrc = 0.
    " Nothing to do
  ENDIF.

  " Fetch the enhancement control for ERPM-15005
  " If enhancement control is active for ERPM-15005, then only
  " ERPM-15005 changes will be considered for execution
  SELECT SINGLE active_flag FROM zca_enh_ctrl INTO lv_aflag_erpm15005
                            WHERE wricef_id = lc_wricef_id_e130 AND
                                    ser_num = lc_snum_2 AND
                                    var_key = lc_vkey AND
                                active_flag = abap_true.
  IF sy-subrc = 0.
    " If Order PO Type is active in ZCACONSTANT against Dev Id: E130, then
    " Sales Rep should be determined from PIGS table as per ERPM-15005
    " Otherwise Continue with the old Logic
    READ TABLE i_const_e130 WITH KEY devid = lc_devid_e130 low = lst_xvbak-bsark
                            TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      " Check for Doc Change/Create
      IF t180-trtyp = lc_change_v.
        " Scenario: Change of Sales Doc
        " Check if Sales Doc has an Invoice or Not.
        " If it has no Invoice then Determine the Sales Rep
        " From PIGS Table
        SELECT SINGLE vbfa~vbeln INTO lv_vbeln
               FROM vbfa INNER JOIN vbrk
                 ON vbfa~vbeln = vbrk~vbeln
              WHERE vbfa~vbelv = vbak-vbeln AND     " Sales Doc - Order / Contract (Source)
                    vbfa~vbtyp_n = vbtyp_rech AND   " SD Doc Category - M (Invoice)
                    vbrk~fksto = abap_false.        " Billing document is cancelled
        IF sy-subrc <> 0.
          " IF Sales Doc has no Invoice, then trigger Sales Rep determination
          lv_salesrep_det = abap_true.
          lv_salesrep_pigs = abap_true.
        ELSE.
          " Scenario: Change of Sales Doc
          " If Sales Doc has an Invoice then Sales Rep Shouldn't be determined
          " as well Sales Rep Shouldn't be changed

          lv_salesrep_pigs = abap_true. " Set the Flag to avoid Sales Rep determination
          " Fetch all the existing Sales Reps from DB table
          SELECT vbeln posnr parvw kunnr pernr
                 FROM vbpa INTO TABLE li_vbpa
                 WHERE vbeln = vbak-vbeln AND
                       ( parvw = lc_parvw_ve OR parvw = lc_parvw_ze ).
          IF sy-subrc = 0.
            SORT li_vbpa BY vbeln posnr parvw.

            " Iterate the Partner functions and Get back the Original Sales Reps
            LOOP AT xvbpa ASSIGNING FIELD-SYMBOL(<lst_vbpa_fs>) WHERE parvw = lc_parvw_ve OR
                                                                      parvw = lc_parvw_ze.
              READ TABLE li_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = <lst_vbpa_fs>-vbeln
                                                              posnr = <lst_vbpa_fs>-posnr
                                                              parvw = <lst_vbpa_fs>-parvw BINARY SEARCH.
              IF sy-subrc = 0.
                <lst_vbpa_fs>-pernr = lst_vbpa-pernr.
                CLEAR lst_vbpa.
              ELSE.
                DELETE xvbpa[].
              ENDIF.
            ENDLOOP.
          ELSE.
            " If Sales Reps are not available in the existing Sales Doc, then
            " delete them from Sales Doc if available
            DELETE xvbpa[] WHERE vbeln = vbak-vbeln AND parvw = lc_parvw_ve.
            DELETE xvbpa[] WHERE vbeln = vbak-vbeln AND parvw = lc_parvw_ze.
          ENDIF. " IF sy-subrc = 0.
        ENDIF. " IF sy-subrc <> 0.
      ELSE.
        " Scenario: Sales Doc Creation
        lv_salesrep_det = abap_true.
        lv_salesrep_pigs = abap_true.
      ENDIF.
    ELSE.
      " Nothing to do
    ENDIF. "  IF sy-subrc = 0. of READ TABLE i_const_e130
  ELSE.
    " Nothing to do
  ENDIF. " IF sy-subrc = 0. of SELECT SINGLE
*** EOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012


  LOOP AT xvbap INTO lst_so_item.
    CLEAR: lv_sls_rep1, lv_sls_rep2.

*--------------------------------------------------------------------*
*  Assumption: We are taking the Sold-to Party Address
*--------------------------------------------------------------------*
    READ TABLE xvbpa[] INTO lst_xvbpa WITH KEY vbeln = lst_so_item-vbeln
                                               posnr = lst_so_item-posnr
                                               parvw = lc_parvw_ag.
    IF sy-subrc NE 0.
      READ TABLE xvbpa[] INTO lst_xvbpa WITH KEY vbeln = lst_so_item-vbeln
                                                 posnr = posnr_low
                                                 parvw = lc_parvw_ag.
    ENDIF.
    IF sy-subrc EQ 0.

*   Check for Sales Rep-1
      READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                        posnr = lst_so_item-posnr
                                                        parvw = lc_parvw_ve.
      IF sy-subrc NE 0.
        READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                          posnr = posnr_low
                                                          parvw = lc_parvw_ve.
      ENDIF.
      IF sy-subrc EQ 0.
        lv_sls_rep1 = <lst_xvbpa>-pernr.
      ENDIF.

*   Check for Sales Rep-2
      READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                        posnr = lst_so_item-posnr
                                                        parvw = lc_parvw_ze.
      IF sy-subrc NE 0.
        READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                          posnr = posnr_low
                                                          parvw = lc_parvw_ze.
      ENDIF.
      IF sy-subrc EQ 0.
        lv_sls_rep2 = <lst_xvbpa>-pernr.
      ENDIF.

*** BOC: CR#7764  KKRAVURI20190128  ED2K914341
*** In below IF condition OR is commented and AND is added
*** as per CR#7764 changes
*   If any one - Sales Rep-1 / Sales Rep-2 is not populated, then only proceed further
*    IF lv_sls_rep1 IS INITIAL OR
*       lv_sls_rep2 IS INITIAL.

*** BOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012
*** Below check is added as per ERPM-15005 requirement.
*   " As per ERPM-15005 requirement, Aviod the Sales Rep from Orders and Pickit up
*   " from PIGS table if Sale Document 'PO Type' is active in ZCACONSTANT table
      IF lv_salesrep_pigs = abap_false.
*** EOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012
        IF lv_sls_rep1 IS INITIAL AND lv_sls_rep2 IS INITIAL.
          " Trigger the Sales Rep determination Logic only IF Sale Document 'PO Type' is
          " active at ZCACONSTNAT table OR Sale Document 'PO Type' is initial
          IF lst_xvbak-bsark IS INITIAL.
            lv_salesrep_det = abap_true.
          ELSE.
            " If Order PO Type is active in ZCACONSTANT, then trigger the Sales Rep determination
            " Logic
            READ TABLE i_const_e130 WITH KEY devid = lc_devid_e129 low = lst_xvbak-bsark
                                    TRANSPORTING NO FIELDS.
            IF sy-subrc = 0.
              lv_salesrep_det = abap_true.
            ENDIF.
          ENDIF.
        ENDIF. " IF lv_sls_rep1 IS INITIAL AND lv_sls_rep2 IS INITIAL.
*** BOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012
      ELSE. " --> IF lv_aflag_erpm15005 = abap_false.
        " Nothing to do
      ENDIF." IF lv_aflag_erpm15005 = abap_false.
*** EOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012

      IF lv_salesrep_det = abap_true.
*** EOC: CR#7764  KKRAVURI20190128  ED2K914341
*     Begin of ADD:CR#606:WROY:16-AUG-2017:ED2K907442
        IF lst_so_item-uepos IS INITIAL.
*     End   of ADD:CR#606:WROY:16-AUG-2017:ED2K907442
          lst_xvbak-adrnr = lst_xvbpa-adrnr.                        " Address Number
          lst_xvbak-matnr = lst_so_item-matnr.                      " Material Number
          lst_xvbak-prctr = lst_so_item-prctr.                      " Profit Center
*** BOC: CR7764 KKRAVURI20181119  ED2K913891
          CLEAR lst_xvbpa.
          READ TABLE xvbpa[] INTO lst_xvbpa WITH KEY vbeln = lst_so_item-vbeln
                                                     posnr = lst_so_item-posnr
                                                     parvw = lc_parvw_we.
          IF sy-subrc NE 0.
            READ TABLE xvbpa[] INTO lst_xvbpa WITH KEY vbeln = lst_so_item-vbeln
                                                       posnr = posnr_low
                                                       parvw = lc_parvw_we.
          ENDIF.
          IF sy-subrc = 0.
            lst_xvbak-ship_to = lst_xvbpa-kunnr.
            CLEAR lst_xvbpa.
          ENDIF.
*** EOC: CR7764 KKRAVURI20181119  ED2K913891
*       Function module call to get the sales representative value
*** BOC: CR7764 KKRAVURI20181119  ED2K913891
*   Below FM Call is commented per CR7764
*        CALL FUNCTION 'ZQTC_SALES_REP_ASSIGNMENT_DET'
*          EXPORTING
*            im_srep_det = lst_xvbak                               " Sales Rep data
*          IMPORTING
*            ex_srep1    = lv_sls_rep1                             " sales rep 1
*            ex_srep2    = lv_sls_rep2.
          " sales rep 2
*   Below new FM Call is per CR7764
          " Clear the Sales Reps which exits at Sales Doc level
          CLEAR: lv_sls_rep1, lv_sls_rep2.                          " ++ ERPM-15005
          CALL FUNCTION 'ZQTC_SALES_REP_ASSMNT_DET_NEW'
            EXPORTING
              im_srep_det = lst_xvbak                               " Sales Rep data
            IMPORTING
              ex_srep1    = lv_sls_rep1                             " sales rep 1
              ex_srep2    = lv_sls_rep2.                            " sales rep 2

*** EOC: CR7764 KKRAVURI20181119  ED2K913891
*     Begin of ADD:CR#606:WROY:16-AUG-2017:ED2K907442
        ELSE.
          " Check for Sales Rep-1 of BOM Header
          READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                            posnr = lst_so_item-uepos
                                                            parvw = lc_parvw_ve.
          IF sy-subrc EQ 0.
            lv_sls_rep1 = <lst_xvbpa>-pernr.
          ENDIF.

          " Check for Sales Rep-2 of BOM Header
          READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                            posnr = lst_so_item-uepos
                                                            parvw = lc_parvw_ze.
          IF sy-subrc EQ 0.
            lv_sls_rep2 = <lst_xvbpa>-pernr.
          ENDIF.
        ENDIF.
*     End   of ADD:CR#606:WROY:16-AUG-2017:ED2K907442

*     Assign Sales Rep-1 if not populated already
        IF lv_sls_rep1 IS NOT INITIAL.

***  BOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012
          " Run the below logic only if ERPM-15005 is active and Sales Rep should be determined
          " from PIGS table, otherwise run the old logic
          IF lv_aflag_erpm15005 = abap_true AND lv_salesrep_pigs = abap_true.
            " Check Personnel Number against HR Master Record
            CALL FUNCTION 'RP_CHECK_PERNR'
              EXPORTING
                beg               = sy-datum
                pnr               = lv_sls_rep1
              EXCEPTIONS
                data_fault        = 1
                person_not_active = 2
                person_unknown    = 3
                exit_fault        = 4
                pernr_missing     = 5
                date_missing      = 6
                OTHERS            = 7.
            CASE sy-subrc.
              WHEN 0.
                " Nothing to do
              WHEN 2.
                MESSAGE w002(vpd) WITH 'Employee'(z01) lv_sls_rep1.
              WHEN OTHERS.
                MESSAGE ID sy-msgid
                      TYPE charw
                    NUMBER sy-msgno
                      WITH sy-msgv1
                           sy-msgv2
                           sy-msgv3
                           sy-msgv4.
            ENDCASE.
            IF <lst_xvbpa> IS ASSIGNED.
              UNASSIGN <lst_xvbpa>.
            ENDIF.
            READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                              posnr = lst_so_item-posnr
                                                              parvw = lc_parvw_ve.
            IF sy-subrc = 0.
              IF <lst_xvbpa>-pernr <> lv_sls_rep1.
                <lst_xvbpa>-pernr = lv_sls_rep1.
                IF <lst_xvbpa>-updkz <> updkz_new.
                  <lst_xvbpa>-updkz = updkz_update.
                ENDIF.
              ENDIF.
            ELSE.
              APPEND INITIAL LINE TO xvbpa ASSIGNING <lst_xvbpa>.
              <lst_xvbpa>-vbeln = lst_so_item-vbeln.
              <lst_xvbpa>-posnr = lst_so_item-posnr.
              <lst_xvbpa>-parvw = lc_parvw_ve.
              <lst_xvbpa>-pernr = lv_sls_rep1.
              <lst_xvbpa>-updkz = updkz_new.
            ENDIF.

          ELSE. " --> IF lv_salesrep_pigs = abap_true.
***  EOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012
            READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                    posnr = lst_so_item-posnr
                                                    parvw = lc_parvw_ve.
            IF sy-subrc NE 0.
              READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                                posnr = posnr_low
                                                                parvw = lc_parvw_ve.
            ENDIF.
            IF sy-subrc NE 0.
*         Begin of ADD:ERP-4832:WROY:27-Nov-2017:ED2K909565
*         Check Personnel Number against HR Master Record
              CALL FUNCTION 'RP_CHECK_PERNR'
                EXPORTING
                  beg               = sy-datum
                  pnr               = lv_sls_rep1
                EXCEPTIONS
                  data_fault        = 1
                  person_not_active = 2
                  person_unknown    = 3
                  exit_fault        = 4
                  pernr_missing     = 5
                  date_missing      = 6
                  OTHERS            = 7.
              CASE sy-subrc.
                WHEN 0.
*             Nothing to do
                WHEN 2.
                  MESSAGE w002(vpd) WITH 'Employee'(z01) lv_sls_rep1.
                WHEN OTHERS.
                  MESSAGE ID sy-msgid
                        TYPE charw
                      NUMBER sy-msgno
                        WITH sy-msgv1
                             sy-msgv2
                             sy-msgv3
                             sy-msgv4.
              ENDCASE.
*         End   of ADD:ERP-4832:WROY:27-Nov-2017:ED2K909565

              APPEND INITIAL LINE TO xvbpa ASSIGNING <lst_xvbpa>.
              <lst_xvbpa>-vbeln = lst_so_item-vbeln.
              <lst_xvbpa>-posnr = lst_so_item-posnr.
              <lst_xvbpa>-parvw = lc_parvw_ve.
              <lst_xvbpa>-pernr = lv_sls_rep1.
              <lst_xvbpa>-updkz = updkz_new.
            ENDIF. " IF sy-subrc NE 0.
          ENDIF. " IF lv_aflag_erpm15005 = abap_true.

        ENDIF.  " IF lv_sls_rep1 IS NOT INITIAL.

*     Assign Sales Rep-2 if not populated already
        IF lv_sls_rep2 IS NOT INITIAL.

***  BOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012
          " Run the below logic only if ERPM-15005 is active and Sales Rep should be determined
          " from PIGS table, otherwise run the old logic
          IF lv_aflag_erpm15005 = abap_true AND lv_salesrep_pigs = abap_true.
            " Check Personnel Number against HR Master Record
            CALL FUNCTION 'RP_CHECK_PERNR'
              EXPORTING
                beg               = sy-datum
                pnr               = lv_sls_rep2
              EXCEPTIONS
                data_fault        = 1
                person_not_active = 2
                person_unknown    = 3
                exit_fault        = 4
                pernr_missing     = 5
                date_missing      = 6
                OTHERS            = 7.
            CASE sy-subrc.
              WHEN 0.
                " Nothing to do
              WHEN 2.
                MESSAGE w002(vpd) WITH 'Employee'(z01) lv_sls_rep2.
              WHEN OTHERS.
                MESSAGE ID sy-msgid
                      TYPE charw
                    NUMBER sy-msgno
                      WITH sy-msgv1
                           sy-msgv2
                           sy-msgv3
                           sy-msgv4.
            ENDCASE.
            IF <lst_xvbpa> IS ASSIGNED.
              UNASSIGN <lst_xvbpa>.
            ENDIF.
            READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                              posnr = lst_so_item-posnr
                                                              parvw = lc_parvw_ze.
            IF sy-subrc = 0.
              IF <lst_xvbpa>-pernr <> lv_sls_rep2.
                <lst_xvbpa>-pernr = lv_sls_rep2.
                IF <lst_xvbpa>-updkz <> updkz_new.
                  <lst_xvbpa>-updkz = updkz_update.
                ENDIF.
              ENDIF.
            ELSE.
              APPEND INITIAL LINE TO xvbpa ASSIGNING <lst_xvbpa>.
              <lst_xvbpa>-vbeln = lst_so_item-vbeln.
              <lst_xvbpa>-posnr = lst_so_item-posnr.
              <lst_xvbpa>-parvw = lc_parvw_ze.
              <lst_xvbpa>-pernr = lv_sls_rep2.
              <lst_xvbpa>-updkz = updkz_new.
            ENDIF.

          ELSE. " --> IF lv_salesrep_pigs = abap_true.
***  EOC  ERPM-15005  KKRAVURI  28-JULY-2020  ED2K919012
            READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                              posnr = lst_so_item-posnr
                                                              parvw = lc_parvw_ze.
            IF sy-subrc NE 0.
              READ TABLE xvbpa[] ASSIGNING <lst_xvbpa> WITH KEY vbeln = lst_so_item-vbeln
                                                                posnr = posnr_low
                                                                parvw = lc_parvw_ze.
            ENDIF.
            IF sy-subrc NE 0.
*         Begin of ADD:ERP-4832:WROY:27-Nov-2017:ED2K909565
*         Check Personnel Number against HR Master Record
              CALL FUNCTION 'RP_CHECK_PERNR'
                EXPORTING
                  beg               = sy-datum
                  pnr               = lv_sls_rep2
                EXCEPTIONS
                  data_fault        = 1
                  person_not_active = 2
                  person_unknown    = 3
                  exit_fault        = 4
                  pernr_missing     = 5
                  date_missing      = 6
                  OTHERS            = 7.
              CASE sy-subrc.
                WHEN 0.
*             Nothing to do
                WHEN 2.
                  MESSAGE w002(vpd) WITH 'Employee'(z01) lv_sls_rep2.
                WHEN OTHERS.
                  MESSAGE ID sy-msgid
                        TYPE charw
                      NUMBER sy-msgno
                        WITH sy-msgv1
                             sy-msgv2
                             sy-msgv3
                             sy-msgv4.
              ENDCASE.
*         End   of ADD:ERP-4832:WROY:27-Nov-2017:ED2K909565

              APPEND INITIAL LINE TO xvbpa ASSIGNING <lst_xvbpa>.
              <lst_xvbpa>-vbeln = lst_so_item-vbeln.
              <lst_xvbpa>-posnr = lst_so_item-posnr.
              <lst_xvbpa>-parvw = lc_parvw_ze.
              <lst_xvbpa>-pernr = lv_sls_rep2.
              <lst_xvbpa>-updkz = updkz_new.
            ENDIF. " IF sy-subrc NE 0.
          ENDIF. " --> IF lv_aflag_erpm15005 = abap_true.

        ENDIF. " IF lv_sls_rep2 IS NOT INITIAL.
      ENDIF. " IF lv_salesrep_det = abap_true.

    ENDIF. " IF sy-subrc EQ 0. --> READ TABLE xvbpa[]

  ENDLOOP.
* Refresh Global Variables
  CALL FUNCTION 'ZQTC_SALES_REP_ASSIGNMENT_CLR'.
