FUNCTION zqtc_idoc_input_matmas01.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT_METHOD) LIKE  BDWFAP_PAR-INPUTMETHD
*"     VALUE(MASS_PROCESSING) LIKE  BDWFAP_PAR-MASS_PROC
*"     VALUE(NO_APPLICATION_LOG) LIKE  SY-DATAR OPTIONAL
*"     VALUE(MASSSAVEINFOS) LIKE  MASSSAVINF STRUCTURE  MASSSAVINF
*"       OPTIONAL
*"     VALUE(KZ_TEST) LIKE  MDAT1-KZ_TEST DEFAULT SPACE
*"     VALUE(ONLY_MAPPING) LIKE  MDAT1-KZ_TEST DEFAULT SPACE
*"     VALUE(KZ_MMCC) LIKE  SY-DATAR DEFAULT SPACE
*"  EXPORTING
*"     VALUE(WORKFLOW_RESULT) LIKE  BDWF_PARAM-RESULT
*"     VALUE(APPLICATION_VARIABLE) LIKE  BDWF_PARAM-APPL_VAR
*"     VALUE(IN_UPDATE_TASK) LIKE  BDWFAP_PAR-UPDATETASK
*"     VALUE(CALL_TRANSACTION_DONE) LIKE  BDWFAP_PAR-CALLTRANS
*"  TABLES
*"      IDOC_CONTRL STRUCTURE  EDIDC
*"      IDOC_DATA STRUCTURE  EDIDD
*"      IDOC_STATUS STRUCTURE  BDIDOCSTAT
*"      RETURN_VARIABLES STRUCTURE  BDWFRETVAR
*"      SERIALIZATION_INFO STRUCTURE  BDI_SER
*"  EXCEPTIONS
*"      WRONG_FUNCTION_CALLED
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_IDOC_INPUT_MATMAS01
* PROGRAM DESCRIPTION : This FM has been refered from standard
*                       Function Module “IDOC_INPUT_MATMAS01”
* Importing and exporting parameters as keep it as same as in IDOC_INPUT_MATMAS01
* Creating and Updating issues from JANIS
* The logic for creating the Media Issues is not standard, we are getting
* some of the field values from Source system (JANIS) whereas some of the field
* values will be determined within SAP (from an existing Media Issue called “Issue Template”).
* We have used the standard Basic Type: ISM_MATMAS03,
* created a custom Message Type ZQTC_ISM_MATMAS to process this FM.
* DEVELOPER           : Lucky Kodwani(LKODWANI)
* CREATION DATE       : 01/11/2017
* OBJECT ID           : I0344
* TRANSPORT NUMBER(S) : ED2K903907
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905820
* REFERENCE NO: C074
* DEVELOPER:Lucky Kodwani(LKODWANI)
* DATE: 05/09/2017
* DESCRIPTION: Defect ERP_1680
* C074A - XMAINIDCODE has X for two IDCODES which is incorrect
* Changes has done inside below change tags
* BOC:ADD:LKODWANI:06/05/2017:ED2K905820:Defect_ERP1680
* EOC:ADD:LKODWANI:06/05/2017:ED2K905820:Defect_ERP1680
* BOC:DEL:LKODWANI:06/05/2017:ED2K905820:Defect_ERP1680
* EOC:DEL:LKODWANI:06/05/2017:ED2K905820:Defect_ERP1680
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906487
* REFERENCE NO: C074
* DEVELOPER:Writtick Roy(WROY)
* DATE: 06/02/2017
* DESCRIPTION: Defect ERP_2571
* Add functionality for E1MARCISM and E1MVKEISM Segments
* Changes has done inside below change tags
* Begin of ADD:ERP-2571:WROY:02-JUN-2017:ED2K906487
* End   of ADD:ERP-2571:WROY:02-JUN-2017:ED2K906487
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  PBOM/RPDM-2077
* REFERENCE NO: ED2K924388
* DEVELOPER:    Sivareddy Guda (SGUDA)
* DATE:         08/24/2021
* DESCRIPTION:  Media Issue short text should update "EN" and "DE" languages
*----------------------------------------------------------------------*
* Local Type Declaration
  TYPES: BEGIN OF lty_counter,
           tranc TYPE transcount,  " Transaction counter for data transfer
           d_ind TYPE m_delind,    " Which number within a transaction must be reset?
         END OF lty_counter,

         BEGIN OF lty_idoc_matnr ,
           docnum TYPE edi_docnum, " IDoc number
           matnr  TYPE matnr,      " Material Number
         END   OF lty_idoc_matnr.

