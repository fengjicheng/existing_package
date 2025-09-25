*&---------------------------------------------------------------------*
*&  Include           ZRTRR_ADVANCE_PAYMENT_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS : slis.    "Type pOlls for LAV
*----------------------------------------------------------------------*
*---------Structures Declarations
*----------------------------------------------------------------------*
TYPES :
*--*Structure for Ouput
  BEGIN OF ty_output,
    proforma             TYPE    vbeln_vf,  "Proforma number
    payer                TYPE    kunrg,     "Payer
    payer_name           TYPE    name1_gp,  "Payer name
    salesrep_name        TYPE    name1_gp,  "Sales Rep
    contract             TYPE    vbeln,     "Contract number
    proforma_status	     TYPE	   char4,     "Proforma Status
    fksto                TYPE    char4,     "Invoice cancellation status
    accounting_clerk     TYPE    busab,     "Collector
    clear_name           TYPE    sname_001s, "Collector name
    proforma_create_date TYPE    erdat,     "Proforma Creadted date
    total_due_amount     TYPE    netwr_ap,  "Total Due amount
    proforma_currency    TYPE    waers,     "Profroma Currency
    last_send_date       TYPE    erdat,     "Last remainder sent date
    payment_term_key     TYPE    dzterm,    "Payment terms key
    no_of_days           TYPE    dztage,    "No. Of days
    due_date             TYPE    kdatu,     "Due date
    pay_value            TYPE    netwr_ap,  "Paymet Value
    payment_date         TYPE    kdatu,     "Payment date
    payment_doc          TYPE    vbeln_vf,  "Payment doc(Latest Invoice)
    invoice              TYPE    vbeln_vf,  "Invoice
    sales_org            TYPE    vkorg,     "Sales Org
    po_number            TYPE    bstnk,     "PO Number
    po_date              TYPE    bstdk,     "PO date
    no_of_reminders      TYPE    numc4,     "no. of reminders sent
    performa_cancel      TYPE    vbeln,      "Camcelled Proforma
  END OF ty_output.
*--*Structure to hold CDS view data
TYPES : BEGIN OF ty_cds,
          proforma             TYPE    vbeln_vf,   "Proforma number
          proforma_item        TYPE    posnr,      "Proforma Item
          proforma_create_date TYPE    erdat,      "Proforma Creadted date
          payer                TYPE    kunrg,      "Payer
          payer_name           TYPE    name1_gp,   "Payer name
          sales_org            TYPE    vkorg,      "Sales Org
          po_number            TYPE    bstnk,      "PO Number
          po_date              TYPE    bstdk,      "PO date
          accounting_clerk     TYPE    busab,      "Collector
          clear_name           TYPE    sname_001s, "Collector name
          contract             TYPE    vbeln,      "Contract number
          contract_item        TYPE    posnr,      "Contract Item
          salesrep_name        TYPE    name1_gp,   "Sales Rep
          total_due_amount     TYPE    netwr_ap,   "Total Due amount
          proforma_currency    TYPE    waers,      "Profroma Currency
          last_send_date       TYPE    erdat,      "Last remainder sent date
          message_type         TYPE    char4,      "Message type
          pay_value            TYPE    netwr_ap,   "Paymet Value
          payment_date         TYPE    kdatu,      "Payment date
          payment_term_key     TYPE    dzterm,     "Payment terms key
          no_of_days           TYPE    dztage,     "No. Of days
          proforma_status	     TYPE	   rfbsk,      "Proforma Status
          message_date         TYPE    na_erdat,   "Message date
          message_time         TYPE    na_eruhr,   "Message Time
          vbelv	               TYPE    vbelv,       "Contract
          posnv	               TYPE    posnv,      "Contract Item
          vbeln                TYPE    vbeln,      "Invoice
          posnn                TYPE    posnr,      "Invoice Item
          vbtyp_n              TYPE    vbtyp_n,    "Invoice type
          vbtyp_v              TYPE    c,
          stufe                TYPE    numc2,
          fksto                TYPE    c,          "Invoice status
          erdat                TYPE    erdat,      "Invoice created date
        END OF ty_cds,
