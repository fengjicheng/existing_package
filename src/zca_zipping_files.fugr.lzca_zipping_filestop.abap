FUNCTION-POOL zca_zipping_files MESSAGE-ID zqtc_r2.

* INCLUDE LZCA_ZIPPING_FILESD...             " Local class definition

* Global Types Declarations
TYPES: BEGIN OF ty_files,
         name TYPE file_name,
         size TYPE pfeflsize,
       END OF ty_files,
       tt_files TYPE STANDARD TABLE OF ty_files INITIAL SIZE 0.
