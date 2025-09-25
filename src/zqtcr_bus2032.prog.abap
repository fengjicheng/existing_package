*****           Implementation of object type ZWOBUS2032           *****
INCLUDE <object>. " INCLUDE for Object Type Definition
begin_data object. " Do not change.. DATA is generated
* only private members may be inserted into structure private
DATA:
                                   " begin of private,
                                   "   to declare private attributes remove comments and
                                   "   insert private attributes here ...
                                   " end of private,
  BEGIN OF key,
    salesdocument LIKE vbak-vbeln, " Sales Document
  END OF key,
  zwav_wf_trigger TYPE kalp-ekkey. " Checkbox
end_data object. " Do not change.. DATA is generated

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
    im_task  = 'WS90200029' "'WS90100014'
  IMPORTING
    ex_flag  = object-zwav_wf_trigger.

swc_set_element container 'ZWAV_WF_TRIGGER' object-zwav_wf_trigger.
end_property.