* Work Area Declaration
  DATA: lst_counter          TYPE lty_counter,
        lst_idoc_matnr       TYPE lty_idoc_matnr,
        lst_mpop_ueb         TYPE mpop_ueb,                 " Field TRANC Added to MPOP
        lst_mvke_ueb         TYPE mvke_ueb,                 " Field TRANC Added to MVKE
        lst_mara_ueb         TYPE mara_ueb,                 " Couple of Fields Added to MARA
        lst_makt_ueb         TYPE makt_ueb,                 " Field TRANC Added to MAKT
        lst_marc_ueb         TYPE marc_ueb,                 " Field TRANC Added to MARC
        lst_mara_tmp         TYPE zstqtc_media_issue_mara , " I0344: Media Issue - General Material Data from JANIS
        lst_makt_tmp         TYPE zstqtc_media_issue_makt , " I0344: Media Issue - Material Description from JANIS
        lst_marc_tmp         TYPE zstqtc_media_issue_marc , " I0344: Media Issue - Plant Data for Material from JANIS
        lst_mvke_tmp         TYPE zstqtc_media_issue_mvke , " I0344: Media Issue - Sales Data for Material from JANIS
        lst_idcdassign       TYPE e1idcdassignism,          " IS-M: Assignment of ID Codes to Media Product Master
        lst_idoc_tranc       TYPE matidoctranc,             " Int. Structure: Assignment of IDoc Number - 1st Transaction
        lst_mara             TYPE mara_ueb,                 " Couple of Fields Added to MARA
        lst_makt             TYPE makt_ueb,                 " Field TRANC Added to MAKT
        lst_marc             TYPE marc_ueb,                 " Field TRANC Added to MARC
        lst_mvke             TYPE mvke_ueb,                 " Field TRANC Added to MVKE
        lst_merrdat          TYPE merrdat,                  " DI: Structure for Returning Error Messages

* Internal Table Declaration
        li_idoc_matnr        TYPE STANDARD TABLE OF lty_idoc_matnr INITIAL SIZE 0,
        li_mara_ueb          TYPE STANDARD TABLE OF mara_ueb INITIAL SIZE 0,     " Couple of Fields Added to MARA
        li_makt_ueb          TYPE STANDARD TABLE OF makt_ueb INITIAL SIZE 0,     " Field TRANC Added to MAKT
        li_marc_ueb          TYPE STANDARD TABLE OF marc_ueb INITIAL SIZE 0,     " Field TRANC Added to MARC
        li_mard_ueb          TYPE STANDARD TABLE OF mard_ueb INITIAL SIZE 0,     " Field TRANC Added to MARD
        li_mvke_ueb          TYPE STANDARD TABLE OF mvke_ueb INITIAL SIZE 0,     " Field TRANC Added to MVKE
        li_mpop_ueb          TYPE STANDARD TABLE OF mpop_ueb INITIAL SIZE 0,     " Field TRANC Added to MPOP
        li_mfieldres         TYPE STANDARD TABLE OF mfieldres INITIAL SIZE 0,    " BI (New): Fields That Must Be Initialized for Each Transact.
        li_merrdat           TYPE STANDARD TABLE OF merrdat   INITIAL SIZE 0,    " DI: Structure for Returning Error Messages
        li_edidd             TYPE STANDARD TABLE OF edidd INITIAL SIZE 0 ,       " Data record (IDoc)
        li_idoc_tranc        TYPE STANDARD TABLE OF matidoctranc INITIAL SIZE 0, " Int. Structure: Assignment of IDoc Number - 1st Transaction
        li_merrdat_tt        TYPE merrdat_tt,
        li_idcd_tmp          TYPE ztqtc_media_issue_idcd,
*     Begin of ADD:PBOM/RPDM-2077:SGUDA:24-AUG-2021:ED2K924388
        lst_headdata         TYPE  bapie1matheader,
        li_headdata          TYPE STANDARD TABLE OF bapie1matheader INITIAL SIZE 0,
        li_bapie1makt        TYPE STANDARD TABLE OF bapie1makt,
        lst_bapie1makt       TYPE bapie1makt,
        lst_return1          TYPE bapiret2,
        li_return            TYPE STANDARD TABLE OF bapie1ret2,
