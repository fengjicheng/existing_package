***------------------------------------------------------------------------*
*** PROGRAM NAME: ZQTCN_RESTRICT_COMPCODE_EXT (Include)
*                 called from include: ZQTCN_BP_VALIDATIONS
*** PROGRAM DESCRIPTION: Restrict Company Code Extension to an Indian BP
*** DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
*** CREATION DATE: 09/25/2018
*** OBJECT ID: E165 / CR# 7428 /
*** TRANSPORT NUMBER(s): ED2K913439/ED2K913558/ED2K913592
***------------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED2K915881
* REFERENCE NO: ERPM 712 & E184
* DEVELOPER: nrmodugu & Prabhu
* DATE: 08/09/2019
* DESCRIPTION: Australian customers / BPIDs also to restrict for the user from extending
* the BP’s to company code 3310 and other company codes. However, If the country is AU, then
* it should allow to extend to only Company code-1001(USD).
*&---------------------------------------------------------------------*
* Local Types
TYPES: BEGIN OF ty_zcaconstant,
         devid  TYPE zdevid,
         param1 TYPE rvari_vnam,
         param2 TYPE rvari_vnam,
         srno   TYPE tvarv_numb,
         sign	  TYPE tvarv_sign,
         opti   TYPE tvarv_opti,
         low    TYPE salv_de_selopt_low,
         high   TYPE salv_de_selopt_high,
       END OF ty_zcaconstant,
       BEGIN OF ty_sales_org,
         vkorg TYPE vkorg,
         waers TYPE waers_v,
       END OF ty_sales_org.

* Local declarations
DATA: li_knb1            TYPE rjgbp_knb1_tab,
      li_knvv            TYPE rjgbp_knvv_tab,
      lst_knvv           TYPE knvv,
      li_sls_org         TYPE STANDARD TABLE OF ty_sales_org INITIAL SIZE 0,
      lst_sls_org        TYPE ty_sales_org,
      lst_addr           TYPE bapibus1006_address,
      lv_msg             TYPE string,
      lv_aktyp_003       TYPE bu_aktyp,                                    " Activity Category
      lv_bp_num_003      TYPE bu_partner,                                  " Business Partner Number
      li_but000_003      TYPE STANDARD TABLE OF but000 INITIAL SIZE 0,     " Itab: BP General data-I
      lv_trtab_count_003 TYPE i,                                           " Log table count
      li_trtab_003       TYPE STANDARD TABLE OF trtab INITIAL SIZE 0,      " Itab: Log
      ls_trtab_003       TYPE trtab,                                       " Log table structure
      li_zcaconstant     TYPE STANDARD TABLE OF ty_zcaconstant INITIAL SIZE 0,
      lir_comp_code      TYPE RANGE OF salv_de_selopt_low,
      lir_country        TYPE RANGE OF salv_de_selopt_low,
      lst_country        LIKE LINE OF lir_country,
      li_busadrdata      TYPE STANDARD TABLE OF busadrdata INITIAL SIZE 0,
      li_adrc            TYPE STANDARD TABLE OF adrc INITIAL SIZE 0,
      lv_curr_validation TYPE abap_bool VALUE abap_false,
      lv_tabix TYPE sy-tabix,
      li_knvp            TYPE STANDARD TABLE OF   knvp, "++VDPATABALL 03/06/2019 CR# 7428
      li_knvp_t          TYPE STANDARD TABLE OF   knvp, "++VDPATABALL 03/06/2019 CR# 7428
      lv_shipto          TYPE parvw.                    "++VDPATABALL 03/06/2019 CR# 7428
