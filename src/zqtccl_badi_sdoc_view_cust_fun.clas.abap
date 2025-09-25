class ZQTCCL_BADI_SDOC_VIEW_CUST_FUN definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_BADI_SDOC_VIEW_CUSTOM_FUNC .
protected section.
private section.
ENDCLASS.



CLASS ZQTCCL_BADI_SDOC_VIEW_CUST_FUN IMPLEMENTATION.


  METHOD if_badi_sdoc_view_custom_func~define_custom_function.
*----------------------------------------------------------------------*
* PROGRAM NAME:IF_BADI_SDOC_VIEW_CUSTOM_FUNC~DEFINE_CUSTOM_FUNCTION
* PROGRAM DESCRIPTION:BADI Implementation for defining customer function
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-12-10
* OBJECT ID:E099
* TRANSPORT NUMBER(S)ED2K903485
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906843
* REFERENCE NO: CR#543
* DEVELOPER: Paramita Bose
* DATE:  2017-07-03
* DESCRIPTION: add new buttons on ALV screen.
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915777
* REFERENCE NO: DM7836
* DEVELOPER: NPOLINA
* DATE:  08/13/2019
* DESCRIPTION: Layout field on ZQTC_VA05 selection screen
*----------------------------------------------------------------------*
* REVISION NO   : ED2K919999
* REFERENCE NO  : OTCM-27113/ E342
* DEVELOPER     : VDPATABALL
* DATE          :  11/02/2020
* DESCRIPTION   : This change will carry ‘Mass update of billing date using VA45
*----------------------------------------------------------------------*
    CONSTANTS: lc_mchanpo     TYPE salv_de_function VALUE 'MCHANPO',
               lc_mchanpotxt  TYPE salv_de_function VALUE 'MCHANPOTXT',
               lc_mchanpofun  TYPE salv_de_function VALUE 'MCHANPOFUN',
               lc_mchanpocond TYPE salv_de_function VALUE 'MCHANPOCON',
               lc_mchapopromo TYPE salv_de_function VALUE 'MCHANPOPRO',
               lc_mchapocan   TYPE salv_de_function VALUE 'MCHANPOCAN',
*               Begin of Change: PBOSE: 03-07-2017: CR#543: ED2K906843
               lc_mchamemcat  TYPE salv_de_function VALUE 'MCHANMEMCAT',
               lc_mchadb      TYPE salv_de_function VALUE 'MCHANDB',
               lc_mchabb      TYPE salv_de_function VALUE 'MCHANBB',
               lc_mchaliccat  TYPE salv_de_function VALUE 'MCHANLICCAT',
*               End of Change: PBOSE: 03-07-2017: CR#543: ED2K906843
               lc_mbilling    TYPE salv_de_function VALUE 'MBILLING'. "++VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45

    DATA lst_cust_func TYPE if_sdoc_function=>tcs_custom_function .

    IF sy-tcode EQ zclqtc_badi_sdoc_wrapper_mass=>c_tran_codes-tcode_va45 OR
       sy-tcode EQ zclqtc_badi_sdoc_wrapper_mass=>c_tran_codes-tcode_va25 OR
       sy-tcode EQ zclqtc_badi_sdoc_wrapper_mass=>c_tran_codes-tcode_va05.
      RETURN.
    ENDIF.

    IF iv_application_id = if_sdoc_select=>co_application_id-va25nn OR
       iv_application_id = if_sdoc_select=>co_application_id-va45nn OR
      iv_application_id = if_sdoc_select=>co_application_id-va05nn.  " NPOLINA ED2K915777 DM7836
      lst_cust_func-name = lc_mchanpo. "'MCHANPO'.
      lst_cust_func-text = 'Mass Change PO'(001).
      INSERT lst_cust_func INTO TABLE ct_custom_function.
      CLEAR lst_cust_func.
      lst_cust_func-name = lc_mchanpotxt. "'MCHANPOTXT'.
      lst_cust_func-text = 'Mass Change POtext'(002).
      INSERT lst_cust_func INTO TABLE ct_custom_function.
      CLEAR lst_cust_func.
      lst_cust_func-name = lc_mchanpofun. "'MCHANPOTXT'.
      lst_cust_func-text = 'Mass Chan Partner func'(003).
      INSERT lst_cust_func INTO TABLE ct_custom_function.
      CLEAR lst_cust_func.
      lst_cust_func-name = lc_mchanpocond. "'MCHANPOTXT'.
      lst_cust_func-text = 'Mass Chan Condition'(005).
      INSERT lst_cust_func INTO TABLE ct_custom_function.
      CLEAR lst_cust_func.
      lst_cust_func-name = lc_mchapopromo. "'MCHANPOTXT'.
      lst_cust_func-text = 'Mass Chan for Promo'(006).
      INSERT lst_cust_func INTO TABLE ct_custom_function.
      CLEAR lst_cust_func.
      lst_cust_func-name = lc_mchapocan. "'MCHANPOTXT'.
      lst_cust_func-text = 'Mass Cancel Order'(007).
      INSERT lst_cust_func INTO TABLE ct_custom_function.
      CLEAR lst_cust_func.
