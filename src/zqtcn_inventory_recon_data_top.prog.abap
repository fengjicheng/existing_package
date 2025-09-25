*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCI_INVENTORY_RECON_DATA_TOP (Include Program)
* PROGRAM DESCRIPTION: Inventory Reconciliation Data
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   12/22/2016
* OBJECT ID:  I0315
* TRANSPORT NUMBER(S): ED2K903838
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: ED2K917189
* Reference No:  ERPM2204
* Developer: Gopalakrishna (GKAMMILI)
* Date:  2020-01-13
* Description: Send error logs to Email Notification
*------------------------------------------------------------------- *
*** Global Types Declaration
TYPES: BEGIN OF ty_soh,
         jgc TYPE string,
         jy  TYPE string,
         iss TYPE string,
         uid TYPE string,
         jt  TYPE string,
         idt TYPE string,
         soh TYPE string,
         mdt TYPE string,
         iv  TYPE string,
         itv TYPE string,
         in  TYPE string,
         itn TYPE string,
         ip  TYPE string,
         itp TYPE string,
*         dp  TYPE string,
         grd TYPE string,
         col TYPE string,
        fnam TYPE string,
       END OF ty_soh.


TYPES: BEGIN OF ty_bios,
         jgc  TYPE string,
         pbs  TYPE string,
         uid  TYPE string,
         adjt TYPE string,
         adjq TYPE string,
         adjn TYPE string,
         adjd TYPE string,
         col  type string,
         fnam TYPE string,
       END OF ty_bios.

TYPES: BEGIN OF ty_jdr,
         uid    TYPE string,
         ippd   TYPE string,
         acro   TYPE string,
         vol    TYPE string,
         iss    TYPE string,
         supm   TYPE string,
         part   TYPE string,
         dw     TYPE string,
         mlqty  TYPE string,
         omq    TYPE string,
         cqty   TYPE string,
         ebo    TYPE string,
         office TYPE string,
         col    TYPE string,
         fname  TYPE string,
         eof    TYPE flag,
         del    TYPE flag,
       END OF ty_jdr.

TYPES: BEGIN OF ty_jrr,
         uid    TYPE string,
         stdd   TYPE string,
         acro   TYPE string,
         vol    TYPE string,
         iss    TYPE string,
         supm   TYPE string,
         part   TYPE string,
         opr    TYPE string,
         qr     TYPE string,
         wpc    TYPE string,
         remk   TYPE string,
         office TYPE string,
         col    TYPE string,
         fname  TYPE string,
         eof    TYPE flag,
         del    TYPE flag,
       END OF ty_jrr,
* File Names
       BEGIN OF ty_fname,
         zsource   TYPE char40,
       END OF ty_fname,
       BEGIN OF ty_msg,
         zsource   TYPE char40,
         text      TYPE string,
       END OF ty_msg,
       BEGIN OF ty_fgrdate,
         MATNR    TYPE MATNR,
         WERKS    TYPE DWERK_EXT,
         ZFGRDAT  TYPE ZFGRDAT,
       END OF ty_fgrdate,
       BEGIN OF ty_err_file_r,
         sign     TYPE sign,
         option   TYPE option,
         low      TYPE char40,
         high     TYPE char40,
       END OF ty_err_file_r,
*-- BOC by GKAMMILI ERPM2204 13/Jan/2020 ED2K917189
       BEGIN OF ty_xml_line,  " Structure for xml line
         data(255) TYPE x,
       END OF ty_xml_line,
       BEGIN OF ty_pack,      "Structure for package
         count     TYPE syindex,
         bstart    TYPE so_bd_strt,
         bnum      TYPE so_bd_num,
         obj_name  TYPE so_obj_nam,
         obj_descr TYPE so_obj_des,
         doc_size  TYPE so_doc_siz,
       END OF ty_pack,
       BEGIN OF ty_filenames,  " Structure for only error files
         data(255) TYPE c,
       END OF ty_filenames.
*-- EOC by GKAMMILI ERPM2204 13/Jan/2020 ED2K917189


