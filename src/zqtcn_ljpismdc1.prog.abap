***********************************************************************
* Name     : ljpismdc1                                                *
* Issue    : 10/28/1999 - jw    . - SAP AG, IBU Media                 *
*                                                                     *
* Purpose  : General constants declaration for                        *
*            media product master data                                *
*                                                                     *
* Changes  :                                                          *
* [ Date ] - [ Name    ] - [ Action                    ]              *
* 09/30/02 -  yng        -  new hierarchy level title                 *
************************************************************************
*----------------------------------------------------------------------*
*   INCLUDE LJPISMDC1                                                  *
*----------------------------------------------------------------------*
* constants for media level
  constants: con_lvl_med_fam     like mara-ismhierarchlevl    value '1'
           , con_lvl_med_prod    like mara-ismhierarchlevl    value '2'
           , con_lvl_med_iss     like mara-ismhierarchlevl    value '3'
           , con_lvl_med_adins   like mara-ismhierarchlevl    value 'S'
           , con_lvl_title       like mara-ismhierarchlevl    value 'T'
           .

* cosntants for media transaction codes
  constants: con_med_browser         like sy-tcode value 'JP20',

             con_med_fam_create      like sy-tcode value 'JP21',
             con_med_fam_change      like sy-tcode value 'JP22',
             con_med_fam_display     like sy-tcode value 'JP23',

             con_med_prod_create     like sy-tcode value 'JP24',
             con_med_prod_change     like sy-tcode value 'JP25',
             con_med_prod_display    like sy-tcode value 'JP26',

             con_med_issue_create    like sy-tcode value 'JP27',
             con_med_issue_change    like sy-tcode value 'JP28',
             con_med_issue_display   like sy-tcode value 'JP29',

             con_med_adins_create    like sy-tcode value 'JPS1',
             con_med_adins_change    like sy-tcode value 'JPS2',
             con_med_adins_display   like sy-tcode value 'JPS3',

             con_title_create        like sy-tcode value 'JP01',
             con_title_change        like sy-tcode value 'JP02',
             con_title_display       like sy-tcode value 'JP03',

             con_deliv_sequ_change   like sy-tcode value 'JPMG0',
             con_deliv_sequ_display  like sy-tcode value 'JPMG1',

             con_pmd_create_from_wbs like sy-tcode value 'JPC1',
             con_pmd_create_from_ar  like sy-tcode value 'JPC4',

             con_prot_jpwbsmpcopy    like sy-tcode value 'JPC3',
             con_prot_jparmpcopy     like sy-tcode value 'JPC6'.

* constants for (internal) periode type
  constants:
            con_pertyp_date     type c                       value '1'
          , con_pertyp_week     type c                       value '2'
          , con_pertyp_month    type c                       value '3'
          , con_pertyp_year     type c                       value '4'
          .

* constants for memory IDs
  constants:
* structure MARA
            con_memoryid_ismmaramem(10)    type c  value 'ISMMARAMEM'
* structure MAKT
          , con_memoryid_ismmaktmem(10)    type c  value 'ISMMAKTMEM'
* id code
          , com_memoryid_ismidcdmem(10)    type c  value 'ISMIDCDMEM'
* jptmara
          , con_memoryid_ismjptmaramem(12) type c  value 'ISMJPMARAMEM'

* Flag maintain material new call
* (otherwise no initialization of variables)
          , con_memoryid_new_call(30) type c
                                value 'ISM_PMD_MATERIAL_NEW_CALL'
* called by delivery sequence
          , con_memoryid_ism_delivseq_call(30) type c
                                value 'ISMDELSEQUCALL'
