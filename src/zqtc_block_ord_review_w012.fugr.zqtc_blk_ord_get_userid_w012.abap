*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTC_BLK_ORD_GET_USERID_W012                   *
* PROGRAM DESCRIPTION:  Function module to retrieve user name and      *
*                       corresponding userid.                          *
* DEVELOPER:            Paramita Bose (PBOSE)                          *
* CREATION DATE:        28/02/2017                                     *
* OBJECT ID:            W012                                           *
* TRANSPORT NUMBER(S):  ED2K904702                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906436
* REFERENCE NO: ERP-2451
* DEVELOPER: Writtick Roy (WROY)
* DATE:  05/31/2017
* DESCRIPTION: Additional check for Delivery / Billing Block
*----------------------------------------------------------------------*
FUNCTION zqtc_blk_ord_get_userid_w012.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VBELN) TYPE  VBELN
*"     REFERENCE(IM_FLAG) TYPE  ABEKZ
*"  EXPORTING
*"     REFERENCE(EX_AGENT) TYPE  ZTQTC_USERID
*"----------------------------------------------------------------------
* Data declaration
  DATA : li_result        TYPE tswhactor,     " Internal table for result
         li_return        TYPE bapiret2_t,    " Return table
         lst_address      TYPE bapiaddr3,     " BAPI reference structure for addresses (contact person)
         lst_agent        TYPE zstqtc_userid, " Structure for email and userid
*** BOC BY SAYANDAS on 03-OCT-2017 for CR-674
         lv_scr_app_otype TYPE otype,
         lv_scr_app_objid TYPE actorid. " Agent ID in Organizational Management
*** EOC BY SAYANDAS on 03-OCT-2017 for CR-674

* Constant Declaration
  CONSTANTS : lc_fst_level TYPE abekz VALUE 'A', " Exception indicator : First level approver
              lc_scn_level TYPE abekz VALUE 'B', " Exception indicator : Second level approver
              lc_scr_level TYPE abekz VALUE 'C'. " Exception indicator : SCR

* If WF resides with first level approver, then proceed to
* get the userid and email ID for first level approver.
  IF im_flag EQ lc_fst_level.

*   Fetch sales related values from VBAK table
    SELECT SINGLE vbeln, " Sales Document
           auart,        " Order type
           lifsk,        " Delivery Block
           faksk,        " Billing block in SD document
           vkorg,        " Sales org
           vtweg,        " Distribution Channel
           spart         " Division
      INTO @DATA(lst_vbak)
      FROM vbak          " Sales Document: Header Data
      WHERE vbeln EQ @im_vbeln.

    IF sy-subrc IS INITIAL.
* Fetch Username from custom table
      SELECT SINGLE first_app_otype, " Object Type
             first_app_objid         " Cost Estimate Number
        FROM zqtc_apprvl_mtrx        " Approval table for Subs WF
        INTO @DATA(lst_userdet)
        WHERE vkorg EQ @lst_vbak-vkorg
          AND vtweg EQ @lst_vbak-vtweg
          AND spart EQ @lst_vbak-spart
          AND auart EQ @lst_vbak-auart
*         Begin of ADD:ERP-2451:WROY:31-MAY-2017:ED2K906436
          AND lifsk EQ @lst_vbak-lifsk
          AND faksk EQ @lst_vbak-faksk.
*         End   of ADD:ERP-2451:WROY:31-MAY-2017:ED2K906436

      IF sy-subrc EQ 0.
        CONCATENATE lst_userdet-first_app_otype lst_userdet-first_app_objid INTO lst_agent-userid.
        APPEND lst_agent TO ex_agent.
        CLEAR lst_agent.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc IS INITIAL
  ELSEIF im_flag EQ lc_scn_level.

* Retrieve delivery block and billing block
    SELECT SINGLE vbeln, " Sales Document
           auart,        " Order type
           lifsk,        " Delivery Block
           faksk,        " Billing block in SD document
           vkorg,        " Sales org
           vtweg,        " Distribution Channel
           spart         " Division
      INTO @DATA(lst_vbak1)
      FROM vbak          " Sales Document: Header Data
      WHERE vbeln EQ @im_vbeln.

    IF sy-subrc IS INITIAL.
*     Fetch Username from custom table
      SELECT SINGLE second_app_otype, " Object Type
             second_app_objid         " Cost Estimate Number
        FROM zqtc_apprvl_mtrx         " Approval table for Subs WF
        INTO @DATA(lst_usrdet)
        WHERE vkorg EQ @lst_vbak1-vkorg
          AND vtweg EQ @lst_vbak1-vtweg
          AND spart EQ @lst_vbak1-spart
          AND auart EQ @lst_vbak1-auart
          AND lifsk EQ @lst_vbak1-lifsk
          AND faksk EQ @lst_vbak1-faksk.

      IF sy-subrc EQ 0.
        CONCATENATE lst_usrdet-second_app_otype lst_usrdet-second_app_objid INTO lst_agent-userid.
        APPEND lst_agent TO ex_agent.
        CLEAR lst_agent.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc IS INITIAL
  ELSEIF im_flag EQ lc_scr_level.
