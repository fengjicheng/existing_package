*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ENHANCE_VF04_OUTPUT (Include)
* PROGRAM DESCRIPTION: Populate additional fields (ALV Output) for
* VF04 transaction and Filter records based on Sel Screen Inputs
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       07/11/2017
* OBJECT ID:           E164
* TRANSPORT NUMBER(S): ED2K907158
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ES1K900339 / ES1K900345
* REFERENCE NO:  AMS_SPS_Upg_2019_VF04
* DEVELOPER:     Nikhilesh Palla (NPALLA)
* DATE:          06/25/2019
* DESCRIPTION:   Upgrade Fix as SAP has introduced select option S_VKBUR
*                Hence changing the Select Option to S_ZVKBUR
*----------------------------------------------------------------------*

DATA:
  li_lvkdfi TYPE STANDARD TABLE OF vkdfi INITIAL SIZE 0.   "Selected Billing Indices

DATA:
*BOC - AMS_SPS_Upg_2019_VF04 - NPALLA - 06/25/2019 - ES1K900339
*  lv_sl_ofc TYPE char50 VALUE '(SDBILLDL)S_VKBUR[]'.       "Sel Screen: Sales Office
  lv_sl_ofc TYPE char50 VALUE '(SDBILLDL)Z_VKBUR[]'.       "Sel Screen: Sales Office
*EOC - AMS_SPS_Upg_2019_VF04 - NPALLA - 06/25/2019 - ES1K900339

FIELD-SYMBOLS:
  <lr_sofc> TYPE rjksd_vkbur_range_tab.                    "Range: Sales Office

IF lvkdfi[] IS NOT INITIAL.
  li_lvkdfi[] = lvkdfi[].                                  "Selected Billing Indices
  SORT li_lvkdfi BY vbeln.
  DELETE ADJACENT DUPLICATES FROM li_lvkdfi COMPARING vbeln.

* Fetch Sales Document: Header Data
  SELECT vbeln,                                            "Sales Document
         vkbur                                             "Sales Office
    FROM vbak
    INTO TABLE @DATA(li_vbak)
     FOR ALL ENTRIES IN @li_lvkdfi
   WHERE vbeln EQ @li_lvkdfi-vbeln.
  IF sy-subrc EQ 0.
    SORT li_vbak BY vbeln.
  ENDIF.

* Get Sales Office Value from Selection Screen
  ASSIGN (lv_sl_ofc) TO <lr_sofc>.                         "Range: Sales Office

  LOOP AT lvkdfi ASSIGNING FIELD-SYMBOL(<lst_lvkdfi>).
*   Determine the Sales Office
    READ TABLE li_vbak ASSIGNING FIELD-SYMBOL(<lst_vbak>)
         WITH KEY vbeln = <lst_lvkdfi>-vbeln
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      <lst_lvkdfi>-zzvkbur = <lst_vbak>-vkbur.             "Sales Office
    ENDIF.

*   Check if the Sales Office is within Selection Screen Range
    IF <lr_sofc> IS ASSIGNED.
      IF <lst_lvkdfi>-zzvkbur NOT IN <lr_sofc>.
        CLEAR: <lst_lvkdfi>-vbeln.
      ENDIF.
    ENDIF.
  ENDLOOP.
* Filter the entries if Selection criteria is not met
  DELETE lvkdfi WHERE vbeln IS INITIAL.
ENDIF.
