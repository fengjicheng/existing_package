*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORD_BDC_TEXT_E263_3
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ORD_BDC_TEXT_E263_3(Include Program for Methods)
* PROGRAM DESCRIPTION:
* Update Bill-to Email ID to “AR Internal Notes’ along with existing text in header text.
* Check the text with reference to object VBBK ID:0005 in idoc
* if exist append the bill to email id to the text.
* else read existing text with reference to Object: KNVV, ID:0005 and BP number
* and append the bill to email id to the text.
* DEVELOPER: mimmadiset(Murali)
* CREATION DATE:   07/12/2021
* OBJECT ID:  E263/OTCM-45037
* TRANSPORT NUMBER(S):ED2K924060
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
* TRANSPORT NUMBER(S):
*------------------------------------------------------------------- *
TYPES: BEGIN OF lty1_xe1edkt2 .
         INCLUDE STRUCTURE e1edkt1.
         INCLUDE STRUCTURE e1edkt2.
       TYPES:     END OF lty1_xe1edkt2.

CONSTANTS:
  lc_devid_e263    TYPE zdevid     VALUE 'E263',             "Devid
  lc1_e1edka1_e263 TYPE char7      VALUE 'E1EDKA1',
  lc1_e1edk01      TYPE edilsegtyp VALUE 'E1EDK01',
  lc1_email_e263   TYPE char16     VALUE 'Z1QTC_E1EDKA1_01',
  lc1_e1edkt1      TYPE edilsegtyp VALUE 'E1EDKT1',
  lc1_e1edk14      TYPE edilsegtyp VALUE 'E1EDK14',
  lc1_qualf_006    TYPE edi_qualfr VALUE '006',            " Qualf_006
  lc1_qualf_007    TYPE edi_qualfr VALUE '007',            " Qualf_007
  lc1_qualf_008    TYPE edi_qualfr VALUE '008',            " Qualf_008
  lc_bstzd_e263    TYPE rvari_vnam VALUE 'SUPPLEMENT_PO',  " SO
  lc1_star(1)      TYPE c          VALUE '*',
  lc_parvw_e263    TYPE rvari_vnam VALUE 'PARVW_EMAIL',
  lc_ag_parvw      TYPE parvw      VALUE 'AG',
  lc_text_id       TYPE rvari_vnam VALUE 'TEXT_ID',
  lc_object        TYPE rstxt-tdobject VALUE 'KNVV'.         " AR Internal Notes Text

DATA:r_supplement_po    TYPE RANGE OF salv_de_selopt_low,
     lst_e1edk01        TYPE e1edk01,
     lst_e1edkt1        TYPE e1edkt1,
     lst_e1edka1_e263   TYPE e1edka1,
     lst_e1edk14        TYPE e1edk14,
     lst1_z1qtc_e1edka1 TYPE z1qtc_e1edka1_01,
     li_tline           TYPE TABLE OF tline,          " AR Internal Notes Text
     lv_name            TYPE thead-tdname,            " Name
     lv_id              TYPE rstxt-tdid ,             " Internal Notes Text id
     r_parvw            TYPE RANGE OF salv_de_selopt_low,
     li_constants_e263  TYPE zcat_constants.           "Constant Values

FIELD-SYMBOLS:
  <lfs1_e1edkt2>      TYPE lty1_xe1edkt2.
*---Check the Constant table before going to the actual logiC.
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e263  "Development ID
  IMPORTING
    ex_constants = li_constants_e263. "Constant Values
*---Fill the respective entries which are maintain in zcaconstant.
IF li_constants_e263[] IS NOT INITIAL.
  LOOP AT li_constants_e263[] INTO DATA(lst_const_e263).
    IF lst_const_e263-param1 = lc_bstzd_e263.
      APPEND INITIAL LINE TO r_supplement_po ASSIGNING FIELD-SYMBOL(<lst_supplement_po>).
      <lst_supplement_po>-sign   = lst_const_e263-sign.
      <lst_supplement_po>-option = lst_const_e263-opti.
      <lst_supplement_po>-low    = lst_const_e263-low.
      <lst_supplement_po>-high   = lst_const_e263-high.
    ELSEIF lst_const_e263-param1 = lc_parvw_e263.
      APPEND INITIAL LINE TO r_parvw ASSIGNING FIELD-SYMBOL(<lst_parvw>).
      <lst_parvw>-sign   = lst_const_e263-sign.
      <lst_parvw>-option = lst_const_e263-opti.
      <lst_parvw>-low    = lst_const_e263-low.
      <lst_parvw>-high   = lst_const_e263-high.
    ELSEIF lst_const_e263-param1 = lc_text_id.  "Text id
      lv_id = lst_const_e263-low.
    ENDIF.
  ENDLOOP.
ENDIF.

READ TABLE dedidd INTO DATA(lst_edidd_263) WITH KEY
                                                  segnam = lc1_e1edk01.
