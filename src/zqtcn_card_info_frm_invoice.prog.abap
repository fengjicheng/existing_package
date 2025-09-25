*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CARD_INFO_FRM_INVOICE
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* PROGRAM NAME:        RV45C900 (Include)
*                      [Sales Orders Data Transfer Routine - 900]
* PROGRAM DESCRIPTION: Copy Payment Card details for Order
* DEVELOPER:           NPOLINA
* CREATION DATE:       16/June/2020
* OBJECT ID:           E070/ERPM-15354
* TRANSPORT NUMBER(S): ED2K918528
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*---------------------------------------------------------------------*
TYPES: BEGIN OF ty_const,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF ty_const.

DATA:lv_fplnr  TYPE fplnr,
     lv_ccins  TYPE ccins,
     lv_ccnum  TYPE ccnum,
     lv_datbi  TYPE datbi_cc,
     lst_xfplt TYPE fpltvb,
     li_const  TYPE STANDARD TABLE OF ty_const,
     li_auart  TYPE shp_auart_range_t,
     li_fkart  TYPE TABLE OF range_fkart.

CONSTANTS:c_devid TYPE zdevid     VALUE 'E070',
          c_900   TYPE rvari_vnam VALUE '900',
          c_zcr   TYPE auart      VALUE 'ZCR',
          c_zocr  TYPE auart      VALUE 'ZOCR',
          c_auart TYPE rvari_vnam VALUE 'AUART',
          c_fkart TYPE rvari_vnam VALUE 'FKART',
          c_03    TYPE fpart      VALUE '03'.

SELECT devid                      "Development ID
            param1                     "ABAP: Name of Variant Variable
            param2                     "ABAP: Name of Variant Variable
            srno                       "Current selection number
            sign                       "ABAP: ID: I/E (include/exclude values)
            opti                       "ABAP: Selection option (EQ/BT/CP/...)
            low                        "Lower Value of Selection Condition
            high                       "Upper Value of Selection Condition
            activate                   "Activation indicator for constant
            FROM zcaconstant           " Wiley Application Constant Table
            INTO TABLE li_const
            WHERE  devid   EQ  c_devid  AND
            param2 = c_900
            AND   activate = abap_true . "Only active record
IF sy-subrc EQ 0.
  LOOP AT li_const INTO DATA(lst_const).
    CASE lst_const-param1.
      WHEN c_auart.
        APPEND INITIAL LINE TO li_auart ASSIGNING FIELD-SYMBOL(<lst_auart>).
        <lst_auart>-sign   = lst_const-sign.
        <lst_auart>-option = lst_const-opti.
        <lst_auart>-low    = lst_const-low.
        <lst_auart>-high   = lst_const-high.
      WHEN c_fkart.
        APPEND INITIAL LINE TO li_fkart ASSIGNING FIELD-SYMBOL(<lst_fkart>).
        <lst_fkart>-sign   = lst_const-sign.
        <lst_fkart>-option = lst_const-opti.
        <lst_fkart>-low    = lst_const-low.
        <lst_fkart>-high   = lst_const-high.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

ENDIF.
IF  vbak-auart IN li_auart AND vbak-vgbel IS NOT INITIAL AND cvbrk-fkart IN li_fkart.
* Get Billing plan number
  SELECT SINGLE fplnr INTO lv_fplnr
    FROM fpla
    WHERE vbeln = vbak-vgbel
      AND fpart = c_03.

  IF sy-subrc EQ 0.
* Get Payment Card details
    SELECT SINGLE ccins ccnum datbi FROM fpltc INTO (ccdata-ccins,ccdata-ccnum,ccdata-datbi)
      WHERE fplnr = lv_fplnr.
    IF sy-subrc NE 0.
      CLEAR:lv_fplnr.
    ENDIF.
  ENDIF.
ENDIF.
