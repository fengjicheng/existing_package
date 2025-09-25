 ##TEXT_USE
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MATERIAL_FREEGOODS_UPLD
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MATERIAL_FREEGOODS_UPLD
*& PROGRAM DESCRIPTION:   Material free goods upload interface based on file Input
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         10/16/2019
*& OBJECT ID:             C111
*& TRANSPORT NUMBER(S):   ED2K916178
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
 REPORT zqtcr_material_freegoods_upld NO STANDARD PAGE
                                     HEADING MESSAGE-ID zqtc_r2.
 TYPES: BEGIN OF lty_file_data,
          kschl  TYPE  kschn,
          vkorg  TYPE  vkorg,
          spart  TYPE  spart,
          matnr  TYPE  matnr,
          datbi  TYPE  char10,
          datab  TYPE  char10,
          knrmm	 TYPE  knrmm,
          knrnm	 TYPE  knrnm,
          knrme	 TYPE  char3,
          knrzm  TYPE  knrzm,
          knrez  TYPE  char3,
          knrmat TYPE	 knrmat,
          knrrr	 TYPE  knrrr,
          knrdd  TYPE  knrdd,
        END OF lty_file_data.
 DATA:li_type      TYPE truxs_t_text_data,
      li_file_data TYPE STANDARD TABLE OF lty_file_data,
      li_bdcdata   LIKE bdcdata    OCCURS 0 WITH HEADER LINE,
      li_messtab   TYPE STANDARD TABLE OF bdcmsgcoll.
 SELECTION-SCREEN: BEGIN OF BLOCK  b1 WITH FRAME TITLE text-001.
 PARAMETERS: p_file LIKE rlgrap-filename OBLIGATORY.
 SELECTION-SCREEN: END OF BLOCK b1.

 AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
   CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
     CHANGING
       file_name     = p_file
     EXCEPTIONS
       mask_too_long = 1
       OTHERS        = 2.
   IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
   ENDIF.

 START-OF-SELECTION.
*--foreground file fetching into internal table

   CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
     EXPORTING
       i_line_header        = abap_true
       i_tab_raw_data       = li_type
       i_filename           = p_file
     TABLES
       i_tab_converted_data = li_file_data
     EXCEPTIONS
       conversion_failed    = 1
       OTHERS               = 2.

   IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
   ENDIF.

 END-OF-SELECTION.
   LOOP AT li_file_data INTO DATA(lst_file_data).

     FREE:li_bdcdata.
     PERFORM bdc_dynpro      USING 'SAPMV13N' '0100'.
     PERFORM bdc_field       USING 'BDC_CURSOR'
                                   'N000-KSCHL'.
     PERFORM bdc_field       USING 'BDC_OKCODE'
                                   '/00'.
     PERFORM bdc_field       USING 'N000-KSCHL'
                                   lst_file_data-kschl."'ZNA0'.
     PERFORM bdc_dynpro      USING 'SAPMV13N' '1900'.
     PERFORM bdc_field       USING 'BDC_CURSOR'
                                   'KOMG-VKORG'.
     PERFORM bdc_field       USING 'BDC_OKCODE'
                                   '=DRAU'.
     PERFORM bdc_field       USING 'KOMG-VKORG'
                                   lst_file_data-vkorg."'1030'.
     PERFORM bdc_field       USING 'KOMG-SPART'
                                   lst_file_data-spart."'30'.
     PERFORM bdc_field       USING 'N000-DATAB'
                                   lst_file_data-datab."'10/16/2019'.
     PERFORM bdc_field       USING 'N000-DATBI'
                                   lst_file_data-datbi."'12/31/9999'.
     PERFORM bdc_dynpro      USING 'SAPMV13N' '2900'.
     PERFORM bdc_field       USING 'BDC_CURSOR'
                                   'KONDN-KNRMAT(01)'.
     PERFORM bdc_field       USING 'BDC_OKCODE'
                                   '=SICH'.
*     PERFORM bdc_field       USING 'KOMG-VKORG'
*                                   lst_file_data-kschl."'1030'.
*     PERFORM bdc_field       USING 'KOMG-SPART'
*                                   lst_file_data-kschl."'30'.
*     PERFORM bdc_field       USING 'N000-DATAB'
*                                   lst_file_data-kschl."'10/16/2019'.
*     PERFORM bdc_field       USING 'N000-DATBI'
*                                   lst_file_data-kschl."'12/31/9999'.
     PERFORM bdc_field       USING 'KOMG-MATNR(01)'
                                   lst_file_data-matnr."'101542237'.
     PERFORM bdc_field       USING 'MV13N-DISPKNRMM(01)'
                                   lst_file_data-knrmm."'            1'.
     PERFORM bdc_field       USING 'MV13N-DISPKNRNM(01)'
                                   lst_file_data-knrnm."'            1'.
     PERFORM bdc_field       USING 'KONDN-KNRME(01)'
                                   lst_file_data-knrme."'EA'.
     PERFORM bdc_field       USING 'MV13N-DISPKNRZM(01)'
                                   lst_file_data-knrzm."'            1'.
     PERFORM bdc_field       USING 'KONDN-KNREZ(01)'
                                   lst_file_data-knrez."'EA'.
     PERFORM bdc_field       USING 'KONDN-KNRRR(01)'
                                   lst_file_data-knrrr."'1'.
     PERFORM bdc_field       USING 'KONDN-KNRDD(01)'
                                   lst_file_data-knrdd."'2'.
     PERFORM bdc_field       USING 'KONDN-KNRMAT(01)'
                                    lst_file_data-knrmat."'7000015402'.
     CALL TRANSACTION 'VBN1' USING  li_bdcdata UPDATE 'A' MODE 'A' MESSAGES INTO  li_messtab.

   ENDLOOP.

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
 FORM bdc_dynpro USING program dynpro.
   CLEAR li_bdcdata.
   li_bdcdata-program  = program.
   li_bdcdata-dynpro   = dynpro.
   li_bdcdata-dynbegin = 'X'.
   APPEND li_bdcdata.
 ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
 FORM bdc_field USING fnam fval.

   CLEAR li_bdcdata.
   li_bdcdata-fnam = fnam.
   li_bdcdata-fval = fval.
   APPEND li_bdcdata.

 ENDFORM.
