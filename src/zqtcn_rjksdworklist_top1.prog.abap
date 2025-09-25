* Deklarationen zur Statusverwaltung von Medienausgaben


TYPE-POOLS: SZAL.


TYPES: STATUS_TYPE TYPE JKSDMATERIALSTATUS.
TYPES: STATUS_TAB_TYPE TYPE JKSDMATERIALSTATUSTAB.
*TYPES: BEGIN OF STATUS_TYPE.
*         ISMREFMDPROD TYPE MARA-ISMREFMDPROD,
*         MATNR TYPE MARA-MATNR,
*         ISMPUBLDATE TYPE MARA-ISMPUBLDATE,
*         XFIRST_ISSUE_LINE TYPE XFELD,
*         MSTAV TYPE MARA-MSTAV,
*         MSTDV TYPE MARA-MSTDV,
*         MSTAE TYPE MARA-MSTAE,
*         MSTDE TYPE MARA-MSTDE,
*         MARC_WERKS TYPE MARC-WERKS,
*         MARC_MMSTA TYPE MARC-MMSTA,
*         MARC_MMSTD TYPE MARC-MMSTD,
*         MVKE_VKORG TYPE MVKE-VKORG,
*         MVKE_VTWEG TYPE MVKE-VTWEG,
*         MVKE_VMSTA TYPE MVKE-VMSTA,
*         MVKE_VMSTD TYPE MVKE-VMSTD,
*TYPES: END OF STATUS_TYPE,
*       STATUS_TAB_TYPE TYPE TABLE OF STATUS_TYPE.
TYPES: BEGIN OF AMARA_STRU.
        INCLUDE STRUCTURE MARA_UEB.
TYPES: END OF AMARA_STRU,
       AMARA_TAB TYPE TABLE OF AMARA_STRU.
TYPES: BEGIN OF AMARC_STRU.
        INCLUDE STRUCTURE MARC_UEB.
TYPES: END OF AMARC_STRU,
       AMARC_TAB TYPE TABLE OF AMARC_STRU.
TYPES: BEGIN OF AMVKE_STRU.
        INCLUDE STRUCTURE MVKE_UEB.
TYPES: END OF AMVKE_STRU,
       AMVKE_TAB TYPE TABLE OF AMVKE_STRU.
TYPES: BEGIN OF AMFIELDRES_STRU.
        INCLUDE STRUCTURE MFIELDRES.
TYPES: END OF AMFIELDRES_STRU,
       AMFIELDRES_TAB TYPE TABLE OF AMFIELDRES_STRU.
TYPES: BEGIN OF TRANC_TYPE,
         TRANC TYPE MERRDAT-TRANC,
         ISMREFMDPROD TYPE MARA-ISMREFMDPROD,
         MATNR TYPE MARA-MATNR,
         XFIRST_ISSUE_LINE TYPE XFELD,
         MARC_WERKS TYPE MARC-WERKS,
         MVKE_VKORG TYPE MVKE-VKORG,
         MVKE_VTWEG TYPE MVKE-VTWEG,
       END OF TRANC_TYPE,
       TRANC_TAB TYPE TABLE OF TRANC_TYPE.
TYPES: ERROR_TYPE TYPE JKSDMATSTATUSERROR,
       ERROR_TAB TYPE JKSDMATSTATUSERRORTAB.
TYPES: BEGIN OF MATNR_STRU,
         MATNR TYPE MARA-MATNR,
       END OF MATNR_STRU,
       LOCKED_TAB TYPE TABLE OF MATNR_STRU,
       MEDPROD_TAB TYPE MATNR_STRU OCCURS 0,
       MARKED_TAB TYPE MATNR_STRU OCCURS 0.

types: matnr_tab type matnr_stru occurs 0.        "TK13062008.


TYPES: ERRMSG_STRU TYPE MERRDAT,                  "TK18022005
       ERRMSG_TAB TYPE TABLE OF ERRMSG_STRU.      "TK18022005
types: ls_tranc type TRANSCOUNT.                  "TK18022005
types: lt_tranc type ls_tranc occurs 0.           "TK18022005


