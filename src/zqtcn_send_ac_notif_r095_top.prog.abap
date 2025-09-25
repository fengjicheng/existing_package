*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SEND_AC_NOTIF_R095_TOP
*&---------------------------------------------------------------------*

  TYPE-POOLS: vrm, slis, sscr.
  TABLES: vbap.
  INCLUDE rvadtabl.
*-------------------------------Types----------------------------------*
  TYPES : BEGIN OF ty_messages,
            contract_id TYPE vbeln,                         " Contract ID
            item        TYPE posnr,                         " Item
            comments    TYPE oij_sim_sc,                    " Success or Error message
          END OF ty_messages.
*-------------------------------Declarations---------------------------*
  DATA: retcode    LIKE sy-subrc,                           " Returncode
        xscreen(1) TYPE c,                                  " Output on printer or screen
        i_msg      TYPE TABLE OF ty_messages,               " Messages internal table
        w_msg      TYPE ty_messages.                        " Messages Work Area
*-------------------------------CONSTANTS------------------------------*
  CONSTANTS : c_devid    TYPE char10   VALUE 'R095',        " Development ID
              c_field    TYPE char3    VALUE 'LOW',         " Field Name
              c_table    TYPE char11   VALUE 'ZCACONSTANT', " Table Name
              c_rem      TYPE salv_de_selopt_low VALUE 'REMINDER', " Reminder text
              c_une      TYPE salv_de_selopt_low VALUE 'UNENROLLMENT', " Unenrollment text
              c_eq       TYPE char2    VALUE 'EQ',          " Equal
              c_x        TYPE char1    VALUE 'X',           " Checked
              c_s        TYPE char1    VALUE 'S',           " Success
              c_e        TYPE char1    VALUE 'E',           " Error / English
              c_so_grade TYPE char8    VALUE 'SO_GRADE',    " Grade
              c_i        TYPE char1    VALUE 'I',           " Inclusive / Informative
              c_w        TYPE char1    VALUE 'W',           " Warning
              c_blank    TYPE char1    VALUE ' ',           " Blank
              c_sh       TYPE char2    VALUE 'WE',          " Partner Function
              c_kappl    TYPE char2    VALUE 'V1',          " Application for message conditions
              c_nacha    TYPE char1    VALUE 5,             " Message transmission medium
              c_anzal    TYPE na_anzal VALUE 0,             " Number of messages (original + copies)
              c_vsztp    TYPE char1    VALUE 1,             " Dispatch time
              c_ldest    TYPE char4    VALUE 'LP01',        " Spool: Output device
              c_tcode    TYPE char4    VALUE 'CS01',        " Communication strategy
              c_objtype  TYPE char10   VALUE 'BUS2032'.     " Object type
*-------------------------------Class----------------------------------*
  CLASS lcl_send_ac_notif DEFINITION FINAL.
    PUBLIC SECTION.
      METHODS:
        meth_get_data,        " Data Selection and Nast entry creation
        meth_generate_output, " Generating output
        meth_send_mail
          IMPORTING
            im_nast    TYPE nast
            im_screen  TYPE c
          CHANGING
            ch_retcode TYPE sy-subrc.
    PRIVATE SECTION.
      METHODS:
        meth_nast_entries
          IMPORTING
            im_nast TYPE nast,
        meth_init_data
          IMPORTING
            im_nast       TYPE nast
          EXPORTING
            ex_sy_date    TYPE char10
            ex_erdat      TYPE char10
* Begin by Aslam on 12/02/2019 - JIRA Ticket:ERPM-8127, TR: ED2K916969
*            ex_arktx      TYPE arktx
            ex_arktx      TYPE string
* End by Aslam on 12/02/2019 - JIRA Ticket:ERPM-8127, TR: ED2K916969
            ex_vdemdat    TYPE char10
            ex_stud_name  TYPE ad_name1
            ex_send_email TYPE ad_smtpadr,
        meth_get_so10_text
          IMPORTING
            im_name      TYPE tdobname
            im_days      TYPE na_obs030
            im_sy_date   TYPE char10
            im_erdat     TYPE char10
* Begin by Aslam on 12/02/2019 - JIRA Ticket:ERPM-8127, TR: ED2K916969
*            im_arktx     TYPE arktx
            im_arktx     TYPE string
* End by Aslam on 12/02/2019 - JIRA Ticket:ERPM-8127, TR: ED2K916969
            im_vdemdat   TYPE char10
            im_stud_name TYPE ad_name1
          EXPORTING
            ex_soli      TYPE soli_tab,
        meth_get_mail_subject
          IMPORTING
            im_name    TYPE tdobname
          EXPORTING
            ex_subject TYPE string.
  ENDCLASS.
