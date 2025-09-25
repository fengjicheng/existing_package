FUNCTION-POOL zrtr_transport_group.         "MESSAGE-ID ..

* INCLUDE LZRTR_TRANSPORT_GROUPD...          " Local class definition
TABLES: zca_tr_log,e070.
DATA:i_return TYPE char1.
DATA:i_log_handle TYPE bal_t_logh, " Application Log: Log Handle Table
     v_log_handle TYPE balloghndl, " Application Log: Log Handle
     v_lognumber  TYPE balognr.    " Application log: log number

CONSTANTS:c_msg_num_0 TYPE symsgno VALUE '000',
          c_msg_typ_i TYPE char1   VALUE 'I',
          c_msg_typ_e TYPE char1   VALUE 'E',
          c_zca       TYPE symsgid VALUE 'ZCA',
          c_zqtc_r2   TYPE symsgid VALUE 'ZQTC_R2'.

DATA: st_bal_msg TYPE bal_s_msg,  " Application Log: Message Data Structure
      i_bal_msg  TYPE bal_t_msg.  " Application Log: Message Data Table

DATA: i_line_length      TYPE i VALUE 254,
      o_editor_container TYPE REF TO cl_gui_custom_container,
      o_text_editor      TYPE REF TO cl_gui_textedit,
      i_text             TYPE string,
      i_message          TYPE string.
TYPES: BEGIN OF ty_tr,
         text TYPE string,
       END OF ty_tr.

DATA:t_text TYPE STANDARD TABLE OF ty_tr.