*     End of ADD:PBOM/RPDM-2077:SGUDA:24-AUG-2021:ED2K924388
* Local Variable Declarations
        lv_flag_mass         TYPE flag,       " General Flag
        lv_max_errors        TYPE anzum,      " Maximum number of incorrect material master records
        lv_change_doc_tcode  TYPE char10,     " Change_doc_tcode of type CHAR10
        lv_marc_tabix        TYPE syst_tabix, "ANI OIL
        lv_application_subrc TYPE syst_subrc, " ABAP System Field: Return Code of ABAP Statements
        lv_mara_ueb_vpsta    TYPE vpsta,      " Maintenance status of complete material
        lv_current_tabix     TYPE syst_tabix, " ABAP System Field: Row Index of Internal Tables
        lv_first_trnac       TYPE transcount, " Transaction counter for data transfer
        lv_mtart             TYPE mtart,      " Material Type
        lv_first_trnac_index TYPE syst_tabix, " Index zu first_tranc
        lv_help_tranc        TYPE transcount, " Transaction counter for data transfer
        lv_general_subrc     TYPE syst_subrc, " ABAP System Field: Return Code of ABAP Statements
        lv_last_marc_tranc   TYPE transcount, " Transaction counter for data transfer
        lv_muss_pruefen      TYPE syst_datar, " ABAP System Field: Highlighted Input in Dynpro Field
        lv_init_tranc        TYPE transcount, " Transaction counter for data transfer
        lv_error             TYPE flag.       " General Flag

  CONSTANTS : lc_ism_matmas03    TYPE edi_idoctp VALUE 'ISM_MATMAS03',    " Basic type
              lc_ism_matmas      TYPE edi_mestyp VALUE 'ZQTC_ISM_MATMAS', " Message Type
              lc_e1maram         TYPE edilsegtyp VALUE 'E1MARAM',         " Segment type
              lc_e1maraism       TYPE edilsegtyp VALUE 'E1MARAISM',       " Segment type
              lc_e1jptmaraism    TYPE edilsegtyp VALUE 'E1JPTMARAISM',    " Segment type
              lc_e1idcdassignism TYPE edilsegtyp VALUE 'E1IDCDASSIGNISM', " Segment type
              lc_e1maktm         TYPE edilsegtyp VALUE 'E1MAKTM',         " Segment type
              lc_e1marcm         TYPE edilsegtyp VALUE 'E1MARCM',         " Segment type
*             Begin of ADD:ERP-2571:WROY:02-JUN-2017:ED2K906487
              lc_e1marcism       TYPE edilsegtyp VALUE 'E1MARCISM',       " Segment type
              lc_e1mvkeism       TYPE edilsegtyp VALUE 'E1MVKEISM',       " Segment type
*             End   of ADD:ERP-2571:WROY:02-JUN-2017:ED2K906487
              lc_e1mvkem         TYPE edilsegtyp VALUE 'E1MVKEM',         " Segment type
              lc_e1mpopm         TYPE edilsegtyp VALUE 'E1MPOPM',         " Segment type
              lc_mal1_tcode      TYPE tcode      VALUE 'MAL1'     ,       " Transaction Code
              lc_sapmm03m        TYPE programm   VALUE 'SAPMM03M',        " ABAP Program Name
              lc_mass            TYPE char10     VALUE '(MASS)',          " Mass of type CHAR10
              lc_mmcc            TYPE char10     VALUE '(MMCC)',          " Mmcc of type CHAR10
              lc_call_mode_ale   TYPE mmd_c_mode VALUE 'ALE',             " Call type for material maintenance in the background
              lc_ale             TYPE char10     VALUE '(ALE)'.           " Ale of type CHAR10

  " Call type for material maintenance in the background