* Local constants
CONSTANTS:
  lc_title           TYPE text25     VALUE 'Invalid Company Code(s)',    " Title text for Pop-up
  lc_devid_e184      TYPE zdevid     VALUE 'E184',                       " Devid: E184
  lc_comp_code_p1    TYPE rvari_vnam VALUE 'COMP_CODE',                  " Param1: Company Code
  lc_country_p1      TYPE rvari_vnam VALUE 'COUNTRY',                    " Param1: Country
  lc_bp_number       TYPE bu_partner VALUE '##1',                        " Unassigned BP number
  lc_all_flag        TYPE char1      VALUE 'X',
  lc_acttyp_01       TYPE bu_aktyp   VALUE '01',                         " Create
  lc_acttyp_02       TYPE bu_aktyp   VALUE '02',                         " Change
  lc_acttyp_03       TYPE bu_aktyp   VALUE '03',                         " Display
  lc_msg_id          TYPE sy-msgid   VALUE 'ZQTC_R2',                    " Message Class
  lc_msg_typ_e       TYPE sy-msgty   VALUE 'E',                          " Message Type: E
  lc_msg_typ_i       TYPE sy-msgty   VALUE 'I',                          " Message Type: I
  lc_msgno_000       TYPE syst_msgno VALUE '000',
  lc_msgno_309       TYPE syst_msgno VALUE '309',                        " Error message number
  lc_msgno_310       TYPE syst_msgno VALUE '310',                        " Error message number
  lc_msgno_312       TYPE syst_msgno VALUE '312',                        " Error message number
  lc_no_partner_spec TYPE string     VALUE 'No Partner Specified',
  lc_no_valid_record TYPE string     VALUE 'No Valid Record Found',
  lc_not_found       TYPE string     VALUE 'BP Not Found',
  lc_blocked_partner TYPE string     VALUE 'Blocked Partner',
  lc_shipto_p1       TYPE rvari_vnam VALUE 'SHIPTO'.  "++ VDPATABALL 03/06/2019 CR# 7428

* Fetch Constant entries from zcaconstant table
SELECT devid, param1, param2, srno, sign, opti, low, high
       FROM zcaconstant INTO TABLE @li_zcaconstant
       WHERE devid = @lc_devid_e184 AND
             activate = @abap_true.
IF li_zcaconstant[] IS NOT INITIAL.
  LOOP AT li_zcaconstant INTO DATA(lsi_constant).
    CASE lsi_constant-param1.
      WHEN lc_comp_code_p1.              " Param1: COMP_CODE
        APPEND INITIAL LINE TO lir_comp_code ASSIGNING FIELD-SYMBOL(<lsf_comp_code>).
        <lsf_comp_code>-sign   = lsi_constant-sign.
        <lsf_comp_code>-option = lsi_constant-opti.
        <lsf_comp_code>-low    = lsi_constant-low.
        <lsf_comp_code>-high   = lsi_constant-high.
*--*BOC Prabhu ED2K916487 on 10/21/2019 ERPM 712
*      WHEN lc_country_p1.               " Param1: COUNTRY
*        APPEND INITIAL LINE TO lir_country ASSIGNING FIELD-SYMBOL(<lsf_country>).
*        <lsf_country>-sign   = lsi_constant-sign.
*        <lsf_country>-option = lsi_constant-opti.
*        <lsf_country>-low    = lsi_constant-low.
*        <lsf_country>-high   = lsi_constant-high.
*--*EOC Prabhu ED2K916487 on 10/21/2019 ERPM 712
*---Begin of change VDPATABALL 03/06/2019 CR# 7428
      WHEN lc_shipto_p1.
        CLEAR lv_shipto.
        lv_shipto = lsi_constant-low.
*---End of change VDPATABALL 03/06/2019 CR# 7428
      WHEN OTHERS.
        " No need of OTHERS in this CASE
    ENDCASE.
    CLEAR lsi_constant.
  ENDLOOP.
ENDIF.  " IF li_zcaconstant[] IS NOT INITIAL

* FM call for BP Control (Create/Change/Display)
CALL FUNCTION 'BUS_PARAMETERS_ISSTA_GET'
  IMPORTING
    e_aktyp = lv_aktyp_003.

IF lv_aktyp_003 = lc_acttyp_01 OR lv_aktyp_003 = lc_acttyp_02 OR
   lv_aktyp_003 = lc_acttyp_03.

* FM call to fetch the BP Id
  CALL FUNCTION 'BUP_BUPA_BUT000_GET'
    TABLES
      et_but000 = li_but000_003.
  IF li_but000_003[] IS NOT INITIAL.
    lv_bp_num_003 = li_but000_003[ 1 ]-partner.
  ENDIF.

  CASE lv_aktyp_003.
    WHEN lc_acttyp_01.
