*&---------------------------------------------------------------------*
*&  Include           ZQTCN_KNV_EDI_ORDERS
*&---------------------------------------------------------------------*
* REVISION NO   : ED2K925996
* REFERENCE NO  : EAM-8227 / I0504.1
* DEVELOPER     : Vamsi Mamillapalli (VMAMILLAPA)
* DATE          : 03/04/2022
* PROGRAM NAME  : ZQTCN_KNV_EDI_ORDERS(Include)
*                 Called from userexit_save_document_prepare(MV45AFZZ)
* DESCRIPTION   : Capture changes to Inbound Orders Interface from KNV-SAP
*-------------------------------------------------------------------------*
 TYPES: BEGIN OF ty_mara,
          matnr        TYPE matnr,        "Material
          ismmediatype TYPE ismmediatype, "Media Type
        END OF ty_mara.
 TYPES:BEGIN OF ty_vbkd,
         vbeln TYPE vbeln_va, "Sales and Distribution Document Number
         posnr TYPE posnr_va, "Item number of the SD document
         bstkd TYPE bstkd,    "Customer purchase order number
         kunnr TYPE kunag,    "Sold-to party
       END OF ty_vbkd.
 DATA: li_vbkd1   TYPE STANDARD TABLE OF ty_vbkd INITIAL SIZE 0, " Internal table for VBKD
       li_mara1   TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0, " Internal table for MATA
       lst_header TYPE thead,           " Work area for Text header
       lst_ltext  TYPE tline,           " Work Area for text lines
       li_ltext   TYPE TABLE OF tline,  " Internal table for text lines
       li_const_i0504_1 TYPE ztca_caconstants.

 CONSTANTS:
   lc_tdname        TYPE tdname     VALUE 'XXXXXXXXXX',   "Text Name-Sales order num
   lc_tdobj_h       TYPE tdobject   VALUE 'VBBK',         "Object for Sales Header texts
   lc_tdobj_i       TYPE tdobject   VALUE 'VBBP',         "Object for Sales Item texts
   lc_tdformat      TYPE tdformat   VALUE '*',            "Text format
   lc_devid_i0504_1 TYPE zdevid     VALUE 'I0504.1',      "Development ID
   lc_dig_mat_rr    TYPE rvari_vnam VALUE 'ABGRU_DIG_MAT', "Rejection code for digital materials
   lc_back_ord_rr   TYPE rvari_vnam VALUE 'ABGRU_BO',     "Rejection code for back order
   lc_cep_rr        TYPE rvari_vnam VALUE 'ABGRU_CEP',    "Reason for rejection Customer Expected Price Validation
   lc_med_typ       TYPE rvari_vnam VALUE 'ISMMEDIATYPE', "Media Type
   lc_dig_mat       TYPE rvari_vnam VALUE 'DIGITAL MATERIAL', "Digital Material
   lc_phy_mat       TYPE rvari_vnam VALUE 'PHYSICAL_MAT', "Physical Material
   lc_auart_i0504_1 TYPE rvari_vnam VALUE 'AUART',        "Order Type
   lc_bsark         TYPE rvari_vnam VALUE 'BSARK',        "PO Type
   lc_vkorg         TYPE rvari_vnam VALUE 'VKORG',        "Sales Org
   lc_vtweg         TYPE rvari_vnam VALUE 'VTWEG',        "Distribution channel
   lc_spart         TYPE rvari_vnam VALUE 'SPART',        "Division
   lc_ihrez_e       TYPE rvari_vnam VALUE 'IHREZ_E',      "First Order flag
   lc_lifsk_dpc     TYPE rvari_vnam VALUE 'LIFSP_DPC',    "Delivery block for duplicate PO
   lc_lifsk_qc      TYPE rvari_vnam VALUE 'LIFSP_QC',     "Delivery block for duplicate PO
   lc_faksk_dpc     TYPE rvari_vnam VALUE 'FAKSP_DPC',    "Billing block for duplicate PO
   lc_max_quan      TYPE rvari_vnam VALUE 'KWMENG',       "Maximum quantity allowed
   lc_cepok         TYPE rvari_vnam VALUE 'CEPOK',        "Status expected price
   lc_dp_htext      TYPE rvari_vnam VALUE 'DP_HEADER_TEXT_ID',       "Header text id for Duplicate PO
   lc_cep_itext     TYPE rvari_vnam VALUE 'CEP_ITEM_TEXT_ID'.        "Item text id for customet expected price

 IF t180-trtyp = charh. "Creation
