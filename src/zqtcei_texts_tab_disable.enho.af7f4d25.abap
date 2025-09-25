"Name: \PR:SAPMV45A\EX:CUA_SETZEN_10\EI
ENHANCEMENT 0 ZQTCEI_TEXTS_TAB_DISABLE.
DATA(lc_screen_4152) = '4152'. "Texts Tab Screen Number
DATA(lc_tcode_va42)  = 'VA42'. "Change Contract Tcode
DATA(lc_v)           = 'V'.    "Edit Mode

* Checking of the TCODE
IF  sy-tcode = lc_tcode_va42.
* Checking Screen for limiting the number of executions of the below code
  IF taxi_body_subscreen = lc_screen_4152.

    TYPES lty_textid_type TYPE RANGE OF char4.
    DATA : lr_textids  TYPE lty_textid_type,
           lv_temp     TYPE char16.

    lr_textids = VALUE lty_textid_type(
                      LET s = 'I'
                          o = 'EQ'
                      IN sign   = s
                         option = o
*                         ( low = '0001' ) "Form Header
*                         ( low = '0002' ) "Header note 1
*                         ( low = '0003' ) "Header note 2
                         ( low = '0004' ) "Header note 3 (CSS Internal Note)
*                         ( low = '0005' ) "Header note 4
*                         ( low = '0006' ) "BP Note
*                         ( low = '0007' ) "Invoicing Instructions
*                         ( low = '0008' ) "Delivery Instructions
*                         ( low = '0020' ) "Special Shipping Instruction
*                         ( low = '0021' ) "CSS Contact Name
*                         ( low = 'Z003' ) "Header note 2
*                         ( low = 'ZSN1' ) "Snap Pay Order ID
*                         ( low = 'ZSN2' ) "Snap Pay transaction ID
                                         ).
* Local Constants
    DATA(lc_vbbk) = 'VBBK'.     "Sales Header Texts
    DATA(lc_item) = 'ITEM'.
    DATA(lc_a) = 'A'.
    DATA(lc_0) = '0'.
    DATA(lc_1) = '1'.
    DATA(lc_pos_add) = 'POS+'.  "Sideways movement: Right
    DATA(lc_pos_sub) = 'POS-'.  "Sideways movement: Left

    FIELD-SYMBOLS : <lfs_tdid>      TYPE any,
                    <lfs_vbeln>     TYPE any,
                    <lfs_posnr>     TYPE any,
                    <lfs_tdlinetab> TYPE ANY TABLE,
                    <lfs_xthead>    TYPE ANY TABLE.

* Fetching of the values from different places
* Text Type ID
    ASSIGN ('(SAPLV70T)LV70T-TDID') TO <lfs_tdid>.
* Sales and Distribution Document Number
    ASSIGN ('(SAPMV45A)XVBAP-VBELN') TO <lfs_vbeln>.
* Item number of the SD document
    ASSIGN ('(SAPMV45A)XVBAP-POSNR') TO <lfs_posnr>.
* TDLINE table
    ASSIGN ('(SAPLV70T)TLINETAB[]') TO <lfs_tdlinetab>.
* XTHEAD: Contains the Text Ids
    ASSIGN ('(SAPMV45A)XTHEAD[]') TO <lfs_xthead>.

* Corner Cases:
* If the previous/next button is pressed of the last/first item
    DATA(lv_tabix) = VALUE i( ivbap[ posnr = <lfs_posnr> ]-tabix OPTIONAL ).
    IF lv_tabix IS NOT INITIAL.
      IF sy-ucomm = lc_pos_add.
        ADD 1 TO lv_tabix.
      ELSEIF sy-ucomm = lc_pos_sub.
        SUBTRACT 1 FROM lv_tabix.
      ENDIF.
    ENDIF.

* For entering 2nd time the same screen(Item Detail)
    IF <lfs_tdid> IS NOT ASSIGNED OR <lfs_tdid> = space
* For sideways movements of items
       OR ( ( sy-ucomm = lc_pos_add OR sy-ucomm = lc_pos_sub )
* Restricting the first/last item to change its existing text id
       AND ( lv_tabix GE lc_1 AND lv_tabix LE lines( ivbap ) ) ).
* Assigning the first text id available
      ASSIGN xthead[ 1 ]-tdid TO <lfs_tdid>.
    ENDIF.

* For entering 2nd time the same screen(Item Detail)
    IF sy-ucomm = lc_item AND <lfs_tdid> IN lr_textids.
* Assigning the first text id available
      <lfs_tdid> = VALUE char4( xthead[ 1 ]-tdid OPTIONAL ).
    ENDIF.

    IF <lfs_tdid> IS ASSIGNED AND <lfs_tdid> IN lr_textids.
* Changing the screen to display mode
      t180-trtyp = lc_a.     "Display
      lv_temp = <lfs_vbeln> && <lfs_posnr>.
* Screen Refresh: If the text id does not have text maintained
      SELECT COUNT( * )
      FROM stxh               "STXD SAPscript text file header
      INTO lv_temp
      WHERE tdobject = lc_vbbk AND
      tdname = lv_temp AND
      tdid = <lfs_tdid>.
      IF sy-subrc = 0 AND lv_temp = lc_0.
        CLEAR <lfs_tdlinetab>.
      ENDIF.
* For not displaying in case of sideways movements
      IF sy-ucomm NE lc_pos_sub AND sy-ucomm NE lc_pos_add.
* Message: The text id is disabled
*        MESSAGE 'Text ID is disabled' TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
* Change mode
      t180-trtyp = lc_v. "Change
    ENDIF.

    CLEAR : lv_temp,
            lv_tabix,
            lr_textids.
  ELSE.
* Change mode
    t180-trtyp = lc_v. "Change
  ENDIF.
ENDIF.

ENDENHANCEMENT.