*     Begin of Change: PBOSE: 03-07-2017: CR#543: ED2K906843
      lst_cust_func-name = lc_mchamemcat. " Mass Change membership category.
      lst_cust_func-text = 'Mass change Mem Catg'(004).
      INSERT lst_cust_func INTO TABLE ct_custom_function.
      CLEAR lst_cust_func.
      lst_cust_func-name = lc_mchadb. " Mass change DB.
      lst_cust_func-text = 'Mass chng DB'(008).
      INSERT lst_cust_func INTO TABLE ct_custom_function.
      CLEAR lst_cust_func.
      lst_cust_func-name = lc_mchabb. " Mass change DB.
      lst_cust_func-text = 'Mass chng BB'(009).
      INSERT lst_cust_func INTO TABLE ct_custom_function.
      CLEAR lst_cust_func.
      lst_cust_func-name = lc_mchaliccat. " Mass change DB.
      lst_cust_func-text = 'Mass chng Lic Catg'(010).
      INSERT lst_cust_func INTO TABLE ct_custom_function.
      CLEAR lst_cust_func.
*     End of Change: PBOSE: 03-07-2017: CR#543: ED2K906843
*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
      lst_cust_func-name = lc_mbilling. " Mass Billing date button.
      lst_cust_func-text = 'Mass Billing Date'.
      INSERT lst_cust_func INTO TABLE ct_custom_function.
      CLEAR lst_cust_func.
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
    ENDIF.
  ENDMETHOD.


  METHOD if_badi_sdoc_view_custom_func~do_custom_function.
*----------------------------------------------------------------------*
* PROGRAM NAME:IF_BADI_SDOC_VIEW_CUSTOM_FUNC~DO_CUSTOM_FUNCTION
* PROGRAM DESCRIPTION:Handling the custom functionality
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-12-10
* OBJECT ID:E099
* TRANSPORT NUMBER(S)ED2K903485
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915777
* REFERENCE NO: DM7836
* DEVELOPER: NPOLINA
* DATE:  08/13/2019
* DESCRIPTION: Changes to ZQTC_VA05
*----------------------------------------------------------------------*
* REVISION NO   : ED2K919999
* REFERENCE NO  : OTCM-27113/ E342
* DEVELOPER     : VDPATABALL
* DATE          :  11/02/2020
* DESCRIPTION   : This change will carry ‘Mass update of billing date using VA45
*----------------------------------------------------------------------*
    CONSTANTS: lc_mchanpo     TYPE salv_de_function VALUE 'MCHANPO',    " ALV Function
               lc_mchanpotxt  TYPE salv_de_function VALUE 'MCHANPOTXT', " ALV Function
               lc_mchanpofun  TYPE salv_de_function VALUE 'MCHANPOFUN', " ALV Function
               lc_mchanpocond TYPE salv_de_function VALUE 'MCHANPOCON', " ALV Function
               lc_mchapopromo TYPE salv_de_function VALUE 'MCHANPOPRO', " ALV Function
               lc_mchapocan   TYPE salv_de_function VALUE 'MCHANPOCAN', " ALV Function
               lc_mbilling    TYPE salv_de_function VALUE 'MBILLING',     "++VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
