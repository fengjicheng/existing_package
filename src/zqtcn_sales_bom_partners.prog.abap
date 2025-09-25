*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_SALES_BOM_PARTNERS [Called from
*                      FCODE_BEARBEITEN (MV45AF0F_FCODE_BEARBEITEN)]
* PROGRAM DESCRIPTION: Copy Partner Detail from BOM Header to Components
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       08/04/2017
* OBJECT ID:           E134
* TRANSPORT NUMBER(S): ED2K907442
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908793
* REFERENCE NO: ERP-7056
* DEVELOPER: Writtick Roy (WROY)
* DATE:  03/22/2018
* DESCRIPTION: Add new Partners
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K916423
* REFERENCE NO:ERPM-3368(Object id-E215)
* DEVELOPER:MIMMADISET
* DATE:10/11/2019
* DESCRIPTION:Issue with duplicate entries are adding to table XVBPA for partner ZX
*----------------------------------------------------------------------*
DATA:
  li_constnt TYPE zcat_constants,                               "Constant Values
  li_pf_excl TYPE zcat_constants,                               "Constant Values (Partner Functions)
  li_prt_det TYPE va_vbpavb_t,                                  "Sales Document: Partner
* Begin of ADD:ERP-7056:WROY:22-Mar-2018:ED2K908793
  li_prt_add TYPE va_vbpavb_t.                                  "Sales Document: Partner (New Additions)
* End   of ADD:ERP-7056:WROY:22-Mar-2018:ED2K908793

DATA:
  lst_sd_org TYPE sdorgdata,                                    "Organizational Data for SD Documents
  lst_tvap_r TYPE tvap.                                         "Sales Document: Item Category Details

DATA:
  lv_obj_typ TYPE oj_name,                                      "Object type
  lv_obj_key TYPE swo_typeid,                                   "Object Key
  lv_prtnr_f TYPE parvw_4,                                      "Partner Function
  lv_kunnr_n TYPE sd_partner_parnr,                             "Partner (New)
  lv_kunnr_o TYPE sd_partner_parnr,                             "Partner (Old)
  lv_initial TYPE flag,                                         "Flag: New Partner
  lv_prtnr_c TYPE flag.                                         "Flag: Add / Change Partner

CONSTANTS:
  lc_id_e134    TYPE zdevid     VALUE 'E134',                      "Development ID (E134)
  lc_prtnr_f    TYPE rvari_vnam VALUE 'PARTNER_FUNC_EXCL',         "Name of Variant Variable: Partner Function
  lc_ptyp_ku    TYPE nrart      VALUE 'KU',                        "Partner Type: Customer
  lc_ptyp_li    TYPE nrart      VALUE 'LI',                        "Partner Type: Vendor
  lc_ptyp_pe    TYPE nrart      VALUE 'PE',                        "Partner Type: Personnel Number
  lc_ptyp_ap    TYPE nrart      VALUE 'AP',                        "Partner Type: Contact Persons
**BOC-MIMMADISET-ED2K916423 CR# ERPM-3368
  lc_parvw_zx   TYPE parvw  VALUE 'ZX',
  lc_devid_e215 TYPE zdevid     VALUE 'E215',                      "Development ID (E215)
  lc_auart      TYPE rvari_vnam  VALUE 'AUART',                    "Parameter: Order Type
  lc_vkorg      TYPE rvari_vnam  VALUE 'VKORG',                    "Parameter: Sale Org
  lc_spart      TYPE rvari_vnam  VALUE 'SPART'.                    "Parameter: Division-

DATA:lir_auart_range TYPE fip_t_auart_range,
     lst_auart_range TYPE fip_s_auart_range,
     lst_vkorg_range TYPE fip_s_vkorg_range,
     lir_vkorg_range TYPE fip_t_vkorg_range,
     lst_spart_range TYPE fip_s_spart_range,
     lir_spart_range TYPE fip_t_spart_range.
