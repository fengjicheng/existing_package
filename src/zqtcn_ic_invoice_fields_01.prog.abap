*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_IC_INVOICE_FIELDS_01 (Called from ZXF06U06)
* PROGRAM DESCRIPTION: IC Invoice Doc - Populate additional Fields
*                      Store required information in Global Variables
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/29/2017
* OBJECT ID: E163
* TRANSPORT NUMBER(S):  ED2K906862
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911464
* REFERENCE NO: ERP-7156
* DEVELOPER: Writtick Roy (WROY)
* DATE:  20-Mar-2018
* DESCRIPTION: Identify the Billing Document Type
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911634
* REFERENCE NO: ERP-7156
* DEVELOPER: Writtick Roy (WROY)
* DATE:  27-Mar-2018
* DESCRIPTION: Additional Logic to avoid cancelled Document(s)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K907196
* REFERENCE NO: INC0194314
* DEVELOPER: Agudurkhad
* DATE:  09-May-2018
* DESCRIPTION: Profit center not populated on the idoc
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K907637
* REFERENCE NO: INC0196041
* DEVELOPER: Agudurkhad
* DATE:  07-June-2018
* DESCRIPTION: Profit center not populated on the idoc
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K907682
* REFERENCE NO: INC0196041
* DEVELOPER: Agudurkhad
* DATE:  13-June-2018
* DESCRIPTION: Profit center not populated on the idoc
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K907841
* REFERENCE NO: INC0199191
* DEVELOPER: Agudurkhad
* DATE:  28-June-2018
* DESCRIPTION: Profit center not populated on the idoc
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K907849
* REFERENCE NO: INC0199191
* DEVELOPER: Agudurkhad
* DATE:  29-June-2018
* DESCRIPTION: Profit center not populated on the idoc
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K908151
* REFERENCE NO: INC0199191
* DEVELOPER: Agudurkhad
* DATE:  06-Aug-2018
* DESCRIPTION: Profit center not populated on the idoc
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K911950 / ED1K912104
* REFERENCE NO: INC0301604
* DEVELOPER:    NPALLA
* DATE:         16-Jul-2020
* DESCRIPTION:  In Intercompany invoice the assignment field on the
*               IC AP should be same as the IC AR for each line item
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
* Begin of ADD:ERP-7156:WROY:27-Mar-2018:ED2K911634
  lst_e1edk01_e163 TYPE e1edk01,                                "IDoc: Document header general data
* End   of ADD:ERP-7156:WROY:27-Mar-2018:ED2K911634
* Begin of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
  lst_e1edk02_e163 TYPE e1edk02,                                "IDoc: Document header reference data
* End   of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
  lst_e1edk14_e163 TYPE e1edk14,                                "IDoc: Document Header Organizational Data
* Begin of ADD:INC0301604:NPALLA:16-Jul-2020:ED1K911950
  lst_e1edp03_e163 TYPE e1edp03,                                "IDoc: Document Item Date Segment
* End   of ADD:INC0301604:NPALLA:16-Jul-2020:ED1K911950
  lst_e1edp02_e163 TYPE e1edp02.                                "IDoc: Document Item Reference Data

* Begin of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
DATA:
  lv_bil_doc_e163  TYPE vbeln_vf.                               "Billing Document
* End   of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464

*Begin of change
DATA: lv_rfbsk TYPE rfbsk.
CONSTANTS: cv_rfbsk TYPE rfbsk VALUE 'C'.
*end of change
*Begin of change ED1K907849
DATA: ls_vbfa_sub TYPE ty_vbfa_sub.
DATA: lv_vbtyp_v  TYPE vbtyp_v.
RANGES: r_vbtyp_v	FOR lv_vbtyp_v.

r_vbtyp_v-sign = 'I'.
r_vbtyp_v-option = 'EQ'.
r_vbtyp_v-low = 'C'.
APPEND r_vbtyp_v.

r_vbtyp_v-sign = 'I'.
r_vbtyp_v-option = 'EQ'.
r_vbtyp_v-low = 'G'.
APPEND r_vbtyp_v.
*End of change ED1K907849

READ TABLE idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data>)
     INDEX idoc_data_index.
IF sy-subrc EQ 0.
  CASE <lst_idoc_data>-segnam.
*   Begin of ADD:ERP-7156:WROY:27-Mar-2018:ED2K911634
    WHEN 'E1EDK01'.                                             "IDoc: Document header general data
      lst_e1edk01_e163 = <lst_idoc_data>-sdata.
      st_glbl_flds-ic_bl_doc = lst_e1edk01_e163-belnr.
