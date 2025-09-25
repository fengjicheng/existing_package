*&---------------------------------------------------------------------*
*&  Include  ZQTCN_DUPLICATE_ORDER_CHECK
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        QTCN_DUPLICATE_ORDER_CHECK(Include Program)
* PROGRAM DESCRIPTION: points:Copy control between order types ZGRC and ZSRO
* Create a routine to check if there is a renewal sub created for the
* main sub/rew by main subscription.
* DEVELOPER:           Prabhu(PTUFARAM)
* CREATION DATE:       1/31/2019
* OBJECT ID:           E142
* TRANSPORT NUMBER(S): ED2K914401
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910816
* REFERENCE NO:
* DEVELOPER: SKKAIRAMKO
* DATE: 08/7/2019
* DESCRIPTION: Changed message type delcaration.
*----------------------------------------------------------------------*
TYPES : BEGIN OF ty_issue,
          vbeln	         TYPE vbeln,           "Sales and Distribution Document Number
          posnr	         TYPE posnr,           "Item number of the SD document
          issue	         TYPE ismmatnr_issue,  "Media Issue
          product	       TYPE ismmatnr_product, "Media Product
          sequence       TYPE	jmsequence,      "IS-M: Sequence
          xorder_created TYPE jmorder_created, "IS-M: Indicator Denoting that Order Was Generated
        END OF ty_issue,
        BEGIN OF ty_vbfa,
          vbelv	  TYPE vbeln_von,            "Preceding sales and distribution document
          posnv	  TYPE posnr_von,            "Preceding item of an SD document
          vbeln	  TYPE vbeln_nach,           "Subsequent sales and distribution document
          posnn	  TYPE posnr_nach,           "Subsequent item of an SD document
          vbtyp_n	TYPE vbtyp_n,              "Document category of subsequent document
        END OF ty_vbfa,

        BEGIN OF ty_vbap,
          vbeln TYPE vbeln_va,
          posnr TYPE posnr_va,
          uepos TYPE uepos,
        END OF ty_vbap.

DATA : lv_vbeln       TYPE vbeln,
*       li_doc_flow    TYPE tdt_docflow,
*       lst_doc_flow   TYPE tds_docflow,
       li_issue       TYPE STANDARD TABLE OF ty_issue,
       lst_issue      TYPE ty_issue,
*       lst_comwa      TYPE vbco6,
       li_vbfa        TYPE STANDARD TABLE OF ty_vbfa,
       lst_vbak       TYPE vbak,
       lst_vbfa       TYPE ty_vbfa,
       lst_vbap       TYPE ty_vbap,
       lv_return_code TYPE sy-subrc.




CONSTANTS: lc_g     TYPE c     VALUE 'G',
           lc_01(2) TYPE c     VALUE '01',
           lc_zrew  TYPE auart VALUE 'ZREW'.

*--------------------------------------------------------------------*

*CLEAR:lv_return_code.

lv_return_code = bp_subrc. "++skkairamko ED1K910791



IF vbap-vgbel IS NOT INITIAL.
*--Check if ZREW order is already exits, then stop creation of ZSRO for ZGRC
  SELECT SINGLE   vbelv
                  posnv
                  vbeln
                  posnn
                  vbtyp_n INTO lst_vbfa FROM vbfa WHERE vbelv = vbap-vgbel
                                                    AND posnv = vbap-vgpos
                                                    AND vbtyp_n = lc_g
                                                    AND stufe = lc_01.



 ELSE. " No reference document found for item then

*--Get the referece document from header & main item for which media issued
*-- In case of BOM item
   IF sy-subrc EQ 0.

       SELECT SINGLE vbelv
                  posnv
                  vbeln
                  posnn
                  vbtyp_n INTO lst_vbfa FROM vbfa WHERE vbelv = vbak-vgbel
                                                    AND posnv = vbap-posnr
                                                    AND vbtyp_n = lc_g
                                                    AND stufe = lc_01.

   ENDIF.

 ENDIF.


IF sy-subrc EQ 0.
*--Check if the document found is renewal document (ZREW).
      SELECT SINGLE *
        FROM vbak
        INTO lst_vbak
         WHERE vbeln EQ lst_vbfa-vbeln AND
              auart EQ lc_zrew.

    IF sy-subrc EQ 0.
*      lv_return_code = 4. "Stop Releae order creation
*--BOC: SKKAIRAMKO - ED1K910816
*       bp_subrc  = 4.
*      MESSAGE  'Renewal order already Created' TYPE 'E'.
      bp_subrc = 4.
*      MESSAGE ID 'ZQTC_R2' TYPE 'E' NUMBER '561'.
*--EOC: SKKAIRAMKO - ED1K910816
      ELSE.
*      lv_return_code = 0.
       bp_subrc = lv_return_code.
    ENDIF.

    ELSE.  "if not document found
*      lv_return_code = 0.
      bp_subrc = lv_return_code. "++ skkairamko ED1K910791
  ENDIF.
