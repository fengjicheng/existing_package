FUNCTION zqtc_update_external_id_bp.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  TABLES
*"      T_EXT_IDENT STRUCTURE  ZQTC_EXT_IDENT OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_UPDATE_EXTERNAL_ID_BP
* PROGRAM DESCRIPTION:FM for populating External ID number BP table
* DEVELOPER: Siva Guda
* CREATION DATE:   22/03/2018
* OBJECT ID:ERP-7078, ERP-6095, ERP-7136
* TRANSPORT NUMBER(S) : ED2K911506
*-------------------------------------------------------------------*

  DATA : lt_zqtc_ext_ident TYPE STANDARD TABLE OF zqtc_ext_ident,
         lst_return        TYPE bapiret2.

  DATA : lv_fval(200) TYPE c,
         lv_title     TYPE zqtc_ext_id_no,
         lv_value     TYPE zqtc_ext_id_no,
         lv_msgtyp    TYPE bapi_mtype,
         lv_partner   TYPE bu_partner.

  lt_zqtc_ext_ident[] = t_ext_ident[].

* Create Application log
  READ TABLE lt_zqtc_ext_ident INTO DATA(lst_zqtc_ext_ident) INDEX 1.
  IF sy-subrc EQ 0.
    lv_partner = lst_zqtc_ext_ident-partner.
    PERFORM f_create_log USING lv_partner
                         CHANGING gv_log_handle.
  ENDIF.



  IF lt_zqtc_ext_ident IS  NOT INITIAL.
    MODIFY zqtc_ext_ident FROM TABLE lt_zqtc_ext_ident.
    IF sy-subrc EQ 0.
      lv_fval = 'Table ZQTC_EXT_IDENT updated with below Partner and Identificaton Nos'(002).
      lv_msgtyp = 'S'.
    ELSE.
      lv_fval = 'Error While updating Table ZQTC_EXT_IDENT with below Partner and Identificaton Nos'(003).
      lv_msgtyp = 'E'.
    ENDIF.
* update application log
    PERFORM f_log_maintain  USING lv_msgtyp
                                  lv_fval
                                  gv_log_handle.
    LOOP AT lt_zqtc_ext_ident INTO lst_zqtc_ext_ident.
      lv_msgtyp = 'I'.
* Partner data
      CLEAR: lv_title,
             lv_value.
      lv_title = 'Partner:'(004).
      lv_value = lst_zqtc_ext_ident-partner.
      PERFORM update_message USING lv_msgtyp lv_title lv_value
                                   gv_log_handle.
* Ident type
      CLEAR: lv_title,
             lv_value.
      lv_title = 'Identification Type:'(005).
      lv_value = lst_zqtc_ext_ident-type.
      PERFORM update_message USING lv_msgtyp lv_title lv_value
                                   gv_log_handle.
* Identification number
      CLEAR: lv_title,
             lv_value.
      lv_title = 'Identification Number:'(006).
      lv_value = lst_zqtc_ext_ident-idnumber.
      PERFORM update_message USING lv_msgtyp  lv_title lv_value
                                   gv_log_handle.

* External Identification number
      CLEAR: lv_title,
             lv_value.
      lv_title = 'External Identification Number:'(007).
      lv_value = lst_zqtc_ext_ident-ext_idnumber.
      PERFORM update_message USING lv_msgtyp lv_title lv_value
                                   gv_log_handle.


    ENDLOOP.
* Save the log
    PERFORM f_log_save USING gv_log_handle.
  ENDIF.

ENDFUNCTION.