STATICS:li_const_1 TYPE zcat_constants.
*---Check the Constant table before going to the actual logic wheather Order type is active or not.
**BOC-MIMMADISET-ED2K916423 CR# ERPM-3368
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e215  "Development ID
  IMPORTING
    ex_constants = li_const_1.  "Constant Values
*---Fill the respective entries which are maintain in zcaconstant.
IF li_const_1[] IS NOT INITIAL.
  SORT li_const_1[] BY param1.
  FREE:lir_auart_range,lir_vkorg_range,lir_spart_range,
       lst_auart_range,lst_vkorg_range,lst_spart_range.
  LOOP AT li_const_1[] ASSIGNING FIELD-SYMBOL(<lfs_constant>).
*---Document Type constant value
    IF <lfs_constant>-param1   = lc_auart.
      lst_auart_range-sign   = <lfs_constant>-sign.
      lst_auart_range-option = <lfs_constant>-opti.
      lst_auart_range-low    = <lfs_constant>-low.
      APPEND lst_auart_range TO lir_auart_range.
      CLEAR: lst_auart_range.
**---Sale Org constant value
    ELSEIF <lfs_constant>-param1 = lc_vkorg.
      lst_vkorg_range-sign     = <lfs_constant>-sign.
      lst_vkorg_range-option   = <lfs_constant>-opti.
      lst_vkorg_range-low      = <lfs_constant>-low.
      APPEND lst_vkorg_range TO lir_vkorg_range.
      CLEAR: lst_vkorg_range.
*---Division constant value
    ELSEIF <lfs_constant>-param1 = lc_spart.
      lst_spart_range-sign     = <lfs_constant>-sign.
      lst_spart_range-option   = <lfs_constant>-opti.
      lst_spart_range-low      = <lfs_constant>-low.
      APPEND lst_spart_range TO lir_spart_range.
      CLEAR: lst_spart_range.
    ENDIF. " IF <lfs_constant>-param1 = lc_auart
  ENDLOOP.
ENDIF. " IF li_constants[] IS NOT INITIAL
*--Check the Document Type,Sale Org and Divison
**BOC-MIMMADISET-ED2K916423 CR# ERPM-3368
IF vbak-auart IN lir_auart_range AND lir_auart_range IS NOT INITIAL
  AND vbak-vkorg IN lir_vkorg_range AND lir_vkorg_range IS NOT INITIAL
  AND vbak-spart IN lir_spart_range AND lir_spart_range IS NOT INITIAL.

*  skip the below code ( Dublicate partners are appended )

ELSE.
**EOC-MIMMADISET-ED2K916423 CR# ERPM-3368
  IF vbap-posnr IS NOT INITIAL AND
     t180-trtyp NE chara.
* Check if the Order line has any specific entry for the Partner Func
* Assumption: Standard Internal Table is already SORTed against Item#
    READ TABLE xvbpa TRANSPORTING NO FIELDS
         WITH KEY posnr = vbap-posnr                              "Line Item: BOM Header
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      DATA(lv_tabix_p) = sy-tabix.

*   Check if the current Line Item is a BOM Header
      READ TABLE xvbap TRANSPORTING NO FIELDS
           WITH KEY uepos = vbap-posnr.
      IF sy-subrc EQ 0.
        DATA(lv_tabix_i) = sy-tabix.

*     Determine the business object from a sales document
        CALL FUNCTION 'SD_OBJECT_TYPE_DETERMINE'
          EXPORTING
            i_document_type   = vbak-vbtyp
            i_tvak            = tvak
          IMPORTING
            e_business_object = lv_obj_typ.                       "Object type
        lv_obj_key         = vbak-vbeln.                          "Object key
        lst_sd_org-vkorg   = vbak-vkorg.                          "Sales Organization
        lst_sd_org-vtweg   = vbak-vtweg.                          "Distribution Channel
        lst_sd_org-spart   = vbak-spart.                          "Division
        lst_sd_org-doctype = vbak-auart.                          "SD Document Type

