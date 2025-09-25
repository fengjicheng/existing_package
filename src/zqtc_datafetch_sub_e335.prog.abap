*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_DATAFETH_SUB_E335 (Fecth data and logic for additional fields)
* REVISION NO: ED2K919561                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  09/21/2020                                                    *
* DESCRIPTION: Add new fields to V_RA report
*----------------------------------------------------------------------*
* REVISION NO: ED2K919844                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/08/2020                                                    *
* DESCRIPTION: Logic changes in FUT level for Volume year, PO number , Del number
*              and ALV output/excel display for PO and deivery number
*----------------------------------------------------------------------*
* REVISION NO: ED2K919899                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/14/2020                                                    *
* DESCRIPTION: Logic changes for Subscrition order/Po count/add new Print vendor
*              display and remove duplicate from the PO number
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED2K925275                                              *
* REFERENCE NO: OTCM-51316                                             *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/20/2021                                                    *
* DESCRIPTION: Add new fields to input and output of V_RA Report
*----------------------------------------------------------------------*

TYPES : BEGIN OF ty_parvw,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE parvw,         " Partner Function
          high TYPE parvw,         " Partner Function
        END OF ty_parvw.

TYPES : BEGIN OF ty_order_count,
          vbeln      TYPE vbeln,
          posnr      TYPE posnr,
          kunnr      TYPE kunnr,
          vbap_vbeln TYPE vbeln,
          vbap_posnr TYPE posnr,
          matnr      TYPE matnr,
          auart      TYPE auart,
          count      TYPE n,
        END OF ty_order_count.

TYPES : BEGIN OF ty_sum_ordertype,
          kunnr TYPE kunnr,
          matnr TYPE matnr,
          count TYPE kwmeng,
        END OF ty_sum_ordertype.

DATA : li_order_count TYPE STANDARD TABLE OF ty_order_count INITIAL SIZE 0.
FIELD-SYMBOLS : <lfs_order_count>   TYPE ty_order_count.

DATA  : lis_sum_ortype TYPE SORTED TABLE OF ty_sum_ordertype WITH UNIQUE KEY kunnr matnr INITIAL SIZE 0,
        lst_sum_ortype TYPE ty_sum_ordertype.

DATA  : lst_parvw      TYPE ty_parvw,
        lv_tablename   TYPE char4,                       " Table Name
        lv_fieldname   TYPE char5,                       " Field Name
        lv_kunnr_matnr TYPE char28.

DATA :  ir_parvw   TYPE RANGE OF vbpa-parvw.      " Partner Function

DATA : li_lines_export    TYPE STANDARD TABLE OF tline INITIAL SIZE 0,     "Lines of text read
       li_ship_intro      TYPE TABLE OF txw_note INITIAL SIZE 0,
       lv_name_export     TYPE thead-tdname,
       lv_tmp_instruction TYPE char255,
       lv_deldate         TYPE char10,
       lv_arrivaldate     TYPE char10,
       lv_kwmeng          TYPE char16,
       lv_kbmeng          TYPE char16,
       lv_olfmng          TYPE char16.

* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
TYPES : BEGIN OF ty_ship2party,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE parvw,         " Partner Function
          high TYPE parvw,         " Partner Function
        END OF ty_ship2party.

DATA  : ir_ship2party  TYPE RANGE OF vbpa-parvw,      " Ship-to party Partner Function
        lst_ship2party TYPE ty_ship2party.

TYPES : BEGIN OF ty_po_count,
          vbeln      TYPE vbeln,
          posnr      TYPE posnr,
          kunnr      TYPE kunnr,
          matnr      TYPE matnr,
          ekkn_vbeln TYPE vbeln,
          ekkn_posnr TYPE vbelp,
          ebeln      TYPE ebeln,
          count      TYPE n,
        END OF ty_po_count.

TYPES : BEGIN OF ty_sum_ponumber,
          kunnr TYPE kunnr,
          matnr TYPE matnr,
          count TYPE kwmeng,
        END OF ty_sum_ponumber.

TYPES : BEGIN OF ty_delivery_count,
          vbeln      TYPE vbeln,
          kunnr      TYPE kunnr,
          lips_vbeln TYPE vbeln,
          lips_posnr TYPE posnr,
          matnr      TYPE matnr,
          count      TYPE n,
        END OF ty_delivery_count.

TYPES : BEGIN OF ty_sum_delnumber,
          kunnr TYPE kunnr,
          matnr TYPE matnr,
          count TYPE kwmeng,
        END OF ty_sum_delnumber.

DATA : li_po_count TYPE STANDARD TABLE OF ty_po_count INITIAL SIZE 0.
FIELD-SYMBOLS : <lfs_po_count>   TYPE ty_po_count.

DATA : li_delivery_count TYPE STANDARD TABLE OF ty_delivery_count INITIAL SIZE 0.
FIELD-SYMBOLS : <lfs_delivery_count>   TYPE ty_delivery_count.

DATA  : lis_sum_ponumber TYPE SORTED TABLE OF ty_sum_ponumber WITH UNIQUE KEY kunnr matnr INITIAL SIZE 0,
        lst_sum_ponumber TYPE ty_sum_ponumber.