* call from sequence (incl Flag XCHRON_PROCESSES      "TK06112003
          , con_memoryid_ism_chron_process(30) type c "TK06112003
                      value 'ISMDELSEQCHRONPROCESSES' "TK06112003
* call from browser
          , con_memoryid_browser_call(30) type c
                                value 'ISM_BROWSER_CALL'
          .

* constant for extent unit page
  constants:
            con_extent_unit_page  like  mara-ismextentunit value 'SE '.

* constants for fieldmodification and extracting data
  constants:
    con_mara(4)         type c      value 'MARA',
    con_jptmara(7)      type c      value 'JPTMARA',
    con_marc(4)         type c      value 'MARC',
    con_mvke(4)         type c      value 'MVKE',
    con_mara_ism(8)     type c      value 'MARA-ISM',
    con_mara_spart(10)  type c      value 'MARA-SPART',
    con_rjpmat01(8)     type c      value 'RJPMAT01',
    con_psi(5)          type c      value 'PS_I_',
    con_ism(3)          type c      value 'ISM',
    con_tree_tab(13)    type c      value 'RJP_TREE_DATA',
    con_separator_minus type c      value '-'.

* constants for tree ok-codes
  constants:
    con_tree_ucomm_display        like sy-ucomm value 'ISM_DISPLAY',
    con_tree_ucomm_create         like sy-ucomm value 'ISM_CREATE',
    con_tree_ucomm_extend         like sy-ucomm value 'ISM_EXTEND',
    con_tree_ucomm_create_fam     like sy-ucomm value 'ISM_CREATE_FAM',
    con_tree_ucomm_create_prod    like sy-ucomm value 'ISM_CREATE_PROD',
    con_tree_ucomm_change         like sy-ucomm value 'ISM_CHANGE',
    con_tree_ucomm_iss_sel        like sy-ucomm value 'ISS_SEQ',
    con_tree_ucomm_add_data       like sy-ucomm value 'ADD_DATA',
    con_tree_ucomm_displ_add_data like sy-ucomm value 'DIS_ADD_DT',
    con_tree_ucomm_sel_show       like sy-ucomm value 'SEL_SHOW'.

* praefix for media tree handling
  constants:

*   prefix of tree control
    con_tree_prefix_fcode    like sy-ucomm  value '%_GC',
*   dummy node for products without link to media product family
    con_dummy_prod(10)       type c         value '$$$$$$$$DP',
*   dummy_node for issues without linkt to media product
    con_dummy_issue(10)      type c         value '$$$$$$$$DI',
*   dummy node for issues and product without links
    con_dummy_prod_iss(10)   type c         value '$$$$$$DPDI',
*   save mode for layout variants
    con_save_all             type c         value 'A',
*   screen-group4 at issue sequence
    con_isq(3)               type c         value 'ISQ',
*   screen-group4 for additonal data
    con_add(3)               type c         value 'ADD',
*   program
    con_tree_prog            like sy-repid  value 'SAPMJPTREE',
*   initial / start screen
    con_screen_start         like  sy-dynnr value '0100',
*   browser screen
    con_screen_tree_result   like  sy-dynnr value '0200',
*   screen with issue sequence data
    con_screen_iss_seq       like  sy-dynnr value '0301',
*   screen with issue sequence selection data
    con_screen_iss_seq_sel   like  sy-dynnr value '0501',
*   screen with issue sequence selection data
    con_screen_issue_sel   like  sy-dynnr value '0502',
*   additional selection criteria
    con_screen_add_sel       like sy-dynnr  value '0302',
*   extended selection
    con_screen_ext_selection like sy-dynnr  value '0303',
*   Selektionsbild Folge
    con_screen_sel_sequence  like sy-dynnr  value '0310',
*   Selektionsbild Medienausgaben
    con_screen_sel_issues    like sy-dynnr  value '0311',
*   main screen issue sequence
    con_screen_main_iss_seq  like sy-dynnr  value '0401',
*   main screen additional data
    con_screen_main_add_data like sy-dynnr  value '0402',
*   selection object issue sequence
    con_iss_seq              like screen-name value 'ISS_SEQ_SELOBJ',
*   icon for issue sequence
    con_iss_seq_icon         like rjp_tree_control-iss_seq_icon
                                              value 'ISS_SEQ_ICON'.

* constants for general ok_code handling
  constants:
    con_ucomm_back      like sy-ucomm value 'BACK',
    con_ucomm_cancel    like sy-ucomm value 'ESC',
    con_ucomm_execute   like sy-ucomm value 'EXECUTE',
    con_ucomm_free_sel  like sy-ucomm value 'FREE_SEL',
    con_ucomm_end       like sy-ucomm value 'END ',
    con_ucomm_ok        like sy-ucomm value 'OK',
    con_ucomm_next      like sy-ucomm value 'NEXT',
    con_ucomm_enter     like sy-ucomm value 'ENTER',
    con_ucomm_ranges    like sy-ucomm value 'RANGES'.

* constants for popup to confirm
  constants:
    con_popup_yes        type c value 'J',
    con_popup_no         type c value 'N',
    con_popup_esc        type c value 'A'.

* constants for idoc
  constants:
    con_ls(3)            type c                value 'LS_',
    con_segment_mara     type edidd-segnam     value 'E1MARAISM',
    con_segment_jptmara  type edidd-segnam     value 'E1JPTMARAISM',
    con_segment_marc     type edidd-segnam     value 'E1MARCISM',
    con_segment_mvke     type edidd-segnam     value 'E1MVKEISM',
    con_segment_idcode   type edidd-segnam     value 'E1IDCDASSIGNISM',
    con_segment_bupa     type edidd-segnam     value 'E1BPASSIGNISM',
    con_idoc_type_ism    type edidc-idoctp     value 'ISM_MATMAS03',
    con_mess_type_ism    type tbdme-mestyp     value 'ISM_MATMAS',
    con_nodata           type bgr00-nodata     value '/'.

* constants for identification of segments of material master
  constants:
    con_segm_mara(10)         type c      value 'MARA',
    con_segm_jptmara(10)      type c      value 'JPTMARA',
    con_segm_makt(10)         type c      value 'MAKT',
    con_segm_marc(10)         type c      value 'MARC',
    con_segm_mard(10)         type c      value 'MARD',
    con_segm_mlgn(10)         type c      value 'MLGN',
    con_segm_mlgt(10)         type c      value 'MLGT',
    con_segm_marm(10)         type c      value 'MARM',
    con_segm_mvke(10)         type c      value 'MVKE',
    con_segm_steu(10)         type c      value 'MG03STEUER',
    con_segm_stmm(10)         type c      value 'MG03STEUMM',
    con_segm_mbew(10)         type c      value 'MBEW',
    con_segm_idcd(14)         type c      value 'JPTIDCDASSIGN',
    con_segm_bupa(14)         type c      value 'JPTBUPAASSIGN'.
