FUNCTION-POOL zcsds     MESSAGE-ID b1.

*----------------------------------------------------------------------*
* global data BOM
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* TYPES
*----------------------------------------------------------------------*
TYPES : BEGIN OF stpob_id_type,
          stlty LIKE stzu-stlty,
          tabix LIKE sy-tabix.
          INCLUDE STRUCTURE csident_01.
        TYPES : END OF stpob_id_type.

TYPES : BEGIN OF no_data_type,
          tabname   LIKE dntab-tabname,
          tabix     LIKE sy-tabix,
          fieldname LIKE dntab-fieldname,
        END OF no_data_type.

TYPES : BEGIN OF val_to_api_type,
          itabname  LIKE dntab-tabname,
          tabix     LIKE sy-tabix,
          apiname   LIKE dntab-tabname,
          apistrct  LIKE dntab-tabname,
          apifields LIKE dfies OCCURS 0,
          apifield  LIKE dfies,
          resetsgn  LIKE csdata-xfeld,
        END OF val_to_api_type.

TYPES : BEGIN OF ptrs_type,
          real LIKE bdcp-cpident,
          cond LIKE bdcp-cpident,
        END OF ptrs_type.
TYPES : ptrs_tab TYPE ptrs_type OCCURS 0.

TYPES : BEGIN OF seri_type,
          appl_key TYPE char30,
          chnum    LIKE serial-chnum,
          obj_type LIKE serial-obj_type,
        END OF seri_type.

*      for STTMAT
DATA : BEGIN OF data_sttmat,
         stdpd     TYPE      mastb-matnr,
         flg_stdpd TYPE      csdata-xfeld.
         INCLUDE    STRUCTURE mastb.
       DATA   END OF data_sttmat.

* --- begin of insertion note 567351
*      for indentification of preceding notes
TYPES: BEGIN OF vgknt_type,
         stlty LIKE stpo-stlty,
         stlnr LIKE stpo-stlnr,
         stlkn LIKE stpo-stlkn,
         stpoz LIKE stpo-stpoz,
         vgknt LIKE stpo-vgknt,
         vgpzl LIKE stpo-vgpzl,
       END OF vgknt_type.

TYPES: BEGIN OF guid_type,
         stlkn LIKE stpo-stlkn,
         stpoz LIKE stpo-stpoz,
         guid  LIKE stpo-guidx,
       END OF guid_type.
* --- end of insertion note 567351
TYPES: BEGIN OF t_idoc_data,
         posnr TYPE sposn,
         postp TYPE postp,
         idnrk TYPE idnrk,
         ktext TYPE kmptx,
         menge TYPE kmpmg,
         datuv TYPE datuv,
         datub TYPE datub,
       END OF t_idoc_data.
DATA : gt_idoc_data TYPE TABLE OF t_idoc_data,
       gw_idoc_data TYPE t_idoc_data.
*           *---- feldleiste stücklistenkopfdaten
DATA: BEGIN OF tstk2.
        INCLUDE STRUCTURE stko_api02.
      DATA: END OF tstk2.
*---- Tabelle Stücklistenpositionen
DATA: BEGIN OF tstp2 OCCURS 0.
        INCLUDE STRUCTURE stpo_api02.
      DATA: END OF tstp2.
DATA: BEGIN OF tdep2_data OCCURS 0.
        INCLUDE STRUCTURE dep_data.
      DATA: END OF tdep2_data.
*     Beschreibung
DATA: BEGIN OF tdep2_descr OCCURS 0.
        INCLUDE STRUCTURE dep_descr.
      DATA: END OF tdep2_descr.
*     Source
DATA: BEGIN OF tdep2_source OCCURS 0.
        INCLUDE STRUCTURE dep_source.
      DATA: END OF tdep2_source.
*     Reihenfolge
DATA: BEGIN OF tdep2_order OCCURS 0.
        INCLUDE STRUCTURE dep_order.
      DATA: END OF tdep2_order.
*     Dokumentation
DATA: BEGIN OF tdep2_doc OCCURS 0.
        INCLUDE STRUCTURE dep_doc.
      DATA: END OF tdep2_doc.
*types: BEGIN OF ty_tstp3,
*TYPES: BEGIN OF  ty_tstp3,
*         include STRUCTURE  stpo_api03,
*       END OF  ty_tstp3.
*        INCLUDE STRUCTURE stpo_api03,
DATA: gt_tstp3 TYPE STANDARD TABLE OF stpo_api03,
      ls_tstp3 TYPE stpo_api03.