*   End   of ADD:ERP-7156:WROY:27-Mar-2018:ED2K911634

*   Begin of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464
    WHEN 'E1EDK02'.                                             "IDoc: Document header reference data
      lst_e1edk02_e163 = <lst_idoc_data>-sdata.
      CASE lst_e1edk02_e163-qualf.
        WHEN '087'.
          lv_bil_doc_e163 = lst_e1edk02_e163-belnr.
*         Fetch Billing Document: Header Data
          SELECT SINGLE fkart                                   "Billing Type
            FROM vbrk
            INTO st_glbl_flds-bill_type                         "Billing Type
           WHERE vbeln EQ lv_bil_doc_e163.
          IF sy-subrc NE 0.
            CLEAR: st_glbl_flds-bill_type.
          ENDIF.
        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
*   End   of ADD:ERP-7156:WROY:20-Mar-2018:ED2K911464

    WHEN 'E1EDK14'.                                             "IDoc: Document Header Organizational Data
      lst_e1edk14_e163 = <lst_idoc_data>-sdata.
      CASE lst_e1edk14_e163-qualf.
        WHEN '003'.
          st_glbl_flds-trg_cmp_cd = lst_e1edk14_e163-orgid.     "Company Code (Target / To)
        WHEN '011'.
          st_glbl_flds-src_cmp_cd = lst_e1edk14_e163-orgid.     "Company Code (Source / From)
        WHEN OTHERS.
*         Nothing to do
      ENDCASE.

    WHEN 'E1EDP02'.                                             "IDoc: Document Item Reference Data
      lst_e1edp02_e163 = <lst_idoc_data>-sdata.
      CASE lst_e1edp02_e163-qualf.

*Begin of Add:ERP-6317:Agudurkhad:28-June-2018:ED2K912177
        WHEN '001'.
          st_glbl_flds-belnr = lst_e1edp02_e163-belnr.
* Begin of Change:INC0301604:NPALLA:16-Jul-2020:ED1K911950
*          st_glbl_flds-datum = lst_e1edp02_e163-datum.
* End   of Change:INC0301604:NPALLA:16-Jul-2020:ED1K911950
*End of Add:ERP-6317:Agudurkhad:28-June-2018:ED2K912177

        WHEN '002'.
* Begin of Change:INC0301604:NPALLA:08-Aug-2020:ED1K912104
          st_glbl_flds-vgbel = lst_e1edp02_e163-belnr.
          st_glbl_flds-vgpos = lst_e1edp02_e163-zeile.
* End of Change:INC0301604:NPALLA:08-Aug-2020:ED1K912104
*         Fetch Accounting Document Segment Details
          SELECT hkont
                 prctr
            FROM bseg
            INTO ( st_glbl_flds-gl_account,                     "GL Account
                   st_glbl_flds-prft_cntr )                     "Profit Center
           UP TO 1 ROWS
           WHERE bukrs EQ st_glbl_flds-trg_cmp_cd               "Company Code
             AND vbel2 EQ lst_e1edp02_e163-belnr                "Sales Document
             AND posn2 EQ lst_e1edp02_e163-zeile                "Sales Document Item
             AND kunnr EQ space
*            Begin of ADD:ERP-7156:WROY:27-Mar-2018:ED2K911634
             AND kidno EQ st_glbl_flds-ic_bl_doc.               "Payment Reference
*            End   of ADD:ERP-7156:WROY:27-Mar-2018:ED2K911634
          ENDSELECT.
          IF sy-subrc NE 0.
*Begin of change
            CLEAR: st_glbl_flds-gl_account,                     "G/L Account
                   st_glbl_flds-prft_cntr.                      "Profit Center
            SELECT hkont
                  prctr
             FROM bseg
             INTO ( st_glbl_flds-gl_account,                     "GL Account
                    st_glbl_flds-prft_cntr )                     "Profit Center
            UP TO 1 ROWS
            WHERE bukrs EQ st_glbl_flds-trg_cmp_cd               "Company Code
              AND vbel2 EQ lst_e1edp02_e163-belnr                "Sales Document
              AND posn2 EQ lst_e1edp02_e163-zeile
              AND kunnr EQ space.                "Sales Document Item
            ENDSELECT.
            IF sy-subrc <> 0.
              CLEAR: st_glbl_flds-gl_account,                     "G/L Account
                  st_glbl_flds-prft_cntr.                      "Profit Center
              SELECT hkont
                     prctr
                     FROM bseg
                     INTO ( st_glbl_flds-gl_account,                     "GL Account
                                  st_glbl_flds-prft_cntr )                     "Profit Center
                          UP TO 1 ROWS
                          WHERE bukrs EQ st_glbl_flds-trg_cmp_cd               "Company Code
                          AND belnr EQ st_glbl_flds-ic_bl_doc
                          AND posn2 EQ lst_e1edp02_e163-zeile                "Sales Document Item
                          AND kunnr EQ space
                          AND kidno EQ st_glbl_flds-ic_bl_doc.
              ENDSELECT.
              IF sy-subrc <> 0.