* Fetch the BP Address from Local buffer if BP is created directly with Sales Customer role
* instead of General role. In this case BP number yet to generate. Hence we have to fetch
* the BP Address from Local Buffer.
      CALL FUNCTION 'BUA_BUPA_ADDRESSES_GET'
        EXPORTING
          i_xall    = lc_all_flag
        TABLES
          t_address = li_busadrdata.
      IF li_busadrdata[] IS NOT INITIAL.
        LOOP AT li_busadrdata INTO DATA(lsi_busadrdata).
          IF lsi_busadrdata-date_to > sy-datum AND
            lsi_busadrdata-country IN lir_country.
            MOVE-CORRESPONDING lsi_busadrdata TO lst_addr.
            EXIT.
          ENDIF.
          CLEAR lsi_busadrdata.
        ENDLOOP.
      ENDIF.

    WHEN lc_acttyp_02.
* Fetch the BP Address details from DB based on BP number. In this case first BP is created
* with the General role and then BP is extend with the required role(s).
      CALL FUNCTION 'BUPA_ADDRESS_READ_DETAIL'
        EXPORTING
          iv_partner            = lv_bp_num_003
        IMPORTING
          es_address            = lst_addr
        EXCEPTIONS
          no_partner_specified  = 1
          no_valid_record_found = 2
          not_found             = 3
          blocked_partner       = 4
          OTHERS                = 5.
      IF sy-subrc <> 0.
        CASE sy-subrc.
          WHEN 1.
            CALL FUNCTION 'BUS_MESSAGE_STORE'
              EXPORTING
                arbgb = lc_msg_id
                msgty = lc_msg_typ_e
                txtnr = lc_msgno_000
                msgv1 = lc_no_partner_spec.
          WHEN 2.
            CALL FUNCTION 'BUS_MESSAGE_STORE'
              EXPORTING
                arbgb = lc_msg_id
                msgty = lc_msg_typ_e
                txtnr = lc_msgno_000
                msgv1 = lc_no_valid_record.
          WHEN 3.
            CALL FUNCTION 'BUS_MESSAGE_STORE'
              EXPORTING
                arbgb = lc_msg_id
                msgty = lc_msg_typ_e
                txtnr = lc_msgno_000
                msgv1 = lc_not_found.
          WHEN 4.
            CALL FUNCTION 'BUS_MESSAGE_STORE'
              EXPORTING
                arbgb = lc_msg_id
                msgty = lc_msg_typ_e
                txtnr = lc_msgno_000
                msgv1 = lc_blocked_partner.
          WHEN OTHERS.
            " No Need of OTHERS
        ENDCASE.
      ENDIF.

    WHEN OTHERS.
      " Nothing to doin this CASE
  ENDCASE.
*--*BOC Prabhu ED2K916487 on 10/21/2019 ERPM 712
*--*Separate Company code and country
  LOOP AT lir_comp_code INTO DATA(lst_comp_code) WHERE high = lst_addr-country.
    lv_tabix = sy-tabix.
    MOVE lst_comp_code TO lst_country.
    lst_country-low = lst_comp_code-high.
    CLEAR : lst_country-high.
    APPEND lst_country TO lir_country.
    CLEAR : lst_country,lst_comp_code-high.
    MODIFY lir_comp_code FROM lst_comp_code INDEX lv_tabix TRANSPORTING high.
  ENDLOOP.
  DELETE lir_comp_code WHERE high IS NOT INITIAL.
*--*EOC Prabhu ED2K916487 on 10/21/2019 ERPM 712
*** Trigger Comp. Code Ext Restriction Logic only to
*** BPs of specific countries maintained in ZCACONSTANT table
  IF lir_country[] IS NOT INITIAL AND
     lst_addr-country IN lir_country.

* FM call to fetch the Company Codes of a Customer
    CALL FUNCTION 'ISM_BUPA_CUSTOMER_MEMORY_GET'
      EXPORTING
        i_kunnr       = lv_bp_num_003
      TABLES
        t_knb1        = li_knb1
        t_knvv        = li_knvv
        t_knvp        = li_knvp "++VDPATABALL 03/06/2019 CR# 7428
      EXCEPTIONS
        no_data_found = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
