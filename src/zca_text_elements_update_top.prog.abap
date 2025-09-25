*&---------------------------------------------------------------------*
*&  Include           ZCA_TEXT_ELEMENTS_UPDATE_TOP
*&---------------------------------------------------------------------*


TYPE-POOLS :slis.
TYPES: BEGIN OF ty_text_details,
         tdname TYPE tdobname,
         spras  TYPE spras,
         ltext  TYPE  char2048,   "ltext,       "Long Text
         tdformat TYPE tdformat,
       END OF ty_text_details.
TYPES : BEGIN OF ty_text,
          tdformat TYPE tdformat,
          text     TYPE tdline,
        END OF ty_text.


DATA:  i_text_data TYPE STANDARD TABLE OF ty_text_details,
       i_text      TYPE TABLE OF ty_text.