DATA: GT_STATUSLIST_TAB                 TYPE STATUS_TAB_TYPE.
DATA: GT_AMFIELDRES_TAB                 TYPE AMFIELDRES_TAB.
DATA: GT_DBTAB                          TYPE STATUS_TAB_TYPE.
DATA: GT_TRANC_TAB                      TYPE TRANC_TAB.
DATA: GT_ERROR_TAB                      TYPE ERROR_TAB.
DATA: GT_LOCK_ERROR                     TYPE LOCKED_TAB.
DATA: TRANC_STRU                        TYPE TRANC_TYPE.
*     gt_locked_contracts          TYPE TABLE OF rjksdcontract.
DATA: GT_AMARA_UEB TYPE AMARA_TAB.
DATA: GT_JPTMARA_TAB TYPE JPTMARA_TAB.                    "TK01102006
DATA: GT_AMARC_UEB TYPE AMARC_TAB.
DATA: GT_AMVKE_UEB TYPE AMVKE_TAB.
DATA  CON_TCODE_MEDAUS_UPDATE LIKE SY-TCODE VALUE 'JP28'.


*---------------------------------------------------------------------*
* Pop-ups
*---------------------------------------------------------------------*
*aTA: OK_CODE LIKE SY-UCOMM.
data: ok_code_101 like sy-ucomm.
TABLES: RJKSD13.
DATA:      GV_CANCEL.                                       " F12
* Im  Feld POPUP_STATUS wird vom Funkt.bst. "POPUP_GET_VALUES..."
* zurückgegeben, ob das POPUP mit F12 oder "normal" beendet wurde!
DATA: POPUP_STATUS(1).
DATA: OK_CODE_0500 LIKE OK_CODE_101.
DATA: OK_CODE_0700 LIKE OK_CODE_101.
DATA: CON_POPUPSTATUS_OK LIKE POPUP_STATUS.
DATA: CON_POPUPSTATUS_ABORT LIKE POPUP_STATUS VALUE 'A'.

DATA: XINDUSTRYMATERIAL TYPE XFELD.
DATA: XRETAILMATERIAL TYPE XFELD.
DATA: XRETAIL TYPE XFELD.

DATA: gv_WERKS_STATUS_COLUMN_MARKED TYPE XFELD.
DATA: gv_VTL_STATUS_COLUMN_MARKED TYPE XFELD.
DATA: gv_DATE_COLUMN_MARKED TYPE XFELD.

DATA: I_OUTTAB TYPE jksdmaterialstatustab.



*---------------------------------------------------------------------*
* Global ALOG Fields
*---------------------------------------------------------------------*
DATA LOG TYPE REF TO CL_ISM_SD_DOCKING_LOG.
DATA: RETURN TYPE REF TO CL_ISM_SD_MESSAGE.   "#EC NEEDED

CONSTANTS CON_LOG_OBJECT TYPE BAL_S_LOG-OBJECT VALUE 'ISMWORKLIST'.
***INCLUDE RJKSDWORKLIST_TOP .
DATA: GRID1  TYPE REF TO CL_GUI_ALV_GRID.   "#EC NEEDED



DATA: XAUTHORITY_OK TYPE XFELD.


*---------------------------------------------------------------------*
* Deklarationen für Retail-Artikel:
*---------------------------------------------------------------------*
DATA: HEADDATA              LIKE  BAPIE1MATHEAD,
      VARIANTSKEYS          LIKE  BAPIE1VARKEY
                             OCCURS 0 WITH HEADER LINE,
      CHARACTERISTICVALUE   LIKE  BAPIE1AUSPRT
                             OCCURS 0 WITH HEADER LINE,
      CHARACTERISTICVALUEX  LIKE  BAPIE1AUSPRTX
                             OCCURS 0 WITH HEADER LINE,
      CLIENTDATA            LIKE  BAPIE1MARART
                             OCCURS 0 WITH HEADER LINE,
      CLIENTDATAX           LIKE  BAPIE1MARARTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Anfang)
      CLIENTEXT             LIKE  BAPIE1MARAEXTRT
                             OCCURS 0 WITH HEADER LINE,
      CLIENTEXTX            LIKE  BAPIE1MARAEXTRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Ende)
      ADDNLCLIENTDATA       LIKE  BAPIE1MAW1RT
                             OCCURS 0 WITH HEADER LINE,
      ADDNLCLIENTDATAX      LIKE  BAPIE1MAW1RTX
                             OCCURS 0 WITH HEADER LINE,
      MATERIALDESCRIPTION   LIKE  BAPIE1MAKTRT
                             OCCURS 0 WITH HEADER LINE,
