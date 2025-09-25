*&---------------------------------------------------------------------*
*&  Include  ZXF06TOP
*&---------------------------------------------------------------------*

TYPES:
  BEGIN OF ty_glbl_flds,
    src_cmp_cd TYPE bukrs,                                 "Source Company Code
    trg_cmp_cd TYPE bukrs,                                 "Target Company Code
    gl_account TYPE saknr,                                 "G/L Account
    prft_cntr  TYPE prctr,                                 "Profit Center
*   Begin of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
    bill_type  TYPE fkart,                                 "Billing Type
*   End   of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
*   Begin of ADD:ERP-7156:WROY:27-Mar-2018:ED2K911634
    ic_bl_doc  TYPE kidno,                                 "Payment Reference (IC Billing Document)
*   End   of ADD:ERP-7156:WROY:27-Mar-2018:ED2K911634
*Begin of Add:ERP-6317:Agudurkhad:28-June-2018:ED2K912177
    belnr      TYPE  edi_belnr,
    datum      TYPE  edidat8,
*End of Add:ERP-6317:Agudurkhad:28-June-2018:ED2K912177
* Begin of Change:INC0301604:NPALLA:08-Aug-2020:ED1K912104
    vgbel      TYPE  vgbel,
    vgpos      TYPE  vgpos,
* End of Change:INC0301604:NPALLA:08-Aug-2020:ED1K912104
  END OF ty_glbl_flds.

TYPES: BEGIN OF ty_vbfa_sub,
         vbelv   TYPE vbeln_von,
         posnv   TYPE posnr_von,
         vbeln   TYPE vbeln_nach,
         posnn   TYPE posnr_nach,
         vbtyp_v TYPE vbtyp_n,
       END OF ty_vbfa_sub.

DATA:
  st_glbl_flds TYPE ty_glbl_flds.

CONSTANTS:
  c_id_line_tx TYPE buzid    VALUE 'T'.                    "Identification of the Line Item