IF sy-subrc = 0 AND lv_id IS NOT INITIAL.
  lst_e1edk01 = lst_edidd_263-sdata.
  "Check SO is there or not
  IF lst_e1edk01-bstzd IS NOT INITIAL
    AND lst_e1edk01-bstzd IN r_supplement_po
    AND r_supplement_po IS NOT INITIAL.
    CLEAR:lst_edidd_263.
    LOOP AT dedidd INTO lst_edidd_263 WHERE segnam = lc1_e1edka1_e263
                                                    AND sdata+0(3) IN r_parvw.
      CLEAR:lst1_z1qtc_e1edka1.
      lst_e1edka1_e263 = lst_edidd_263-sdata.
      READ TABLE dedidd  INTO DATA(ls_seg_email) WITH KEY psgnum = lst_edidd_263-segnum
                                                          segnam = lc1_email_e263.
      " sdata+60(2) = lst_e1edka1_e263-parvw.
      IF sy-subrc = 0.
        lst1_z1qtc_e1edka1 = ls_seg_email-sdata.
        DATA(lv_partner) = lst_e1edka1_e263-partn.           "Read Partner for reading cusomer AR notes
        DATA(lv_email_e263) = lst1_z1qtc_e1edka1-smtp_addr.  "Read Email id
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_email_e263 IS NOT INITIAL.
      REFRESH:li_tline.
** Check the tdid 0005 is comming from IDOC or not
      LOOP AT dxe1edkt2 ASSIGNING <lfs1_e1edkt2>.
        IF <lfs1_e1edkt2>-tdid = lv_id.
          DATA(lv_id_exist) = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF sy-subrc = 0 AND lv_id_exist EQ abap_true. "ID is comming from idoc
        "Nothing to do
      ELSE." If not read the customer sales text and appren the email id
        CLEAR:lst_e1edka1_e263.
        IF lv_partner IS INITIAL."If partner number is not exist in bill to party
          " Read from sold to party
          READ TABLE dedidd INTO lst_edidd_263 WITH KEY segnam = lc1_e1edka1_e263
                                                     sdata+0(3) = lc_ag_parvw.
          IF sy-subrc = 0.
            lst_e1edka1_e263 = lst_edidd_263-sdata.
            lv_partner = lst_e1edka1_e263-partn.           "Read Partner
          ENDIF.
        ENDIF.
        LOOP AT dedidd INTO lst_edidd_263 WHERE segnam = lc1_e1edk14.
          lst_e1edk14 = lst_edidd_263-sdata.
          IF lst_e1edk14-qualf = lc1_qualf_006.
            DATA(lv_006_div) = lst_e1edk14-orgid.   "Division
          ELSEIF lst_e1edk14-qualf = lc1_qualf_007.
            DATA(lv_007_dis) = lst_e1edk14-orgid.   "Dis channel
          ELSEIF lst_e1edk14-qualf = lc1_qualf_008.
            DATA(lv_008_org) = lst_e1edk14-orgid.   "Sales org
          ENDIF.
        ENDLOOP.
        CONCATENATE lv_partner lv_008_org lv_007_dis lv_006_div INTO lv_name.
        IF lv_name IS NOT INITIAL.
** Read the customer language from STXH table based on the id and name
          SELECT SINGLE tdspras      " language
                 FROM stxh " STXD SAPscript text file lines
                 INTO @DATA(lv_langu)
                 WHERE tdobject = @lc_object
                 AND tdname = @lv_name
                 AND tdid = @lv_id.
          IF sy-subrc EQ 0.
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                id                      = lv_id
                language                = lv_langu
                name                    = lv_name
                object                  = lc_object
              TABLES
                lines                   = li_tline
              EXCEPTIONS
                id                      = 1
                language                = 2
                name                    = 3
                not_found               = 4
                object                  = 5
                reference_check         = 6
                wrong_access_to_archive = 7
                OTHERS                  = 8.
            IF sy-subrc EQ 0 AND li_tline[] IS NOT INITIAL.
              LOOP AT li_tline INTO DATA(ls_tline).
                APPEND INITIAL LINE TO dxe1edkt2  ASSIGNING <lfs1_e1edkt2>.
                <lfs1_e1edkt2>-tdid = lv_id.
                <lfs1_e1edkt2>-tdformat = ls_tline-tdformat.
                <lfs1_e1edkt2>-tdline = ls_tline-tdline.
              ENDLOOP.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
** Append  the email id to the text.
      APPEND INITIAL LINE TO dxe1edkt2  ASSIGNING <lfs1_e1edkt2>.
      <lfs1_e1edkt2>-tdid = lv_id.
      <lfs1_e1edkt2>-tdformat = lc1_star.
      <lfs1_e1edkt2>-tdline = lv_email_e263.
      CLEAR:lv_partner,lv_008_org,lv_007_dis,lv_006_div,lv_name,lst_edidd_263,
            lv_id_exist,lv_langu,lv_email_e263.
      REFRESH:li_tline[].
    ENDIF."IF lv_partner IS NOT INITIAL AND lv_email_e263 IS NOT INITIAL.
  ENDIF." IF lst_e1edk01-bstzd IS NOT INITIAL
ENDIF."IF sy-subrc = 0 AND lv_id IS NOT INITIAL.