DATA  : lis_sum_delnumber TYPE SORTED TABLE OF ty_sum_delnumber WITH UNIQUE KEY kunnr matnr INITIAL SIZE 0,
        lst_sum_delnumber TYPE ty_sum_delnumber.

* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *

* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
TYPES : BEGIN OF ty_vbtyp_v,       " for preceding SD document from VBFA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE vbtyp_v,       " Document category of preceding SD document
          high TYPE vbtyp_v,       " Document category of preceding SD document
        END OF ty_vbtyp_v.

DATA  : ir_doccat  TYPE RANGE OF vbfa-vbtyp_v,      " Document category of preceding SD document
        lst_doccat TYPE ty_vbtyp_v.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *

CONSTANTS : lc_devid            TYPE zdevid     VALUE 'E335',       " WRICEF ID
            lc_posnr            TYPE posnr      VALUE '000000',     " Line item
            lc_parvw            TYPE rvari_vnam VALUE 'PARVW',      " Partner function
            lc_ship2party       TYPE parvw      VALUE 'WE',         " Ship to party
            lc_forwarding_agent TYPE parvw      VALUE 'SP',         " Forwarding agent
            lc_table            TYPE rvari_vnam VALUE 'TABLE',      " Table name
            lc_field            TYPE rvari_vnam VALUE 'FIELD',      " Field name
            lc_separator        TYPE char1      VALUE ':',          " Concatenation separator
            lc_clickhere        TYPE char10     VALUE 'Click Here', " Shipping instruction popup
            lc_id_export        TYPE thead-tdid VALUE '0020',
            lc_object_export    TYPE thead-tdobject VALUE 'VBBK',
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
            lc_vbtyp_n          TYPE rvari_vnam VALUE 'VBTYP_V'.      " SD doc category for preceding doc
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *

IF postab[] IS NOT INITIAL.         " Check whether standard program return outtab is empty

  SELECT devid,
       param1,
       param2,
       srno,
       sign,
       opti,
       low ,
       high,
       activate
   FROM zcaconstant
   INTO TABLE @DATA(li_constant)
   WHERE devid    = @lc_devid         " WRICEF ID
   AND   activate = @abap_true.       " Only active record
  IF sy-subrc IS INITIAL.
    SORT li_constant BY param1.
    FREE : lv_tablename , lv_fieldname.
    LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
      CASE <lfs_constant>-param1.
        WHEN lc_parvw.                                      " Check partner type
          lst_parvw-sign = <lfs_constant>-sign.
          lst_parvw-opti = <lfs_constant>-opti.
          lst_parvw-low  = <lfs_constant>-low.
          lst_parvw-high = <lfs_constant>-high.
          APPEND lst_parvw TO ir_parvw.
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
          IF lc_ship2party = <lfs_constant>-low.        " check whether ship to party then fill separate range
            lst_ship2party-sign = <lfs_constant>-sign.
            lst_ship2party-opti = <lfs_constant>-opti.
            lst_ship2party-low  = <lfs_constant>-low.
            lst_ship2party-high = <lfs_constant>-high.
            APPEND lst_ship2party TO ir_ship2party.
          ENDIF.
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
        WHEN lc_vbtyp_n.
          lst_doccat-sign = <lfs_constant>-sign.
          lst_doccat-opti = <lfs_constant>-opti.
          lst_doccat-low  = <lfs_constant>-low.
          lst_doccat-high = <lfs_constant>-high.
          APPEND  lst_doccat TO ir_doccat.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
      ENDCASE.
      FREE : lst_parvw , lst_ship2party , lst_doccat.
    ENDLOOP.
    " Get Table name
    READ TABLE li_constant ASSIGNING <lfs_constant> WITH KEY param1 = lc_table BINARY SEARCH.
    IF sy-subrc = 0.
      lv_tablename = <lfs_constant>-low.      " Table name
    ENDIF.
    " Get Field name
    READ TABLE li_constant ASSIGNING <lfs_constant> WITH KEY param1 = lc_field BINARY SEARCH.
    IF sy-subrc = 0.
      lv_fieldname = <lfs_constant>-low.      " field name
    ENDIF.
  ENDIF.

  gv_alv_output = abap_true.            " Enable ALV list view as a ALV grid report
  DATA(li_tmp_postab) = postab[].       " Standard itab return data assign to temporary itab for further processing
  DELETE ADJACENT DUPLICATES FROM li_tmp_postab COMPARING ALL FIELDS.

  " Fetch Forwarding agent/Ship to party
  SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
    FROM vbpa INTO TABLE @DATA(li_vbpa_partner)
    FOR ALL ENTRIES IN @li_tmp_postab
    WHERE vbeln = @li_tmp_postab-vbeln
    AND ( posnr = @li_tmp_postab-posnr OR posnr = @lc_posnr )
    AND  parvw IN @ir_parvw.
  IF sy-subrc IS INITIAL .
    " Fetch Ship to party country code
    SELECT kunnr,land1
      FROM kna1 INTO TABLE @DATA(li_kna1)
      FOR ALL ENTRIES IN @li_vbpa_partner
      WHERE kunnr = @li_vbpa_partner-kunnr.
  ENDIF.

  " Fecth sales bussiness data
  SELECT vbeln,posnr,ihrez
    FROM vbkd INTO TABLE @DATA(li_vbkd)
    FOR ALL ENTRIES IN @li_tmp_postab
    WHERE vbeln = @li_tmp_postab-vbeln
    AND ( posnr = @li_tmp_postab-posnr OR posnr = @lc_posnr ).
  IF sy-subrc IS INITIAL.
    " Nothing to do
  ENDIF.

  " Fetch VBAK/VBAP/MARC/MARA data
  SELECT a~vbeln,a~auart,a~lifsk,a~faksk,a~vsbed,a~vgbel,b~matnr,b~posnr,b~werks,b~vstel,b~zzvyp,c~ismarrivaldateac,d~ismyearnr
    FROM vbak AS a INNER JOIN vbap AS b
    ON b~vbeln = a~vbeln
    INNER JOIN marc AS c
    ON b~matnr = c~matnr AND
       b~werks = c~werks
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
    INNER JOIN mara AS d
    ON c~matnr = d~matnr
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
    INTO TABLE @DATA(li_vbak_vbap_marc)
    FOR ALL ENTRIES IN @li_tmp_postab
    WHERE a~vbeln = @li_tmp_postab-vbeln  AND
          b~posnr = @li_tmp_postab-posnr.
  IF li_vbak_vbap_marc IS NOT INITIAL.
    " Fetch delivery block description text
    SELECT lifsp,vtext
      FROM tvlst INTO TABLE @DATA(li_tvlst)
      FOR ALL ENTRIES IN @li_vbak_vbap_marc
      WHERE lifsp = @li_vbak_vbap_marc-lifsk AND
            spras = @sy-langu.
    IF sy-subrc IS INITIAL.
      " Nothing to do
    ENDIF.

    " Fetch  billing block description text
    SELECT faksp,vtext
      FROM tvfst INTO TABLE @DATA(li_tvfst)
      FOR ALL ENTRIES IN @li_vbak_vbap_marc
      WHERE faksp = @li_vbak_vbap_marc-faksk AND
            spras = @sy-langu.
    IF sy-subrc IS INITIAL.
      " Nothing to do
    ENDIF.
  ENDIF.

* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
  " Fetch VBAK/VBFA data for subscription order
  SELECT a~vbelv,a~vbeln,a~posnn,a~stufe,b~vbeln AS vbak_vbeln
    FROM vbfa AS a INNER JOIN vbak AS b
    ON b~vbeln = a~vbelv
    INTO TABLE @DATA(li_vbfa_vbak)
    FOR ALL ENTRIES IN @li_tmp_postab
    WHERE a~vbeln = @li_tmp_postab-vbeln AND
          a~posnn = @li_tmp_postab-posnr AND
          a~vbtyp_v IN @ir_doccat.
  IF sy-subrc IS INITIAL.
    " Get the highest level for subcription order.
    SORT li_vbfa_vbak BY vbeln posnn stufe DESCENDING.
    DELETE ADJACENT DUPLICATES FROM li_vbfa_vbak COMPARING vbeln posnn stufe.
  ENDIF.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *

  "Fetch overall credit status and description
  SELECT a~vbeln,a~cmgst,b~bezei
    FROM vbuk AS a INNER JOIN tvbst AS b
    ON b~statu = a~cmgst
    INTO TABLE @DATA(li_tvbst)
    FOR ALL ENTRIES IN @li_tmp_postab
    WHERE a~vbeln = @li_tmp_postab-vbeln  AND
          b~spras = @sy-langu             AND
          b~tbnam = @lv_tablename         AND
          b~fdnam = @lv_fieldname.
  IF sy-subrc IS INITIAL.
    " Nothing to do
  ENDIF.

  "Fetch Fixed vendor
  SELECT a~matnr,a~werks,a~autet,a~lifnr,b~name1
    FROM eord AS a INNER JOIN lfa1 AS b
    ON b~lifnr = a~lifnr
    INTO TABLE @DATA(li_eord_lfa1)
    FOR ALL ENTRIES IN @li_tmp_postab
    WHERE a~matnr = @li_tmp_postab-matnr    AND
          a~werks = @li_tmp_postab-werks    AND
          a~flifn = @abap_true.
  IF sy-subrc IS INITIAL.
    " Nothing to do
  ENDIF.

* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
  "Fetch Printer vendor
  SELECT a~matnr,a~werks,a~lifnr,b~name1
    FROM eord AS a INNER JOIN lfa1 AS b
    ON b~lifnr = a~lifnr
    INTO TABLE @DATA(li_eord_lfa1_prt)
    FOR ALL ENTRIES IN @li_tmp_postab
    WHERE a~matnr = @li_tmp_postab-matnr    AND
          a~werks = @li_tmp_postab-werks    AND
          a~autet NE @space.
  IF sy-subrc IS INITIAL.
    " Nothing to do
  ENDIF.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *

  " Sort Itab based on the key fields
  SORT li_vbpa_partner BY vbeln posnr parvw.
  SORT li_vbak_vbap_marc BY vbeln posnr.
  SORT li_tvlst BY lifsp.
  SORT li_tvfst BY faksp.
  SORT li_tvbst BY vbeln.
  SORT li_eord_lfa1 BY matnr werks.
  SORT li_vbkd BY vbeln posnr.
  SORT li_kna1 BY kunnr.
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
  SORT li_eord_lfa1_prt BY matnr werks.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *

  " Fill the standard table from the custom data.
  LOOP AT postab ASSIGNING FIELD-SYMBOL(<lfs_postab>).
    " Check whether partner data is available
    IF li_vbpa_partner IS NOT INITIAL.
      " Ship to party read with line item
      READ TABLE li_vbpa_partner ASSIGNING FIELD-SYMBOL(<lfs_vbpa_partner>) WITH KEY vbeln = <lfs_postab>-vbeln
                                                                                     posnr = <lfs_postab>-posnr
                                                                                     parvw = lc_ship2party BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_postab>-zzship2party = <lfs_vbpa_partner>-kunnr.   " Ship to party
      ELSE.
        " Ship to party read with header level
        READ TABLE li_vbpa_partner ASSIGNING <lfs_vbpa_partner> WITH KEY vbeln = <lfs_postab>-vbeln
                                                                         posnr = lc_posnr
                                                                         parvw = lc_ship2party BINARY SEARCH.
        IF sy-subrc = 0.
          <lfs_postab>-zzship2party = <lfs_vbpa_partner>-kunnr.   " Ship to party
        ENDIF.
      ENDIF.
      " Check whether Customer master data is available
      IF li_kna1 IS NOT INITIAL.
        READ TABLE li_kna1 ASSIGNING FIELD-SYMBOL(<lfs_kna1>) WITH KEY kunnr = <lfs_vbpa_partner>-kunnr BINARY SEARCH.
        IF sy-subrc = 0.
          <lfs_postab>-zzland1 = <lfs_kna1>-land1.          " Ship to party country code
        ENDIF.
      ENDIF.
      " Forwarding Agent read with line item
      READ TABLE li_vbpa_partner ASSIGNING <lfs_vbpa_partner> WITH KEY vbeln = <lfs_postab>-vbeln
                                                                       posnr = <lfs_postab>-posnr
                                                                       parvw = lc_forwarding_agent BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_postab>-zzforwarding_agent = <lfs_vbpa_partner>-lifnr.       " Forwarding agent
      ELSE.
        " Forwarding Agent read with header level
        READ TABLE li_vbpa_partner ASSIGNING <lfs_vbpa_partner> WITH KEY vbeln = <lfs_postab>-vbeln
                                                                         posnr = lc_posnr
                                                                         parvw = lc_forwarding_agent BINARY SEARCH.
        IF sy-subrc = 0.
          <lfs_postab>-zzforwarding_agent = <lfs_vbpa_partner>-lifnr.    " Forwarding agent
        ENDIF.
      ENDIF.
    ENDIF.
    " Check whether bussiness data is available
    IF li_vbkd IS NOT INITIAL.
      " Business data read with line item
      READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lfs_vbkd>) WITH KEY vbeln = <lfs_postab>-vbeln
                                                                     posnr = <lfs_postab>-posnr BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_postab>-zzihrez = <lfs_vbkd>-ihrez.
      ELSE.
        " Business data read with header data.
        READ TABLE li_vbkd ASSIGNING <lfs_vbkd> WITH KEY vbeln = <lfs_postab>-vbeln
                                                         posnr = lc_posnr BINARY SEARCH.
        IF sy-subrc = 0.
          <lfs_postab>-zzihrez = <lfs_vbkd>-ihrez.
        ENDIF.
      ENDIF.
    ENDIF.
    " Check whether vbak_vbap_marc data is available
    IF li_vbak_vbap_marc IS NOT INITIAL.
      READ TABLE li_vbak_vbap_marc ASSIGNING FIELD-SYMBOL(<lfs_vbak_vbap_marc>) WITH KEY vbeln = <lfs_postab>-vbeln
                                                                                         posnr = <lfs_postab>-posnr BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_postab>-zzvstel = <lfs_vbak_vbap_marc>-vstel.             " Shipping point
        <lfs_postab>-zzauart = <lfs_vbak_vbap_marc>-auart.             " Order type
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
        <lfs_postab>-zzismyearnr =   <lfs_vbak_vbap_marc>-ismyearnr.   " Volume year
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
        <lfs_postab>-zzvsbed = <lfs_vbak_vbap_marc>-vsbed.             " Shipping condition
        <lfs_postab>-zzlifsk = <lfs_vbak_vbap_marc>-lifsk.             " Delivery block
        <lfs_postab>-zzfaksk = <lfs_vbak_vbap_marc>-faksk.             " Billing block
        <lfs_postab>-zzismarrivaldateac = <lfs_vbak_vbap_marc>-ismarrivaldateac.    " Actual goods arrival date

        " Check whether delivery block text data is available
        IF li_tvlst IS NOT INITIAL.
          READ TABLE li_tvlst ASSIGNING FIELD-SYMBOL(<lfs_tvlst>) WITH KEY lifsp = <lfs_vbak_vbap_marc>-lifsk BINARY SEARCH.
          IF sy-subrc = 0.
            <lfs_postab>-zzdel_vtext = <lfs_tvlst>-vtext.           " Delivery block text
          ENDIF.
        ENDIF.
        " Check whether Billing block text data is available
        IF li_tvfst IS NOT INITIAL.
          READ TABLE li_tvfst ASSIGNING FIELD-SYMBOL(<lfs_tvfst>) WITH KEY faksp = <lfs_vbak_vbap_marc>-faksk BINARY SEARCH.
          IF sy-subrc = 0.
            <lfs_postab>-zzbill_vtext = <lfs_tvfst>-vtext.          " Billing block text
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
    " Check whether sales document flow data is available
    IF li_vbfa_vbak IS NOT INITIAL.
      READ TABLE li_vbfa_vbak ASSIGNING FIELD-SYMBOL(<lfs_vbfa_vbak>) WITH KEY vbeln = <lfs_postab>-vbeln
                                                                               posnn = <lfs_postab>-posnr BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_postab>-zzvgbel = <lfs_vbfa_vbak>-vbak_vbeln.             " reference document
      ENDIF.

    ENDIF.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
    " Check whether overall credit block text data is available
    IF li_tvbst IS NOT INITIAL.
      READ TABLE li_tvbst ASSIGNING FIELD-SYMBOL(<lfs_tvbst>) WITH KEY vbeln = <lfs_postab>-vbeln BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_postab>-zzcmgst = <lfs_tvbst>-cmgst.                 " Overall credit block
        <lfs_postab>-zzbezei = <lfs_tvbst>-bezei.                 " Overall credit block text
      ENDIF.
    ENDIF.
    " Check whether MRP and vendor data available.
    IF li_eord_lfa1 IS NOT INITIAL.
      READ TABLE li_eord_lfa1 ASSIGNING FIELD-SYMBOL(<lfs_eord_lfa1>) WITH KEY matnr = <lfs_postab>-matnr
                                                                               werks = <lfs_postab>-werks BINARY SEARCH.
      IF sy-subrc = 0.
        CONCATENATE <lfs_eord_lfa1>-lifnr <lfs_eord_lfa1>-name1 INTO <lfs_postab>-zzvendor SEPARATED BY lc_separator.  " Vendor and name
      ENDIF.
    ENDIF.
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
    IF li_eord_lfa1_prt IS NOT INITIAL.
      READ TABLE li_eord_lfa1_prt ASSIGNING FIELD-SYMBOL(<lfs_eord_lfa1_prt>) WITH KEY matnr = <lfs_postab>-matnr
                                                                                       werks = <lfs_postab>-werks BINARY SEARCH.
      IF sy-subrc = 0.
        CONCATENATE <lfs_eord_lfa1_prt>-lifnr <lfs_eord_lfa1_prt>-name1 INTO <lfs_postab>-zzvendor_prt SEPARATED BY lc_separator.  " Print vendor and name
      ENDIF.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
    ENDIF.
  ENDLOOP.

  " Assign latest value to temporary table
  REFRESH li_tmp_postab.
  li_tmp_postab = postab[].       " Standard itab return data assign to temporary itab for further processing
  DELETE ADJACENT DUPLICATES FROM li_tmp_postab COMPARING ALL FIELDS.

  " fetch orginal ship to party and material related sales document and ordertype
  SELECT a~vbeln,a~posnr,a~kunnr,b~vbeln AS vbap_vbeln ,b~posnr AS vbap_posnr,b~matnr,c~auart
  FROM vbpa AS a INNER JOIN vbap AS b
  ON b~vbeln = a~vbeln
  INNER JOIN vbak AS c
  ON b~vbeln = c~vbeln
  INTO TABLE @DATA(li_vbap_vbpa)
  FOR ALL ENTRIES IN @li_tmp_postab
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
  WHERE a~parvw IN @ir_ship2party             AND
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
        a~kunnr = @li_tmp_postab-zzship2party AND
        b~matnr = @li_tmp_postab-matnr.
  IF sy-subrc IS INITIAL.
    SORT li_vbap_vbpa BY vbap_vbeln vbap_posnr.
    DELETE ADJACENT DUPLICATES FROM li_vbap_vbpa COMPARING vbap_vbeln vbap_posnr.
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
    SORT li_vbap_vbpa BY kunnr matnr vbap_vbeln.
    DELETE ADJACENT DUPLICATES FROM li_vbap_vbpa COMPARING kunnr matnr vbap_vbeln.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
  ENDIF.

* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
  " Fetch purchase order history data
  SELECT a~vbeln,a~posnr,a~kunnr,b~matnr,c~vbeln AS ekkn_vbeln,c~vbelp AS ekkn_posnr,d~ebeln
  FROM vbpa AS a INNER JOIN vbap AS b
  ON b~vbeln = a~vbeln
  INNER JOIN ekkn AS c
  ON b~vbeln = c~vbeln  AND
     b~posnr = c~vbelp
  INNER JOIN ekpo AS d
  ON c~ebeln = d~ebeln  AND
     c~ebelp = d~ebelp
  INTO TABLE @DATA(li_vbep_ekpo)
  FOR ALL ENTRIES IN @li_tmp_postab
  WHERE a~parvw IN @ir_ship2party             AND
        a~kunnr = @li_tmp_postab-zzship2party AND
        b~matnr = @li_tmp_postab-matnr.
  IF sy-subrc IS INITIAL.
    SORT li_vbep_ekpo BY ekkn_vbeln ekkn_posnr.
    DELETE ADJACENT DUPLICATES FROM li_vbep_ekpo COMPARING ekkn_vbeln ekkn_posnr.
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
    SORT li_vbep_ekpo BY kunnr matnr ebeln.
    DELETE ADJACENT DUPLICATES FROM li_vbep_ekpo COMPARING kunnr matnr ebeln.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
  ENDIF.

  " Fetch outbound delivery history data
  SELECT a~vbeln,a~kunnr,b~vbeln AS lips_vbeln,b~posnr AS lips_posnr,b~matnr
  FROM likp AS a INNER JOIN lips AS b
  ON b~vbeln = a~vbeln
  INTO TABLE @DATA(li_lips)
  FOR ALL ENTRIES IN @li_tmp_postab
  WHERE a~kunnr = @li_tmp_postab-zzship2party AND
        b~matnr = @li_tmp_postab-matnr.
  IF sy-subrc IS INITIAL.
    SORT li_lips BY lips_vbeln lips_posnr.
    DELETE ADJACENT DUPLICATES FROM li_lips COMPARING lips_vbeln lips_posnr.
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
    SORT li_lips BY kunnr matnr lips_vbeln.
    DELETE ADJACENT DUPLICATES FROM li_lips COMPARING kunnr matnr lips_vbeln.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
  ENDIF.
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *

  SORT li_vbap_vbpa BY kunnr matnr.
  SORT li_vbep_ekpo BY kunnr matnr.
  SORT li_lips BY kunnr matnr.

  IF li_vbap_vbpa IS NOT INITIAL.
    " add new column with numeric value for order type
    LOOP AT li_vbap_vbpa ASSIGNING FIELD-SYMBOL(<lfs_vbap_vbpa>).
      APPEND INITIAL LINE TO li_order_count ASSIGNING <lfs_order_count>.
      <lfs_order_count>-vbeln       = <lfs_vbap_vbpa>-vbeln.
      <lfs_order_count>-posnr       = <lfs_vbap_vbpa>-posnr.
      <lfs_order_count>-kunnr       = <lfs_vbap_vbpa>-kunnr.
      <lfs_order_count>-vbap_vbeln  = <lfs_vbap_vbpa>-vbap_vbeln.
      <lfs_order_count>-vbap_posnr  = <lfs_vbap_vbpa>-vbap_posnr.
      <lfs_order_count>-matnr       = <lfs_vbap_vbpa>-matnr.
      <lfs_order_count>-auart       = <lfs_vbap_vbpa>-auart.
      <lfs_order_count>-count       = 1.
    ENDLOOP.
  ENDIF.

* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
  IF li_vbep_ekpo IS NOT INITIAL.
    " add new column with numeric value for Po History
    LOOP AT li_vbep_ekpo ASSIGNING FIELD-SYMBOL(<lfs_vbep_ekpo>).
      APPEND INITIAL LINE TO li_po_count ASSIGNING <lfs_po_count>.
      <lfs_po_count>-vbeln      = <lfs_vbep_ekpo>-vbeln.
      <lfs_po_count>-posnr      = <lfs_vbep_ekpo>-posnr.
      <lfs_po_count>-kunnr      = <lfs_vbep_ekpo>-kunnr.
      <lfs_po_count>-matnr      = <lfs_vbep_ekpo>-matnr.
      <lfs_po_count>-ekkn_vbeln = <lfs_vbep_ekpo>-ekkn_vbeln.
      <lfs_po_count>-ekkn_posnr = <lfs_vbep_ekpo>-ekkn_posnr.
      <lfs_po_count>-ebeln      = <lfs_vbep_ekpo>-ebeln.
      <lfs_po_count>-count      = 1.
    ENDLOOP.
  ENDIF.

  IF li_lips IS NOT INITIAL.
    " add new column with numeric value for delivery History
    LOOP AT li_lips ASSIGNING FIELD-SYMBOL(<lfs_lips>).
      APPEND INITIAL LINE TO li_delivery_count ASSIGNING <lfs_delivery_count>.
      <lfs_delivery_count>-kunnr      = <lfs_lips>-kunnr.
      <lfs_delivery_count>-vbeln      = <lfs_lips>-vbeln.
      <lfs_delivery_count>-lips_vbeln = <lfs_lips>-lips_vbeln.
      <lfs_delivery_count>-lips_posnr = <lfs_lips>-lips_posnr.
      <lfs_delivery_count>-matnr      = <lfs_lips>-matnr.
      <lfs_delivery_count>-count      = 1.
    ENDLOOP.
  ENDIF.
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *

  IF li_order_count IS NOT INITIAL.
    " Summaraized the order count againt shipto party and materail
    LOOP AT li_order_count ASSIGNING <lfs_order_count>.
      " Summarized data againts shipto party/material
      lst_sum_ortype-kunnr = <lfs_order_count>-kunnr.
      lst_sum_ortype-matnr = <lfs_order_count>-matnr.
      lst_sum_ortype-count = <lfs_order_count>-count.

      COLLECT lst_sum_ortype INTO lis_sum_ortype.
      CLEAR : lst_sum_ortype.

      " Summarized data againts shipto party/material/ order type
      st_sum_ortypewise-kunnr = <lfs_order_count>-kunnr.
      st_sum_ortypewise-matnr = <lfs_order_count>-matnr.
      st_sum_ortypewise-auart = <lfs_order_count>-auart.
      st_sum_ortypewise-count = <lfs_order_count>-count.

      COLLECT st_sum_ortypewise INTO is_sum_ortypewise.
      CLEAR : st_sum_ortypewise.
    ENDLOOP.
  ENDIF.

* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
  IF li_po_count IS NOT INITIAL.
    " Summaraized the Po count againt shipto party and materail
    LOOP AT li_po_count ASSIGNING <lfs_po_count>.
      " Summarized data againts shipto party/material
      lst_sum_ponumber-kunnr = <lfs_po_count>-kunnr.
      lst_sum_ponumber-matnr = <lfs_po_count>-matnr.
      lst_sum_ponumber-count = <lfs_po_count>-count.

      COLLECT lst_sum_ponumber INTO lis_sum_ponumber.
      CLEAR lst_sum_ponumber.

      " Prepare data for detail display
      APPEND INITIAL LINE TO i_pohistory ASSIGNING FIELD-SYMBOL(<lfs_pohistory>).
      <lfs_pohistory>-kunnr = <lfs_po_count>-kunnr.
      <lfs_pohistory>-matnr = <lfs_po_count>-matnr.
      <lfs_pohistory>-ebeln = <lfs_po_count>-ebeln.
    ENDLOOP.
  ENDIF.

  IF li_delivery_count IS NOT INITIAL.
    " Summaraized the delivery count againt shipto party and materail
    LOOP AT li_delivery_count ASSIGNING <lfs_delivery_count>.
      " Summarized data againts shipto party/material
      lst_sum_delnumber-kunnr = <lfs_delivery_count>-kunnr.
      lst_sum_delnumber-matnr = <lfs_delivery_count>-matnr.
      lst_sum_delnumber-count = <lfs_delivery_count>-count.

      COLLECT lst_sum_delnumber INTO lis_sum_delnumber.
      CLEAR lst_sum_delnumber.

      " Prepare data for detail display
      APPEND INITIAL LINE TO i_delhistory ASSIGNING FIELD-SYMBOL(<lfs_delhistory>).
      <lfs_delhistory>-kunnr = <lfs_delivery_count>-kunnr.
      <lfs_delhistory>-matnr = <lfs_delivery_count>-matnr.
      <lfs_delhistory>-vbeln = <lfs_delivery_count>-lips_vbeln.
    ENDLOOP.
  ENDIF.

  SORT i_pohistory BY kunnr matnr.
  SORT i_delhistory BY kunnr matnr.
  SORT postab BY vbeln.
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
* BOC by NPOLINA on 12/20/2021 for OTCM-51316 with ED2K925275 *
  IF s_erdat IS NOT INITIAL.
    DELETE postab[] WHERE erdat NOT IN s_erdat.
  ELSEIF s_arrdat IS NOT INITIAL.
    DELETE postab[] WHERE zzismarrivaldateac NOT IN s_arrdat.
  ENDIF.
