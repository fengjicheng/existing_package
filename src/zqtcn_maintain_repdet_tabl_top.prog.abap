*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAINTAIN_REPDET_TABL_TOP
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_zcaconstant,
         devid       TYPE zdevid,
         param1      TYPE rvari_vnam,
         param2      TYPE rvari_vnam,
         srno        TYPE tvarv_numb,
         low         TYPE salv_de_selopt_low,
         high        TYPE salv_de_selopt_high,
         description TYPE zconstdesc,
       END OF ty_zcaconstant.
DATA:
  c_fld_vkorg   TYPE viewfield  VALUE 'VKORG',               "Sales Organization
  c_fld_vtweg   TYPE viewfield  VALUE 'VTWEG',               "Distribution Channel
  c_fld_spart   TYPE viewfield  VALUE 'SPART',               "Division
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
  c_fld_bsark   TYPE viewfield  VALUE 'BSARK',               "PO Type
  c_fld_zsp     TYPE viewfield  VALUE 'ZSHIP_TO',            "Ship-to party
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
  c_fld_datab   TYPE viewfield  VALUE 'DATAB',               "Valid-From Date
  c_fld_datbi   TYPE viewfield  VALUE 'DATBI',               "Valid To Date
  c_fld_matnr   TYPE viewfield  VALUE 'MATNR',               "Material / Product
  c_fld_prctr   TYPE viewfield  VALUE 'PRCTR',               "Profit Center
  c_fld_kunnr   TYPE viewfield  VALUE 'KUNNR',               "Sold-to BPID
  c_fld_kvgr1   TYPE viewfield  VALUE 'KVGR1',               "Customer Group
  c_fld_pst_f   TYPE viewfield  VALUE 'PSTLZ_F',             "Postal Code (From)
  c_fld_pst_t   TYPE viewfield  VALUE 'PSTLZ_T',             "Postal Code (To)
  c_fld_regio   TYPE viewfield  VALUE 'REGIO',               "Region
  c_fld_land1   TYPE viewfield  VALUE 'LAND1',               "Country

  c_oprtr_eq    TYPE vsoperator VALUE 'EQ',
  c_oprtr_ne    TYPE vsoperator VALUE 'NE',
  c_oprtr_ge    TYPE vsoperator VALUE 'GE',
  c_oprtr_le    TYPE vsoperator VALUE 'LE',

  c_scond_and   TYPE vsconj     VALUE 'AND',

  c_action_u    TYPE char1      VALUE 'U',
  c_action_s    TYPE char1      VALUE 'S',

  c_fc_aend     TYPE fcode      VALUE 'AEND',                "Function Code: Display -> Change

  c_view_name   TYPE tabname    VALUE 'ZVQTC_REPDET',
  i_zcaconstant TYPE STANDARD TABLE OF ty_zcaconstant INITIAL SIZE 0.
