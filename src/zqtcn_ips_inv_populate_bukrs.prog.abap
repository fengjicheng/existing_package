*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_IPS_INV_POPULATE_BUKRS
* PROGRAM DESCRIPTION: Include program will determine
*                       1. Company code from IDOC data
*                       2. Process the IDOC data and populate additional
*                          segments as per line item qunatity and amt
*                       3. Set the global variable data which is used during
*                          further invoice processing
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
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
CONSTANTS : lc_seg_e1edk14      TYPE edilsegtyp VALUE 'E1EDK14',             " Segment type
            lc_qualf_011        TYPE edi_qualfo VALUE '011',                 " IDOC qualifer organization
            lc_seg_pdf_filename TYPE edilsegtyp VALUE 'Z1QTC_INV_ATTCH_01',  " Segment type
            lc_seg_pdf_content  TYPE edilsegtyp VALUE 'Z1QTC_ATTCH_CONT_01'. " Segment type

DATA : lst_e1edk14_data     TYPE e1edk14,                 " IDoc: Document Header Organizational Data
       lst_seg_pdf_filename TYPE z1qtc_inv_attch_01,      " I0353 - Segment for IPS invoice attachment File Name
       lst_seg_pdf_content  TYPE z1qtc_attch_cont_01,     " I0353 - IPS Inovice Interface-Segment for Attachment content
       li_bin_content       TYPE STANDARD TABLE OF tdline " Text Line
                                INITIAL SIZE 0,
       lv_filename          TYPE char100,                 " Filename of type CHAR100
       lv_error_flg         TYPE char01.                  " Error_flg of type CHAR01

IF t_idoc_data IS NOT INITIAL.

  LOOP AT t_idoc_data ASSIGNING FIELD-SYMBOL(<lfs_idoc_data>).

    CASE <lfs_idoc_data>-segnam.

      WHEN lc_seg_e1edk14.

        lst_e1edk14_data = <lfs_idoc_data>-sdata.

        IF lst_e1edk14_data-qualf EQ lc_qualf_011.

          e_bukrs = lst_e1edk14_data-orgid.
          e_lifnr = i_lifnr.
          e_change = abap_true.

        ENDIF. " IF lst_e1edk14_data-qualf EQ lc_qualf_011

      WHEN lc_seg_pdf_content.

        lst_seg_pdf_content = <lfs_idoc_data>-sdata.

        APPEND lst_seg_pdf_content-attcontent TO li_bin_content.

        CLEAR lst_seg_pdf_content.

      WHEN lc_seg_pdf_filename.

        lst_seg_pdf_filename = <lfs_idoc_data>-sdata.

        lv_filename = lst_seg_pdf_filename-filename.

      WHEN OTHERS.

    ENDCASE.

  ENDLOOP. " LOOP AT t_idoc_data ASSIGNING FIELD-SYMBOL(<lfs_idoc_data>)

  CALL FUNCTION 'ZQTC_MODIFY_IDOC_DATA_IPS'
    IMPORTING
      ex_error     = lv_error_flg
    CHANGING
      ct_idoc_data = t_idoc_data[].

  IF lv_error_flg IS NOT INITIAL.

    RAISE error_message.

  ENDIF. " IF lv_error_flg IS NOT INITIAL


  CALL FUNCTION 'ZQTC_SET_MESCOD_IPS_I0353'
    EXPORTING
      im_mescod = i_idoc_contrl-mescod.


  CALL FUNCTION 'ZQTC_SET_BIN_CONTENT_IPS_I0353'
    EXPORTING
      it_bin_content = li_bin_content[]
      im_filename    = lv_filename.


  CALL FUNCTION 'ZQTC_SET_IDOC_DATA_IPS_I0353'
    EXPORTING
      it_data_idoc = t_idoc_data[].


ENDIF. " IF t_idoc_data IS NOT INITIAL