*#      MATERIALDESCRIPTIONX  LIKE  BAPIE1MAKTRTX
*#                             OCCURS 0 WITH HEADER LINE,
      PLANTDATA             LIKE  BAPIE1MARCRT
                             OCCURS 0 WITH HEADER LINE,
      PLANTDATAX            LIKE  BAPIE1MARCRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Anfang)
      PLANTEXT              LIKE  BAPIE1MARCEXTRT
                             OCCURS 0 WITH HEADER LINE,
      PLANTEXTX             LIKE  BAPIE1MARCEXTRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Ende)
      FORECASTPARAMETERS    LIKE  BAPIE1MPOPRT
                             OCCURS 0 WITH HEADER LINE,
      FORECASTPARAMETERSX   LIKE  BAPIE1MPOPRTX
                             OCCURS 0 WITH HEADER LINE,
      FORECASTVALUES        LIKE  BAPIE1MPRWRT
                             OCCURS 0 WITH HEADER LINE,
*#      FORECASTVALUESX       LIKE  BAPIE1MPRWRTX
*#                             OCCURS 0 WITH HEADER LINE,
      TOTALCONSUMPTION      LIKE  BAPIE1MVEGRT
                             OCCURS 0 WITH HEADER LINE,
*#      TOTALCONSUMPTIONX     LIKE  BAPIE1MVEGRTX
*#                             OCCURS 0 WITH HEADER LINE,
      UNPLNDCONSUMPTION     LIKE  BAPIE1MVEURT
                             OCCURS 0 WITH HEADER LINE,
*#      UNPLNDCONSUMPTIONX    LIKE  BAPIE1MVEURTX
*#                             OCCURS 0 WITH HEADER LINE,
      PLANNINGDATA          LIKE  BAPIE1MPGDRT
                             OCCURS 0 WITH HEADER LINE,
      PLANNINGDATAX         LIKE  BAPIE1MPGDRTX
                             OCCURS 0 WITH HEADER LINE,
      STORAGELOCATIONDATA   LIKE  BAPIE1MARDRT
                             OCCURS 0 WITH HEADER LINE,
      STORAGELOCATIONDATAX  LIKE  BAPIE1MARDRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Anfang)
      STORAGELOCATIONEXT    LIKE  BAPIE1MARDEXTRT
                            OCCURS 0 WITH HEADER LINE,
      STORAGELOCATIONEXTX   LIKE  BAPIE1MARDEXTRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Ende)
      UNITSOFMEASURE        LIKE  BAPIE1MARMRT
                             OCCURS 0 WITH HEADER LINE,
      UNITSOFMEASUREX       LIKE  BAPIE1MARMRTX
                             OCCURS 0 WITH HEADER LINE,
      UNITOFMEASURETEXTS    LIKE  BAPIE1MAMTRT
                             OCCURS 0 WITH HEADER LINE,
*#      UNITOFMEASURETEXTSX   LIKE  BAPIE1MAMTRTX
*#                             OCCURS 0 WITH HEADER LINE,
      INTERNATIONALARTNOS   LIKE  BAPIE1MEANRT
                             OCCURS 0 WITH HEADER LINE,
*#      INTERNATIONALARTNOSX  LIKE  BAPIE1MEANRTX
*#                             OCCURS 0 WITH HEADER LINE,
      VENDOREAN             LIKE  BAPIE1MLEART
                             OCCURS 0 WITH HEADER LINE,