* EOC by NPOLINA on 12/20/2021 for OTCM-51316 with ED2K925275 *
  LOOP AT postab ASSIGNING <lfs_postab>.
    CLEAR : lv_deldate , lv_arrivaldate.
    " Check whether summarized PO history data available
    IF lis_sum_ponumber IS NOT INITIAL.
      READ TABLE lis_sum_ponumber INTO lst_sum_ponumber WITH KEY kunnr = <lfs_postab>-zzship2party
                                                                 matnr = <lfs_postab>-matnr BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_postab>-zzpohistory = lst_sum_ponumber-count.
        CLEAR : lst_sum_ponumber.
      ENDIF.
    ENDIF.
    " Check whether summarized delivery history data available
    IF lis_sum_delnumber IS NOT INITIAL.
      READ TABLE lis_sum_delnumber INTO lst_sum_delnumber WITH KEY kunnr = <lfs_postab>-zzship2party
                                                                   matnr = <lfs_postab>-matnr BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_postab>-zzdeliveryhistory = lst_sum_delnumber-count.
        CLEAR : lst_sum_delnumber.
      ENDIF.
    ENDIF.
    " Check whether summarized order history data available
    IF lis_sum_ortype IS NOT INITIAL.
      READ TABLE lis_sum_ortype INTO lst_sum_ortype WITH KEY kunnr = <lfs_postab>-zzship2party
                                                             matnr = <lfs_postab>-matnr BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_postab>-zzhistory = lst_sum_ortype-count.
        CLEAR : lst_sum_ortype.
      ENDIF.
    ENDIF.
    " Assign standard output related plant data to Custom structure plant (Maintain the sequence of the ALV output and excel export)
    <lfs_postab>-zzwerks = <lfs_postab>-werks.
    <lfs_postab>-zzship_introduction = lc_clickhere.        " Text display with popup window

    " ALV output table assign to Excel export itab with breakdown details.
    APPEND INITIAL LINE TO i_excel_tab ASSIGNING FIELD-SYMBOL(<lfs_excel_tab>).
    <lfs_excel_tab>-vbeln               = <lfs_postab>-vbeln.
    <lfs_excel_tab>-posnr               = <lfs_postab>-posnr.
    <lfs_excel_tab>-matnr               = <lfs_postab>-matnr.
    "<lfs_excel_tab>-kwmeng              = <lfs_postab>-kwmeng.
    WRITE <lfs_postab>-kwmeng TO lv_kwmeng DECIMALS 0.
    <lfs_excel_tab>-kwmeng  = lv_kwmeng.
    CONDENSE <lfs_excel_tab>-kwmeng NO-GAPS.
    "<lfs_excel_tab>-kbmeng              = <lfs_postab>-kbmeng.
    WRITE <lfs_postab>-kbmeng TO lv_kbmeng DECIMALS 0.
    <lfs_excel_tab>-kbmeng  = lv_kbmeng.
    CONDENSE <lfs_excel_tab>-kbmeng NO-GAPS.
    "<lfs_excel_tab>-olfmng              = <lfs_postab>-olfmng.
    WRITE <lfs_postab>-olfmng TO lv_olfmng DECIMALS 0.
    <lfs_excel_tab>-olfmng  = lv_olfmng.
    CONDENSE <lfs_excel_tab>-olfmng NO-GAPS.
    <lfs_excel_tab>-vrkme               = <lfs_postab>-vrkme.
    IF <lfs_postab>-lfdat_1 IS NOT INITIAL.
      WRITE <lfs_postab>-lfdat_1 TO lv_deldate MM/DD/YYYY.
      <lfs_excel_tab>-lfdat_1             = lv_deldate.
    ENDIF.
    <lfs_excel_tab>-lprio               = <lfs_postab>-lprio.
    <lfs_excel_tab>-kunnr               = <lfs_postab>-kunnr.
    <lfs_excel_tab>-fixmg               = <lfs_postab>-fixmg.
    <lfs_excel_tab>-zzship2party        = <lfs_postab>-zzship2party.
    <lfs_excel_tab>-zzforwarding_agent  = <lfs_postab>-zzforwarding_agent.
    <lfs_excel_tab>-zzvgbel             = <lfs_postab>-zzvgbel.
    <lfs_excel_tab>-zzihrez             = <lfs_postab>-zzihrez.
    IF <lfs_postab>-zzismarrivaldateac IS NOT INITIAL.
      WRITE <lfs_postab>-zzismarrivaldateac TO lv_arrivaldate MM/DD/YYYY.
      <lfs_excel_tab>-zzismarrivaldateac  = lv_arrivaldate.
    ENDIF.
    <lfs_excel_tab>-zzwerks             = <lfs_postab>-zzwerks.
    <lfs_excel_tab>-zzvstel             = <lfs_postab>-zzvstel.
    <lfs_excel_tab>-zzland1             = <lfs_postab>-zzland1.
    <lfs_excel_tab>-zzauart             = <lfs_postab>-zzauart.
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
    <lfs_excel_tab>-zzvendor_prt        = <lfs_postab>-zzvendor_prt.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
    <lfs_excel_tab>-zzvendor            = <lfs_postab>-zzvendor.
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
    <lfs_excel_tab>-zzismyearnr         = <lfs_postab>-zzismyearnr.
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
    <lfs_excel_tab>-zzvsbed             = <lfs_postab>-zzvsbed.
    <lfs_excel_tab>-zzlifsk             = <lfs_postab>-zzlifsk.
    <lfs_excel_tab>-zzdel_vtext         = <lfs_postab>-zzdel_vtext.
    <lfs_excel_tab>-zzfaksk             = <lfs_postab>-zzfaksk.
    <lfs_excel_tab>-zzbill_vtext        = <lfs_postab>-zzbill_vtext.
    <lfs_excel_tab>-zzcmgst             = <lfs_postab>-zzcmgst.
    <lfs_excel_tab>-zzbezei             = <lfs_postab>-zzbezei.

    AT NEW vbeln.     " New sales document, then read the header text
      REFRESH li_lines_export.
      CLEAR : lv_name_export,lv_tmp_instruction.
      lv_name_export = <lfs_postab>-vbeln.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = lc_id_export
          language                = sy-langu
          name                    = lv_name_export
          object                  = lc_object_export
        TABLES
          lines                   = li_lines_export
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc EQ 0.
        LOOP AT li_lines_export INTO DATA(lst_lines_export).
          CONCATENATE <lfs_excel_tab>-zzship_introduction lst_lines_export-tdline INTO <lfs_excel_tab>-zzship_introduction
                                                                                  SEPARATED BY space.
        ENDLOOP.
        SHIFT <lfs_excel_tab>-zzship_introduction LEFT DELETING LEADING space.
        lv_tmp_instruction = <lfs_excel_tab>-zzship_introduction.
      ENDIF.
    ENDAT.
    " same sales document,then used the already fetch data to other line items
    <lfs_excel_tab>-zzship_introduction = lv_tmp_instruction.

  ENDLOOP.

ENDIF.