* Fetch Publication type from ZCACONSTANTS table
*   zca_utilities=>get_constants( EXPORTING im_devid        = lc_devid_i0504_1
*                                           im_activate     = abap_true
*                                 IMPORTING et_constants    = DATA(li_const_i0504_1) ).
   SELECT *
      FROM zcaconstant
      INTO TABLE li_const_i0504_1
      WHERE devid    = lc_devid_i0504_1
        AND activate = abap_true.

* Check if Sales area, Order type,PO type maintained for I0504.1
   IF sy-subrc IS INITIAL AND
     line_exists( li_const_i0504_1[ param1 = lc_auart_i0504_1 low = vbak-auart ] )
     AND line_exists( li_const_i0504_1[ param1 = lc_vkorg low = vbak-vkorg ] )
     AND line_exists( li_const_i0504_1[ param1 = lc_vtweg low = vbak-vtweg ] )
     AND line_exists( li_const_i0504_1[ param1 = lc_spart low = vbak-spart ] ).

* Read the media type for digital materials maintained in ZCACONSTANTS
     IF line_exists( li_const_i0504_1[ param1 = lc_med_typ param2 = lc_dig_mat ] ).
       DATA(lv_med_typ_dig) = CONV ismmediatype( li_const_i0504_1[ param1 = lc_med_typ param2 = lc_dig_mat ]-low ).
     ENDIF.
     IF line_exists( li_const_i0504_1[ param1 = lc_med_typ param2 = lc_phy_mat ] ).
       DATA(lv_med_typ_phy) = CONV ismmediatype( li_const_i0504_1[ param1 = lc_med_typ param2 = lc_phy_mat ]-low ).
     ENDIF.

     DATA(li_xvbap1) = xvbap[].
     SORT li_xvbap1 BY matnr.
     DELETE ADJACENT DUPLICATES FROM li_xvbap1 COMPARING matnr.
*      Retrieve Media Type from MARA
     SELECT matnr
            ismmediatype
     FROM mara
     INTO TABLE li_mara1
     FOR ALL ENTRIES IN li_xvbap1
     WHERE matnr = li_xvbap1-matnr.
     IF sy-subrc IS INITIAL.
     ENDIF.
     IF line_exists( li_const_i0504_1[ param1 = lc_bsark low = vbak-bsark ] )."EDI Orders
*&---------------------------------------------------------------------*
*Digital Products cannot be accepted through EDI

*&---------------------------------------------------------------------*

       IF line_exists( li_const_i0504_1[ param1 = lc_dig_mat_rr ] ) AND lv_med_typ_dig IS NOT INITIAL.
*Loop for all items of the Sales Order
         LOOP AT xvbap ASSIGNING FIELD-SYMBOL(<lfs_xvbap1>).
           IF line_exists( li_mara1[ matnr = <lfs_xvbap1>-matnr ] ) AND
             li_mara1[ matnr = <lfs_xvbap1>-matnr ]-ismmediatype EQ lv_med_typ_dig."Check material is digital material
*     Update Reason for rejection maintained in ZCACONSTANT table
             <lfs_xvbap1>-abgru = li_const_i0504_1[ param1 = lc_dig_mat_rr ]-low.
           ENDIF.
         ENDLOOP.
       ENDIF.
