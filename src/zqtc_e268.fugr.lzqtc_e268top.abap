*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923403
* REFERENCE NO: E268
* DEVELOPER: Thilina Dimantha
* DATE: 12-May-2021
* DESCRIPTION: Add PO History related fields to ME2N ME2M Output
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923969
* REFERENCE NO: E268 / OTCM-48208
* DEVELOPER: Thilina Dimantha
* DATE: 29-June-2021
* DESCRIPTION: Output Changes for ME2M and ME2N
*-----------------------------------------------------------------------*
FUNCTION-POOL zqtc_e268.                    "MESSAGE-ID ..
*Table type for GR Document
TYPES: BEGIN OF ty_gr,
         ebeln TYPE ekbe-ebeln,      "Purchasing Doc
         ebelp TYPE ekbe-ebelp,      "Purchasing Doc Item
         belnr TYPE ekbe-belnr,      "Material Document(GR)
         budat TYPE ekbe-budat,      "Document Date(GR)
         menge TYPE ekbe-menge,      "Document Quantity(GR)
         bwart TYPE ekbe-bwart,      "Movement Type(GR)
       END OF ty_gr.
*Table type for IR Document
TYPES: BEGIN OF ty_ir,
         ebeln TYPE ekbe-ebeln,      "Purchasing Doc
         ebelp TYPE ekbe-ebelp,      "Purchasing Doc Item
         belnr TYPE ekbe-belnr,      "Material Document(IR)
         budat TYPE ekbe-budat,      "Document Date(IR)
         menge TYPE ekbe-menge,      "Document Quantity(IR)
         dmbtr TYPE ekbe-dmbtr,      "Doc Local Amount(IR)
         waers TYPE ekbe-waers,      "Document Currency(IR)
       END OF ty_ir.

DATA: i_table_pur      TYPE ztqtc_merep_outtab_purchdoc,    "Temporary table for Basic view
      i_table_pur_dis  TYPE ztqtc_merep_outtab_purchdoc,    "Output table for Basic View
      ls_table_pur     TYPE zstqtc_merep_outtab_purchdoc,   "Work area for Basic View
      i_table_sche     TYPE ztqtc_merep_outtab_schedlines,  "Temporary table for Schedule line view
      i_table_sche_dis TYPE ztqtc_merep_outtab_schedlines,  "Output table for Schedule line View
      ls_table_sche    TYPE zstqtc_merep_outtab_schedlines, "Work area for Schedule line View
      i_table_acc      TYPE ztqtc_merep_outtab_accounting,  "Temporary table for Acct Assignment view
      i_table_acc_dis  TYPE ztqtc_merep_outtab_accounting,  "Display table for Acct Assignment view
      ls_table_acc     TYPE zstqtc_merep_outtab_accounting, "Work area for Acct Assignment views
      lv_index         TYPE syst-tabix,                     "Table index
*BOC ED2K924089 TDIMANTHA 13-July-2021
*      li_gr_tmp        TYPE STANDARD TABLE OF ty_gr,        "Temporary table for GR documents
*      li_ir_tmp        TYPE STANDARD TABLE OF ty_ir,        "Temporary table for IR documents
*      lv_gr_lines      TYPE i,                              "Line count of GR temp table
*      lv_ir_lines      TYPE i,                              "Line count for IR temp table
*EOC ED2K924089 TDIMANTHA 13-July-2021
*BOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
      ir_ir_cat        TYPE TABLE OF bewtp_ran,             "Range Table: IR Document Category
      ir_gr_cat        TYPE TABLE OF bewtp_ran,             "Range Table: GR Document Category
      ir_ir_typ        TYPE TABLE OF vgabe_ran,             "Range Table: IR Document Type
      ir_gr_typ        TYPE TABLE OF vgabe_ran,             "Range Table: GR Document Type
*EOI OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*BOI ED2K924089 TDIMANTHA 13-July-2021
      lv_indx_gr    TYPE syst-tabix,
      lv_indx_ir    TYPE syst-tabix,
      lv_no_ir_read TYPE c,
      lv_no_gr_read TYPE c,
      lv_count      TYPE i,
      lv_irrev_subrc TYPE syst-subrc.
*EOI ED2K924089 TDIMANTHA 13-July-2021


CONSTANTS: lc_base TYPE syst-ucomm VALUE 'MEBASE',     "Basic View
      lc_me2m TYPE syst-tcode VALUE 'ME2M',            "Transaction ME2M
      lc_schedule TYPE syst-ucomm VALUE 'MESCHEDULE',  "Schedule line view
      lc_account  TYPE syst-ucomm VALUE 'MEACCOUNT',   "Acct assignment View
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*      lc_gr TYPE ekbe-vgabe VALUE '1',                "GR Document type
*      lc_ir TYPE ekbe-vgabe VALUE '2',                "IR Document type
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
      lc_debit TYPE ekbe-shkzg VALUE 'S'.
*BOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
*      lc_grcat TYPE ekbe-bewtp VALUE 'E',
*      lc_ircat TYPE ekbe-bewtp VALUE 'Q'.             "Debit/Credit Indicator
*EOC OTCM-48208 TDIMANTHA 29-June-2021 ED2K923969
* INCLUDE LZQTC_E268D...                     " Local class definition
