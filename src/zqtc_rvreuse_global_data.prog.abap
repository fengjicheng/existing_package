*
tables: ltdx.
type-pools: rsfs.
type-pools: rsds.
type-pools: slis.
type-pools: kkblo.

types: begin of sd_alv,
*
         grid_top_of_page type slis_t_listheader,
         fieldcat     type slis_t_fieldcat_alv,
         variant      like disvariant,
         events       type slis_t_event,
         event_exit  type  slis_t_event_exit,
         layout       type slis_layout_alv,
         sort         type slis_t_sortinfo_alv,
         filter       type slis_t_filter_alv,
         special_groups type slis_t_sp_group_alv,
         excluding      type slis_t_extab,
         sel_hide       type slis_sel_hide_alv,
         program        like sy-repid,
         pf_status_set  type slis_formname,
         user_command   type slis_formname,
         structure      like dd02l-tabname,
         structure_item like dd02l-tabname,
         keyinfo        type slis_keyinfo_alv,
         default        type c,
         save           type c,
         print          type slis_print_alv,
         start_column   type i,
         start_line     type i,
         end_column     type i,
         end_line       type i,
         exit           type c,
         user_exit      type slis_exit_by_user ,
* select
         title(100)     type c,
         selection      type c,
         zebra          type c,
         checkbox       like dd03p-fieldname,
         linemark       like dd03p-fieldname,
         tabname        like dd02l-tabname,
* ok_code
         selfield       type slis_selfield,
*
         tabname_header like dd02l-tabname,
         tabname_item   like dd02l-tabname,
* List_loayout_more
         filtered_entries type  kkblo_t_sfinfo,
         filtered_entries_item type  kkblo_t_sfinfo,
         list_scroll type  kkblo_list_scroll,
*
         grid_display   type c,
         subrc          like sy-subrc,

end of sd_alv.

types: begin of list_variant,
         kind,
         tabname_header like dd02l-tabname,
         tabname_item   like dd02l-tabname,
       end   of list_variant.


types: begin of events,
       node like dd02l-tabname,
       kind,
       end   of events.

types: t_events type events occurs 1.
*--** Internal table for holding child jobs
*--*Prabhu
TYPES : BEGIN OF ty_child_jobs,
        jobname   LIKE tbtcjob-jobname,
        jobcount  LIKE tbtcjob-jobcount,
        jobstatus LIKE tbtcjob-status,
        created_steps(4)  TYPE n,
        created_custs(5)  TYPE n,
        created_orders(6) TYPE n,
        job_closed TYPE c,
        remove TYPE c,
      END OF ty_child_jobs.
DATA : i_child_jobs TYPE STANDARD TABLE OF ty_child_jobs,
       st_child_jobs TYPE ty_child_jobs,
       v_no_docs TYPE salv_de_selopt_low,
       v_serv_per TYPE salv_de_selopt_low,
       v_doc_count(6) TYPE n,
       v_total_docs(6) TYPE n,
       v_sel_docs(6) TYPE n,
       v_rem_docs(6) TYPE n.

data:  gs_sd_alv type sd_alv.
data:  gs_list_variant type list_variant.

data:  gv_old_list_layout.

data:  gv_ucomm like sy-ucomm.
data:  gv_subrc like sy-subrc.
data:  gv_exit.
data:  d_save(1) type c.
DATA: created_steps(4)  TYPE n,
        created_custs(5)  TYPE n,
        created_orders(6) TYPE n.
constants:
      gc_chara type c value 'A',
      gc_charb type c value 'B',
      gc_charc type c value 'C',
      gc_chard type c value 'D',
      gc_chare type c value 'E',
      gc_charf type c value 'F',
      gc_charg type c value 'G',
      gc_charh type c value 'H',
      gc_chari type c value 'I',
      gc_charj type c value 'J',
      gc_chark type c value 'K',
      gc_charl type c value 'L',
      gc_charm type c value 'M',
      gc_charn type c value 'N',
      gc_charo type c value 'O',
      gc_charp type c value 'P',
      gc_charq type c value 'Q',
      gc_charr type c value 'R',
      gc_chars type c value 'S',
      gc_chart type c value 'T',
      gc_charu type c value 'U',
      gc_charv type c value 'V',
      gc_charw type c value 'W',
      gc_charx type c value 'X',
      gc_chary type c value 'Y',
      gc_charz type c value 'Z',
      gc_char0 type c value '0',
      gc_char1 type c value '1',
      gc_char2 type c value '2',
      gc_char3 type c value '3',
      gc_char4 type c value '4',
      gc_char5 type c value '5',
      gc_char6 type c value '6',
      gc_char7 type c value '7',
      gc_char8 type c value '8',
      gc_char9 type c value '9',
      gc_char* type c value '*',
      gc_char$ type c value '$',
      gc_char- type c value '-',                            "#EC *
      gc_char_plus type c value '+',
      gc_space type c value ' '.


data : gs_selfield type slis_selfield.