*     Get data from local memory - Sales Document: Partner
        CALL FUNCTION 'SD_PARTNER_DATA_GET'
          EXPORTING
            fic_objecttype      = lv_obj_typ                      "Object type
            fic_objectkey       = lv_obj_key                      "Object key
          TABLES
            fet_xvbpa           = li_prt_det                      "Partner Details
          EXCEPTIONS
            no_object_specified = 1
            no_object_found     = 2
            merge_failed        = 3
            OTHERS              = 4.
        IF sy-subrc NE 0.
          li_prt_det[] = xvbpa[].
        ENDIF.
        IF li_prt_det IS NOT INITIAL.
          SORT li_prt_det BY posnr parvw.
        ENDIF.

*     Retrieve the Constant values
        CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
          EXPORTING
            im_devid     = lc_id_e134                             "Development ID (E134)
          IMPORTING
            ex_constants = li_constnt.                            "Constant Values
*     Partner Functions to be excluded
        li_pf_excl[] = li_constnt[].
        DELETE li_pf_excl WHERE param1 NE lc_prtnr_f.

        LOOP AT xvbpa INTO DATA(lst_xvbpa_bom_h) FROM lv_tabix_p.
          IF lst_xvbpa_bom_h-posnr NE vbap-posnr.
            EXIT.
          ENDIF.
*       Exclude certain Partner Functions
*       BINARY SEARCH not used, since the Int Table will have very limited entries
          READ TABLE li_pf_excl TRANSPORTING NO FIELDS
               WITH KEY low = lst_xvbpa_bom_h-parvw.              "Partner Function
          IF sy-subrc EQ 0.
            CONTINUE.
          ENDIF.

          lv_prtnr_f = lst_xvbpa_bom_h-parvw.                     "Partner Function
          CLEAR: lv_kunnr_n.
          CASE lst_xvbpa_bom_h-nrart.                             "Type of partner number
            WHEN lc_ptyp_ku.
              lv_kunnr_n = lst_xvbpa_bom_h-kunnr.                 "Customer Number
            WHEN lc_ptyp_li.
              lv_kunnr_n = lst_xvbpa_bom_h-lifnr.                 "Account Number of Vendor or Creditor
            WHEN lc_ptyp_pe.
              lv_kunnr_n = lst_xvbpa_bom_h-pernr.                 "Personnel Number
            WHEN lc_ptyp_ap.
              lv_kunnr_n = lst_xvbpa_bom_h-parnr.                 "Number of contact person
          ENDCASE.

*       Loop through BOM Components
          LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<lst_bom_itm>) FROM lv_tabix_i.
            IF <lst_bom_itm>-uepos NE vbap-posnr.
              EXIT.
            ENDIF.
*         Fetch Item Category Details
            CALL FUNCTION 'SD_TVAP_SELECT'
              EXPORTING
                i_pstyv   = <lst_bom_itm>-pstyv                   "Item Category
              IMPORTING
                e_tvap    = lst_tvap_r                            "Sales Document: Item Category details
              EXCEPTIONS
                not_found = 1
                OTHERS    = 2.
            IF sy-subrc EQ 0.
              CLEAR: lv_prtnr_c,
                     lv_initial,
                     lv_kunnr_o.
*           Check if BOM Component has any specific entry for the Partner Function
              READ TABLE li_prt_det INTO DATA(lst_xvbpa_bom_i)
                   WITH KEY posnr = <lst_bom_itm>-posnr           "Line Item: BOM Component
                            parvw = lv_prtnr_f                    "Partner Function
                   BINARY SEARCH.
*           No entry for the Partner Function
              IF sy-subrc NE 0.
                lv_prtnr_c = abap_true.
                lv_initial = abap_true.
