*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVDBU02 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for populating BDC DATA
*
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   24/10/2016
* OBJECT ID: I0233.2
* TRANSPORT NUMBER(S):  ED2K903117
*----------------------------------------------------------------------*
*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr_233_2 , "Partner
         posnr LIKE vbap-posnr,  " Sales Document Item
         parvw LIKE vbpa-parvw,  " Partner Function
         kunnr LIKE rv02p-kunde, " Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad.  " Unloading Point
        INCLUDE STRUCTURE vbadr. " Address work area
TYPES: END OF lty_xvbadr_233_2.

*** Local work area and local internal table declaration
DATA: lst_vbadr_233              TYPE lty_xvbadr_233_2,
      li_bdcdata_233             TYPE STANDARD TABLE OF bdcdata,
      lst_bdcdata_233_2          TYPE bdcdata.

*** Local Data declaration
DATA:  lv_line1       TYPE sytabix, " Row Index of Internal Tables
       lv_tabix1      TYPE sytabix,
       lv_fnam_233     TYPE fnam_____4,               " Field name
       lv_fval_233     TYPE bdc_fval.

*** Local Field Symbol declaration
FIELD-SYMBOLS: <lst_bdcdata_233> TYPE bdcdata. " Batch input: New table field structure

*** Local Constant declaration
CONSTANTS: lc_bok  TYPE fnam_____4 VALUE 'BDC_OKCODE'.


DESCRIBE TABLE dxbdcdata LINES lv_line1.
*READ TABLE didoc_data INTO lst_idoc_233 INDEX 1.

*** Reading BDCDATA table into a work area
  READ TABLE dxbdcdata INTO lst_bdcdata_233_2 INDEX lv_line1.
  IF sy-subrc = 0.

