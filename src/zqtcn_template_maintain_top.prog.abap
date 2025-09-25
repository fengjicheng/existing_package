*&---------------------------------------------------------------------*
* Include           ZQTCN_TEMPLATE_MAINTAIN_TOP
* PROGRAM DESCRIPTION: File layout maintain Data declaration
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*

  TYPES : BEGIN OF ty_proname,                                    " Data declaration for get program name for seletion screen
            program_name TYPE zca_templates-program_name,
          END OF ty_proname.

  TYPES : BEGIN OF ty_tempname,                                   " Data declaration for get template for selection screen
            template_name TYPE zca_templates-template_name,
          END OF ty_tempname.

  TYPES : BEGIN OF ty_version,                                    " Data declaration for get version for selection screen
            version TYPE zca_templates-version,
          END OF ty_version.

  TYPES : BEGIN OF ty_template_data,                              " Data declaration for get template details
            program_name    TYPE zca_templates-program_name,
            template_name   TYPE zca_templates-template_name,
            version         TYPE zca_templates-version,
            active          TYPE zca_templates-active,
            upload_location TYPE zca_templates-upload_location,
            erdat           TYPE zca_templates-erdat,
            ernam           TYPE zca_templates-ernam,
            erzet           TYPE zca_templates-erzet,
            aedat           TYPE zca_templates-aedat,
            aenam           TYPE zca_templates-aenam,
            cputm           TYPE zca_templates-cputm,
            wricef_id       TYPE zca_templates-wricef_id,
            comments        TYPE zca_templates-comments,
            file_type       TYPE zca_templates-file_type,
          END OF ty_template_data,
          tt_template_data TYPE STANDARD TABLE OF ty_template_data INITIAL SIZE 0.

  TYPES : BEGIN OF ty_recordcount,                                " select number of record
            program_name  TYPE zca_templates-program_name,
            template_name TYPE zca_templates-template_name,
            version       TYPE zca_templates-version,
            active        TYPE zca_templates-active,
          END OF ty_recordcount.

  DATA : i_template_data  TYPE tt_template_data.

  DATA : i_recordcount TYPE STANDARD TABLE OF ty_recordcount.       " Data declaration for record count Itab

  DATA : i_return  TYPE STANDARD TABLE OF ddshretval,               " Data declaration for F4 search help return value table
         st_return TYPE ddshretval.

  DATA : ok_code TYPE sy-ucomm.                                     " data declaration for screen clicks


  TYPES : BEGIN OF ty_control_data,                                 " Data declaration for get template details from screen
            program_name    TYPE zca_templates-program_name,
            template_name   TYPE zca_templates-template_name,
            version         TYPE zca_templates-version,
            active          TYPE zca_templates-active,
            upload_location TYPE zca_templates-upload_location,
            erdat           TYPE zca_templates-erdat,
            ernam           TYPE zca_templates-ernam,
            erzet           TYPE zca_templates-erzet,
            aedat           TYPE zca_templates-aedat,
            aenam           TYPE zca_templates-aenam,
            cputm           TYPE zca_templates-cputm,
            wricef_id       TYPE zca_templates-wricef_id,
            comments        TYPE zca_templates-comments,
            file_type       TYPE zca_templates-file_type,
          END OF ty_control_data.

  DATA : st_control_data            TYPE ty_control_data,          " data declaration for screen fields
         st_control_data_dupliacate TYPE ty_control_data,          " data declaration for screen value changes identify
         v_dataupdated              TYPE char1,
         st_previous_data           TYPE ty_control_data,          " data declaration for previous data identification
         st_active_data             TYPE ty_control_data.          " data declaration for current active data

  DATA : rb_viewdata TYPE char1 VALUE 'X',                         " RAdio button for both view and update data in the screen 2000
         rb_upddata  TYPE char1.

  DATA : v_name        TYPE zca_templates-program_name,                  " Global variable for program name
         v_tname       TYPE zca_templates-template_name,                 " Global variable for Template name
         v_recordcount TYPE i.                                     " Global varible for itab record count

  DATA :   i_dynpro_values TYPE TABLE OF dynpread.                 " Data declaration for Read screen field value
  FIELD-SYMBOLS : <gfs_dynpro_values> TYPE dynpread.

  DATA : lbl_version(4) TYPE n,                                    " Model dialog box label name(active to inactive scenario)
         lbl_t5(4)      TYPE n.                                    " Model dialog box label name(deactive to active scenario)

  DATA: i_fieldcat  TYPE STANDARD TABLE OF lvc_s_fcat,             " Fieldcat for Report output
        st_fieldcat TYPE lvc_s_fcat.

  DATA : v_grid         TYPE REF TO cl_gui_alv_grid,               " Data declaration for report output grid
         v_con_report   TYPE scrfname VALUE 'CC_REPORT',           " data declaration for report output custom container
         v_cc_reportout TYPE REF TO cl_gui_custom_container,       " Data declaration for custom container
         st_layout      TYPE lvc_s_layo.                           " ALV layout

  CONSTANTS : c_msgty_e TYPE char1 VALUE 'E',                      " Error messege
              c_msgty_i TYPE symsgty VALUE 'I',                    " Message Type: (I)nformation
              c_msgty_s TYPE symsgty VALUE 'S'.                    " (S)Succesful messege type
