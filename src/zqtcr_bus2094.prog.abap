**----------------------------------------------------------------------*
** PROGRAM NAME:         ZQTCR_BUS2094                                  *
** PROGRAM DESCRIPTION:  Program for business object BUS2094            *
** DEVELOPER:            Paramita Bose (PBOSE)                          *
** CREATION DATE:        09/03/2017                                     *
** OBJECT ID:            W012                                           *
** TRANSPORT NUMBER(S):  ED2K904702                                     *
**----------------------------------------------------------------------*
**----------------------------------------------------------------------*
** REVISION HISTORY-----------------------------------------------------*
** REVISION NO: <TRANSPORT NO>
** REFERENCE NO:  <DER OR TPR OR SCR>
** DEVELOPER:
** DATE:  MM/DD/YYYY
** DESCRIPTION:
**----------------------------------------------------------------------*

*****           Implementation of object type ZWOBUS2094           *****
INCLUDE <object>. " INCLUDE for Object Type Definition
BEGIN_DATA OBJECT. " Do not change.. DATA is generated
* only private members may be inserted into structure private
DATA:
" begin of private,
"   to declare private attributes remove comments and
"   insert private attributes here ...
" end of private,
  BEGIN OF KEY,
      SALESDOCUMENT LIKE VBAK-VBELN,
  END OF KEY,
      ZWAV_WF_TRIGGER TYPE KALP-EKKEY.
END_DATA OBJECT. " Do not change.. DATA is generated

begin_method zwmbf_get_agent changing container.
DATA:
  ex_agent LIKE zstqtc_userid OCCURS 0, " Structure for email and userid
  im_flag  TYPE mdez-abekz.             " Exception indicator
swc_get_element container 'IM_FLAG' im_flag.
CALL FUNCTION 'ZQTC_BLK_ORD_GET_USERID_W012'
  EXPORTING
    im_vbeln = object-key-salesdocument
    im_flag  = im_flag
  IMPORTING
    ex_agent = ex_agent.

swc_set_table container 'EX_AGENT' ex_agent.
end_method.

begin_method zwmbf_delete_block changing container.

CALL FUNCTION 'ZQTC_DELETE_DELIVERY_BILL_BLCK'
  EXPORTING
    im_vbeln = object-key-salesdocument
  EXCEPTIONS
    exc_lock = 1
    exc_fail = 2
    OTHERS   = 3.

IF sy-subrc EQ 1.
  exit_return 9001 space space space space.
ELSEIF sy-subrc EQ 2.
  exit_return 9002 space space space space.
ENDIF. " IF sy-subrc EQ 1

end_method.

begin_method zwmbf_rej_reason changing container.
CALL FUNCTION 'ZQTC_REJECTION_REASON_UPDATE'
  EXPORTING
    im_vbeln = object-key-salesdocument
  EXCEPTIONS
    exc_lock = 1
    exc_fail = 2
    OTHERS   = 3.
IF sy-subrc EQ 1.
  exit_return 9001 space space space space.
ELSEIF sy-subrc EQ 2.
  exit_return 9002 space space space space.
ENDIF. " IF sy-subrc EQ 0
end_method.


begin_method zwmbf_get_text changing container.
DATA:
  im_workitemid  TYPE swr_struct-workitemid, " Work item ID
  im_user        TYPE wfsyst-agent,          " Agent
  im_langu       TYPE syst-langu,            " ABAP System Field: Language Key of Text Environment
  ex_text        TYPE tline_t,
  ex_reason_text TYPE ztqtc_reason_text.


swc_get_element container 'IM_WORKITEMID' im_workitemid.
swc_get_element container 'IM_USER' im_user.
swc_get_element container 'IM_LANGU' im_langu.

CALL FUNCTION 'ZQTC_GET_ACTION_TEXT'
  EXPORTING
    im_workitemid  = im_workitemid
    im_user        = im_user
    im_langu       = im_langu
  IMPORTING
    ex_text        = ex_text
    ex_reason_text = ex_reason_text.


swc_set_table container 'EX_TEXT' ex_text.
swc_set_table container 'EX_REASON_TEXT' ex_reason_text.
end_method.

begin_method zwmbf_calculate_wait_date changing container.
DATA:
  ex_wait_date TYPE syst-datum, " ABAP System Field: Current Date of Application Server
  ex_days      TYPE vbak-vtweg. " Distribution Channel

CALL FUNCTION 'ZQTC_CALCULATE_WAITING_DATE'
  IMPORTING
    ex_wait_date = ex_wait_date
    ex_days      = ex_days.

swc_set_element container 'EX_WAIT_DATE' ex_wait_date.
swc_set_element container 'EX_DAYS' ex_days.
end_method.

get_property zwav_wf_trigger changing container.

CALL FUNCTION 'ZQTC_BLOCK_ORD_TRIG_COND_W012'
  EXPORTING
    im_vbeln = object-key-salesdocument
    im_task  = 'WS90200030' "'WS90100013'
  IMPORTING
    ex_flag  = object-zwav_wf_trigger.

swc_set_element container 'ZWAV_WF_TRIGGER' object-zwav_wf_trigger.

end_property.

BEGIN_METHOD ZWMBF_GET_BLANK CHANGING CONTAINER.
END_METHOD.