DATA: BEGIN OF tstk1.
        INCLUDE STRUCTURE stko_api01.
      DATA: END OF tstk1.
DATA: flg_warning LIKE capiflag-fllkenz.
DATA : idoc_status TYPE bdidocstat.
DATA : flg_lock_err LIKE csdata-xfeld,                      "note598927
       akt_uname    LIKE sy-uname,
       ls_ccin      LIKE ccin.                                  "note598927                           "note598927

*----------------------------------------------------------------------*
* global data BOM
*----------------------------------------------------------------------*
* bom tables
TABLES: stzu, stko, stpo, stas, mast, t415s, tcsfgf.
* API structures
DATA:
  api_mbom              LIKE csap_mbom,
  api_dbom              LIKE csap_dbom,
  api_kbom              LIKE csap_kbom,
  api_stko1             LIKE stko_api01 OCCURS 0 WITH HEADER LINE,
  api_stpo1             LIKE stpo_api01 OCCURS 0 WITH HEADER LINE,
  api_stko2             LIKE stko_api02 OCCURS 0 WITH HEADER LINE,
  api_stpo2             LIKE stpo_api02 OCCURS 0 WITH HEADER LINE,
  api_stpo3             LIKE stpo_api03 OCCURS 0 WITH HEADER LINE,
  api_dep_dat           LIKE csdep_dat  OCCURS 0 WITH HEADER LINE,
  api_dep_des           LIKE csdep_desc OCCURS 0 WITH HEADER LINE,
  api_dep_ord           LIKE csdep_ord  OCCURS 0 WITH HEADER LINE,
  api_dep_src           LIKE csdep_sorc OCCURS 0 WITH HEADER LINE,
  api_dep_doc           LIKE csdep_doc  OCCURS 0 WITH HEADER LINE,
  api_ltx_lin           LIKE csltx_line OCCURS 0 WITH HEADER LINE, "n495036
  api_stpu              LIKE stpu_api01 OCCURS 0 WITH HEADER LINE, "n530922
  api_logno             LIKE balhdri-extnumber,
  api_warning           LIKE csdata-xfeld,
  api_messages          LIKE messages   OCCURS 0 WITH HEADER LINE,

* bom internal tables
  stzub                 LIKE stzub         OCCURS 1 WITH HEADER LINE,
  stkob                 LIKE stkob         OCCURS 1 WITH HEADER LINE,
  stasb                 LIKE stasb         OCCURS 0 WITH HEADER LINE,
  stpoi                 LIKE stpoi         OCCURS 0 WITH HEADER LINE,
  stpob                 LIKE stpob         OCCURS 0 WITH HEADER LINE,
  stpob_id              TYPE stpob_id_type OCCURS 0 WITH HEADER LINE,
  stpub                 LIKE stpub         OCCURS 0 WITH HEADER LINE,
* object links
  mastb                 LIKE mastb  OCCURS 1 WITH HEADER LINE,
  dostb                 LIKE dostb  OCCURS 0 WITH HEADER LINE,
*     EQSTB     LIKE EQSTB  OCCURS 0 WITH HEADER LINE, "not yet in use
*     TPSTB     LIKE TPSTB  OCCURS 0 WITH HEADER LINE, "not yet in use
  kdstb                 LIKE kdstb  OCCURS 0 WITH HEADER LINE,
*     STSTB     LIKE STSTB  OCCURS 0 WITH HEADER LINE, "not yet in use
* recursivity (objects in classes)
  clrkb                 LIKE csclrk OCCURS 0 WITH HEADER LINE,
* long text
  ltx_head              LIKE thead,
  ltx_lines             LIKE tline OCCURS 0 WITH HEADER LINE,
* for processing NO_DATA_SIGN / RESET_SIGN
  no_data_tab           TYPE no_data_type OCCURS 0 WITH HEADER LINE,
  val_to_api            TYPE val_to_api_type,
  itab_to_api_last_itab LIKE val_to_api-itabname,           "note562112
  itab_to_api_dfies_tab TYPE dfies OCCURS 0                 "note562112
                                   WITH HEADER LINE,        "note562112
