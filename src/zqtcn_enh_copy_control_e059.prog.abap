*---------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_ENH_COPY_CONTROL_E059
* PROGRAM DESCRIPTION:Enhancement for Copy Control
* DEVELOPER: Shivangi Priya (SHPRIYA)
* CREATION DATE:   2016-12-08
* OBJECT ID:E059
* TRANSPORT NUMBER(S) ED2K903605
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: ED2K909379
* REFERENCE NO: I0234 - CR568
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-12-01
* DESCRIPTION: Changed logic to populate Referenced quantity
*---------------------------------------------------------------------*

***Data declaration***
  DATA: li_xvbfa TYPE TABLE OF vbfavb,       " Local int table for XVBFA
*       Begin of DEL:CR#568:WROY:01-DEC-2017:ED2K909379
*       lv_count TYPE i,                     " Count local var
*       End   of DEL:CR#568:WROY:01-DEC-2017:ED2K909379
*       Begin of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
        lv_count TYPE rfmng,                 " Count local var
        lv_rfmng TYPE rfmng,                 " Referenced quantity in base unit of measure
        lv_zmeng_n TYPE dzmeng,              " Quan local var
*       End   of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
        lv_zmeng TYPE i,                     " Quan local var
        lv_posnr TYPE posnr_va,              " Contract Posnr temp var
        lv_netwr TYPE netwr_ap.

***Field symbol declaration***
  FIELD-SYMBOLS: <lfs_xvbap> TYPE vbapvb,
                 <lfs_xvbfa> TYPE vbfavb,
                 <lfs_xkomv> TYPE komv.
***Constant declaration***
  CONSTANTS:
    lc_devid_e059 TYPE zdevid        VALUE 'E059',    " Type of Identification Code
    lc_prom_e059  TYPE rvari_vnam    VALUE 'KSCHL',   " Promotion code for variant variable
    lc_c          TYPE c             VALUE 'C'.       " C

  IF t180-trtyp EQ charh.      " Create only
* Fetch Identification Code Type from constant table.
    SELECT SINGLE  devid       " Development ID
                   param1      " ABAP: Name of Variant Variable
                   param2      " ABAP: Name of Variant Variable
                   sign        " ABAP: ID: I/E (include/exclude values)
                   opti        " ABAP: Selection option (EQ/BT/CP/...)
                   low         " Lower Value of Selection Condition
                   high        " Upper Value of Selection Condition
      FROM zcaconstant " Wiley Application Constant Table
      INTO lst_constant
      WHERE devid    = lc_devid_e059
        AND param1   = lc_prom_e059
        AND activate = abap_true.
* checking for ordertype 'ZTRO'.
    IF vbak-auart = lst_constant-high.
      IF xvbap-posex IS INITIAL.
        lv_posnr =  cvbap-posnr.
      ELSE.
        lv_posnr = xvbap-posex.
*       Begin of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
        lv_rfmng =  xvbap-kwmeng.           " Referenced quantity in base unit of measure
*       End   of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
      ENDIF.
      READ TABLE xvbfa ASSIGNING <lfs_xvbfa>
      INDEX 1.
      IF sy-subrc = 0.
* Updating VBFA structure preceding item num n quan
        <lfs_xvbfa>-posnv = lv_posnr.
        <lfs_xvbfa>-rfmng = 1000. "lc_quan.
*       Begin of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
        IF lv_rfmng IS NOT INITIAL.
          <lfs_xvbfa>-rfmng = lv_rfmng.     " Referenced quantity in base unit of measure
        ENDIF.
*       End   of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
      ENDIF.
* Updating VBAP structre with VGBEL and VBPOS
      READ TABLE xvbap ASSIGNING <lfs_xvbap>
      INDEX 1.
      IF <lfs_xvbap> IS ASSIGNED.
        IF <lfs_xvbap>-posex IS INITIAL.
          lv_posnr =  cvbap-posnr.
        ELSE.
          lv_posnr = <lfs_xvbap>-posex.
        ENDIF.
        <lfs_xvbap>-vgpos = lv_posnr.
        <lfs_xvbap>-vgbel = xvbfa-vbelv.

*Fetch contract quantity in LV_ZMENG
        CLEAR lv_zmeng.
        SELECT SINGLE zmeng
*         Begin of DEL:CR#568:WROY:01-DEC-2017:ED2K909379
*         INTO lv_zmeng
*         End   of DEL:CR#568:WROY:01-DEC-2017:ED2K909379
*         Begin of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
          INTO lv_zmeng_n
*         End   of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
          FROM vbap
          WHERE vbeln = xvbfa-vbelv
            AND posnr = lv_posnr.
      ENDIF.

*Fetch contract quantity in LV_COUNT
      CLEAR lv_count.

      li_xvbfa[] = xvbfa[].
*& DELETING THE NEW ONE , KEEPING ONLY ONE
      DELETE li_xvbfa WHERE posnv NE lv_posnr.
      DELETE li_xvbfa WHERE vbtyp_n NE lc_c.
*     Begin of DEL:CR#568:WROY:01-DEC-2017:ED2K909379
*     DESCRIBE TABLE li_xvbfa LINES lv_count.
*     End   of DEL:CR#568:WROY:01-DEC-2017:ED2K909379
*     Begin of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
      LOOP AT li_xvbfa ASSIGNING <lfs_xvbfa>.
        lv_count = lv_count + <lfs_xvbfa>-rfmng.     " Referenced quantity in base unit of measure
      ENDLOOP.
*     End   of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
*Compare the two quantity and is refernced quantity sum is more than
*     contract quantity, throw error message.
*     Begin of DEL:CR#568:WROY:01-DEC-2017:ED2K909379
*     IF lv_count GT lv_zmeng.
*     End   of DEL:CR#568:WROY:01-DEC-2017:ED2K909379
*     Begin of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
      IF lv_count GT lv_zmeng_n.
*     End   of ADD:CR#568:WROY:01-DEC-2017:ED2K909379
        MESSAGE e901(v1) WITH lv_count lv_zmeng xvbfa-vbelv lv_posnr.
      ENDIF.
* Chnaging Condition type record
      IF xkomv[] IS NOT INITIAL.
        READ TABLE xkomv[] ASSIGNING <lfs_xkomv>
        WITH KEY kschl = lst_constant-low.
        IF sy-subrc = 0 AND <lfs_xkomv> IS ASSIGNED.
          CLEAR: lv_netwr,
                  lv_zmeng.
* Select the net value and quantity for per unit price
          SELECT SINGLE netwr   "Net value of the order item
                        zmeng   "Target quantity in sales units
            FROM vbap
            INTO (lv_netwr , lv_zmeng)
            WHERE vbeln = xvbfa-vbelv
              AND posnr = lv_posnr.
          IF sy-subrc = 0 AND lv_zmeng NE 0.
            <lfs_xkomv>-kbetr = lv_netwr / lv_zmeng.
            CLEAR <lfs_xkomv>-kwert.
          ENDIF.    "IF sy-subrc = 0 AND lv_zmeng NE 0.
        ENDIF.    "IF sy-subrc = 0 AND <lfs_xkomv> IS ASSIGNED.
      ENDIF.    "IF xkomv[] IS NOT INITIAL.
    ENDIF.   "IF vbak-auart = lc_auart.
  ENDIF.
