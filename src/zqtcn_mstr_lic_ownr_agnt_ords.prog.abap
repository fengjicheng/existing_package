*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MSTR_LIC_OWNR_AGNT_ORDS
* PROGRAM DESCRIPTION: Add Master License Owner for Agent Orders
* For Agent Orders, Master License Owner has to be dtermined based on
* Ship-to Party's Partner Function
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 2018-08-10
* OBJECT ID: I0341 (ERP-6593)
* TRANSPORT NUMBER(S) ED2K913006
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  li_const_i0341 TYPE zcat_constants,                " Wiley Application Constants
  lir_cust_grp1  TYPE RANGE OF kvgr1 INITIAL SIZE 0. " Customer group 1

DATA:
  lst_prtnr_func TYPE knvp,      " Customer Master Partner Functions
  lst_sdorgdata	 TYPE	sdorgdata. " Organizational Data for SD Documents

DATA:
  lv_pf_mlo      TYPE parvw,      " Partner Function
  lv_pf_mlo_mod  TYPE parvw_4,    " Partner Function
  lv_mlo_old     TYPE kunnr,      " Master License Owner (Old)
  lv_mlo_new     TYPE kunnr,      " Master License Owner (New)
  lv_object_type TYPE swo_objtyp, " Object Type
  lv_object_key  TYPE swo_typeid. " Object key

CONSTANTS:
  lc_devid_i0341 TYPE zdevid     VALUE 'I0341',            " Development ID
  lc_pf_mlo      TYPE rvari_vnam VALUE 'PF_MSTR_LIC_OWNR', " ABAP: Name of Variant Variable
  lc_mvgr1_agent TYPE rvari_vnam VALUE 'CUST_GRP1_AGENTS'. " ABAP: Name of Variant Variable

IF t180-trtyp NE chara.  " Not in Display mode
* Fetche Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_i0341  " Development ID (I0341)
    IMPORTING
      ex_constants = li_const_i0341. " Wiley Application Constants
  LOOP AT li_const_i0341 ASSIGNING FIELD-SYMBOL(<lst_const_i0341>).
    CASE <lst_const_i0341>-param1.
      WHEN lc_pf_mlo. " Partner Function: Master License Owner
        lv_pf_mlo              = <lst_const_i0341>-low.

      WHEN lc_mvgr1_agent. " Customer Group 1: Agents
        APPEND INITIAL LINE TO lir_cust_grp1 ASSIGNING FIELD-SYMBOL(<lst_cust_grp1>).
        <lst_cust_grp1>-sign   = <lst_const_i0341>-sign.
        <lst_cust_grp1>-option = <lst_const_i0341>-opti.
        <lst_cust_grp1>-low    = <lst_const_i0341>-low.
        <lst_cust_grp1>-high   = <lst_const_i0341>-high.
      WHEN OTHERS.
*     Nothing to Do
    ENDCASE.
  ENDLOOP. " LOOP AT li_const_i0341 ASSIGNING FIELD-SYMBOL(<lst_const_i0341>)

  IF rv02p-weupd EQ abap_true OR                     " Ship-to Party is changed
   ( svbkd-tabix EQ 0 AND vbap-posnr EQ posnr_low ). " For the very first time

    IF kuagv-kvgr1 IN lir_cust_grp1. " Sold-to Party's Customer Group 1: Agents
      CLEAR: lv_mlo_old.
*   Check if Master License Owner already exists
      READ TABLE xvbpa ASSIGNING FIELD-SYMBOL(<lst_xvbpa>)
           WITH KEY vbeln = vbak-vbeln
                    posnr = posnr_low
                    parvw = lv_pf_mlo
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lv_mlo_old = <lst_xvbpa>-kunnr. " Master License Owner (Old)
      ENDIF. " IF sy-subrc EQ 0

      CLEAR: lv_mlo_new.
*   Fetch Customer Master Partner Functions
      CALL FUNCTION 'SD_KNVP_READ'
        EXPORTING
          fif_vkorg            = vbak-vkorg     " Sales Organization
          fif_vtweg            = vbak-vtweg     " Distribution Channel
          fif_spart            = vbak-spart     " Division
          fif_kunnr            = kuwev-kunnr    " Ship-to Party
          fif_filter_parvw     = lv_pf_mlo      " Partner Function: Master License Owner
        IMPORTING
          fes_knvp             = lst_prtnr_func " Customer Master Partner Functions
        EXCEPTIONS
          parameter_incomplete = 1
          no_record_found      = 2
          OTHERS               = 3.
      IF sy-subrc EQ 0.
        lv_mlo_new = lst_prtnr_func-kunn2. " Master License Owner (New)
      ENDIF. " IF sy-subrc EQ 0

      IF lv_mlo_new NE lv_mlo_old.
        lv_object_type = businessobjekt.
        lv_object_key  = vbak-vbeln.
        MOVE-CORRESPONDING vbak TO lst_sdorgdata.
        lst_sdorgdata-doctype = vbak-auart.
        lv_pf_mlo_mod = lv_pf_mlo.
*     Add / Change / Remove Master License Owner
        CALL FUNCTION 'SD_PARTNER_SINGLE_MODIFY'
          EXPORTING
            fic_objecttype       = lv_object_type " Object Type
            fic_objectkey        = lv_object_key  " Object Key
            fis_sdorgdata        = lst_sdorgdata  " Organizational Data for SD Documents
            fif_pargr            = tvak-pargr     " Partner Determination Procedure
            fif_parvw            = lv_pf_mlo_mod  " Partner Function: Master License Owner
            fif_posnr            = posnr_low      " SD Line Item Number (Header)
            fif_kunnr_old        = lv_mlo_old     " Master License Owner (Old)
            fif_kunnr_new        = lv_mlo_new     " Master License Owner (New)
          EXCEPTIONS
            parameter_incomplete = 1
            object_not_found     = 2
            check_error          = 3
            numbers_not_ok       = 4
            OTHERS               = 5.
        IF sy-subrc EQ 0.
*       Get partner data to be compatible
          CALL FUNCTION 'SD_PARTNER_DATA_GET'
            EXPORTING
              fic_objecttype      = lv_object_type " Object Type
              fic_objectkey       = lv_object_key  " Object Key
              fic_xvbuv_merged    = abap_true
            TABLES
              fet_xvbpa           = xvbpa          " Partner Table
              fet_xvbuv           = xvbuv          " Incompleteness Log
              fet_xvbadr          = xvbadr         " Document Addresses
            EXCEPTIONS
              no_object_specified = 1
              no_object_found     = 2
              merge_failed        = 3
              OTHERS              = 4.
          IF sy-subrc NE 0.
*         Nothing to do
          ENDIF. " IF sy-subrc NE 0
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF lv_mlo_new NE lv_mlo_old
    ENDIF. " IF kuagv-kvgr1 IN lir_cust_grp1
  ENDIF. " IF rv02p-weupd EQ abap_true OR
ENDIF. " IF t180-trtyp NE chara