*       ENDIF.
*&---------------------------------------------------------------------*
*Back Orders
*&---------------------------------------------------------------------*
* Read first order flag from ZCACONSTANT
       IF line_exists( li_const_i0504_1[ param1 = lc_ihrez_e ] ) AND line_exists( li_const_i0504_1[ param1 = lc_back_ord_rr ] ).
         DATA(lv_ihrez_e) = CONV ihrez_e( li_const_i0504_1[ param1 = lc_ihrez_e ]-low )."FIRSTORDER
         DATA(lv_ihrez_e2) = CONV ihrez_e( li_const_i0504_1[ param1 = lc_ihrez_e ]-high )."BACKORDER
       ENDIF.
       IF  ( lv_ihrez_e IS NOT INITIAL AND line_exists( xvbkd[ ihrez_e = lv_ihrez_e ]  ) )
         OR ( lv_ihrez_e2 IS NOT INITIAL AND line_exists( xvbkd[ ihrez_e = lv_ihrez_e2 ] ) ). "BACKORDER/FIRSTORDERR

         UNASSIGN <lfs_xvbap1>.
         LOOP AT xvbap ASSIGNING <lfs_xvbap1> WHERE abgru IS INITIAL.
           IF line_exists( xvbep[ vbeln = <lfs_xvbap1>-vbeln posnr = <lfs_xvbap1>-posnr etenr = 1 ] ) .
* If Confirmed quantity is not equal to requested quantity
*        update Back order Reason for rejection maintained in ZCACONSTANT table
             IF <lfs_xvbap1>-kwmeng NE xvbep[ vbeln = <lfs_xvbap1>-vbeln posnr = <lfs_xvbap1>-posnr etenr = 1 ]-bmeng.
               <lfs_xvbap1>-abgru = li_const_i0504_1[ param1 = lc_back_ord_rr ]-low.
             ENDIF.
           ENDIF.
         ENDLOOP.
       ENDIF.
     ENDIF.
*&---------------------------------------------------------------------*
*Duplicate PO Number Check
*&---------------------------------------------------------------------*
     IF line_exists( li_const_i0504_1[ param1 = lc_lifsk_dpc ] ) AND line_exists( li_const_i0504_1[ param1 = lc_faksk_dpc ] )
       AND vbak-bstnk IS NOT INITIAL.

       DATA(li_xvbkd1) = xvbkd[].
       SORT li_xvbkd1 BY bstkd.
       DELETE ADJACENT DUPLICATES FROM li_xvbkd1 COMPARING bstkd.
*   Check for Duplicate PO
       SELECT a~vbeln
              a~posnr
              a~bstkd
              b~kunnr
         FROM vbkd AS a JOIN vbak AS b
         ON a~vbeln = b~vbeln
         INTO TABLE li_vbkd1
         FOR ALL ENTRIES IN li_xvbkd1
         WHERE bstkd = li_xvbkd1-bstkd AND
              kunnr =  vbak-kunnr.
       IF sy-subrc IS INITIAL.
         SORT li_vbkd1 BY bstkd.
         IF line_exists( li_vbkd1[ bstkd = vbak-bstnk ] ). " If customer and PO matches
           UNASSIGN <lfs_xvbap1>.
*   if the order contains physical material update delivery block
*   if the order contains non physical material update biling block
           LOOP AT xvbap ASSIGNING <lfs_xvbap1>.
             IF line_exists( li_mara1[ matnr = <lfs_xvbap1>-matnr ] ).
               IF li_mara1[ matnr = <lfs_xvbap1>-matnr ]-ismmediatype EQ lv_med_typ_phy.
                 DATA(lv_del_block) = abap_true.
               ELSE.
                 DATA(lv_bill_block) = abap_true.
               ENDIF.
             ENDIF.
