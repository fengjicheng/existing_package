**----------------------------------------------------------------------*
** PROGRAM NAME:         ZQTCR_BUS2034                                  *
** PROGRAM DESCRIPTION:  Program for business object BUS2034            *
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

*****           Implementation of object type ZWOBUS2034           *****
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
  im_flag  TYPE mdez-abekz,             " Exception indicator
  ex_agent LIKE zstqtc_userid OCCURS 0. " Structure for email and userid

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

get_property zwav_wf_trigger changing container.

CALL FUNCTION 'ZQTC_BLOCK_ORD_TRIG_COND_W012'
  EXPORTING
    im_vbeln = object-key-salesdocument
    im_task  = 'WS90200028' "'WS90100011'
  IMPORTING
    ex_flag  = object-zwav_wf_trigger.

swc_set_element container 'ZWAV_WF_TRIGGER' object-zwav_wf_trigger.
end_property.

begin_method zwnbf_get_usertype changing container.
DATA:
  im_agent         TYPE wfsyst-agent, " Agent
  ex_agent_type    TYPE mdey-abekz,
  lv_agent         TYPE wfsyst-agent, " Agent
  lv_ex_agent_type TYPE xuustyp.
swc_get_element container 'IM_AGENT' im_agent.


*lv_agent = im_agent+2(12).
lv_agent = im_agent.
SELECT SINGLE ustyp " User Type
  FROM usr02        " Logon Data (Kernel-Side Use)
  INTO lv_ex_agent_type
  WHERE bname EQ lv_agent.

ex_agent_type = lv_ex_agent_type.

swc_set_element container 'EX_Agent_type' ex_agent_type.
end_method.