*#      VENDOREANX            LIKE  BAPIE1MLEARTX
*#                             OCCURS 0 WITH HEADER LINE,
      LAYOUTMODULEASSGMT    LIKE  BAPIE1MALGRT
                             OCCURS 0 WITH HEADER LINE,
      LAYOUTMODULEASSGMTX   LIKE  BAPIE1MALGRTX             "JH/4.0C
                             OCCURS 0 WITH HEADER LINE,     "JH/4.0C
      TAXCLASSIFICATIONS    LIKE  BAPIE1MLANRT
                             OCCURS 0 WITH HEADER LINE,
*#      TAXCLASSIFICATIONSX   LIKE  BAPIE1MLANRTX
*#                             OCCURS 0 WITH HEADER LINE,
      VALUATIONDATA         LIKE  BAPIE1MBEWRT
                             OCCURS 0 WITH HEADER LINE,
      VALUATIONDATAX        LIKE  BAPIE1MBEWRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Anfang)
      VALUATIONEXT          LIKE  BAPIE1MBEWEXTRT
                             OCCURS 0 WITH HEADER LINE,
      VALUATIONEXTX         LIKE  BAPIE1MBEWEXTRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Ende)
      WAREHOUSENUMBERDATA   LIKE  BAPIE1MLGNRT
                             OCCURS 0 WITH HEADER LINE,
      WAREHOUSENUMBERDATAX  LIKE  BAPIE1MLGNRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Anfang)
      WAREHOUSENUMBEREXT    LIKE  BAPIE1MLGNEXTRT
                             OCCURS 0 WITH HEADER LINE,
      WAREHOUSENUMBEREXTX   LIKE  BAPIE1MLGNEXTRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Ende)
      STORAGETYPEDATA       LIKE  BAPIE1MLGTRT
                             OCCURS 0 WITH HEADER LINE,
      STORAGETYPEDATAX      LIKE  BAPIE1MLGTRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Anfang)
      STORAGETYPEEXT        LIKE  BAPIE1MLGTEXTRT
                             OCCURS 0 WITH HEADER LINE,
      STORAGETYPEEXTX       LIKE  BAPIE1MLGTEXTRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Ende)
      SALESDATA             LIKE  BAPIE1MVKERT
                             OCCURS 0 WITH HEADER LINE,
      SALESDATAX            LIKE  BAPIE1MVKERTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Anfang)
      SALESEXT              LIKE  BAPIE1MVKEEXTRT
                             OCCURS 0 WITH HEADER LINE,
      SALESEXTX             LIKE  BAPIE1MVKEEXTRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Ende)
      POSDATA               LIKE  BAPIE1WLK2RT
                             OCCURS 0 WITH HEADER LINE,
      POSDATAX              LIKE  BAPIE1WLK2RTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Anfang)
      POSEXT                LIKE  BAPIE1WLK2EXTRT
                             OCCURS 0 WITH HEADER LINE,
      POSEXTX               LIKE  BAPIE1WLK2EXTRTX
                             OCCURS 0 WITH HEADER LINE,
*       JH/22.04.98/4.0C Strukturen f. Userexit (Ende)
      MATERIALLONGTEXT      LIKE  BAPIE1MLTXRT
                             OCCURS 0 WITH HEADER LINE,
*#      MATERIALLONGTEXTX     LIKE  BAPIE1MLTXRTX
*#                             OCCURS 0 WITH HEADER LINE,
      PLANTKEYS             LIKE  BAPIE1WRKKEY
                             OCCURS 0 WITH HEADER LINE,
      STORAGELOCATIONKEYS   LIKE  BAPIE1LGOKEY
                             OCCURS 0 WITH HEADER LINE,
      DISTRCHAINKEYS        LIKE  BAPIE1VTLKEY
                             OCCURS 0 WITH HEADER LINE,
      WAREHOUSENOKEYS       LIKE  BAPIE1LGNKEY
                             OCCURS 0 WITH HEADER LINE,
      STORAGETYPEKEYS       LIKE  BAPIE1LGTKEY
                             OCCURS 0 WITH HEADER LINE,
      VALUATIONTYPEKEYS     LIKE  BAPIE1BWAKEY
                             OCCURS 0 WITH HEADER LINE.