*                   Begin of Change: PBOSE: 03-07-2017: CR#543: ED2K906843
               lc_mchamemcat  TYPE salv_de_function VALUE 'MCHANMEMCAT', " ALV Function
               lc_mchadb      TYPE salv_de_function VALUE 'MCHANDB',     " ALV Function
               lc_mchabb      TYPE salv_de_function VALUE 'MCHANBB',     " ALV Function
               lc_mchaliccat  TYPE salv_de_function VALUE 'MCHANLICCAT', " ALV Function
               lc_9010        TYPE sy-dynnr VALUE '9010',                " ABAP System Field: Current Dynpro Number
               lc_9011        TYPE sy-dynnr VALUE '9011',                " ABAP System Field: Current Dynpro Number
               lc_9012        TYPE sy-dynnr VALUE '9012',                " ABAP System Field: Current Dynpro Number
               lc_9013        TYPE sy-dynnr VALUE '9013',                " ABAP System Field: Current Dynpro Number
*                   End of Change: PBOSE: 03-07-2017: CR#543: ED2K906843
               lc_9001        TYPE sy-dynnr VALUE '9001', " ABAP System Field: Current Dynpro Number
               lc_9003        TYPE sy-dynnr VALUE '9003', " ABAP System Field: Current Dynpro Number
               lc_9009        TYPE sy-dynnr VALUE '9009', " ABAP System Field: Current Dynpro Number
               lc_9006        TYPE sy-dynnr VALUE '9006', " ABAP System Field: Current Dynpro Number
               lc_9007        TYPE sy-dynnr VALUE '9007', " ABAP System Field: Current Dynpro Number
               lc_9008        TYPE sy-dynnr VALUE '9008', " ABAP System Field: Current Dynpro Number
               lc_9014        TYPE sy-dynnr VALUE '9014'. "++VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
    DATA  lst_selected_row TYPE i. " Selected_row of type Integers
    FIELD-SYMBOLS: <lst_result> TYPE any.
*    break ndutta.
    CASE iv_application_id.
      WHEN if_sdoc_select=>co_application_id-va25nn OR
           if_sdoc_select=>co_application_id-va45nn OR
           if_sdoc_select=>co_application_id-va05nn.  "NPOLINA 08/13/2019 DM7836 ED2K915777
        CASE iv_name .
          WHEN lc_mchanpo. "'MCHANPO'.

            IF it_selected_rows[] IS  NOT INITIAL.
              CALL FUNCTION 'ZQTC_SD_VIEW_1'
                EXPORTING
                  im_application_id = iv_application_id
                  im_name           = iv_name
                  im_screen_no      = lc_9001
                TABLES
                  t_result          = it_result
                  t_selected_rows   = it_selected_rows
                CHANGING
                  ch_message        = ct_message.
            ENDIF. " IF it_selected_rows[] IS NOT INITIAL
          WHEN lc_mchanpotxt. "'MCHANPOTXT'.
            IF it_selected_rows[] IS  NOT INITIAL.
              CALL FUNCTION 'ZQTC_SD_VIEW_1'
                EXPORTING
                  im_application_id = iv_application_id
                  im_name           = iv_name
                  im_screen_no      = lc_9003
                TABLES
                  t_result          = it_result
                  t_selected_rows   = it_selected_rows
                CHANGING
                  ch_message        = ct_message.

            ENDIF. " IF it_selected_rows[] IS NOT INITIAL
          WHEN lc_mchanpofun.
            IF it_selected_rows[] IS  NOT INITIAL.
              CALL FUNCTION 'ZQTC_SD_VIEW_1'
                EXPORTING
                  im_application_id = iv_application_id
                  im_name           = iv_name
                  im_screen_no      = lc_9009
                TABLES
                  t_result          = it_result
                  t_selected_rows   = it_selected_rows
                CHANGING
                  ch_message        = ct_message.

            ENDIF. " IF it_selected_rows[] IS NOT INITIAL
          WHEN lc_mchanpocond.
            IF it_selected_rows[] IS  NOT INITIAL.
              CALL FUNCTION 'ZQTC_SD_VIEW_1'
                EXPORTING
                  im_application_id = iv_application_id
                  im_name           = iv_name
                  im_screen_no      = lc_9006
                TABLES
                  t_result          = it_result
                  t_selected_rows   = it_selected_rows
                CHANGING
                  ch_message        = ct_message.

            ENDIF. " IF it_selected_rows[] IS NOT INITIAL
          WHEN lc_mchapopromo.
            IF it_selected_rows[] IS  NOT INITIAL.
              CALL FUNCTION 'ZQTC_SD_VIEW_1'
                EXPORTING
                  im_application_id = iv_application_id
                  im_name           = iv_name
                  im_screen_no      = lc_9007
                TABLES
                  t_result          = it_result
                  t_selected_rows   = it_selected_rows
                CHANGING
                  ch_message        = ct_message.

            ENDIF. " IF it_selected_rows[] IS NOT INITIAL
          WHEN lc_mchapocan. " Cancel Orders
            IF it_selected_rows[] IS  NOT INITIAL.
              CALL FUNCTION 'ZQTC_SD_VIEW_1'
                EXPORTING
                  im_application_id = iv_application_id
                  im_name           = iv_name
                  im_screen_no      = lc_9008
                TABLES
                  t_result          = it_result
                  t_selected_rows   = it_selected_rows
                CHANGING
                  ch_message        = ct_message.
            ENDIF. " IF it_selected_rows[] IS NOT INITIAL