*=========BADI IDOC verbuchen===========================================
  CLASS cl_exithandler DEFINITION LOAD. " Class for Ext. Services Within Framework of Exit Technique
  STATICS: lf_exit        TYPE REF TO if_ex_badi_matmas_ale_in. " BAdI Interface IF_EX_BADI_MATMAS_ALE_IN
  STATICS: lf_exit_akt    TYPE char1 VALUE ' '. " Exit_akt(1) of type Character

  IF NOT masssaveinfos-run IS INITIAL.
    lv_flag_mass = abap_true.
  ELSE. " ELSE -> IF NOT masssaveinfos-run IS INITIAL
    CLEAR lv_flag_mass.
  ENDIF. " IF NOT masssaveinfos-run IS INITIAL

  lst_counter-tranc = 1.
  lst_counter-d_ind = 1.

* Initialize data - general
  REFRESH: li_mfieldres,
           li_idoc_tranc,
           li_idoc_matnr,
           li_mara_ueb,
           li_makt_ueb,
           li_marc_ueb,
           li_mpop_ueb,
           li_mvke_ueb,
           idoc_status[],
           li_merrdat.

  CLEAR : lv_application_subrc.

  CALL FUNCTION 'MGV_ALE_ADD_INTERNAL_MATNR'
    TABLES
      idoc_data       = idoc_data
      idoc_contrl     = idoc_contrl
    EXCEPTIONS
      number_mismatch = 1
      OTHERS          = 2.
  IF sy-subrc IS NOT INITIAL.
* Do Nothing
  ENDIF. " IF sy-subrc IS NOT INITIAL

  IF  idoc_contrl-idoctp <> lc_ism_matmas03
    OR idoc_contrl-mestyp <>  lc_ism_matmas.
    RAISE wrong_function_called.
  ENDIF. " IF idoc_contrl-idoctp <> lc_ism_matmas03

* Fill Data from IDOC into internal material tables
* the master data tables are filled as follows:
*   first: it is tried to create the material
*   immediately afterwards: it is tried to change the material
* ----------------------------------------------------------------------
  LOOP AT idoc_contrl.
*   Initialize data - per IDOC
    lst_idoc_tranc-docnum = idoc_contrl-docnum.
    lst_idoc_tranc-first_tranc_idoc = lst_counter-tranc .
    APPEND lst_idoc_tranc  TO li_idoc_tranc.

*   Select segments which belong to IDOC
    REFRESH li_edidd.
    LOOP AT idoc_data WHERE docnum = idoc_contrl-docnum.
      APPEND idoc_data TO li_edidd.
    ENDLOOP. " LOOP AT idoc_data WHERE docnum = idoc_contrl-docnum

*    BUSINESS TRANSACTION EVENT (header / data)         "note0388000
    CALL FUNCTION 'OPEN_FI_PERFORM_MGV00200_E' "note0388000
      EXPORTING                                "note0388000
        idoc_header       = idoc_contrl        "note0388000
        flg_append_status = abap_true          "note0388000
      TABLES                                   "note0388000
        idoc_data         = li_edidd           "note0418561
        idoc_status       = idoc_status        "note0388000
      EXCEPTIONS                               "note0388000
        OTHERS            = 1.                 "note0388000
    IF sy-subrc = 1. "note0388000
*      note 1075735: implement correct error handling as documented
*      in example function module SAMPLE_INTERFACE_MGV00200
*       continue.                                       "note0388000
      lv_application_subrc = sy-subrc.
      PERFORM handle_error_bte IN PROGRAM saplmv02 IF FOUND
                  TABLES
                     idoc_contrl
                     idoc_status
                     return_variables
                  USING
                     lv_application_subrc
                  CHANGING
                     workflow_result.
      EXIT.
    ENDIF. " IF sy-subrc = 1
*   Within one IDOC: loop through data segments:
*   Prepare internal tables for the current material
    LOOP AT li_edidd INTO idoc_data.
      lv_current_tabix = sy-tabix.
      lst_counter-d_ind = lst_counter-d_ind + 1.
*      lst_counter-tranc = lst_counter-tranc + 2.

      CASE idoc_data-segnam.

        WHEN lc_e1maram .
          lst_counter-d_ind = 1.
          lv_first_trnac = lst_counter-tranc.