*End of change
*Begin of change
                CLEAR: st_glbl_flds-gl_account,                     "G/L Account
                       st_glbl_flds-prft_cntr.                      "Profit Center


                SELECT vbelv posnv vbeln posnn vbtyp_v INTO ls_vbfa_sub UP TO 1 ROWS
                                                       FROM vbfa
                                                       WHERE  vbeln = st_glbl_flds-ic_bl_doc
                                                       AND    posnn = lst_e1edp02_e163-zeile
                                                       AND    vbtyp_v IN  r_vbtyp_v.
                ENDSELECT.
                IF sy-subrc = 0.
*                SELECT hkont
*                       prctr
*                       FROM bseg
*                       INTO ( st_glbl_flds-gl_account,                     "GL Account
*                                    st_glbl_flds-prft_cntr )                     "Profit Center
*                            UP TO 1 ROWS
*                            WHERE bukrs EQ st_glbl_flds-trg_cmp_cd               "Company Code
*                            AND belnr EQ st_glbl_flds-ic_bl_doc
*                            AND posn2 EQ lst_e1edp02_e163-zeile                  "Sales Document Item
*                            AND kunnr EQ space.
*
*                ENDSELECT.

                  SELECT hkont
                         prctr
                         FROM bseg
                         INTO ( st_glbl_flds-gl_account,                     "GL Account
                                      st_glbl_flds-prft_cntr )                     "Profit Center
                              UP TO 1 ROWS
                              WHERE bukrs EQ st_glbl_flds-trg_cmp_cd               "Company Code
                              AND belnr EQ st_glbl_flds-ic_bl_doc
                              AND vbel2 EQ ls_vbfa_sub-vbelv
                              AND posn2 EQ ls_vbfa_sub-posnv                "Sales Document Item
                              AND kunnr EQ space.

                  ENDSELECT.

                  IF sy-subrc <> 0.

*End of change
                    CLEAR: st_glbl_flds-gl_account,                     "G/L Account
                           st_glbl_flds-prft_cntr.                      "Profit Center
                  ENDIF.

                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.

*Begin of change ED1K908151
          IF st_glbl_flds-prft_cntr IS INITIAL.
            CLEAR ls_vbfa_sub.
            SELECT vbelv posnv vbeln posnn vbtyp_v INTO ls_vbfa_sub UP TO 1 ROWS
                                                   FROM vbfa
                                                   WHERE  vbeln = lst_e1edp02_e163-belnr
                                                   AND    posnn = lst_e1edp02_e163-zeile
                                                   AND    vbtyp_v IN  r_vbtyp_v.
            ENDSELECT.
            IF sy-subrc = 0.
              SELECT SINGLE rfbsk INTO lv_rfbsk FROM vbrk
                                                WHERE vbeln = st_glbl_flds-ic_bl_doc.
              IF sy-subrc = 0.
                IF lv_rfbsk = cv_rfbsk.
                  SELECT SINGLE prctr INTO st_glbl_flds-prft_cntr FROM vbap
                                                                  WHERE vbeln = ls_vbfa_sub-vbelv
                                                                  AND posnr =  ls_vbfa_sub-posnv.
                  IF sy-subrc <> 0.
                    CLEAR st_glbl_flds-prft_cntr.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.

*End of change ED1K908151

        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
* Begin of Change:INC0301604:NPALLA:16-Jul-2020:ED1K911950
    WHEN 'E1EDP03'.                                             "IDoc: Document Item Reference Data
      lst_e1edp03_e163 = <lst_idoc_data>-sdata.
      CASE lst_e1edp03_e163-iddat.
        WHEN '023'.
          st_glbl_flds-datum = lst_e1edp03_e163-datum.
        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
* End   of Change:INC0301604:NPALLA:16-Jul-2020:ED1K911950
    WHEN OTHERS.
*     Nothing to do
  ENDCASE.

ENDIF.