* Customer Connection Projects 200680 and 200681 in 2018
data : gv_enhancement_set.      "User Parameter Enhancement TAB
DATA : gd_repid LIKE sy-repid VALUE 'ZQTC_RV60SBAT'. "Prabhu
DATA   : trvog TYPE c.
DATA: BEGIN OF links OCCURS 0.
        INCLUDE STRUCTURE tline.
      DATA: END OF links.
* data for processing the job
DATA: jobgroup        LIKE tbtcjob-jobgroup VALUE 'INVOICE',
      jobname         LIKE tbtcjob-jobname,
      jobname_invoice LIKE tbtcjob-jobname VALUE
                   'INVOICE_&D_&T_&&',
      jobcount        LIKE tbtcjob-jobcount.
DATA: job_close.
DATA: job_count(3) TYPE p.
DATA: x_host LIKE sy-host.
* data for selecting CUSTOMERS_INVOICE
DATA:
* table with normal customers
  BEGIN OF customers_invoice OCCURS 8000,
    kunnr     LIKE kna1-kunnr,
    orders(6) TYPE n,
    jobs(2)   TYPE n,
  END OF customers_invoice.
**Prabhu
DATA : BEGIN OF customers_docs OCCURS 8000,
         kunnr     LIKE kna1-kunnr,
         vbeln     TYPE vbeln,
         orders(6) TYPE n,
         jobs(2)   TYPE n,
       END OF customers_docs.
RANGES kunnr_sel FOR vkdfs-kunnr.
RANGES x_fktyp FOR vbco7-fktyp.
DATA: kunnr_count(4) TYPE p.
DATA: current_host(3) TYPE n.

DATA: rc LIKE sy-subrc.

* data for print information
DATA: params LIKE pri_params.

* Returncodes der Routine GET_SERVER_LIST
DATA: cant_get_server_info TYPE i VALUE 1,
      no_server_found      TYPE i VALUE 2.

* Returncodes der Zielrechnerprüfung ( CHECK_TARGET_HOST,
* ACQUIRE_DEFAULT_BTCHOST, GET_SRVNAME_FOR_JOB_EXEC und GET_BTC_SYSTEMS)
DATA: tgt_host_chk_has_failed  TYPE i VALUE 1,
      no_batch_on_target_host  TYPE i VALUE 2,
      no_free_batch_wp_now     TYPE i VALUE 3,
      no_batch_server_found    TYPE i VALUE 4,
      target_host_not_defined  TYPE i VALUE 5,
      no_batch_wp_for_jobclass TYPE i VALUE 6.

*  Tabelle der z.Zt. aktiven Batch-Systeme
*
DATA BEGIN OF btc_sys_tbl OCCURS 10.
        INCLUDE STRUCTURE btctgtitbl.
DATA END OF btc_sys_tbl.

DATA BEGIN OF btc_sys_host_tbl OCCURS 10.
        INCLUDE STRUCTURE btctgtitbl.
DATA END OF btc_sys_host_tbl.

* Hilfstabelle für PF4-Behandlung (Help) eines Dynprofeldes
*
DATA BEGIN OF field_tbl OCCURS 10.
        INCLUDE STRUCTURE help_value.
DATA END OF field_tbl.
*
DATA: BEGIN OF xtvfsp OCCURS 0.
        INCLUDE STRUCTURE tvfsp.
      DATA: END   OF xtvfsp.

*ALV
DATA : gs_output TYPE rv60sbat_alv.
DATA : gt_output TYPE STANDARD TABLE OF rv60sbat_alv.


DATA: gt_fieldcat    TYPE slis_t_fieldcat_alv,   "Fieldcat
      gt_layout      TYPE slis_layout_alv,       "Layout
      gt_extab       TYPE slis_t_extab,          "#EC
      gt_top_of_page TYPE slis_t_listheader.

* Constants
CONSTANTS : gc_strct TYPE tabname VALUE 'RV60SBAT_ALV'.

*----------------------------------------------------------------------*
*     Selection Screen                                                 *
*----------------------------------------------------------------------*
* Belegselektion
SELECTION-SCREEN BEGIN OF BLOCK beleg WITH FRAME TITLE text-a01.
PARAMETERS: vkor1 LIKE vbco7-vkorg MEMORY ID fko OBLIGATORY.
SELECT-OPTIONS : so_vtweg FOR vbco7-vtweg.
SELECT-OPTIONS : so_spart FOR vbco7-spart.
SELECT-OPTIONS : so_vstel FOR vbco7-vstel.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(31) text-p01 FOR FIELD fkdat.
PARAMETERS: fkdat LIKE vbco7-fkdat.
SELECTION-SCREEN COMMENT 52(5) text-p11 FOR FIELD fkdab.
PARAMETERS: fkdab LIKE vbco7-fkdat_bis DEFAULT sy-datlo.
SELECTION-SCREEN END OF LINE.
SELECT-OPTIONS: x_fkart FOR vbco7-fkart.
SELECTION-SCREEN END   OF BLOCK beleg.
*Kundendaten
SELECTION-SCREEN BEGIN OF BLOCK kunde WITH FRAME TITLE text-a02.
SELECT-OPTIONS: x_kunnr FOR vbco7-kunnr MATCHCODE OBJECT debi,
               x_lland FOR vbco7-lland,
               x_vbeln FOR vbco7-vbeln,
               x_sortk FOR vbco7-sortkri.
