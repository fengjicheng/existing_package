FUNCTION-POOL zqtc_table_read.              "MESSAGE-ID ..

* INCLUDE LZQTC_TABLE_READD...               " Local class definition

DATA:
  i_buff_vbkd TYPE vbkd_t.                   "Sales Document: Business Data

CONSTANTS:
  c_posnr_hdr TYPE posnr     VALUE '000000'. "Item number of the SD document (Header)