***------------------>> Update Email Address of partner
 IF   lst_bdcdata_233_2-fnam = lc_bok
 AND lst_bdcdata_233_2-fval = 'SICH'.

  CLEAR:  lst_bdcdata_233_2,lv_fval_233.
  CLEAR:  lst_bdcdata_233_2,lv_fval_233.
  lv_fnam_233 = lc_bok.
  lv_fval_233 = 'UER2'.
  IF lv_fval_233 IS NOT INITIAL.
    lst_bdcdata_233_2-fnam = lv_fnam_233.
    lst_bdcdata_233_2-fval = lv_fval_233.
    APPEND lst_bdcdata_233_2 TO li_bdcdata_233.
  ENDIF. " IF lv_fval_233 IS NOT INITIAL

  CLEAR:  lst_bdcdata_233_2,lv_fval_233.
  CLEAR:  lst_bdcdata_233_2,lv_fval_233.
  lv_fnam_233 = lc_bok.
  lv_fval_233 = 'KPAR_SUB'.
  IF lv_fval_233 IS NOT INITIAL.
    lst_bdcdata_233_2-fnam = lv_fnam_233.
    lst_bdcdata_233_2-fval = lv_fval_233.
    APPEND lst_bdcdata_233_2 TO li_bdcdata_233.
  ENDIF. " IF lv_fval_233 IS NOT INITIAL

  CLEAR:  lst_bdcdata_233_2,lv_fval_233.
  lst_bdcdata_233_2-program = 'SAPMV45A'.
  lst_bdcdata_233_2-dynpro  =  '4002'.
  lst_bdcdata_233_2-dynbegin   = 'X'.
  APPEND lst_bdcdata_233_2 TO li_bdcdata_233.


  LOOP AT dxvbadr INTO lst_vbadr_233.
    IF lst_vbadr_233-email_addr IS NOT INITIAL.

      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      lv_fnam_233 = lc_bok.
      lv_fval_233 = 'PAPO'.
      IF lv_fval_233 IS NOT INITIAL.
        lst_bdcdata_233_2-fnam = lv_fnam_233.
        lst_bdcdata_233_2-fval = lv_fval_233.
        APPEND lst_bdcdata_233_2 TO li_bdcdata_233.
      ENDIF. " IF lv_fval_233 IS NOT INITIAL

      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      lst_bdcdata_233_2-program = 'SAPLV09C'.
      lst_bdcdata_233_2-dynpro  =  '0666'.
      lst_bdcdata_233_2-dynbegin   = 'X'.
      APPEND lst_bdcdata_233_2 TO li_bdcdata_233.

      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      lv_fnam_233 = 'DV_PARVW'.
      lv_fval_233 = lst_vbadr_233-parvw.
      IF lv_fval_233 IS NOT INITIAL.
        lst_bdcdata_233_2-fnam = lv_fnam_233.
        lst_bdcdata_233_2-fval = lv_fval_233.
        APPEND lst_bdcdata_233_2 TO li_bdcdata_233.
      ENDIF. " IF lv_fval_233 IS NOT INITIAL

      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      lst_bdcdata_233_2-program = 'SAPMV45A'.
      lst_bdcdata_233_2-dynpro  =  '4002'.
      lst_bdcdata_233_2-dynbegin   = 'X'.
      APPEND lst_bdcdata_233_2 TO li_bdcdata_233.

      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      lv_fnam_233 = lc_bok.
      lv_fval_233 = 'PSDE'.
      IF lv_fval_233 IS NOT INITIAL.
        lst_bdcdata_233_2-fnam = lv_fnam_233.
        lst_bdcdata_233_2-fval = lv_fval_233.
        APPEND lst_bdcdata_233_2 TO li_bdcdata_233.
      ENDIF. " IF lv_fval_233 IS NOT INITIAL

      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      lst_bdcdata_233_2-program = 'SAPLV09C'.
      lst_bdcdata_233_2-dynpro  =  '5000'.
      lst_bdcdata_233_2-dynbegin   = 'X'.
      APPEND lst_bdcdata_233_2 TO li_bdcdata_233.

      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      lv_fnam_233 = 'SZA1_D0100-SMTP_ADDR'.
      lv_fval_233 = lst_vbadr_233-email_addr.
      IF lv_fval_233 IS NOT INITIAL.
        lst_bdcdata_233_2-fnam = lv_fnam_233.
        lst_bdcdata_233_2-fval = lv_fval_233.
        APPEND lst_bdcdata_233_2 TO li_bdcdata_233.
      ENDIF. " IF lv_fval_233 IS NOT INITIAL

      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      lv_fnam_233 = lc_bok.
      lv_fval_233 = 'ENT1'.
      IF lv_fval_233 IS NOT INITIAL.
        lst_bdcdata_233_2-fnam = lv_fnam_233.
        lst_bdcdata_233_2-fval = lv_fval_233.
        APPEND lst_bdcdata_233_2 TO li_bdcdata_233.
      ENDIF. " IF lv_fval_233 IS NOT INITIAL

      CLEAR:  lst_bdcdata_233_2,lv_fval_233.
      lst_bdcdata_233_2-program = 'SAPMV45A'.
      lst_bdcdata_233_2-dynpro  =  '4002'.
      lst_bdcdata_233_2-dynbegin   = 'X'.
      APPEND lst_bdcdata_233_2 TO li_bdcdata_233.


    ENDIF. " IF lst_vbadr-email_addr IS NOT INITIAL
  ENDLOOP. " LOOP AT dxvbadr INTO lst_vbadr

  DESCRIBE TABLE dxbdcdata LINES lv_tabix1.
  READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_233> INDEX lv_tabix1.
  IF <lst_bdcdata_233> IS ASSIGNED.
    <lst_bdcdata_233>-fval = 'OWN_OKCODE'.
  ENDIF. " IF <lst_bdcdata> IS ASSIGNED
  INSERT LINES OF li_bdcdata_233 INTO dxbdcdata INDEX lv_tabix1.

ENDIF. " IF lst_bdcdata_233-fnam = 'BDC_OKCODE'

IF   lst_bdcdata_233_2-fnam = lc_bok
 AND lst_bdcdata_233_2-fval = 'OWN_OKCODE'.

  DESCRIBE TABLE dxbdcdata LINES lv_tabix1.
  READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_233> INDEX lv_tabix1.
  IF <lst_bdcdata_233> IS ASSIGNED.
    <lst_bdcdata_233>-fval = 'SICH'.
  ENDIF. " IF <lst_bdcdata> IS ASSIGNED

ENDIF. " IF lst_bdcdata_233-fnam = 'BDC_OKCODE'
ENDIF.
