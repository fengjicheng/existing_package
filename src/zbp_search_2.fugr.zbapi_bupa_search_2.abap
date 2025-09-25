FUNCTION zbapi_bupa_search_2.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_EMAIL) TYPE  BAPIBUS1006_COMM-E_MAIL OPTIONAL
*"  TABLES
*"      IT_ADDR STRUCTURE  ZBP_ADDR OPTIONAL
*"      IT_RET STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------

  DATA:li_addr1 TYPE STANDARD TABLE OF bapibus1006_bp_addr.
  CALL FUNCTION 'BAPI_BUPA_SEARCH_2'
    EXPORTING
*     TELEPHONE    =
      email        = i_email
*     URL          =
*     ADDRESSDATA  =
*     CENTRALDATA  =
*     BUSINESSPARTNERROLECATEGORY       =
*     ALL_BUSINESSPARTNERROLES          =
*     BUSINESSPARTNERROLE               =
*     COUNTRY_FOR_TELEPHONE             =
*     FAX_DATA     =
*     VALID_DATE   =
*     OTHERS       =
*     IV_REQ_MASK  = 'X'
    TABLES
      searchresult = li_addr1
      return       = it_ret.
  .
  DATA:lst_adr2 TYPE zbp_addr.
  LOOP AT li_addr1 INTO DATA(lst_addr1).
    MOVE-CORRESPONDING lst_addr1 TO lst_adr2.
    lst_adr2-email = i_email.
    APPEND lst_adr2 TO it_addr.
  ENDLOOP.
ENDFUNCTION.