*         interpret segment
          e1maram = idoc_data-sdata.
          TRANSLATE e1maram-matnr TO UPPER CASE.         "#EC TRANSLANG

          PERFORM e1maram_nodata_find IN PROGRAM saplmv02 TABLES li_mfieldres
                                                         USING e1maram
                                                               lst_counter-tranc
                                                               lst_counter-d_ind.
          CLEAR lst_mara_ueb. "note 934416
          MOVE-CORRESPONDING e1maram TO lst_mara_ueb.
          lv_mtart = lst_mara_ueb-mtart.
          lst_idoc_matnr-docnum = idoc_contrl-docnum.
          lst_idoc_matnr-matnr  = lst_mara_ueb-matnr.
          APPEND lst_idoc_matnr TO li_idoc_matnr.
*         Convert unit of measures
          IF lv_flag_mass IS INITIAL.
            PERFORM e1maram_unit_iso_sap IN PROGRAM  saplmv02 USING    e1maram
                                                              CHANGING lst_mara_ueb.
          ENDIF. " IF lv_flag_mass IS INITIAL

          CALL FUNCTION '/SAPMP/MV02_MARA_UEB'
            EXPORTING
              im_edidd          = li_edidd[]
              im_transcount     = lst_counter-tranc
              im_delind         = lst_counter-d_ind
              im_msgfn          = e1maram-msgfn
              im_current_tx     = lv_current_tabix
            CHANGING
              ch_mara_ueb       = lst_mara_ueb
              ch_mfieldres      = li_mfieldres
            EXCEPTIONS
              application_error = 1
              OTHERS            = 2.
          IF sy-subrc NE 0.
            lv_application_subrc = sy-subrc.
            PERFORM handle_error IN PROGRAM saplmv02
                          TABLES
                             idoc_contrl
                             idoc_status
                             return_variables
                             li_merrdat
                             li_idoc_matnr
                          USING
                             lv_application_subrc
                          CHANGING
                             workflow_result.
            EXIT.
          ENDIF. " IF sy-subrc NE 0

*         Add some technical parameters + append data
          lst_mara_ueb-mandt = sy-mandt.
          lst_mara_ueb-tcode = lc_mal1_tcode. "General...
          lst_mara_ueb-tranc = lst_counter-tranc.
          lst_mara_ueb-d_ind = lst_counter-d_ind.
          APPEND lst_mara_ueb TO li_mara_ueb.
          lv_first_trnac_index = sy-tabix.

        WHEN lc_e1maraism.
          CALL FUNCTION 'ISM_IDOC_E1MARAISM_NODATA_FIND'
            EXPORTING
              ps_i_sdata     = idoc_data-sdata
              pv_i_tranc     = lv_first_trnac
              pv_i_d_ind     = lst_counter-d_ind
            TABLES
              pt_c_mfieldres = li_mfieldres
              pt_c_mara_ueb  = li_mara_ueb
            CHANGING
              ps_c_mara_ueb  = lst_mara_ueb.

          lv_first_trnac_index = sy-tabix.
        WHEN lc_e1jptmaraism.
          CALL FUNCTION 'ISM_IDOC_E1JPTMARA_NODATA_FIND'
            EXPORTING
              ps_i_sdata     = idoc_data-sdata
              ps_i_mara_ueb  = lst_mara_ueb
              pv_i_mestyp    = idoc_contrl-mestyp
            TABLES
              pt_c_mfieldres = li_mfieldres.

        WHEN lc_e1idcdassignism.
          CALL FUNCTION 'ISM_IDOC_E1IDCODES_NODATA_FIND'
            EXPORTING
              ps_i_sdata     = idoc_data-sdata
              ps_i_mara_ueb  = lst_mara_ueb
              pv_i_mestyp    = idoc_contrl-mestyp
            TABLES
              pt_c_mfieldres = li_mfieldres.

          lst_idcdassign = idoc_data-sdata.

          APPEND INITIAL LINE TO li_idcd_tmp ASSIGNING FIELD-SYMBOL(<lst_idcd_tmp>).
          MOVE-CORRESPONDING lst_idcdassign TO <lst_idcd_tmp>.
          UNASSIGN: <lst_idcd_tmp>.
          CLEAR: lst_idcdassign.

        WHEN lc_e1maktm.
          CLEAR lv_general_subrc.
          e1maktm = idoc_data-sdata.
          MOVE-CORRESPONDING e1maktm TO lst_makt_ueb. " //br240497
          lst_makt_ueb-matnr = lst_mara_ueb-matnr. " zu 3.1H
          lst_makt_ueb-mandt = sy-mandt.
          lst_makt_ueb-tranc = lv_first_trnac.
          lst_makt_ueb-d_ind = lst_counter-d_ind.
          APPEND lst_makt_ueb TO li_makt_ueb. " 3.1H
        WHEN lc_e1marcm.
