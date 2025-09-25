*&---------------------------------------------------------------------*
*&  Include           ZQTCN_IPS_INV_POP_I0379_001
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_IPS_INV_POP_I0379_001
* PROGRAM DESCRIPTION: Include program will determine
*                       1. Company code from IDOC data
*                       2. Process the IDOC data and populate additional
*                          segments as per line item qunatity and amt
*                       3. Set the global variable data which is used during
*                          further invoice processing
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-03-01
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*

*constant data declaration
CONSTANTS : lc1_seg_e1edk14      TYPE edilsegtyp VALUE 'E1EDK14',             " Segment type
            lc1_qualf_011        TYPE edi_qualfo VALUE '011',                 " IDOC qualifer organization
            lc1_seg_pdf_filename TYPE edilsegtyp VALUE 'Z1QTC_INV_ATTCH_01',  " Segment type
            lc1_seg_pdf_content  TYPE edilsegtyp VALUE 'Z1QTC_ATTCH_CONT_01'. " Segment type

DATA : lst1_e1edk14_data     TYPE e1edk14,                 " IDoc: Document Header Organizational Data
       lst1_seg_pdf_filename TYPE z1qtc_inv_attch_01,      " I0353 - Segment for IPS invoice attachment File Name
       lst1_seg_pdf_content  TYPE z1qtc_attch_cont_01,     " I0353 - IPS Inovice Interface-Segment for Attachment content
       li1_bin_content       TYPE STANDARD TABLE OF tdline " Text Line
                                INITIAL SIZE 0,
       lv1_filename          TYPE char100,                 " Filename of type CHAR100
       lv1_error_flg         TYPE char01.                  " Error_flg of type CHAR01

IF t_idoc_data IS NOT INITIAL.

  LOOP AT t_idoc_data ASSIGNING FIELD-SYMBOL(<lfs1_idoc_data>).

    CASE <lfs1_idoc_data>-segnam.

      WHEN lc1_seg_e1edk14.

        lst1_e1edk14_data = <lfs1_idoc_data>-sdata.

        IF lst1_e1edk14_data-qualf EQ lc1_qualf_011.

          e_bukrs = lst1_e1edk14_data-orgid.
          e_lifnr = i_lifnr.
          e_change = abap_true.

        ENDIF. " IF lst_e1edk14_data-qualf EQ lc_qualf_011

      WHEN lc1_seg_pdf_content.

        lst1_seg_pdf_content = <lfs1_idoc_data>-sdata.

        APPEND lst1_seg_pdf_content-attcontent TO li1_bin_content.
        CLEAR lst1_seg_pdf_content.

      WHEN lc1_seg_pdf_filename.
        lst1_seg_pdf_filename = <lfs1_idoc_data>-sdata.
        lv1_filename = lst1_seg_pdf_filename-filename.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP. " LOOP AT t_idoc_data ASSIGNING FIELD-SYMBOL(<lfs_idoc_data>)

  CALL FUNCTION 'ZQTC_MODI_IDOC_DATA_IPS_I0379'
    IMPORTING
      ex_error     = lv1_error_flg
    CHANGING
      ct_idoc_data = t_idoc_data[].

  IF lv1_error_flg IS NOT INITIAL.

    RAISE error_message.

  ENDIF. " IF lv_error_flg IS NOT INITIAL


  CALL FUNCTION 'ZQTC_SET_MESCOD_IPS_I0379'
    EXPORTING
      im_mescod = i_idoc_contrl-mescod.


  CALL FUNCTION 'ZQTC_SET_BIN_CONTENT_IPS_I0379'
    EXPORTING
      it_bin_content = li1_bin_content[]
      im_filename    = lv1_filename.


  CALL FUNCTION 'ZQTC_SET_IDOC_DATA_IPS_I0379'
    EXPORTING
      it_data_idoc = t_idoc_data[].


ENDIF. " IF t_idoc_data IS NOT INITIAL