* other bom data
  bom_error             LIKE csdata-xfeld,
  idoc_err_nr           TYPE i,
  flg_ale               LIKE csdata-xfeld,
  flg_chid              LIKE csdata-xfeld,
  flg_no_commit_work    LIKE csdata-xfeld,
  ale_aennr             LIKE aenr-aennr,
  gv_matnr_err          TYPE matnr.

*----------------------------------------------------------------------*
* global data ALE
*----------------------------------------------------------------------*

* ALE tables
TABLES:
  tbda1,
  tbda2,
* IDOC segment types
  e1mastm, e1dostm, e1kdstm,           "bom type
  e1stzum, e1stkom, e1stkon, e1stasm,  "bom data
  e1stpom, e1stpon, e1stpum,
  e1szuth, e1szutl,                    "long texts
  e1skoth, e1skotl,
  e1spoth, e1spotl,
  e1cukbm, e1cukbt, e1cuknm, e1cutxm,  "dependencies
* SGUDA
  e1maram, e1maraism, e1idcdassignism,
  e1marcm, e1maktm, e1mvkem, e1mtxhm,
  e1mlanm, e1oclfm, e1auspm, e1ksskm,
  e1jptmaraism, e1mtxlm.
* SGUDA
* ALE internal tables
DATA:
  t_idoc_data                  LIKE edidd OCCURS 0 WITH HEADER LINE, "data records
  t_comm_control               LIKE edidc OCCURS 0 WITH HEADER LINE, "comm.protocl
* for STTMAT
  mastb_ref                    LIKE mastb        OCCURS 0 WITH HEADER LINE,
  itab_sttmat                  LIKE data_sttmat  OCCURS 1 WITH HEADER LINE,
  csap_sttmat                  LIKE api_sttmat01 OCCURS 1 WITH HEADER LINE,
* other ALE data:
  idoc_control                 LIKE edidc,                    "IDoc control record
  seri                         TYPE seri_type,
  h_create_idoc,
  serial(4)                    TYPE n,
* identification by GUID                                   "note 567351
*     inbound IDocs                                        "note 567351
  g_inb_bom_exit               TYPE REF TO if_ex_bom_exit,           "note 567351
  g_flg_ident_by_guid          TYPE c,                          "note 567351
  g_flg_ident_by_guid_checked  TYPE c,                  "note 567351
*     outbound IDocs                                       "note 567351
  g_outb_bom_exit              TYPE REF TO if_ex_bom_exit,          "note 567351
  g_flg_guid_into_idoc         TYPE c,                         "note 567351
  g_flg_guid_into_idoc_checked TYPE c,                 "note 567351
  g_fl_mdm_inbound_active,                             "note 617329
  g_fl_mdm_outbound_active.                            "note 617329
*** SGUDA
TYPES: BEGIN OF ty_class_data,
         msgfn        TYPE msgfn,
         obtab        TYPE catabelle,
         objek        TYPE objnum,
         klart        TYPE klassenart,
         mafid        TYPE klmaf,
         object_table TYPE tabelle,
         class        TYPE klasse_d,
         aennr        TYPE aennr,
         datuv        TYPE datuv,
         statu        TYPE clstatus,
         stdcl        TYPE stdclass,
         atnam        TYPE atnam,
         atwrt        TYPE atwrt,
       END OF ty_class_data,
       BEGIN OF ty_header_data,
         matnr           TYPE matnr,
         spras           TYPE spras,
         maktx           TYPE maktx,
         ntgew           TYPE ntgew,
         brgew           TYPE brgew,
         meins           TYPE meins,
         werks           TYPE werks,
         ismpubltype     TYPE ismpubltype,
         ismmediatype    TYPE ismmediatype,
         ismconttype     TYPE ismconttype,
         ismhierarchlevl TYPE ismhierarchlvl,
         mstae           TYPE mstae,
         mstav           TYPE mstav,
         mstdv           TYPE mstdv,
         spart           TYPE spart,
         matkl           TYPE matkl,
         extwg           TYPE extwg,
         mbrsh           TYPE mbrsh,
         mtart           TYPE mtart,
         ismtitle        TYPE ismsubtitle1,
         ismsstratni     TYPE jsearchstrat,
         ismniptype      TYPE jniptype,
         ismperrule      TYPE ismperregel,
         idcodetype1     TYPE ismidcodetype,
         xmainidcode     TYPE ismxmainidcode,
         identcode1      TYPE  ismidentcode,
         prctr           TYPE prctr,
         prat1           TYPE prat1,
       END OF ty_header_data,
       BEGIN OF ty_org_data,
         dwerk TYPE dwerk,
         mtpos TYPE mtpos,
         vkorg TYPE vkorg,
         vtweg TYPE vtweg,
         mvgr5 TYPE mvgr5,
         prat1 TYPE prat1,
       END OF ty_org_data,
       BEGIN OF ty_basic_text,
         tdobject   TYPE tdobject,
         tdname     TYPE tdname,
         tdid       TYPE tdid,
         tdspras    TYPE tdspras,
         tdtexttype TYPE tdtexttype,
         spras_iso  TYPE laiso,
         tdline     TYPE tdline,
       END OF ty_basic_text,
       BEGIN OF ty_header_text,
         matnr TYPE matnr,
         spras TYPE spras,
         maktx TYPE maktx,
       END OF ty_header_text,
       BEGIN OF ty_tax_classification,
         aland TYPE aland,
         taty1 TYPE tatyp,
         taxm1 TYPE taklm,
       END OF ty_tax_classification,
       BEGIN OF ty_ism_data,
         idcodetype  TYPE ismidcodetype,
         identcode   TYPE ismidentcode,
         xmainidcode TYPE ismxmainidcode,
       END OF ty_ism_data.