*         Tranc = first tranc of material, if already used for MARC
*         then take new tranc + add MARA-Data
* skip first tranc so that correct maintaince status can be set for each
* plant
*         Add segment
          e1marcm = idoc_data-sdata.
          PERFORM e1marcm_nodata_find IN PROGRAM saplmv02
                                      TABLES li_mfieldres
                                      USING  e1marcm
                                             lst_counter-tranc
                                             lst_counter-d_ind.

          CLEAR lst_marc_ueb. "note 934416
          MOVE-CORRESPONDING e1marcm TO lst_marc_ueb.
* note 1943214
*         .....Add MARA to new tranc
          lst_mara_ueb-tranc = lst_counter-tranc.
          lst_mara_ueb-d_ind = lst_counter-d_ind.
          lv_mara_ueb_vpsta = lst_mara_ueb-vpsta.
          IF lst_marc_ueb-pstat IS NOT INITIAL.
            lst_mara_ueb-vpsta = lst_marc_ueb-pstat.
* note 2115458
            CALL FUNCTION 'VEREINIGUNG'
              EXPORTING
                status_in1 = lst_mara_ueb-pstat
                status_in2 = lst_marc_ueb-pstat
              IMPORTING
                status_out = lst_mara_ueb-pstat.
          ENDIF. " IF lst_marc_ueb-pstat IS NOT INITIAL
          APPEND lst_mara_ueb TO li_mara_ueb.

          lst_mara_ueb-vpsta = lv_mara_ueb_vpsta.
          lv_help_tranc         = lst_counter-tranc.
          lst_marc_ueb-mandt = sy-mandt.
          lst_marc_ueb-matnr = lst_mara_ueb-matnr.

          IF lv_flag_mass IS INITIAL. "note 1606371
            PERFORM e1marcm_unit_iso_sap IN PROGRAM saplmv02 IF FOUND
                                         USING    e1marcm " //br4.0
                                         CHANGING lst_marc_ueb. "
          ENDIF. " IF lv_flag_mass IS INITIAL

* IS-MP - modification - C5007732
          CALL FUNCTION '/SAPMP/MV02_MARC_UEB'
            EXPORTING
              im_edidd          = li_edidd
              im_transcount     = lv_help_tranc
              im_delind         = lst_counter-d_ind
              im_msgfn          = e1marcm-msgfn
              im_current_tx     = lv_current_tabix
            CHANGING
              ch_marc_ueb       = lst_marc_ueb
              ch_mfieldres      = li_mfieldres
            EXCEPTIONS
              application_error = 1
              OTHERS            = 2.
          IF sy-subrc NE 0.
            lv_application_subrc = sy-subrc.
            PERFORM handle_error IN PROGRAM saplmv02 IF FOUND
                          TABLES
                             idoc_contrl
                             idoc_status
                             return_variables
                             li_merrdat
                             li_idoc_matnr
                          USING
                             lv_application_subrc
                          CHANGING
                             workflow_result.
            EXIT.
          ENDIF. " IF sy-subrc NE 0
*         Add some technical parameters + append data
          lst_marc_ueb-tranc = lv_help_tranc.
          lst_marc_ueb-d_ind = lst_counter-d_ind.
          APPEND lst_marc_ueb TO li_marc_ueb.
          lv_marc_tabix = sy-tabix.
*         Store tranc information in lv_last_marc_tranc
*       Begin of ADD:ERP-2571:WROY:02-JUN-2017:ED2K906487
        WHEN lc_e1marcism.
          CALL FUNCTION 'ISM_IDOC_E1MARCISM_NODATA_FIND'
            EXPORTING
              ps_i_sdata     = idoc_data-sdata
              pv_i_tranc     = lv_first_trnac
              pv_i_d_ind     = lst_counter-d_ind
            TABLES
              pt_c_mfieldres = li_mfieldres
              pt_c_marc_ueb  = li_marc_ueb
            CHANGING
              ps_c_marc_ueb  = lst_marc_ueb.

          lv_first_trnac_index = sy-tabix.