*---------------------------------------------------------------------*
* Deklarationen für BADI:
*---------------------------------------------------------------------*
data: exit_worklist_checks type ref to ism_worklist_checks.  "#EC NEEDED




*-----------------------------Anfang --------------"TK01102006--------*
* Deklarationen für neuen BADI (neue Felder):
*---------------------------------------------------------------------*

data: worklist_add_fields
           type ref to ISM_WORKLIST_ADD_FIELDS.  "#EC NEEDED




*TYPES: BEGIN OF gs_badi_field,
*         fieldname type fieldname,
*         xinput    type xfeld,
*       END OF gs_badi_field,
*       gt_badi_fields TYPE TABLE OF gs_badi_field.
*data: gs_badi_field type gs_badi_field.
data:  gt_badi_fields type JKSDBADItab.
data:  gs_badi_field  type JKSDBADIFIELD.



*constants: CON_TCODE_CHANGE   TYPE SYST-TCODE VALUE 'JKSD13',  "TK08022007
 data     : CON_TCODE_CHANGE   TYPE SYST-TCODE VALUE 'JKSD13',  "TK08022007
           CON_TCODE_DISPLAY  TYPE SYST-TCODE VALUE 'JKSD13A'.


data: gt_tjksd13  type standard table of TJKSD13.          "TK08022007
data: gs_tjksd13a type TJKSD13a.                           "TK08022007
data: GV_DISPLAY   TYPE XANZEIGE.                          "TK08022007
data: gt_tjksd130t type standard table of TJKSD130t.       "TK08022007
data: gt_tjksd130  type standard table of TJKSD130.        "TK08022007




* Verlagerung von RJKSDWORKLIST hierher (Umbau: Sichern vor CALL Transaction)
DATA: GV_VARIANT_TREE TYPE REF TO CL_ISM_REPORT_VARIANT_TREE.  "#EC NEEDED

DATA  XSHOW_ERROR_ALOG LIKE CON_ANGEKREUZT.

data: gv_pedex_active type xfeld.                       "TK28022007



TYPES: BEGIN OF jvtphdate_STRU.                             "TK01022008
        INCLUDE STRUCTURE jvtphdate.                        "TK01022008
TYPES: END OF jvtphdate_stru,                               "TK01022008
       jvtphdate_TAB TYPE TABLE OF jvtphdate_STRU.          "TK01022008

data: gv_pedex2_active type xfeld.                          "TK01022008

data: gv_segment_level type jksdworklist_segment_level.     "TK01022008
*data: gv_sel_subscreen type JKSDWORKLIST_SEL_SUBSCREEN.     "TK01022008
data: gv_selection_cprog type JKSDWORKLIST_SEL_PROGRAM.      "TK01022008

data: gt_tjksd13a type standard table of TJKSD13a.          "TK01022008
data: gv_phasenlayout type xfeld.                           "TK01022008


data: con_level_mara_marc_mvke                              "TK01022008
       type jksdworklist_segment_level value '1'.           "TK01022008
data: con_level_mara_marc                                   "TK01022008
       type jksdworklist_segment_level value '2'.           "TK01022008
data: con_level_mara_mvke                                   "TK01022008
       type jksdworklist_segment_level value '3'.           "TK01022008
data: con_level_mara                                        "TK01022008
       type jksdworklist_segment_level value '4'.           "TK01022008

data: gt_tjksd13f type standard table of TJKSD13f.          "TK01022008
data: gs_tjksd13f type TJKSD13f.                            "TK01022008

data: con_field_status_invisible(1) value '0'.              "TK01022008
data: con_field_status_display(1) value '1'.                "TK01022008



