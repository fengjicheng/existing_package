*&---------------------------------------------------------------------*
*&  Include  ZQTC_CONTRACT_TYPE_E164
*&---------------------------------------------------------------------*
*  * BOC by KJAGANA ERP7848 TR:   ED2K913989
  CONSTANTS : lc_devid  TYPE ZDEVID      VALUE 'E164',   "  Development ID
              lc_param1_e164 TYPE RVARI_VNAM VALUE 'AUART'.  "Name of Variant Variable

*FM is Retrieve the all sales document types from zcaconstant
*table
  CALL FUNCTION 'ZQTC_CONTRACT_TYPE_DETERMINE'
    EXPORTING
      im_objectid          = lc_devid
      im_param1            = lc_param1_e164
      im_auart             = vbak-auart
   IMPORTING
     EX_ACTIVE_FLAG       = lv_flag_type.
