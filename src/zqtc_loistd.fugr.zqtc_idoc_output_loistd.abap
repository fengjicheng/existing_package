FUNCTION zqtc_idoc_output_loistd.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(MESSAGE_TYPE) TYPE  BDMSGTYP-MESTYP OPTIONAL
*"     VALUE(RCVPRN) TYPE  BDALEDC-RCVPRN OPTIONAL
*"  EXPORTING
*"     VALUE(IDOC_MUST_BE_SENT)
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME        :ZQTC_IDOC_OUTPUT_LOISTD(FM)
* PROGRAM DESCRIPTION : Get the stock info changes and genrated the
*                       Outbound IDOCs (Outbound Process Code)
* DEVELOPER          : Venkata D Rao P (VDPATABALL)
* CREATION DATE      : 05/14/2020
* OBJECT ID          : I0382
* TRANSPORT NUMBER(S):ED2K918150
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
  DATA:created_masteridocs_std TYPE sy-tabix.


*---free the all variables and all tables.
  PERFORM f_free_all.

*---Get the Constant Values from Constant Table
  PERFORM f_get_constants.

*---Assign the message type to global
  FREE created_masteridocs_std.
  iv_msgtyp = message_type.
  rcvprn    = iv_target .
*---get the Last run date and time
  PERFORM f_get_last_date_time.

*---Get the Changes log Values from CDHDR and CDPOS
  PERFORM f_get_change_log.

*----Get the material from table EBAN
  PERFORM f_get_eban_from_material.

*----Get the material from table EKPO
  PERFORM f_get_ekpo_from_material.

*----Get the material from table VBAP
  PERFORM f_get_vbap_from_material.

*----Get the delivery from table LIPS
  PERFORM f_get_lips_from_material.

*----Get the material from table MARC
  PERFORM f_get_marc_from_material.

*----Creating Range table to material
  PERFORM f_range_table_material.

*----Create the IDOC from standard report
  PERFORM f_submit_sel_to_idoc_create.

*---Check the ALE Model Snding status using below FM
  CALL FUNCTION 'ALE_MODEL_DETERMINE_IF_TO_SEND'
    EXPORTING
      message_type           = message_type
      receiving_system       = rcvprn
    IMPORTING
      idoc_must_be_sent      = idoc_must_be_sent
    EXCEPTIONS
      own_system_not_defined = 1
      OTHERS                 = 2.

*---IF the sent status is blank then raise the error
  IF idoc_must_be_sent IS INITIAL.
    IF rcvprn IS INITIAL.
      MESSAGE e004(gds_extract) WITH message_type
                                     RAISING no_ale_model.
    ELSE.
      MESSAGE e014(gds_extract) WITH rcvprn message_type
                                     RAISING no_ale_model.
    ENDIF.
    EXIT.

  ELSE.
*---Update last run date and time to constant table
    IF iv_date_last IS NOT INITIAL.
      st_interface-lrdat          =  iv_date_last.
      st_interface-lrtime         =  iv_time_last.
      UPDATE zcainterface FROM st_interface.
    ENDIF.
*----If sent status is successfull then import the no.of IDOCs from the standard report
*----then raise the information messages in RBDMIDOC Report
    IMPORT  created_masteridocs_std TO  created_masteridocs_std FROM MEMORY ID 'LOI001'.
    MESSAGE ID c_b1 TYPE c_i NUMBER c_038
        WITH  created_masteridocs_std message_type.
    MESSAGE ID c_b1 TYPE c_i NUMBER c_039
            WITH  created_masteridocs_std message_type.
    FREE MEMORY ID 'LOI001'.
    FREE:created_masteridocs_std .
  ENDIF.

ENDFUNCTION.