*--*Structure to hold Message type data
        BEGIN OF ty_msg_type,
          proforma     TYPE vbeln_vf,              "Proforma number
          message_type TYPE    kschl,              "Message Type
        END OF ty_msg_type.
*----------------------------------------------------------------------*
*---------Variables,Structures and Internal tables delarations
*----------------------------------------------------------------------*
DATA: v_vbeln    TYPE vbrk-vbeln,                  "Variable for Proforma
      v_kunrg    TYPE kunnr,                       "Payer
      v_vkorg    TYPE vkorg,                       "Sales org
      v_vkbur    TYPE vkbur,                       "Sales Office
      v_contract TYPE vbeln_va,                    "Contract
      v_po       TYPE bstnk,                       "Customer PO
      v_inv      TYPE vbrk-vbeln,                  "Invoice
      v_datum    TYPE datum,
      v_vbtyp_n  TYPE vbtyp_n.


DATA: i_output    TYPE STANDARD TABLE OF ty_output, "Itab for final output
      i_cds       TYPE STANDARD TABLE OF ty_cds,   "Itab for CDS view data
      i_cds_tmp   TYPE STANDARD TABLE OF ty_cds,   "Temp itab for cds data
      i_msg_type  TYPE STANDARD TABLE OF ty_cds, "Itab for message types
      st_output   TYPE ty_output,                  "Work area for output
      st_cds      TYPE ty_cds,                     "Work area for CDS view
      st_msg_type TYPE ty_cds,                      "Work area for message type
      i_fcat      TYPE slis_t_fieldcat_alv,        "Itab for fcat
      i_sort      TYPE slis_t_sortinfo_alv,        "Itab to sort fields
      st_sort     TYPE slis_sortinfo_alv,        "work area for alv sort
      st_fcat     TYPE slis_fieldcat_alv,          "work area for fcat
      st_layo     TYPE slis_layout_alv.            "work area for ALV layout
*--*Constants used across the program
CONSTANTS : c_x     TYPE c VALUE 'X',                 "ABAP_TRUE
            c_m     TYPE c VALUE 'M',                 "Value M
            c_n     TYPE c VALUE 'N',                 "Value N
            c_u     TYPE c VALUE 'U',
            c_i     TYPE c VALUE 'I',
            c_eq    TYPE char2 VALUE 'EQ',
            c_e     TYPE c VALUE 'E',
            c_ic1   TYPE char4 VALUE '&IC1',
            c_va43  TYPE char4 VALUE 'VA43',
            c_vf03  TYPE char4 VALUE 'VF03',
            c_ktn   TYPE char3 VALUE 'KTN',
            c_vf    TYPE char2 VALUE 'VF',
            c_table TYPE char8 VALUE 'I_OUTPUT',
            c_yes   TYPE char4 VALUE 'YES',
            c_no    TYPE char2 VALUE 'NO'.

*----------------------------------------------------------------------*
*---------Variables,Structures and Internal tables delarations
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001.
SELECT-OPTIONS :
  s_prof FOR v_vbeln,                           "Proforma
  s_kunrg FOR v_kunrg,                          "Payer
  s_erdat FOR v_datum OBLIGATORY,               "Proforma created date
  s_vkorg FOR v_vkorg,                          "Sales org
  s_vkbur FOR v_vkbur,                          "Sales Office
  s_con FOR v_contract,                         "Contract
  s_po FOR v_po NO INTERVALS,                   "Customer PO
  s_inv FOR v_inv MODIF ID m3,                  "Invoice
  s_vbtyp FOR v_vbtyp_n NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK a1.
SELECTION-SCREEN BEGIN OF BLOCK a2 WITH FRAME TITLE text-002.
*--*Radio button profomra With invoice
PARAMETERS : rb_wt_in RADIOBUTTON GROUP gp1 DEFAULT 'X' USER-COMMAND ucom1 MODIF ID m1,
*--*Radio button Without Invoice
             rb_wo_in RADIOBUTTON GROUP gp1 MODIF ID m2,
*--*Radio button for both with and withut invoice
             rb_all   RADIOBUTTON GROUP gp1.
SELECTION-SCREEN END OF BLOCK a2.