*           Entry exists for the Partner Function and the Partner is different than BOM Header
              ELSE.
                CASE lst_xvbpa_bom_i-nrart.                       "Type of partner number
                  WHEN lc_ptyp_ku.
                    lv_kunnr_o = lst_xvbpa_bom_i-kunnr.           "Customer Number
                  WHEN lc_ptyp_li.
                    lv_kunnr_o = lst_xvbpa_bom_i-lifnr.           "Account Number of Vendor or Creditor
                  WHEN lc_ptyp_pe.
                    lv_kunnr_o = lst_xvbpa_bom_i-pernr.           "Personnel Number
                  WHEN lc_ptyp_ap.
                    lv_kunnr_o = lst_xvbpa_bom_i-parnr.           "Number of contact person
                ENDCASE.
                IF lv_kunnr_n NE lv_kunnr_o.
                  lv_prtnr_c = abap_true.
                  lv_initial = abap_false.
                ENDIF.
              ENDIF.

              IF lv_prtnr_c IS NOT INITIAL.                       "Partner Has to be maintained
*             Add / Change of a Partner
                CALL FUNCTION 'SD_PARTNER_SINGLE_MODIFY'
                  EXPORTING
                    fic_objecttype       = lv_obj_typ             "Object Type
                    fic_objectkey        = lv_obj_key             "Object Key
                    fis_sdorgdata        = lst_sd_org             "Organizational Data for SD Documents
                    fif_pargr            = lst_tvap_r-pargr       "Partner Determination Procedure
                    fif_parvw            = lv_prtnr_f             "Partner Function
                    fif_posnr            = <lst_bom_itm>-posnr    "Document Line Item Number
                    fif_kunnr_old        = lv_kunnr_o             "Customer (old)
                    fif_kunnr_new        = lv_kunnr_n             "Customer (new)
                    fif_dialog           = space                  "Flag: No Dialog
                    fif_initial_value    = lv_initial             "Flag: New partner
                    fif_vkorg            = lst_sd_org-vkorg       "Sales Organization
                  EXCEPTIONS
                    parameter_incomplete = 1
                    object_not_found     = 2
                    check_error          = 3
                    numbers_not_ok       = 4
                    OTHERS               = 5.
                IF sy-subrc NE 0.
*               Begin of DEL:ERP-7056:WROY:22-Mar-2018:ED2K908793
**              Display Message
*               MESSAGE ID sy-msgid
*                     TYPE type_i
*                   NUMBER sy-msgno
*                     WITH sy-msgv1
*                          sy-msgv2
*                          sy-msgv3
*                          sy-msgv4.
*               End   of DEL:ERP-7056:WROY:22-Mar-2018:ED2K908793
*               Begin of ADD:ERP-7056:WROY:22-Mar-2018:ED2K908793
*               Sales Document: Partner (New Additions)
                  APPEND INITIAL LINE TO li_prt_add ASSIGNING FIELD-SYMBOL(<lst_xvbpa_bom_c>).
                  MOVE-CORRESPONDING lst_xvbpa_bom_h TO <lst_xvbpa_bom_c>.
                  <lst_xvbpa_bom_c>-posnr = <lst_bom_itm>-posnr.  "Line Item: BOM Component
*               End   of ADD:ERP-7056:WROY:22-Mar-2018:ED2K908793
                ENDIF.
              ENDIF.
              CLEAR: lst_xvbpa_bom_i.
            ENDIF.
          ENDLOOP.
        ENDLOOP.
      ENDIF.
    ENDIF.
* Begin of ADD:ERP-7056:WROY:22-Mar-2018:ED2K908793
    IF li_prt_add IS NOT INITIAL.
*   Add Sales Document: Partners
      APPEND LINES OF li_prt_add TO xvbpa.
      SORT xvbpa BY vbeln posnr parvw.
      CLEAR: li_prt_add.
    ENDIF.
* End   of ADD:ERP-7056:WROY:22-Mar-2018:ED2K908793
  ENDIF.
ENDIF.