*             Exit the loop once the values are set
             IF lv_del_block IS NOT INITIAL AND lv_bill_block IS NOT INITIAL.
               EXIT.
             ENDIF.
           ENDLOOP.
           IF lv_del_block IS NOT INITIAL.
             vbak-lifsk = li_const_i0504_1[ param1 = lc_lifsk_dpc ]-low."Set Delivery block
           ENDIF.
           IF lv_bill_block IS NOT INITIAL.
             vbak-faksk = li_const_i0504_1[ param1 = lc_faksk_dpc ]-low."Set Billing block
           ENDIF.
*             Update Sales order header text with the old sales order number which has the same PO reference
           IF line_exists( li_const_i0504_1[ param1 = lc_dp_htext ] ).
             CLEAR:li_ltext[],lst_ltext,lst_header.
             lst_header-tdobject     = lc_tdobj_h.
             lst_header-tdname       = lc_tdname. "'XXXXXXXXXX'
             lst_header-tdid         = li_const_i0504_1[ param1 = lc_dp_htext ]-low.
             lst_header-tdspras      = sy-langu.
             lst_ltext-tdformat      = lc_tdformat."'*'.
             lst_ltext-tdline        = li_vbkd1[ bstkd = vbak-bstnk kunnr = vbak-kunnr ]-vbeln.
             CLEAR:li_ltext[].
             APPEND lst_ltext TO li_ltext.
             CALL FUNCTION 'SAVE_TEXT'
               EXPORTING
                 client   = sy-mandt
                 header   = lst_header
               TABLES
                 lines    = li_ltext
               EXCEPTIONS
                 id       = 1
                 language = 2
                 name     = 3
                 object   = 4
                 OTHERS   = 5.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.
*&---------------------------------------------------------------------*
*Customer Expected Price Validation and Rejection
*&---------------------------------------------------------------------*
     UNASSIGN <lfs_xvbap1>.
     LOOP AT xvbap ASSIGNING <lfs_xvbap1>.
       IF  line_exists( li_const_i0504_1[ param1 = lc_cepok ] ) AND <lfs_xvbap1>-cepok =  li_const_i0504_1[ param1 = lc_cepok ]-low
         AND line_exists( li_const_i0504_1[ param1 = lc_cep_rr ] ).
         <lfs_xvbap1>-abgru = li_const_i0504_1[ param1 = lc_cep_rr ]-low." Set reason for rejection
* Update line Item text
         IF line_exists( li_const_i0504_1[ param1 = lc_cep_itext ] ).
           CLEAR:li_ltext[],lst_ltext,lst_header.
           lst_header-tdobject     = lc_tdobj_i.
           lst_header-tdname       = |{ lc_tdname }| && |{ <lfs_xvbap1>-posnr }|. "'XXXXXXXXXX''000010'.
           lst_header-tdid         = li_const_i0504_1[ param1 = lc_cep_itext ]-low. "0002'.
           lst_header-tdspras      = sy-langu.
           lst_ltext-tdformat      = lc_tdformat."'*'.
           lst_ltext-tdline        = li_const_i0504_1[ param1 = lc_cep_itext ]-high.
           APPEND lst_ltext TO li_ltext.
           CALL FUNCTION 'SAVE_TEXT'
             EXPORTING
               client   = sy-mandt
               header   = lst_header
             TABLES
               lines    = li_ltext
             EXCEPTIONS
               id       = 1
               language = 2
               name     = 3
               object   = 4
               OTHERS   = 5.
         ENDIF.
       ENDIF.
*&---------------------------------------------------------------------*
*       Maximum Order Quantity Check
*&---------------------------------------------------------------------*
       IF line_exists( li_const_i0504_1[ param1 = lc_max_quan ] ) AND line_exists( li_const_i0504_1[ param1 = lc_lifsk_qc ] )
         AND ( <lfs_xvbap1>-kwmeng > ( CONV kwmeng( li_const_i0504_1[ param1 = lc_max_quan ]-low ) ) )."Maximum Order Quantity Check
         vbak-lifsk = li_const_i0504_1[ param1 = lc_lifsk_qc ]-low."Set Delivery block
       ENDIF.
     ENDLOOP.

   ENDIF.
 ENDIF.
