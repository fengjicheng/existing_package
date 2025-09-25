*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_INV_CANCELLATION_E213 RV60B904 (Include)
*                      [Copying Requirement Billing Doc Routine - 900]
* PROGRAM DESCRIPTION: Restrict Cancellation of Invoice when not cancelled
*                      Subsequent Documents exists.
* DEVELOPER:           Thilina Dimantha (TDIMANTHA)
* CREATION DATE:       10/05/2021 (MM/DD/YYYY)
* OBJECT ID:           E213
* TRANSPORT NUMBER(S): ED2K924711
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
STATICS:
  lr_subseq_doccat TYPE /dsd/sl_clselvbtyp_t.                   "Range: Subsequent Doc. Cat.

DATA: lv_subrc TYPE syst-subrc.                                 "Local Variable for sy-subrc.

CONSTANTS:
  lc_devid_e213  TYPE zdevid      VALUE 'E213',                 "Development ID: E213
  lc_p1_subs_cat TYPE rvari_vnam  VALUE 'SUBSEQ_DOC_CAT',       "Name of Variant Variable: Subsequent Doc Category
  lc_msgid_e213  TYPE vbfs-msgid  VALUE 'ZQTC_R2',              "Message Class of Error Message
  lc_msgtye_e213 TYPE vbfs-msgty  VALUE 'E',                    "Error Message type
  lc_msgno_e213  TYPE vbfs-msgno  VALUE '606'.                  "Error Message Number

IF lr_subseq_doccat IS INITIAL.
* Get Cnonstant values
  SELECT param1,                                                  "ABAP: Name of Variant Variable
         param2,                                                  "ABAP: Name of Variant Variable
         srno,                                                    "Current selection number
         sign,                                                    "ABAP: ID: I/E (include/exclude values)
         opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low,                                                     "Lower Value of Selection Condition
         high                                                     "Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE @DATA(li_const_values)
   WHERE devid    EQ @lc_devid_e213                               "Development ID
     AND activate EQ @abap_true.                                  "Only active record
  IF sy-subrc IS INITIAL.
    LOOP AT li_const_values ASSIGNING FIELD-SYMBOL(<lst_const_value>).
      CASE <lst_const_value>-param1.
        WHEN lc_p1_subs_cat.                                       "Subseq. Doc. Cat.
          APPEND INITIAL LINE TO lr_subseq_doccat ASSIGNING FIELD-SYMBOL(<lst_subseq_cat>).
          <lst_subseq_cat>-sign   = <lst_const_value>-sign.
          <lst_subseq_cat>-opti   = <lst_const_value>-opti.
          <lst_subseq_cat>-low    = <lst_const_value>-low.
          <lst_subseq_cat>-high   = <lst_const_value>-high.

        WHEN OTHERS.
*       Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF. " IF sy-subrc IS INITIAL
ENDIF.
lv_subrc = 0. "Initializing sy-subrc value.
*Selecting Subsequent document from document flow
SELECT vbelv,
       posnv,
       vbeln,
       posnn,
       vbtyp_n
  FROM vbfa
  INTO TABLE @DATA(lt_vbfa)
  WHERE vbelv EQ @*vbrp-vbeln AND
        posnv EQ @*vbrp-posnr AND
        vbtyp_n IN @lr_subseq_doccat "K,L
        ORDER BY PRIMARY KEY.
IF sy-subrc IS INITIAL.
*Check for Cancelled items in subsequent document
  SELECT vbeln,
         posnr,
         abgru
         FROM vbap
         INTO TABLE @DATA(lst_abgru)
         FOR ALL ENTRIES IN @lt_vbfa
         WHERE vbeln = @lt_vbfa-vbeln
         AND posnr = @lt_vbfa-posnn
         AND abgru = @space.
  IF sy-subrc = 0.

    PERFORM vbfs_hinzufuegen_allg USING *vbrp-vbeln     "Write Error Log
                                        *vbrp-posnr
                                        lc_msgid_e213
                                        lc_msgtye_e213
                                        lc_msgno_e213
                                        space
                                        space
                                        space
                                        space.
    lv_subrc = 4.
  ENDIF.
ENDIF.

sy-subrc = lv_subrc.
IF sy-subrc = 4.
  CLEAR lv_subrc.
  RETURN.
ENDIF.