* If Customer field is not populated with BP number,
* call the below FM with dummy BP number '##1' to fetch the
* Company Codes of a Customer
      CALL FUNCTION 'ISM_BUPA_CUSTOMER_MEMORY_GET'
        EXPORTING
          i_kunnr       = lc_bp_number
        TABLES
          t_knb1        = li_knb1
          t_knvv        = li_knvv
          t_knvp        = li_knvp "++VDPATABALL 03/06/2019 CR# 7428
        EXCEPTIONS
          no_data_found = 1
          OTHERS        = 2.
    ENDIF.

* Sales Organization Currency validation
    IF li_knvv[] IS NOT INITIAL AND
       lst_addr-country IN lir_country.
      SELECT vkorg, waers FROM tvko INTO TABLE @li_sls_org
                          FOR ALL ENTRIES IN @li_knvv
                          WHERE vkorg = @li_knvv-vkorg.
      IF li_sls_org[] IS NOT INITIAL.
        SORT li_sls_org BY vkorg.
        LOOP AT li_knvv INTO lst_knvv.
          READ TABLE li_sls_org INTO lst_sls_org WITH KEY vkorg = lst_knvv-vkorg
                                                 BINARY SEARCH.
          IF sy-subrc = 0.
            IF lst_sls_org-waers <> lst_knvv-waers.
              lv_curr_validation = abap_true.
              CALL FUNCTION 'BUS_MESSAGE_STORE'
                EXPORTING
                  arbgb = lc_msg_id
                  msgty = lc_msg_typ_e
                  txtnr = lc_msgno_312
                  msgv1 = lst_sls_org-vkorg
                  msgv2 = lst_sls_org-waers
                  msgv3 = lst_knvv-waers.
              CLEAR lst_sls_org.
              EXIT.
            ENDIF. " IF lst_sls_org-waers <> lst_knvv-waers
          ENDIF. " IF sy-subrc = 0
          CLEAR lst_knvv.
        ENDLOOP.
      ENDIF. " IF li_sls_org[] IS NOT INITIAL
    ENDIF. " IF li_knvv[] IS NOT INITIAL AND

* Check for Company Codes/Sales Orgs. of a customer
    IF ( lv_curr_validation = abap_false ) AND
       ( li_knb1[] IS NOT INITIAL OR li_knvv[] IS NOT INITIAL ).

      DELETE li_knb1 WHERE erdat IS NOT INITIAL.   " Delete the Old/already existing Company Codes
      DELETE li_knb1 WHERE bukrs IN lir_comp_code. " Delete if BUKRS = '1001'
      DELETE li_knvv WHERE erdat IS NOT INITIAL.   " Delete the Old/already existing Sales Orgs
      DELETE li_knvv WHERE vkorg IN lir_comp_code. " Delete if VKORG = '1001'
*---Begin of change VDPATABALL 03/06/2019 CR# 7428
      IF li_knvp IS NOT INITIAL.
        IF lst_addr-country IN lir_country.
          FREE:li_knvp_t.
          IF li_knvv IS NOT INITIAL.
            DATA(lv_vkorg) = li_knvv[ 1 ]-vkorg.
          ENDIF.
          LOOP AT li_knvp INTO DATA(lst_knvp) WHERE vkorg = lv_vkorg.
            APPEND lst_knvp TO li_knvp_t.
          ENDLOOP.
          SORT li_knvp_t BY kunn2.
          DELETE li_knvp_t WHERE kunn2 =  lv_bp_num_003.
          IF sy-subrc <> 0.
            SORT li_knvp_t BY kunn2.
            DELETE li_knvp_t WHERE kunn2 = lc_bp_number.
          ENDIF.
        ENDIF.
      ENDIF.
*---End of change VDPATABALL 03/06/2019 CR# 7428
      IF li_knb1[] IS NOT INITIAL.
        IF lst_addr-country IN lir_country.
          SORT li_knb1 BY bukrs.
          LOOP AT li_knb1 INTO DATA(lis_knb1).