*                                      e1marcm-werks
*                                      e1marcm-herkl
DATA : gt_class_data         TYPE TABLE OF ty_class_data,
       gt_header_data        TYPE TABLE OF ty_header_data,
       gt_basic_text         TYPE TABLE OF ty_basic_text,
       gt_header_text        TYPE TABLE OF ty_header_text,
       gt_org_data           TYPE TABLE OF ty_org_data,
       gt_tax_classification TYPE TABLE OF ty_tax_classification,
       gs_tax_classification TYPE ty_tax_classification,
       gt_ism_data           TYPE TABLE OF ty_ism_data,
       gs_ism_data           TYPE ty_ism_data,
       gs_org_data           TYPE ty_org_data,
       gs_class_data         TYPE ty_class_data,
       gs_header_data        TYPE ty_header_data,
       gs_edidc              LIKE edidc,
       gs_header_text        TYPE ty_header_text,
       gs_basic_text         TYPE ty_basic_text,
       lst_header            TYPE bapimathead,
       lst_clientdata        TYPE bapi_mara,
       lst_clientdatax       TYPE bapi_marax,
       lst_plantdata         TYPE bapi_marc,
       lst_plantdatax        TYPE bapi_marcx,
       lst_saledata          TYPE bapi_mvke,
       lst_saledatax         TYPE bapi_mvkex,
       lst_mat_des           TYPE bapi_makt,
       lst_return            TYPE bapiret2,
       li_mat_unit           TYPE TABLE OF bapi_marm,
       ls_mat_unit           TYPE bapi_marm,
       li_mat_unitx          TYPE TABLE OF bapi_marmx,
       ls_mat_unitx          TYPE bapi_marmx,
       li_return             TYPE STANDARD TABLE OF bapi_matreturn2,
       li_mat_des            TYPE STANDARD TABLE OF bapi_makt,
       li_mat_text           TYPE STANDARD TABLE OF bapi_mltx,
       ls_mat_text           TYPE bapi_mltx,
       li_taxclas            TYPE STANDARD TABLE OF bapi_mlan,
       ls_taxclas            TYPE bapi_mlan,
       lt_extension          LIKE bapiparex OCCURS 0 WITH HEADER LINE,
       lt_extensionx         LIKE bapiparexx OCCURS 0 WITH HEADER LINE,
       ls_ext_mara           TYPE bapi_te_mara,
       ls_ext_marax          TYPE bapi_te_marax,
       ls_ext_mvke           TYPE bapi_te_mvke,
       ls_ext_mvkex          TYPE bapi_te_mvkex,
       lst_idoc_stat         TYPE bdidocstat,
       i_objectkey           TYPE bapi1003_key-object,
       i_objecttab           TYPE bapi1003_key-objecttable,
       i_classnum            TYPE bapi1003_key-classnum,
       i_classtype           TYPE bapi1003_key-classtype,
       i_keydate             TYPE bapi1003_key-keydate,
       st_allocvalueschar    TYPE bapi1003_alloc_values_char,
       lt_merrdat            TYPE jp_merrdat_tab,
       gt_idcode             TYPE TABLE OF rjp_idcode_dark, "TRANC added hint 1297839
       gs_idcode             TYPE  rjp_idcode_dark, "TRANC added hint 1297839
       kz_test               TYPE xfeld,
       gt_jptmara            TYPE jptmara_tab_dark,
       gs_jptmara            TYPE rjp_jptmara_dark,
       i_allocvaluesnumnew   TYPE STANDARD TABLE OF bapi1003_alloc_values_num,
       i_allocvaluescurrnew  TYPE STANDARD TABLE OF bapi1003_alloc_values_curr,
       i_allocvalueschar     TYPE STANDARD TABLE OF bapi1003_alloc_values_char,
       i_return              TYPE STANDARD TABLE OF bapiret2,
       lv_flag_error         TYPE char1,
       lv_flag_success       TYPE char1,
       li_constant           TYPE TABLE OF zcaconstant,
       l_str_message         TYPE bapiret2,
       l_tab_messages        TYPE bapiret2_t,
       r_multi_journal       TYPE RANGE OF salv_de_selopt_low.
