*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_BUILD_FIELD_CAT_R112 (Include Program)
* PROGRAM DESCRIPTION: Build field catalog for custom fields
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   05/30/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918328
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------*

" Unit price
CLEAR : fieldcat.
fieldcat-col_pos = 27.
fieldcat-fieldname = 'NETWR'.
fieldcat-tabname = 1.
CONDENSE fieldcat-tabname.
fieldcat-coltext   = text-901."'Potential value of release orders'.
fieldcat-datatype  = 'CURR'.
fieldcat-outputlen = 18.
fieldcat-dd_outlen = 18.
APPEND fieldcat TO fieldcatalog.

" Currency
CLEAR : fieldcat.
fieldcat-col_pos = 28.
fieldcat-fieldname = 'WAERK'.
fieldcat-tabname = 1.
CONDENSE fieldcat-tabname.
fieldcat-coltext   = text-902.   "'Currency'.
fieldcat-datatype  = 'CUKY'.
fieldcat-outputlen = 5.
fieldcat-dd_outlen = 5.
APPEND fieldcat TO fieldcatalog.

" Media Product
CLEAR : fieldcat.
fieldcat-col_pos = 29.
fieldcat-fieldname = 'MATNR'.
fieldcat-tabname = 1.
CONDENSE fieldcat-tabname.
fieldcat-coltext   = text-903." 'Media Product'.
fieldcat-datatype  = 'CHAR'.
fieldcat-outputlen = 18.
fieldcat-dd_outlen = 18.
fieldcat-lowercase = abap_true.
APPEND fieldcat TO fieldcatalog.

" Journal Code
CLEAR : fieldcat.
fieldcat-col_pos = 30.
fieldcat-fieldname = 'IDENTCODE'.
fieldcat-tabname = 1.
CONDENSE fieldcat-tabname.
fieldcat-coltext   = text-904.  "'Journal Code'.
fieldcat-datatype  = 'CHAR'.
fieldcat-outputlen = 18.
fieldcat-dd_outlen = 18.
fieldcat-lowercase = abap_true.
APPEND fieldcat TO fieldcatalog.

" Country
CLEAR : fieldcat.
fieldcat-col_pos = 31.
fieldcat-fieldname = 'COUNTRY'.
fieldcat-tabname = 1.
CONDENSE fieldcat-tabname.
fieldcat-coltext   = text-980.  "'Country'.
fieldcat-datatype  = 'CHAR'.
fieldcat-outputlen = 20.
fieldcat-dd_outlen = 20.
fieldcat-lowercase = abap_true.
APPEND fieldcat TO fieldcatalog.


" Postal code
CLEAR : fieldcat.
fieldcat-col_pos = 32.
fieldcat-fieldname = 'POSTAL_CODE'.
fieldcat-tabname = 1.
CONDENSE fieldcat-tabname.
fieldcat-coltext   = text-981.  "'Postal code'.
fieldcat-datatype  = 'CHAR'.
fieldcat-outputlen = 10.
fieldcat-dd_outlen = 10.
APPEND fieldcat TO fieldcatalog.


" Distributor
CLEAR : fieldcat.
fieldcat-col_pos = 33.
fieldcat-fieldname = 'VENDOR'.
fieldcat-tabname = 1.
CONDENSE fieldcat-tabname.
fieldcat-coltext   = text-982.  "'Distributor'.
fieldcat-datatype  = 'CHAR'.
fieldcat-outputlen = 10.
fieldcat-dd_outlen = 10.
APPEND fieldcat TO fieldcatalog.

" plant
CLEAR : fieldcat.
fieldcat-col_pos = 34.
fieldcat-fieldname = 'PLANT'.
fieldcat-tabname = 1.
CONDENSE fieldcat-tabname.
fieldcat-coltext   = text-983.  "'Plant'.
fieldcat-datatype  = 'CHAR'.
fieldcat-outputlen = 5.
fieldcat-dd_outlen = 5.
APPEND fieldcat TO fieldcatalog.


" Ship Mode
CLEAR : fieldcat.
fieldcat-col_pos = 35.
fieldcat-fieldname = 'SHIP_METHOD'.
fieldcat-tabname = 1.
CONDENSE fieldcat-tabname.
fieldcat-coltext   = text-984.  "'Shi mode'.
fieldcat-datatype  = 'CHAR'.
fieldcat-outputlen = 20.
fieldcat-dd_outlen = 20.
fieldcat-lowercase = abap_true.
APPEND fieldcat TO fieldcatalog.
