PROGRAM ZQTC_RJKSDWORKLIST MESSAGE-ID JKSDWORKLIST.
*
* zu klären/TODO:
*================
* - Relinfo (Relinfo ISMSD_471_ISSUE_STAT ergänzen!!!!)
* - Testfall
* - setzuff (soweit OK)
* - Einbindung ins Menüe
*    - Online-Transaktion JKSD13/JKSD13A + Protokollanzeige
*      - unter Mengenplanung
*      - unter Ausstattungsplanung
*      - unter Auftrag ????
*      - unter Remission ??????
*    - Report für Massenänd: RJKSDISSUESTATUSCHANGE + Protokollanzeige
* - Fehlernachrichten (JKSDWORKLIST) bereinigen
* - Coding bereinigen
* - Laufzeit sichern für MAINTAIN_DARK

* Besonderheiten:
* ===============
* - eine Ausgabe in n Folgen => Ausgabe kann nur in 1.Folge gepflegt
*     werden, alle weiteren Vorkommen des Ausgabe sind nur Anzeige
* - Absprung von der Medienausgabe
*   - in Mengenplanung(JKSD07) und Beilagenplanung(JVSD12)
*     (abhänging vom Modus in Anzeige oder Pflege) => OK
*   - in die Einzelpflege Medienausgabe: generell Anzeige  => OK
*     (kein(!) Sprung ins Ändern(kritisch:Sperren, Verbuchung abwarten.)
* - Sperren  => OK (nur MARA-Sperre, Folge wird nicht gesperrt)
*               - siehe Form LOCK: nur Sperre auf ENQUEUE_EMMARAE,
*               - Statusänderung hat keinen Einfluss auf die Folge
*               - Unschärfe: Nach dem Einlesen der Ausgaben zur Folge
*                            kann sich diese Folge parallel verändern.
* - Authority => OK (Berechtigung für Mara anzeigen/ändern wird geprüft)
* - Fehlerhandling
*   - Plausis im Dialog (GÜlt/igbis Muß oder Kann???) => Nein
*   - Maintain_DARK umsetzen in eigene Fehlermeldung => JA
*   - Fehlermeldungen (Fehler beim Sichern) als ALOG => JA
*     (keine ALOG-Anzeige bei F3/F15/F12 = Anzeig im Menü möglich)
* - REFRESH notwendig (z.B. für neue Selektionseingaben, Sperren ...)

* TK08082005: MVKE-ISMCOLLDATE inaktiviert (wegen Datenmodelländerung
*             ist dieses Feld nicht mehr unterstützt)
* TK10082005: Datumsselektion erweitert um Bestelldatum,Verkaufsdatum
*             und Versanddatum
*               Laufzeit: fehlenden Indizes auf diese Felder -> Hinweis ?
*             Lesen über Folge ist jetzt Default (XSEQUENCE = X )
* TK13022006: < ERP2007: Hinweis 923436
*             Implizite Verwaltung der Flags ISMMATRETURN/ISMINTERRUPT
* TK01102006: neu zu ERP2007: - BADI für neue Felder
*                             - Texte je Medienausgabe
*                             - Integration Medienfelder in Retail-BAPI
* TK08022007: Erweiterung um Transaktionsvarianten
*             (Steuerung erfolgt über neue Tabellen TJKSD13 und TJKSD13A)
* TK07032007: Rel <= ERP2005 korrigiert mit Hinweis 1034893
*             Performance-Verbesserung bei Selektion nach Erstversanddatum
* TK01022008: User-spezifische Transaktionssteuerung

*---------------------------------------------------------------------*
* Dialog program to change material status.
*---------------------------------------------------------------------*

INCLUDE LJPISMDC1.
INCLUDE MJ001TAL_CON.
INCLUDE MJPG0TC0.
INCLUDE LJPISMDC2.

INCLUDE MJ_SYDATUM.

*---------------------------------------------------------------------*
* Global Fields
*---------------------------------------------------------------------*
DATA: GV_RECOMMEND_SAVE TYPE XFELD,
      GT_RETURN         TYPE RJMSG_TAB.
*DATA  XSHOW_ERROR_ALOG LIKE CON_ANGEKREUZT.

DATA: BEGIN OF EXCL_BUTTONS OCCURS 20.         "für SET PF-STATUS..
        INCLUDE STRUCTURE RJ181.               "..EXCLUDING ...
      DATA: END   OF EXCL_BUTTONS.

*----------------------------------------------------------------------*
*     BADI
*----------------------------------------------------------------------*
CLASS CL_EXITHANDLER DEFINITION LOAD.
*DATA  exit TYPE REF TO if_ex_ism_quantityplan.
*DATA  change_exit TYPE REF TO if_ex_ism_demandchange.


*---------------------------------------------------------------------*
* Global Docking Fields
*---------------------------------------------------------------------*
CLASS LCL_HANDLER DEFINITION DEFERRED.

*DATA: GV_VARIANT_TREE TYPE REF TO CL_ISM_REPORT_VARIANT_TREE,
DATA: GV_TREE_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GV_HANDLER        TYPE REF TO LCL_HANDLER.

*---------------------------------------------------------------------*
* Global Selection Fields
*---------------------------------------------------------------------*
CONTROLS: SELECTTAB TYPE TABSTRIP.
CONSTANTS: CON_SUBSCREEN_SELECT LIKE SY-DYNNR VALUE '0200',
           CON_SUBSCREEN_EMPTY  LIKE SY-DYNNR VALUE '0210',
           CON_SELECTTAB_MAIN   LIKE SY-DYNNR VALUE '0200'.
DATA: GV_SELECTION_DYNNR           LIKE SY-DYNNR,
      GV_ACTIVESELECTTAB           LIKE SY-DYNNR,
      GV_SELECTSUBSCREEN           LIKE SY-DYNNR,
      GV_SELECTION_TOGGLE_TEXT(50) TYPE C,
      GV_SELECTION_HIDDEN          TYPE XFELD,
      GT_PARAMS                    TYPE RSPARAMS_TT,
      GT_UNKNOWN_PARAMS            LIKE GT_PARAMS[],
      GT_MAPPING                   TYPE RJKSD_OBJECT_SET_MAPPING_TAB.

*---------------------------------------------------------------------*
* Global Macros
*---------------------------------------------------------------------*
DEFINE CONVERT_FROM.
  PERFORM CONVERT_FROM_PARAMS USING    &1
                              CHANGING GT_UNKNOWN_PARAMS[]
                                       GV_VKORG
                                       GV_VTWEG
*                                       GV_SPART
                                       GV_WERK
                                       GR_PRULE[]
                                       GR_MPROD[]
                                       GR_ISSUE[]   "SEL_ISSUE
                                       GR_PTYPE[]
                                       GR_MTYPE[]
                                       GR_MSTAV[]
                                       GR_VMSTA[]
                                       GR_MSTAE[]
                                       GR_MMSTA[]
                                       gv_filt    .         "TK01042009
*                                      gv_norm              "TK01022008
*                                      gv_incl              "TK01022008
*                                      gv_excl.             "TK01022008
*                                      gr_phmod[].          "TK01022008

END-OF-DEFINITION.
DEFINE CONVERT_TO.
  PERFORM CONVERT_TO_PARAMS USING
                                     GV_VKORG
                                     GV_VTWEG
*                                     GV_SPART
                                     GV_WERK
                                     GR_PRULE[]
                                     GR_MPROD[]
                                     GR_ISSUE[]   "SEL_ISSUE
                                     GR_PTYPE[]
                                     GR_MTYPE[]
                                     GR_MSTAV[]
                                     GR_VMSTA[]
                                     GR_MSTAE[]
                                     GR_MMSTA[]
                                     gv_filt                "TK01042009

*                                    GR_phmod[]             "TK01022008
*                                    GR_phnr[]              "TK01022008
*                                    gv_norm                "TK01022008
*                                    gv_incl                "TK01022008
*                                    gv_excl                "TK01022008
                            CHANGING &1
                                     GT_UNKNOWN_PARAMS[].
END-OF-DEFINITION.

*---------------------------------------------------------------------*
* Global ChangeFields
*---------------------------------------------------------------------*
TABLES: RJKSDWORKLIST_CHANGEFIELDS.
TYPES:  CHANGEFIELDS_TYPE          TYPE RJKSDWORKLIST_CHANGEFIELDS.

CONSTANTS: CON_SUBSCREEN_CHANGE  LIKE SY-DYNNR VALUE '9910',  " '0310',
           CON_PUBLDATE_SELECTED TYPE JKSELRULE VALUE 'D',
           CON_COPYNR_SELECTED   TYPE JKSELRULE VALUE 'C'.
CONSTANTS: CON_PROGRAM_CHANGE     TYPE SY-CPROG VALUE 'ZQTC_RJKSDWORKLIST'. "TK01022008
DATA: GV_CHANGE_DYNNR   LIKE SY-DYNNR VALUE CON_SUBSCREEN_CHANGE,
      GV_CHANGE_PROGRAM LIKE SY-CPROG VALUE CON_PROGRAM_CHANGE, "TK01022008
      GV_ACTIVETAB      LIKE SY-DYNNR,
      GV_SUBPROGRAM     LIKE SY-CPROG,
      GV_SUBSCREEN      LIKE SY-DYNNR.
DATA: LS_FILTERSH TYPE TJKSDV13FILTERSH.                    "TK01042009


*---------------------------------------------------------------------*
* Global List Fields
*---------------------------------------------------------------------*
CLASS ISM_WORKLIST_LIST DEFINITION DEFERRED.
DATA: GV_LIST      TYPE REF TO ISM_WORKLIST_LIST.
*     gv_viewer    TYPE REF TO cl_ism_sd_viewerdemandchange,
*     GV_DISPLAY   TYPE XANZEIGE.                        "TK08022007
CONSTANTS: CON_LIST_CONTAINER TYPE SCRFNAME VALUE 'LIST'.
*---------------------------------------------------------------------*
* Global Popup Fields
*---------------------------------------------------------------------*
DATA: BUTTON_SELECTED_ISSUES TYPE XFELD,
      BUTTON_ALL_ISSUES      TYPE FIELD.


*
*---------------------------------------------------------------------*
* Includes
*---------------------------------------------------------------------*
INCLUDE LJKSDVERSIONCON.
INCLUDE LJVPHCON.
INCLUDE ZQTCN_RJKSDWORKLIST_TOP1.             "Includiert im Update-Fuba !
INCLUDE RJKSDWORKLIST_SELECT.
INCLUDE ZQTCN_RJKSDWORKLIST_CLASS_LIST.
*INCLUDE RJKSDWORKLIST_CLASS_LIST.             "Includiert im Update-Fuba !
INCLUDE RJKSDWORKLIST_CLASS_HANDLER.
INCLUDE RJKSDWORKLIST_MODULE.
*INCLUDE ZQTC_RJKSDWORKLIST_MODULE.
INCLUDE ZQTCN_RJKSDWORKLIST_FORM.
*INCLUDE RJKSDWORKLIST_FORM.
INCLUDE ZQTCN_RJKSDWORKLIST_F_MAIN_DRK.
*INCLUDE RJKSDWORKLIST_FORM_MAIN_DARK.   "Includiert im Update-Fuba !
INCLUDE RJKSDWORKLIST_VARIANT.
*INCLUDE ZQTC_RJKSDWORKLIST_VARIANT.
*---------------------------------------------------------------------*
*       INIT                                                          *
*---------------------------------------------------------------------*
INITIALIZATION.
*
  PERFORM INIT CHANGING XAUTHORITY_OK.
*
  IF XAUTHORITY_OK IS INITIAL.
    IF GV_DISPLAY IS INITIAL.
      MESSAGE S003(JKSDWORKLIST).
    ELSE.
      MESSAGE S004(JKSDWORKLIST).
    ENDIF.
    STOP.   " => End of Selection
  ENDIF.

* Test------todo-----------------------------"TK01022008
AT SELECTION-SCREEN OUTPUT.
* break kast.  "Phasenselektion wird schalterabhängig ein/ausgeblendet
* ev. ist die Phasenselektion auch je Tranaktionsvariante customizebar?
* aktuell wird Phasenselektion wieder inaktiviert, also ausgeblendet
* (kann bei Bedarf wieder aktiviert werden!)

* Achtung: Bei Resizingfähiger Transaktion können Selektionen NICHT(!!)
*          ein/ausgeblendet werden!!!!
*
*
  IF GV_PEDEX2_ACTIVE IS INITIAL.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*GR_PHMOD*' OR
*       screen-name cp '*GR_PHNR*'  or
         SCREEN-NAME CP '*GV_NORM*'  OR
         SCREEN-NAME CP '*GV_INCL*'  OR
         SCREEN-NAME CP '*GV_EXCL*'  OR
         SCREEN-NAME CP '%B250*'     OR   "Rahmenelement
         SCREEN-NAME CP '%F251*'     OR   "text-251 auf Sel.Dynpro
         SCREEN-NAME CP '%F252*'     OR   "text-252 auf Sel.Dynpro
         SCREEN-NAME CP '%F260*'     .    "text-252 auf Sel.Dynpro
*
        SCREEN-ACTIVE = 0.
        SCREEN-INPUT = 0.
        SCREEN-OUTPUT = 0.
        MODIFY SCREEN.
*
      ENDIF.

      IF SCREEN-NAME CP '*GV_FILT*' OR
         SCREEN-NAME CP '%B350*'       .  "Rahmenelement
        SCREEN-ACTIVE = 0.
        SCREEN-INPUT = 0.
        SCREEN-OUTPUT = 0.
        MODIFY SCREEN.
*
      ENDIF.

    ENDLOOP.
  ENDIF.
* Test------todo-----------------------------"TK01022008

* Filter------------------------Anfang-------------------"TK01042009
AT SELECTION-SCREEN ON GV_FILT.
  IF NOT GV_FILT IS INITIAL.
    SELECT SINGLE * FROM TJKSDV13FILTERSH INTO LS_FILTERSH
      WHERE WL_TCODE_CHANGE = GS_TJKSD13A-WL_TCODE_CHANGE
      AND   FILTER_ID       = GV_FILT.
    IF   SY-SUBRC <> 0.
*       keine gültige FIlterkennung
      MESSAGE E067 WITH GV_FILT.
    ENDIF.
  ENDIF. " not gv_filt is initial.

*   die Tabelle TJKSD13A gelesen wird, wird immer der WL_TCODE_CHANGE gemommen,
*   auch in der DSIPLAY-Transaktiosnvariante.
*   Die Übergaben des TCODE an die Suchhilfe erfolgt per Patameter:
*   set parameter id 'JKSD13_F4_SH_TCODE' field gs_tjksd13a-wl_tcode_change.
*   Filter------------------------Ende---------------------"TK01042009
* endif.
*----Ende------------------------------------------- "TK01022008


*---------------------------------------------------------------------*
*       MAIN                                                          *
*---------------------------------------------------------------------*
END-OF-SELECTION.
  CHECK XAUTHORITY_OK = CON_ANGEKREUZT.
  CALL SCREEN 0101.