CONSTANTS : c_x             TYPE char1      VALUE 'X',
            c_kg            TYPE gewei      VALUE 'KG',
            c_e             TYPE bapi_mtype VALUE 'E',
            c_s             TYPE bapi_mtype VALUE 'S',
            c_devid         TYPE zdevid     VALUE 'I0409',
            c_multi_journal TYPE rvari_vnam VALUE 'MULTI_JOURNAL',
            c_u             TYPE char1      VALUE 'U',
            c_i             TYPE char1      VALUE 'I',
            c_d             TYPE char1      VALUE 'D',
            c_n             TYPE char1      VALUE 'N',
            c_1             TYPE char1      VALUE '1',
            c_multi_jour    TYPE mtart      VALUE 'ZMMJ',
            c_multi_med     TYPE mtart      VALUE 'ZMJL',
            c_enddate       TYPE char10     VALUE '12/31/9999'.
DATA : l_werks  LIKE mast-werks.
DATA:  ls_stko1 LIKE stko_api01.

DATA: l_flg_cls_item LIKE csdata-xfeld,
      ls_t418        LIKE t418.
DATA:
*    t_field    LIKE TABLE OF fs_field,
  t_bdcdata  LIKE TABLE OF bdcdata,
  fs_bdcdata LIKE LINE OF t_bdcdata.

*  fs_bdcdata LIKE LINE OF t_bdcdata.   " Structure type of bdcdata
*  DATA: "ls_ccin      LIKE ccin,                             "note598927
"akt_uname    LIKE sy-uname,                         "note598927
"flg_lock_err LIKE csdata-xfeld.                     "note598927
TYPES: BEGIN OF t_tab_tmp,
         posnr TYPE sposn,
         postp TYPE postp,
         idnrk TYPE idnrk,
         ktext TYPE kmptx,
         menge TYPE kmpmg,
         datuv TYPE datuv,
         datub TYPE datub,
         ind   TYPE c,
       END OF t_tab_tmp.
DATA :
  lt_bom_original     TYPE STANDARD TABLE OF t_tab_tmp,
  lt_bom_original_tmp TYPE STANDARD TABLE OF t_tab_tmp,
  wa_bom_original     TYPE t_tab_tmp,
  wa_bom_original_tmp TYPE  t_tab_tmp,
  v_idnrk             TYPE idnrk,
  v_date              TYPE DATUV.
DATA : li_stpo  TYPE STANDARD TABLE OF stpo_api02.  " Local Itab for BOM Items
DATA : lst_mara          TYPE mara,
       lst_mastb         LIKE LINE OF mastb,
       lv_date           TYPE csap_mbom-datuv,
       lt_log_number_tab TYPE TABLE OF balnri,
       ls_log_number     TYPE balnri.
TYPES : BEGIN OF ty_idoc_message,
          err_nr TYPE i,
          msgid  TYPE symsgid,
          msgno  TYPE symsgno,
          msgv1  TYPE symsgv,
        END OF ty_idoc_message.
DATA : lt_idoc_status  TYPE TABLE OF ty_idoc_message,
       lst_idoc_status TYPE ty_idoc_message.
*** SGUDA
*----------------------------------------------------------------------*
* Variables
*----------------------------------------------------------------------*
DATA: retail_flg,
      nr_entries    TYPE  i.

*----------------------------------------------------------------------*
* Constants
*----------------------------------------------------------------------*
INCLUDE csdscons.