*          Begin of Change: PBOSE: 03-07-2017: CR#543: ED2K906843
          WHEN lc_mchabb. " Billing Block
            IF it_selected_rows[] IS  NOT INITIAL.
              CALL FUNCTION 'ZQTC_SD_VIEW_1'
                EXPORTING
                  im_application_id = iv_application_id
                  im_name           = iv_name
                  im_screen_no      = lc_9010
                TABLES
                  t_result          = it_result
                  t_selected_rows   = it_selected_rows
                CHANGING
                  ch_message        = ct_message.
            ENDIF. " IF it_selected_rows[] IS NOT INITIAL
          WHEN lc_mchadb. " Delivery Block
            IF it_selected_rows[] IS  NOT INITIAL.
              CALL FUNCTION 'ZQTC_SD_VIEW_1'
                EXPORTING
                  im_application_id = iv_application_id
                  im_name           = iv_name
                  im_screen_no      = lc_9011
                TABLES
                  t_result          = it_result
                  t_selected_rows   = it_selected_rows
                CHANGING
                  ch_message        = ct_message.
            ENDIF. " IF it_selected_rows[] IS NOT INITIAL

          WHEN lc_mchamemcat. " Member Category
            IF it_selected_rows[] IS  NOT INITIAL.
              CALL FUNCTION 'ZQTC_SD_VIEW_1'
                EXPORTING
                  im_application_id = iv_application_id
                  im_name           = iv_name
                  im_screen_no      = lc_9012
                TABLES
                  t_result          = it_result
                  t_selected_rows   = it_selected_rows
                CHANGING
                  ch_message        = ct_message.
            ENDIF. " IF it_selected_rows[] IS NOT INITIAL

          WHEN lc_mchaliccat. " Licence Group
            IF it_selected_rows[] IS  NOT INITIAL.
              CALL FUNCTION 'ZQTC_SD_VIEW_1'
                EXPORTING
                  im_application_id = iv_application_id
                  im_name           = iv_name
                  im_screen_no      = lc_9013
                TABLES
                  t_result          = it_result
                  t_selected_rows   = it_selected_rows
                CHANGING
                  ch_message        = ct_message.
            ENDIF. " IF it_selected_rows[] IS NOT INITIAL

*          End of Change: PBOSE: 03-07-2017: CR#543: ED2K906843
*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
          WHEN lc_mbilling. " Mass Billing Date
            IF it_selected_rows[] IS  NOT INITIAL.
              CALL FUNCTION 'ZQTC_SD_VIEW_1'
                EXPORTING
                  im_application_id = iv_application_id
                  im_name           = iv_name
                  im_screen_no      = lc_9014
                TABLES
                  t_result          = it_result
                  t_selected_rows   = it_selected_rows
                CHANGING
                  ch_message        = ct_message.
            ENDIF. " IF it_selected_rows[] IS NOT INITIAL
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
          WHEN OTHERS.
        ENDCASE.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