*---Begin of change VDPATABALL 03/06/2019 CR# 7428
            READ TABLE li_knvp INTO lst_knvp WITH KEY kunnr = lis_knb1-kunnr
                                                      vkorg = lis_knb1-bukrs
                                                      parvw = lv_shipto.
            IF sy-subrc = 0 AND li_knvp_t IS INITIAL.
*---End of change VDPATABALL 03/06/2019 CR# 7428
              MESSAGE ID lc_msg_id TYPE lc_msg_typ_i NUMBER lc_msgno_310
                      INTO lv_msg
*                      WITH lis_knb1-bukrs.                   " commented by nrmodugu 08/09/2019 ERPM-712
                  WITH lis_knb1-bukrs lst_addr-country.       " Added by nrmodugu 08/09/2019 ERPM-712
              ls_trtab_003-line = lv_msg.
              APPEND ls_trtab_003 TO li_trtab_003.
              CLEAR: ls_trtab_003, lis_knb1, lv_msg.
            ENDIF. "IF lst_knvp IS NOT INITIAL.
          ENDLOOP.
        ENDIF. " IF lst_addr-country IN lir_country
      ENDIF. " IF li_knb1[] IS NOT INITIAL

      IF li_trtab_003[] IS INITIAL AND
         li_knvv[] IS NOT INITIAL.
        IF lst_addr-country IN lir_country.
          SORT li_knvv BY vkorg.
          LOOP AT li_knvv INTO lst_knvv.
*---Begin of change VDPATABALL 03/06/2019 CR# 7428
            READ TABLE li_knvp INTO lst_knvp WITH KEY kunnr = lst_knvv-kunnr
                                                vkorg = lst_knvv-vkorg
                                                parvw = lv_shipto.
            IF sy-subrc = 0  AND li_knvp_t IS INITIAL.
*---End of change VDPATABALL 03/06/2019 CR# 7428
              MESSAGE ID lc_msg_id TYPE lc_msg_typ_i NUMBER lc_msgno_310
                      INTO lv_msg
*                      WITH lst_knvv-vkorg                   " commented by nrmodugu 08/09/2019 ERPM-712
                      WITH lst_knvv-vkorg lst_addr-country.  " Added by nrmodugu 08/09/2019 ERPM-712
              ls_trtab_003-line = lv_msg.
              APPEND ls_trtab_003 TO li_trtab_003.
              CLEAR: ls_trtab_003, lst_knvv, lv_msg.
            ENDIF. "IF lst_knvp IS NOT INITIAL.
          ENDLOOP.
        ENDIF. " IF lst_addr-country IN lir_country
      ENDIF. " IF li_trtab_003[] IS INITIAL AND

      lv_trtab_count_003 = lines( li_trtab_003 ).
* Check entries in the Log table
      IF lv_trtab_count_003 >= 1.

        DATA(lv_size) = strlen( li_trtab_003[ 1 ]-line ).
        lv_size = lv_size + 10.

        CALL FUNCTION 'LAW_SHOW_POPUP_WITH_TEXT'
          EXPORTING
            titelbar         = lc_title
            line_size        = lv_size
          TABLES
            list_tab         = li_trtab_003
          EXCEPTIONS
            action_cancelled = 1
            OTHERS           = 2.
        IF sy-subrc = 0.
          CALL FUNCTION 'BUS_MESSAGE_STORE'
            EXPORTING
              arbgb = lc_msg_id
              msgty = lc_msg_typ_e
              txtnr = lc_msgno_309.
          IF sy-subrc <> 0.
            " Nothing to do
          ENDIF.
        ENDIF. " IF sy-subrc = 0

      ENDIF. " IF lv_trtab_count_003 >= 1

    ENDIF. " ( lv_curr_validation = abap_false ) AND

  ENDIF. " IF lir_country[] IS NOT INITIAL AND

  CLEAR: li_but000_003[], lst_addr, li_knb1[], li_knvv[], li_trtab_003[], li_busadrdata[],
         lir_country[], lir_comp_code[], lv_aktyp_003, lv_trtab_count_003, lv_curr_validation.

ENDIF. " IF lv_aktyp_003 = '01' OR lv_aktyp_003 = '02' OR lv_aktyp_003 = '03'