* Retrieve delivery block and billing block
    SELECT SINGLE vbeln, " Sales Document
*** BOC BY SAYANDAS on 03-OCT-2017 for CR-674
           ernam,
*** EOC BY SAYANDAS on 03-OCT-2017 for CR-674
           auart, " Order type
           lifsk, " Delivery Block
           faksk, " Billing block in SD document
           vkorg, " Sales org
           vtweg, " Distribution Channel
           spart  " Division
      INTO @DATA(lst_vbak2)
      FROM vbak   " Sales Document: Header Data
      WHERE vbeln EQ @im_vbeln.

    IF sy-subrc IS INITIAL.
*** BOC BY SAYANDAS on 03-OCT-2017 for CR-674
** Fetch Username from custom table
*      SELECT SINGLE scr_app_otype, " Object Type
*                    scr_app_objid  " Cost Estimate Number
*        FROM zqtc_apprvl_mtrx      " Approval table for Subs WF
*        INTO @DATA(lst_userdetail)
*        WHERE vkorg EQ @lst_vbak2-vkorg
*          AND vtweg EQ @lst_vbak2-vtweg
*          AND spart EQ @lst_vbak2-spart
*          AND auart EQ @lst_vbak2-auart
**         Begin of ADD:ERP-2451:WROY:31-MAY-2017:ED2K906436
*          AND lifsk EQ @lst_vbak2-lifsk
*          AND faksk EQ @lst_vbak2-faksk.
*         End   of ADD:ERP-2451:WROY:31-MAY-2017:ED2K906436
*** EOC BY SAYANDAS on 03-OCT-2017 for CR-674
*      IF sy-subrc EQ 0. " Commented for CR-674 BY SAYANDAS
*       Check whether Object type is Position
*        IF lst_userdetail-scr_app_otype = 'S'. " Commented BY SAYANDAS for CR-674
*** BOC BY SAYANDAS on 03-OCT-2017 for CR-674
      lv_scr_app_otype = 'US'.
      lv_scr_app_objid = lst_vbak2-ernam.
*** EOC BY SAYANDAS on 03-OCT-2017 for CR-674
*         IF lst_userdetail-scr_app_otype = 'US'. " Commented BY SAYANDAS for CR-674
      IF lv_scr_app_otype = 'US'.
*** BOC BY SAYANDAS on 03-OCT-2017 for CR-674
**       Fetch position from object ID and object type
*        CALL FUNCTION 'RH_STRUC_GET'
*          EXPORTING
*            act_otype       = lv_scr_app_otype "lst_userdetail-scr_app_otype " commented
*            act_objid       = lv_scr_app_objid "lst_userdetail-scr_app_objid " commented
*            act_wegid       = 'A008'
*            act_plvar       = '01'
*            act_begda       = sy-datum
*            act_endda       = sy-datum
*            act_tflag       = abap_true
*            act_vflag       = abap_true
*            authority_check = abap_true
*          TABLES
*            result_tab      = li_result
*          EXCEPTIONS
*            no_plvar_found  = 1
*            no_entry_found  = 2
*            OTHERS          = 3.

*        IF sy-subrc EQ 0.
*          LOOP AT li_result INTO DATA(lst_result).
**           Get User details from object id
*            CALL FUNCTION 'BAPI_USER_GET_DETAIL'
*              EXPORTING
*                username = lst_result-objid
*              IMPORTING
*                address  = lst_address
*              TABLES
*                return   = li_return.
*
**             Populate CSR email ID and Object ID
*            lst_agent-userid  = lst_result-objid. " Object ID
*            lst_agent-emailid = lst_address-e_mail. " Email
*            APPEND lst_agent TO ex_agent.
*            CLEAR lst_agent.
*          ENDLOOP. " LOOP AT li_result INTO DATA(lst_result)
*        ENDIF. " IF sy-subrc EQ 0
*      ELSE. " ELSE -> IF lv_scr_app_otype = 'US'
*** EOC BY SAYANDAS on 03-OCT-2017 for CR-674
*         Get User details from object id
        CALL FUNCTION 'BAPI_USER_GET_DETAIL'
          EXPORTING
            username = lv_scr_app_objid "lst_userdetail-scr_app_objid "commenmted
          IMPORTING
            address  = lst_address
          TABLES
            return   = li_return.

*         Populate CSR email ID and Object ID
*** BOC BY SAYANDAS on 03-OCT-2017 for CR-674
*          CONCATENATE lst_userdetail-scr_app_otype
*                      lst_userdetail-scr_app_objid
*          INTO lst_agent-userid. " Object ID
        CONCATENATE lv_scr_app_otype
                    lv_scr_app_objid
        INTO lst_agent-userid.
*** EOC BY SAYANDAS on 03-OCT-2017 for CR-674
        lst_agent-emailid = lst_address-e_mail. " Email
        APPEND lst_agent TO ex_agent.
        CLEAR lst_agent.
      ENDIF. " IF lv_scr_app_otype = 'US'
*      ENDIF. " IF sy-subrc EQ 0 " Commented for CR-674 BY SAYANDAS
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF im_flag EQ lc_fst_level
ENDFUNCTION.