*       End   of ADD:ERP-2571:WROY:02-JUN-2017:ED2K906487
        WHEN lc_e1mvkem. "-----------------------------------------------
*         Tranc = first tranc without MVKE data
          CLEAR lv_help_tranc.
          IF lv_help_tranc IS INITIAL.
            lv_help_tranc = lst_counter-tranc.
*           .....Add MARA to new tranc
            lst_mara_ueb-tranc = lst_counter-tranc.
            lst_mara_ueb-d_ind = lst_counter-d_ind.
            APPEND lst_mara_ueb TO li_mara_ueb.
          ENDIF. " IF lv_help_tranc IS INITIAL
*         add segment to block
          e1mvkem = idoc_data-sdata.
          PERFORM e1mvkem_nodata_find IN PROGRAM saplmv02  IF FOUND
                                      TABLES li_mfieldres
                                      USING  e1mvkem
                                             lv_help_tranc
                                             lst_counter-d_ind.
          CLEAR lst_mvke_ueb. "note 934416
          MOVE-CORRESPONDING e1mvkem TO lst_mvke_ueb.
          lst_mvke_ueb-mandt = sy-mandt.
          lst_mvke_ueb-matnr = lst_mara_ueb-matnr.
*         convert unit of measures                           "//br4.0
          IF lv_flag_mass IS INITIAL. "note 1606371
            PERFORM e1mvkem_unit_iso_sap IN PROGRAM saplmv02 USING    e1mvkem     "
                                         CHANGING lst_mvke_ueb. "
          ENDIF. " IF lv_flag_mass IS INITIAL

*         Add some technical parameters + append data
          lst_mvke_ueb-tranc = lv_help_tranc.
          lst_mvke_ueb-d_ind = lst_counter-d_ind.
          APPEND lst_mvke_ueb TO li_mvke_ueb.
*         find out land for current sales organisation (tax assignment)
*         perform fill_vkorg_aland using lst_mvke_ueb-vkorg.
*       Begin of ADD:ERP-2571:WROY:02-JUN-2017:ED2K906487
        WHEN lc_e1mvkeism.
          CALL FUNCTION 'ISM_IDOC_E1MVKEISM_NODATA_FIND'
            EXPORTING
              ps_i_sdata     = idoc_data-sdata
              pv_i_tranc     = lv_first_trnac_index
              pv_i_d_ind     = lst_counter-d_ind
            TABLES
              pt_c_mfieldres = li_mfieldres
              pt_c_mvke_ueb  = li_mvke_ueb
            CHANGING
              ps_c_mvke_ueb  = lst_mvke_ueb.

          lv_first_trnac_index = sy-tabix.
*       End   of ADD:ERP-2571:WROY:02-JUN-2017:ED2K906487
        WHEN lc_e1mpopm.

          lv_help_tranc = lv_last_marc_tranc.
*         add segment
          e1mpopm = idoc_data-sdata.
          PERFORM e1mpopm_nodata_find IN PROGRAM saplmv02 IF FOUND
                                      TABLES li_mfieldres
                                      USING  e1mpopm
                                             lv_help_tranc
                                             lst_counter-d_ind.
          CLEAR lst_mpop_ueb. "note 934416
          MOVE-CORRESPONDING e1mpopm TO lst_mpop_ueb.
          lst_mpop_ueb-mandt = sy-mandt.
          lst_mpop_ueb-matnr = lst_mara_ueb-matnr.
          lst_mpop_ueb-werks = lst_marc_ueb-werks.

*         Add some technical parameters + append data
          lst_mpop_ueb-tranc = lv_help_tranc.
          lst_mpop_ueb-d_ind = lst_counter-d_ind.
          APPEND lst_mpop_ueb TO li_mpop_ueb.
      ENDCASE.
*      clear lst_counter-tranc.
    ENDLOOP. " LOOP AT li_edidd INTO idoc_data
    IF lv_application_subrc NE 0.
      EXIT.
    ENDIF. " IF lv_application_subrc NE 0

