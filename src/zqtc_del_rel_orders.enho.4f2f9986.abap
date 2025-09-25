"Name: \PR:SAPFV45C\FO:XVBFA_LESEN_NACHFOLGER\SE:END\EI
ENHANCEMENT 0 ZQTC_DEL_REL_ORDERS.
***-------------------------------------------------------------------*
*** PROGRAM NAME:ZQTC_DEL_REL_ORDERS
*** PROGRAM DESCRIPTION: Delete Released Orders
*** DEVELOPER:Shivani Nageswara
*** CREATION DATE:24-Mar-2020
*** OBJECT ID:I0236/ERPM13382
*** TRANSPORT NUMBER(S): ED2K917840
***-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K912844
* REFERENCE NO: INC0349363
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  04/01/2021
* DESCRIPTION: Delete a Release Order line when PO line is set to deletion
*----------------------------------------------------------------------*
CONSTANTS:c_devid TYPE zdevid   VALUE 'E236',
          c_enh   TYPE zvar_key VALUE 'ENH_SWITCH',
          c_001   TYPE zsno     VALUE '001'.

DATA:     lv_flag TYPE ZACTIVE_FLAG.
* BOC - INC0349363 - NPALLA - 04/01/2021 - ED1K912844
DATA:     lv_activ_flag_e236 TYPE zactive_flag.     "Active / Inactive flag
DATA:     lv_vbeln   TYPE vbeln_nach,
          lv_posnn   TYPE posnr_nach,
          lv_vbtyp_n TYPE vbtyp_n,
          lv_loekz   TYPE eloek,
          lv_matnr   TYPE matnr,
          lv_subrc   TYPE syst_subrc.
CONSTANTS:c_v        TYPE vbtyp_n VALUE 'V',
          c_j        TYPE vbtyp_n VALUE 'J'.
* EOC - INC0349363 - NPALLA - 04/01/2021 - ED1K912844

* Begin Of Comment - INC0349363 - NPALLA - 04/01/2021 - ED1K912844
*SELECT SINGLE active_flag FROM zca_enh_ctrl
*  INTO lv_flag
*  WHERE wricef_id = c_devid
*    AND ser_num = c_001
*    AND var_key = c_enh
*    AND active_flag = abap_true.
*IF sy-subrc EQ 0.
*  sy-subrc = 4.
*ENDIF.
* End Of Comment - INC0349363 - NPALLA - 04/01/2021 - ED1K912844

* BOC - INC0349363 - NPALLA - 04/01/2021 - ED1K912844
* Retain sy-subrc from standard code.
lv_subrc = xl_subrc.       "sy-subrc
*
CLEAR: lv_activ_flag_e236.
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = c_devid                 "Constant value for WRICEF (E236)
    im_ser_num     = c_001                   "Serial Number (001)
    im_var_key     = c_enh                   "Variable Key (ENH_SWITCH)
  IMPORTING
    ex_active_flag = lv_activ_flag_e236.     "Active / Inactive flag
IF lv_activ_flag_e236  = abap_true.
  SELECT SINGLE vbeln posnn vbtyp_n
    FROM vbfa
    INTO (lv_vbeln,lv_posnn,lv_vbtyp_n)
    WHERE vbelv = xvbfa-vbelv
      AND posnv = xvbfa-posnv
      AND ( vbtyp_n = c_v OR
            vbtyp_n = c_j ).
  IF sy-subrc = 0 and lv_vbtyp_n = c_v.
    SELECT SINGLE loekz matnr
      INTO (lv_loekz,lv_matnr)
      FROM ekpo
      WHERE ebeln = lv_vbeln
        AND ebelp = lv_posnn
        AND loekz = space.
    IF sy-subrc = 0.
    "Do Nothing - retain sy-subrc
    ENDIF.
  ENDIF.
ELSE.
  sy-subrc = lv_subrc.
ENDIF.
* Update XL_SUBRC parameter of Standard Code
xl_subrc = sy-subrc.
* EOC - INC0349363 - NPALLA - 04/01/2021 - ED1K912844

ENDENHANCEMENT.
