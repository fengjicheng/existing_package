*&---------------------------------------------------------------------*
* REVISION NO:   ED2K908162
* REFERENCE NO:  ERP-2974
* DEVELOPER:     Writtick Roy (WROY)
* DATE:          23-Aug-2017
* DESCRIPTION:
* 1. Provide option for Immediate processing VS Batch processing
* 2. Update Error Handling process to display Standard messages
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
***INCLUDE LZQTC_INBOUND_SAP_ORDERS_FGF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ERROR_MSG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_error_msg  CHANGING f_ex_message TYPE bapiretct.
* Begin of DEL:RFC Issue:WROY:23-AUG-2017:ED2K908162
*  CONSTANTS :  lc_e          TYPE  bapi_mtype  VALUE 'E',       " Message type: S Success, E Error, W Warning, I Info, A Abort
*               lc_id         TYPE  symsgid     VALUE 'ZQTC_R2', " Message Class
*               lc_msg_number TYPE  symsgno     VALUE '048'.     " Message Number
* End   of DEL:RFC Issue:WROY:23-AUG-2017:ED2K908162
  DATA :  lst_message TYPE bapiretc. " Return Parameter for Complex Data Type
* Begin of DEL:RFC Issue:WROY:23-AUG-2017:ED2K908162
*  lst_message-type    = lc_e.
*  lst_message-id      = lc_id.
*  lst_message-number  = lc_msg_number.
*  MESSAGE ID lc_id
*  TYPE       lc_e
*  NUMBER     lc_msg_number
*  INTO       lst_message-message.
* End   of DEL:RFC Issue:WROY:23-AUG-2017:ED2K908162
* Begin of ADD:RFC Issue:WROY:23-AUG-2017:ED2K908162
  lst_message-type        = sy-msgty.
  lst_message-id          = sy-msgid.
  lst_message-number      = sy-msgno.
  lst_message-message_v1  = sy-msgv1.
  lst_message-message_v2  = sy-msgv2.
  lst_message-message_v3  = sy-msgv3.
  lst_message-message_v4  = sy-msgv4.
  MESSAGE ID sy-msgid
        TYPE sy-msgty
      NUMBER sy-msgno
        WITH sy-msgv1
             sy-msgv2
             sy-msgv3
             sy-msgv4
        INTO lst_message-message.
* End   of ADD:RFC Issue:WROY:23-AUG-2017:ED2K908162
  APPEND lst_message TO f_ex_message.
  CLEAR lst_message.


ENDFORM.
