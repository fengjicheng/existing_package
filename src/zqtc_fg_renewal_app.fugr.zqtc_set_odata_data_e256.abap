FUNCTION zqtc_set_odata_data_e256.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      TB_ITEM_DATA STRUCTURE  ZQTC_S_FUTURE_RENEWAL OPTIONAL
*"----------------------------------------------------------------------

  FREE:li_item1.

  APPEND LINES OF tb_item_data TO li_item1.

ENDFUNCTION.