* BOC:ADD:LKODWANI:06/05/2017:ED2K905820:Defect_ERP1680
    READ TABLE li_mara_ueb INTO lst_mara INDEX 1.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING lst_mara TO lst_mara_tmp .
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE li_makt_ueb INTO lst_makt INDEX 1.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING lst_makt TO lst_makt_tmp .
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE li_marc_ueb INTO lst_marc INDEX 1.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING lst_marc TO lst_marc_tmp .
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE li_mvke_ueb INTO lst_mvke INDEX 1.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING lst_mvke TO lst_mvke_tmp .
    ENDIF. " IF sy-subrc EQ 0

    CALL FUNCTION 'ZQTC_CREATE_UPDATE_MEDIA_ISSUE'
      EXPORTING
        im_med_issue_mara      = lst_mara_tmp
        im_med_issue_makt      = lst_makt_tmp
        im_med_issue_marc      = lst_marc_tmp
        im_med_issue_mvke      = lst_mvke_tmp
        im_med_issue_idcd      = li_idcd_tmp
      IMPORTING
        ex_is_error            = lv_error
        ex_message_tab         = li_merrdat_tt
      EXCEPTIONS
        exc_med_prod_invalid   = 1
        exc_med_prod_locked    = 2
        exc_temp_issue_missing = 3
        OTHERS                 = 4.
    IF sy-subrc EQ 0.
* Begin of ADD:PBOM/RPDM-2077:SGUDA:24-AUG-2021:ED2K924388
      CLEAR : li_bapie1makt[],li_headdata[],li_return[],lst_return1.
* To Populate Media Issue Texts in all languages
      LOOP AT li_makt_ueb INTO lst_makt.
        lst_bapie1makt-material = lst_makt-matnr.
        lst_bapie1makt-langu = lst_makt-spras.
        lst_bapie1makt-matl_desc = lst_makt-maktx.
        APPEND  lst_bapie1makt  TO li_bapie1makt.
        CLEAR:lst_bapie1makt,lst_makt.
      ENDLOOP.
      lst_headdata-material   = lst_mara_tmp-matnr.
      lst_headdata-basic_view = abap_true.
      APPEND lst_headdata TO li_headdata.
      CALL FUNCTION 'BAPI_MATERIAL_SAVEREPLICA'
        EXPORTING
          noappllog           = abap_true
          nochangedoc         = space
          testrun             = space
          inpfldcheck         = space
        IMPORTING
          return              = lst_return1
        TABLES
          headdata            = li_headdata
          materialdescription = li_bapie1makt
          returnmessages      = li_return.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
      ENDIF.
*  End of ADD:PBOM/RPDM-2077:SGUDA:24-AUG-2021:ED2K924388
*   Include some of the messages those were missing in the Application log
      lst_merrdat-tranc = lv_init_tranc + 1.
      MODIFY li_merrdat_tt FROM lst_merrdat TRANSPORTING tranc
       WHERE tranc EQ lv_init_tranc.

      CLEAR: lv_general_subrc.
      SORT li_merrdat_tt BY tranc.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      lv_general_subrc = sy-subrc..
    ENDIF. " IF sy-subrc EQ 0

    PERFORM handle_error_ext IN PROGRAM saplmv02 IF FOUND " //br40
                                    TABLES                                        "
                                       idoc_contrl                                "
                                       idoc_status                                "
                                       return_variables                           "
                                       li_merrdat_tt                                "
                                       li_idoc_tranc                               "
                                       li_idoc_matnr      "JH/4.0C/KPr100004993
                                    USING
                                       kz_test                                    "
                                       lv_general_subrc                              "
                                       no_application_log                         "
                                       masssaveinfos      "wk/40c
                                    CHANGING                                      "
                                       workflow_result.

    CLEAR: li_mara_ueb,
          li_makt_ueb,
          li_mpop_ueb,
          li_marc_ueb,
          li_mvke_ueb,
          li_idcd_tmp,
          li_idoc_tranc,
          li_idoc_matnr,
          idoc_status,
          li_merrdat_tt,
          lst_makt_tmp.
* EOC:ADD:LKODWANI:06/05/2017:ED2K905820:Defect_ERP1680
  ENDLOOP. " LOOP AT idoc_contrl

  IF lv_application_subrc NE 0.
    RETURN. " ZQTC_IDOC_INPUT_MATMAS01
  ENDIF. " IF lv_application_subrc NE 0
  CLEAR lv_help_tranc.


ENDFUNCTION.
