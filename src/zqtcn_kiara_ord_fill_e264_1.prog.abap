* Program Name : ZQTCN_KIARA_ORD_FILL_E264_1                           *
* REVISION NO : ED2K923064/ ED2K923484                                             *
* REFERENCE NO: OTCM-23859                                             *
* DEVELOPER   : Lahiru Wathudura (LWATHUDURA)                          *
* DATE        : 04/16/2021                                             *
* DESCRIPTION : SAP/Kiara Intergration - Mapping the registration code *
*               for Order processing with Z12 message variant.At the   *
*               line item level updating the registration code to identify
*               the licencing info and based on the licence info addressing
*               revenue
*----------------------------------------------------------------------*

TYPES : BEGIN OF ty_ismpubltype,        " Publication type
          sign TYPE tvarv_sign,
          opti TYPE tvarv_opti,
          low  TYPE ismpubltype,
          high TYPE ismpubltype,
        END OF ty_ismpubltype.

DATA : lst_control_data_z12_e264_1 TYPE edidc,
       lst_ze1edp01_e264_1         TYPE z1qtc_e1edp01_01,
       lir_pubtype                 TYPE RANGE OF mara-ismpubltype,                               " Range declaration for Publication type
       lst_pubtype                 TYPE ty_ismpubltype,
       lst_e1edp19_e264_1          TYPE e1edp19,
       lv_matnr                    TYPE matnr,
       lst_e1edpa1_e264_1          TYPE e1edpa1. "++VDPATABALL ED2K927222 05/10/2022 - removing lineitem partner 'WE'

STATICS : lv_docnum_z12_e264_1 TYPE edi_docnum,   " Idoc Number
          lv_regcode_empty     TYPE char1,
          lv_pubtype           TYPE char1.

CONSTANTS : lc_ze1edp01_e264_1 TYPE edilsegtyp VALUE 'Z1QTC_E1EDP01_01',  " Line Item Extended fields
            lc_ismpubltype     TYPE rvari_vnam VALUE 'ISMPUBLTYPE',       " Publication type
            lc_e1edp19_e264_1  TYPE edilsegtyp VALUE 'E1EDP19',
            lc_devid_e264_1    TYPE zdevid     VALUE 'E264'.

" Fetch the constant value for E264
SELECT devid,
       param1,
       param2,
       srno,
       sign,
       opti,
       low ,
       high,
       activate
   FROM zcaconstant
   INTO TABLE @DATA(li_constant)
   WHERE devid    = @lc_devid_e264_1  " WRICEF ID
   AND   activate = @abap_true.       " Only active record
IF sy-subrc IS INITIAL.               " check whether value is initial or not
  SORT li_constant BY param1.
  LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
    CASE <lfs_constant>-param1.
      WHEN lc_ismpubltype.        " Publication type
        lst_pubtype-sign   = <lfs_constant>-sign.
        lst_pubtype-opti   = <lfs_constant>-opti.
        lst_pubtype-low    = <lfs_constant>-low.
        lst_pubtype-high   = <lfs_constant>-high..
        APPEND lst_pubtype TO lir_pubtype.
        CLEAR lst_pubtype.
      WHEN OTHERS.
        " Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF.

lst_control_data_z12_e264_1 = contrl.

*---Static Variable clearing based on DOCNUM field (IDOC Number)..
IF lst_control_data_z12_e264_1 IS NOT INITIAL.
  IF lv_docnum_z12_e264_1 NE lst_control_data_z12_e264_1-docnum.
    FREE: lv_docnum_z12_e264_1, lv_regcode_empty , lv_pubtype.
    lv_docnum_z12_e264_1  =  lst_control_data_z12_e264_1-docnum.
  ENDIF.
ENDIF.

" Populate segments of the IDoc data
CASE segment-segnam.
  WHEN lc_ze1edp01_e264_1.
    lst_ze1edp01_e264_1 = segment-sdata.           " " Get the IDoc data into local work area to process further processing
    IF lst_ze1edp01_e264_1-zzrgcode IS INITIAL.    " Registration code is not in the line item for kIARA Orders IDOC should be failed
      lv_regcode_empty = abap_true.
    ENDIF.
  WHEN lc_e1edp19_e264_1.
    lst_e1edp19_e264_1 = segment-sdata.           " Get the IDoc data into local work area to process further processing
    " Convert material to internal format
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = lst_e1edp19_e264_1-idtnr
      IMPORTING
        output = lv_matnr.
* Fetch Publication type for the particular material
    SELECT matnr, ismpubltype
      FROM mara INTO TABLE @DATA(li_mara)
      WHERE matnr = @lv_matnr AND
            ismpubltype IN @lir_pubtype.
    IF sy-subrc = 0.
      lv_pubtype = abap_true.
    ELSE.
* BOC by Lahiru on 05/19/2021 for OTCM-23859 with ED2K923484  *
      IF lv_regcode_empty IS NOT INITIAL.
        FREE lv_regcode_empty.
      ENDIF.
* EOC by Lahiru on 05/19/2021 for OTCM-23859 with ED2K923484  *
    ENDIF.
    IF lv_regcode_empty = abap_true AND lv_pubtype = abap_true .  " Publicatoin type is 'KB' and registration code is null then failed the iDoc
      MESSAGE e587(zqtc_r2) RAISING user_error.
      FREE : lv_regcode_empty , lv_pubtype.
    ENDIF.
  WHEN OTHERS.
    " Nothing to do
ENDCASE.
