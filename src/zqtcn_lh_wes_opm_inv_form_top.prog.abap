*&---------------------------------------------------------------------*
*&  Include           ZQTCN_LH_WES_OPM_INV_FORM_TOP
*&---------------------------------------------------------------------*

TABLES : tnapr,    " Processing programs for output
         nast,     " Message Status
         toa_dara. " SAP ArchiveLink structure of a DARA line

TYPES: BEGIN OF ty_count,
         maktx TYPE maktx,                      " Material Description
         kdmat TYPE kdmat,                      " Customer Material
         vkaus TYPE vkaus,                      " Unused - Reserve Length 3
         pstyv TYPE pstyv,                      " Sales document item category
         vbeln TYPE vbeln,                      " Billing Document Number
         posnr TYPE posnr,                      " Billing Document Item
         arktx TYPE arktx,                      " Short text for sales order item
       END OF ty_count.

DATA:       li_makt               TYPE STANDARD TABLE OF makt,                      " Material Descriptions
            li_adrc               TYPE STANDARD TABLE OF adrc,                      " Addresses (Business Address Services)
            li_t001z              TYPE STANDARD TABLE OF t001z,                     " Additional Specifications for Company Code
            li_vbrk               TYPE STANDARD TABLE OF vbrk,                      " Billing Document: Header Data
            li_adrc_part          TYPE STANDARD TABLE OF adrc,                      " Addresses (Business Address Services)
            li_kna1               TYPE STANDARD TABLE OF kna1,                      " General Data in Customer Master
            li_tvlvt              TYPE STANDARD TABLE OF tvlvt,                     " Release order usage ID: Texts
            li_t001               TYPE STANDARD TABLE OF t001,                      " Company Codes
            li_count              TYPE STANDARD TABLE OF ty_count,                  " Total Counts
            li_bil_invoice        TYPE lbbil_invoice,                               " Billing Data: Transfer Structure to Smart Forms
            li_output             TYPE ztqtc_output_supp_retrieval,                 " Table Type for ZSTQTC_OUTPUT_SUPP_RETRIEVAL
            li_hdr_itm            TYPE zstqtc_lh_opm_hdr_itm_f046,                  " Structure for LH/OPM Invoice Header and Item Data
            li_itm_gen            TYPE ztqtc_lh_opm_item_f046,                      " Table type for LH/OPM Invoice Item Data
            li_print_data_to_read TYPE lbbil_print_data_to_read,                    " Select. of Tables to be Compl. for Printing RD00;SmartForms
            st_address            TYPE zstqtc_add_f037,                             " Structure for address node
            st_formoutput         TYPE fpformoutput,                                " Form Output (PDF, PDL)
            repeat(1)             TYPE c,                                           " Repeat
            nast_anzal            LIKE nast-anzal,                                  " Number of outputs (Orig. + Cop.)
            nast_tdarmod          LIKE nast-tdarmod,                                " Archiving only one time
            v_division            TYPE char30,                                      " Sales Org Division
            v_fkimg               TYPE char20,                                      " Billing Qty
            lst_itm_gen           TYPE zstqtc_lh_opm_itm_f046,                      " Structure for LH/OPM Invoice Item Data
            lst_count             TYPE ty_count,                                    " Total Counts
            v_kzwi5               TYPE kzwi5,                                       " Subtotal 5 from pricing procedure for condition
            v_formname            TYPE fpname,                                      " Formname.
            v_ent_retco           LIKE sy-subrc,                                    " ABAP System Field: Return Code of ABAP Statements
            v_ent_screen          TYPE c,                                           " Screen of type Character
            v_send_email          TYPE ad_smtpadr,                                  " E-Mail Address
            v_output_typ          TYPE sna_kschl,                                   " Message type
            g_language            LIKE sy-langu,                                    " Lang
            v_logo                TYPE salv_de_selopt_low,                          " Lower Value of Selection Condition
            v_bmp                 TYPE xstring.                                     " Bitmap
CONSTANTS : c_zopm_form_name TYPE fpname   VALUE 'ZQTC_FRM_LH_OPM_INVOICE_F046',    " OPM form layout
            c_zsga_form_name TYPE fpname   VALUE 'ZQTC_FRM_LH_SG_AG_INVOICE_F046',  " SG/AG Form
            c_zopm           TYPE char4    VALUE 'ZOPM',                            " OPM output
            c_zsga           TYPE char4    VALUE 'ZSGA',                            " SG/AG output
            c_zprg           TYPE pstyv    VALUE 'ZPRG',                            " Item Cat
            c_cust_mail      TYPE char20   VALUE 'WES@wiley.com',                   " Customer service mail id
            c_tax_text       TYPE char15   VALUE 'Tax Exempt',                      " Tax exempt text
            c_re             TYPE parvw    VALUE 'RE',                              " Partner Function
            c_we             TYPE parvw    VALUE 'WE',                              " Partner Function
            c_attn           TYPE char4    VALUE 'Attn',                            " Attn
            c_colen          TYPE char1    VALUE ':',                               " Coolen
            c_vbbk           TYPE tdobject VALUE 'VBBK',                            " Text object
            c_0007           TYPE tdid     VALUE '0007',                            " Text id
            c_devid          TYPE zdevid   VALUE 'F046'.                            " Dev ID
