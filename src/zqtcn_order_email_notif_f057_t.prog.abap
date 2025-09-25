*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORDER_EMAIL_NOTIF_F057_T
*&---------------------------------------------------------------------*
TABLES: nast.     " Message Status
*        tnapr,    " Processing programs for output
*        vbap.     " Sales Document: Item Data
TYPES: BEGIN OF ty_vbak,
         vbeln TYPE vbeln,
         auart TYPE auart,
         vkorg TYPE vkorg,
         vtweg TYPE vtweg,
         spart TYPE spart,
       END OF ty_vbak,

       BEGIN OF ty_vbap,
         vbeln TYPE vbeln,
         posnr TYPE posnr,
         matnr TYPE matnr,
         arktx TYPE arktx,
         pstyv TYPE pstyv,
         uepos TYPE uepos,
         vkaus TYPE abrvw,
       END OF ty_vbap,

       BEGIN OF ty_veda,
         vbeln   TYPE	vbeln_va,
         vposn   TYPE posnr_va,
         vbegdat TYPE vbdat_veda,
         venddat TYPE vndat_veda,
       END OF ty_veda,

       BEGIN OF ty_kna1,
         kunnr TYPE kunnr,
         name1 TYPE name1_gp,
         adrnr TYPE adrnr,
       END OF ty_kna1,

       BEGIN OF ty_constant,
         devid  TYPE zdevid,                           "Development ID
         param1 TYPE  rvari_vnam,                      "ABAP: Name of Variant Variable
         param2 TYPE  rvari_vnam,                      "ABAP: Name of Variant Variable
         srno   TYPE  tvarv_numb,                      "ABAP: Current selection number
         sign   TYPE  tvarv_sign,                      "ABAP: ID: I/E (include/exclude values)
         opti   TYPE  tvarv_opti,                      "ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,               "Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high,              "Upper Value of Selection Condition
       END OF ty_constant,

       BEGIN OF ty_text_name,
         sign TYPE  tvarv_sign,
         opti TYPE  tvarv_opti,
         low  TYPE salv_de_selopt_low,
         high TYPE salv_de_selopt_high,
       END OF ty_text_name,

       BEGIN OF ty_output,
         course_name TYPE char256,
         course_no   TYPE matnr,
         lifnr       TYPE lifnr,
         int_name    TYPE name1,
         credits     TYPE char5,
         start_dt    TYPE char10,
         end_dt      TYPE char10,
       END OF ty_output,
       tt_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0.

DATA: i_vbak           TYPE STANDARD TABLE OF ty_vbak,
      i_vbap           TYPE STANDARD TABLE OF ty_vbap,
      i_veda           TYPE STANDARD TABLE OF ty_veda,
      i_constant       TYPE tt_constant,
      st_kna1          TYPE ty_kna1,
      i_output_tb      TYPE STANDARD TABLE OF ty_output,
      st_output        TYPE ty_output,
      iv_partner       TYPE lifnr,
      iv_send          TYPE adr6-smtp_addr,
      v_output_typ     TYPE sna_kschl,    " Message type
      st_vbco3         TYPE vbco3,        " Sales Doc.Access Methods: Key Fields: Document Printing
      v_unversity_text TYPE thead-tdname. "Unversity/Vendor standard text

DATA: r_output_typ TYPE fkk_rt_kschl,
      r_vkorg_f057 TYPE tdt_rg_vkorg,
      r_vtweg_f057 TYPE tdt_rg_vtweg,
      r_spart_f057 TYPE tdt_rg_spart,
      r_auart_f057 TYPE tdt_rg_auart,
      r_tdnam_f057 TYPE STANDARD TABLE OF ty_text_name,
      v_langu      TYPE syst_langu.                    " ABAP System Field: Language Key of Text Environment

DATA: v_retcode    LIKE sy-subrc,     " ABAP System Field: Return Code of ABAP Statements
      v_ent_screen TYPE c.            " Screen of type Character
CONSTANTS: c_devid      TYPE zdevid     VALUE 'F057',
           c_output_typ TYPE rvari_vnam VALUE 'OUTPUT_TYPE',
           c_vkorg      TYPE rvari_vnam VALUE 'VKORG',
           c_vtweg      TYPE rvari_vnam VALUE 'VTWEG',
           c_spart      TYPE rvari_vnam VALUE 'SPART',
           c_auart      TYPE rvari_vnam VALUE 'AUART',
           c_tdname     TYPE rvari_vnam VALUE 'TDNAME',
           c_zweh       TYPE sna_kschl  VALUE 'ZWEH', " OUTPUT  type
           c_zwel       TYPE sna_kschl  VALUE 'ZWEL', " OUTPUT  type
           c_st         TYPE thead-tdid VALUE 'ST',
           c_language   TYPE thead-tdspras  VALUE 'E',                   "Language
           c_object     TYPE thead-tdobject VALUE 'TEXT',
           c_greetings  TYPE thead-tdname   VALUE 'ZQTC_GREETING_SECTION_F057'.