* Phasenselektion wurde nach elementarem Einbau wieder deak- "TK01022008
* tiviert, kann aber wieder aktiviert werden:                "TK01022008
* 1.) Selektionsfelder müssen ansatt der Deklaration hier    "TK01022008
*     in RJKSDWORKLIST_SELECTION wieder aktiviert werden:    "TK01022008
data: ls_JVTPHDATE type JVTPHDATE.                           "TK01022008
data gv_norm like RJKSDWORKLIST_CHANGEFIELDS-xwithout_phases "TK01022008
     value 'X'.                                              "TK01022008
data: gv_incl like RJKSDWORKLIST_CHANGEFIELDS-xincl_phases.  "TK01022008
data: gv_excl like RJKSDWORKLIST_CHANGEFIELDS-xexcl_phases.  "TK01022008
* 2.) GR_PHMOD muß kompletet wieder akiviert werden :        "TK01022008
*ELECT-OPTIONS: GR_phmod FOR ls_JVTPHDATE-PHASEMDL           "TK01022008
* 3.) in RJKSDWORKLIST_ALV müssen wieder aufgenommen werden: "TK01022008
* RJKSDWORKLIST_ALV-PH_PHASEMDL                              "TK01022008
* RJKSDWORKLIST_ALV-PH_PHASENBR                              "TK01022008
* RJKSDWORKLIST_ALV-PH_DELIV_DATE                            "TK01022008


constants: con_plant_memoryid type memoryid      "TK01042008/hint1158167
               value 'WORKLIST_PLANT'.           "TK01042008/hint1158167
constants: con_vkorg_memoryid type memoryid      "TK01042008/hint1158167
               value 'WORKLIST_VKORG'.           "TK01042008/hint1158167
constants: con_vtweg_memoryid type memoryid      "TK01042008/hint1158167
               value 'WORKLIST_VTWEG'.           "TK01042008/hint1158167

* --- Anfang-----------optimistisches Sperren----- "TK01042008
DATA: GT_MARA_DB TYPE ism_MARA_DB_TAB.
DATA: GT_MARc_DB TYPE ism_MARc_DB_TAB.
DATA: GT_Mvke_DB TYPE ism_Mvke_DB_TAB.
data: gv_wl_enq_active type xfeld.
data: gv_wl_erschdat_change type xfeld.
data: gv_wl_selvar_separated type xfeld.
data: gv_twpa_vlgvz type vlgvz.  "Vorlageverteilzentrum    "TK13062008
data: gt_vlgvz_matnr TYPE MATNR_tab.                       "TK13062008
* --- Ende-------------optimistisches Sperren----- "TK01042008

*screens
data: gv_main_screen   type sy-dynnr,
      gv_main_program  type sy-repid value 'ZQTC_RJKSDWORKLIST',
      con_screen_0100  type sy-dynnr value '0100',
      con_screen_0102  type sy-dynnr value '0102',
      con_screen_0103  type sy-dynnr value '0103'.  "TK11082009/hint1374274

data: con_dynnr_selection_warning type dynnr value '550'.
DATA: OK_CODE_0550 LIKE OK_CODE_101.
data: xabort_selection type xfeld.
data: gv_selection_warning_cnt type sy-tabix value '500'.

data: gv_reset_marked_lines type xfeld.          "TK16072009/hint1365757
data: gv_double_click_selection type xfeld.      "TK16072009/hint1365757
data: gv_save_okcode like sy-ucomm.              "TK16072009/hint1365757

data: gv_reset_sorting type xfeld.               "TK11082009/hint1374477



*-----Anfang---------------------------------------"TK17092009/hint1386691
*---------------------------------------------------------------------*
* Deklarationen für BADI/Fuba Vorbelegung bei CALL Worklist
*---------------------------------------------------------------------*

data: worklist_call
           type ref to ISM_WORKLIST_CALL.  "#EC NEEDED

data: gv_from_date        type jdate_from2,
      gv_to_date          type jdate_to2,
      gv_read_sequence    TYPE JREAD_ISSUE_BY_SEQUENCE,
      gv_selection_date   TYPE RJKSDWORKLIST_SELECTION_DATE .

data: gv_selection_set_active type xfeld.
data: gv_selection_set_done type xfeld.
*-----Ende-----------------------------------------"TK17092009/hint1386691
