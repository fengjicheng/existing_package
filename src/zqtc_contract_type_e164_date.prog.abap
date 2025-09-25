*&---------------------------------------------------------------------*
*&  Include  ZQTC_CONTRACT_TYPE_E164
*&---------------------------------------------------------------------*
*  * BOC by KJAGANA ERP7848 TR:   ED2K913989
  CONSTANTS : lc_devid  TYPE ZDEVID      VALUE 'E164',   "  Development ID
              lc_param1_e164 TYPE RVARI_VNAM VALUE 'AUART'.  "Name of Variant Variable

DATA: lv_strc_tkomk1 TYPE char40 VALUE '(SAPLV60F)TKOMK'.   "Communication Header for Pricing

FIELD-SYMBOLS:
  <lst_s_tkomk1> TYPE komk.
ASSIGN (lv_strc_tkomk1) TO <lst_s_tkomk1>.

*FM is Retrieve the all sales document types from zcaconstant
*table
  CALL FUNCTION 'ZQTC_CONTRACT_TYPE_DETERMINE'
    EXPORTING
      im_objectid          = lc_devid
      im_param1            = lc_param1_e164
      im_auart             = <lst_s_tkomk1>-auart
   IMPORTING
     EX_ACTIVE_FLAG       = lv_flag_type.