*** Global Data Declaration

DATA: v_ap_path    TYPE localfile,
      v_pr_path    TYPE rlgrap-filename,
      v_drctry     TYPE string,
      v_flag       TYPE char1 VALUE abap_false,
      v_file       TYPE   string,
      v_nomat_flag TYPE char1,
      v_file_count TYPE   i,
* Begin of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833
      v_date       type datum.
* End of CHANGE:ADD:RITM0079465:RBTIRUMALA:26/10/2018:ED1K908833

*** Global Internal table and work area declaration
DATA: i_inv_rcon     TYPE STANDARD TABLE OF zqtc_inven_recon,
      i_soh          TYPE STANDARD TABLE OF ty_soh,
      st_soh         TYPE  ty_soh,
      i_bios         TYPE STANDARD TABLE OF ty_bios,
      st_bios        TYPE ty_bios,
      i_jdr          TYPE STANDARD TABLE OF ty_jdr,
      i_jrr          TYPE STANDARD TABLE OF ty_jrr,
      i_fname        TYPE STANDARD TABLE OF ty_fname, " File Names
      i_file_names   TYPE STANDARD TABLE OF salfldir INITIAL SIZE 0, "Directory of Files.
      i_err_file_r   TYPE STANDARD TABLE OF ty_err_file_r,
      i_fgrdate_tab  TYPE TABLE OF ty_fgrdate,
      i_prc_files    TYPE STANDARD TABLE OF zqtc_inven_recon,
      i_errlog_files TYPE STANDARD TABLE OF ty_msg,
      i_errlog_msgs  TYPE STANDARD TABLE OF ty_msg,
* Begin of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
      i_err_tmp      TYPE STANDARD TABLE OF ty_msg,
* End of CHANGE:ADD:INC0223402:RBTIRUMALA:31/01/2018:ED1K908833
      st_file_names  TYPE salfldir,
      i_file_names1  TYPE STANDARD TABLE OF salfldir INITIAL SIZE 0,
      i_file_names2  TYPE STANDARD TABLE OF salfldir INITIAL SIZE 0,
      st_file_names1 TYPE   salfldir.

*** Global Constant Declaration
CONSTANTS: c_slash      TYPE char1 VALUE '/',     "Slash Delimiter
           c_tab        TYPE c VALUE cl_abap_char_utilities=>horizontal_tab,
           c_soh        TYPE text VALUE 'SOH',
           c_bios       TYPE char4 VALUE 'BIOS',
           c_jdr        TYPE char3 VALUE 'JDR',
           c_jrr        TYPE char3 VALUE 'JRR',
           c_dot        TYPE char1  VALUE '.',     "Dot Seperator
           c_csv        TYPE char3  VALUE 'csv',            "File type
           c_sign_i     TYPE sign  VALUE 'I',
           c_opt_eq     TYPE option VALUE 'EQ',
           c_comma      TYPE char1 VALUE ',',
           c_fpath_in   TYPE char4 VALUE '/in/',
           c_fpath_err  TYPE char5 VALUE '/err/',
           c_negative   TYPE char1 VALUE '-',  " Negative qty
           c_file_undsc TYPE char1 VALUE '_',
           c_inf        TYPE char1 VALUE 'I'.      " GKAMMILI ERPM2204 13/Jan/2020 ED2K917189.

* SOC by GKAMMILI ERPM2204 13/Jan/2020 ED2K917189
DATA:      st_adr6     TYPE adr6,
           i_xml_table TYPE TABLE OF ty_xml_line,
           st_xml      TYPE          ty_xml_line,
           i_pack      TYPE TABLE OF ty_pack,
           st_pack     TYPE          ty_pack,
           i_filenames TYPE TABLE OF ty_filenames,
           st_filenames TYPE         ty_filenames,
           i_file_err  TYPE TABLE OF ty_filenames,
           st_file_err TYPE          ty_filenames,
           i_objbin    LIKE solix OCCURS 10 WITH HEADER LINE.
* EOC by GKAMMILI ERPM2204 13/Jan/2020 ED2K917189
