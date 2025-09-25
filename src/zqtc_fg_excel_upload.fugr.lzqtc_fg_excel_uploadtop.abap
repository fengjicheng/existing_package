FUNCTION-POOL ZQTC_FG_EXCEL_UPLOAD.         "MESSAGE-ID ..

* INCLUDE LZQTC_FG_EXCEL_UPLOADD...          " Local class definition
TYPE-POOLS: ole2.

*      value of excel-cell
TYPES: ty_d_itabvalue             TYPE ZQTC_ALSMEX_TABLINE-value,
*      internal table containing the excel data
       ty_t_itab                  TYPE ZQTC_ALSMEX_TABLINE   OCCURS 0,

*      line type of sender table
       BEGIN OF ty_s_senderline,
         line(4096)               TYPE c,
       END OF ty_s_senderline,
*      sender table
       ty_t_sender                TYPE ty_s_senderline  OCCURS 0.

*
CONSTANTS:  gc_esc              VALUE '"'.