SELECTION-SCREEN END   OF BLOCK kunde.
*zu selektierende Belege
SELECTION-SCREEN BEGIN OF BLOCK choice WITH FRAME TITLE text-a03.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: allea LIKE vbco7-allea DEFAULT 'X'.
SELECTION-SCREEN COMMENT 3(29) text-p09 FOR FIELD allea.
PARAMETERS: allel LIKE vbco7-allel DEFAULT 'X'.
SELECTION-SCREEN COMMENT 35(28) text-p10 FOR FIELD allel.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: alleb LIKE vbco7-alleb.
SELECTION-SCREEN COMMENT 3(29) text-p07 FOR FIELD alleb.
PARAMETERS: allei LIKE vbco7-allei.
SELECTION-SCREEN COMMENT 35(28) text-p08 FOR FIELD allei.
SELECTION-SCREEN END OF LINE.
PARAMETERS: allef LIKE vbco7-allef NO-DISPLAY.
SELECTION-SCREEN SKIP 1.
PARAMETERS: no_faksk LIKE vbco7-no_faksk.
PARAMETERS: p_pdstk  LIKE vkdfi-pdstk AS CHECKBOX.

SELECTION-SCREEN END   OF BLOCK choice.
*----------------------------------------------------------------------*
*   Job Launch Data                                                    *
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK job    WITH FRAME TITLE text-a04.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(31) text-j01 FOR FIELD exdate.
* Start Date
PARAMETERS:
      exdate LIKE sy-datum DEFAULT sy-datum.
SELECTION-SCREEN COMMENT 45(15) text-j02 FOR FIELD extime.
* Start Time
PARAMETERS:
      extime LIKE sy-uzeit DEFAULT sy-uzeit.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
* Immediate start
PARAMETERS: immedi AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN COMMENT 3(29) text-j03 FOR FIELD immedi.
* test only
PARAMETERS: test AS CHECKBOX." NO-DISPLAY.
SELECTION-SCREEN COMMENT 35(28) text-j04 FOR FIELD test.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END   OF BLOCK job.
*----------------------------------------------------------------------*
*   Normal Invoicing                                                   *
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK invoice WITH FRAME TITLE text-a54.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(31) text-j08 FOR FIELD p_sergrp.
PARAMETERS  : p_sergrp  LIKE bdfields-rfcgr DEFAULT ' ' OBLIGATORY.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
* number of jobs
SELECTION-SCREEN COMMENT 1(31) text-j05 FOR FIELD numbjobs.
PARAMETERS: numbjobs(2) TYPE n DEFAULT '05' OBLIGATORY. "Prabhu
* number of jobs
*SELECTION-SCREEN COMMENT 45(15) text-j06 FOR FIELD max_cust.
PARAMETERS  max_cust(3) TYPE n DEFAULT '100' NO-DISPLAY. "Prabhu
*SELECTION-SCREEN COMMENT 65(12) text-p12.
* number of customers per step
SELECTION-SCREEN END OF LINE.
* host for job launch
SELECT-OPTIONS: host FOR x_host LOWER CASE no-DISPLAY. "Prabhu
SELECTION-SCREEN END   OF BLOCK invoice.
*Ablaufsteuerung
SELECTION-SCREEN BEGIN OF BLOCK ablauf  WITH FRAME TITLE text-a05.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETER  anzei TYPE sdbill_listanzei AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN COMMENT 3(28)  text-p06 FOR FIELD anzei.
SELECTION-SCREEN END OF LINE.
PARAMETERS: proto TYPE sdbill_sammelgang AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END   OF BLOCK ablauf.
*ENHANCEMENT-POINT RV60SBAT_01 SPOTS ES_RV60SBAT STATIC.

* neue Seite
*Vorgabedaten
SELECTION-SCREEN BEGIN OF BLOCK vorgabe WITH FRAME TITLE text-a06.
PARAMETERS: vfkar LIKE rv60a-fkart,
            vfkda LIKE rv60a-fkdat,
            fbuda LIKE rv60a-fbuda,
            prsdt LIKE rv60a-prsdt.
SELECTION-SCREEN END   OF BLOCK vorgabe.
*---------------------------------------------------------------------*
*   Update task                                                       *
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK update WITH FRAME TITLE text-a07.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: utasy RADIOBUTTON GROUP updt DEFAULT 'X'.
SELECTION-SCREEN COMMENT 5(30) text-u01 FOR FIELD utasy.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: utswl RADIOBUTTON GROUP updt.
SELECTION-SCREEN COMMENT 5(30) text-u02 FOR FIELD utswl.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: utsnl RADIOBUTTON GROUP updt.
SELECTION-SCREEN COMMENT 5(30) text-u03 FOR FIELD utsnl.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END   OF BLOCK update.
