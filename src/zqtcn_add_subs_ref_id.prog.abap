*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_SUBS_REF_ID (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used for changes or checks,
*                      before a document is saved.
* This program will assigned unique “Sub Ref ID” number to the subscription .
* This will happen only for the first time of the subscription order in SAP.
* This number will be assigned in the “Your Reference “field at item level in Order Data tab.
* DEVELOPER: Lucky Kodwani(lkodwani)
* CREATION DATE:   10/20/2016
* OBJECT ID: E112
* TRANSPORT NUMBER(S): ED2K903129
*----------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K919114
* REFERENCE NO:  ERPM-21151
* DEVELOPER: AMOHAMMED
* DATE:  08/10/2020 (MM/DD/YYYY).
* DESCRIPTION: When the product is changed for DD and firm invoice on a
*              future renewal contract. SubRef ID should be copied from
*              rejected line to new line added for product change
*-------------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ADD_SUBS_REF_ID
*&---------------------------------------------------------------------*

* Type Declaration
TYPES : BEGIN OF lty_zcaconstant,
          devid    TYPE zdevid,              "Development ID
          param1   TYPE rvari_vnam,          "ABAP: Name of Variant Variable
          param2   TYPE rvari_vnam,          "ABAP: Name of Variant Variable
          srno     TYPE tvarv_numb,          "ABAP: Current selection number
          sign     TYPE tvarv_sign,          "ABAP: ID: I/E (include/exclude values)
          opti     TYPE tvarv_opti,          "ABAP: Selection option (EQ/BT/CP/...)
          low      TYPE salv_de_selopt_low,  "Lower Value of Selection Condition
          high     TYPE salv_de_selopt_high, "Upper Value of Selection Condition
          activate TYPE zconstactive,        "Activation indicator for constant
        END OF   lty_zcaconstant.

* Local Constant Declaration
DATA : lc_e112       TYPE zdevid        VALUE 'E112',         " Development ID
       lc_numb_ran   TYPE rvari_vnam    VALUE 'NUMBER_RANGE', " ABAP: Name of Variant Variable
       lc_auart      TYPE rvari_vnam    VALUE 'AUART',        " ABAP: Name of Variant Variable
       lc_range_name TYPE rvari_vnam    VALUE 'RANGE_NAME',   " ABAP: Name of Variant Variable
       lc_object     TYPE rvari_vnam    VALUE 'OBJECT_NAME',  " ABAP: Name of Variant Variable
       lc_i          TYPE char1         VALUE 'I',            " I of type CHAR1
       lc_n          TYPE trtyp         VALUE 'N',            " Transaction type
       lc_eq         TYPE char2         VALUE 'EQ'.           " Eq of type CHAR2



* Local Variable Declaration
DATA : lv_rang_obj  TYPE nrobj ,        " Name of number range object
       lv_rang_name TYPE nrnr         , " Number range number
       lv_ref_id    TYPE ihrez,         " Your Reference
       lv_ref_id_fg TYPE flag.          " General Flag

* local Internal Table Declaration
DATA : li_zcaconstant  TYPE STANDARD TABLE OF lty_zcaconstant INITIAL SIZE 0,
       lst_zcaconstant TYPE lty_zcaconstant. " Wiley Application Constant Table

* Local Workarea Declaration
DATA : lst_vbapvb TYPE vbapvb, " Document Structure for XVBAP/YVBAP
       lst_xvbkd  TYPE vbkdvb. " Reference structure for XVBKD/YVBKD

* Range Declaration
TYPES : ty_auart_r TYPE RANGE OF auart. " Sales Document Type
DATA : lst_auart TYPE LINE OF ty_auart_r,
       lr_auart  TYPE ty_auart_r.

* Field Symbol Declaration
FIELD-SYMBOLS: <lst_xvbkd>   TYPE vbkdvb, " Reference structure for XVBKD/YVBKD
               <lst_xvbkd_b> TYPE vbkdvb, " Reference structure for XVBKD/YVBKD
               <lst_xvbkd_h> TYPE vbkdvb. " Reference structure for XVBKD/YVBKD

* Begin by AMOHAMMED ON 08/11/2020 TR # ED2K919114
DATA lv_ihrez_temp TYPE ihrez.         " Your Reference
CLEAR lv_ihrez_temp.
* End by AMOHAMMED ON 08/11/2020 TR # ED2K919114

SELECT devid       "Development ID
       param1	     "ABAP: Name of Variant Variable
       param2	     "ABAP: Name of Variant Variable
       srno	       "ABAP: Current selection number
       sign	       "ABAP: ID: I/E (include/exclude values)
       opti	       "ABAP: Selection option (EQ/BT/CP/...)
       low         "Lower Value of Selection Condition
       high	       "Upper Value of Selection Condition
       activate    "Activation indicator for constant
  FROM zcaconstant "Wiley Application Constant Table
  INTO TABLE li_zcaconstant
  WHERE devid  = lc_e112
    AND activate = abap_true.

IF sy-subrc EQ 0.

* Get the number range object name
  CLEAR lst_zcaconstant.
* Table li_zcaconstant will be having very less records so no binary search is used .

  READ TABLE li_zcaconstant INTO lst_zcaconstant WITH KEY param1 = lc_numb_ran
                                                          param2 = lc_object.
  IF sy-subrc IS INITIAL.
    lv_rang_obj = lst_zcaconstant-low.
  ENDIF. " IF sy-subrc IS INITIAL

* Get the number range name
  CLEAR lst_zcaconstant.
* Table li_zcaconstant will be having very less records so no binary search is used .
  READ TABLE li_zcaconstant INTO lst_zcaconstant WITH KEY param1 = lc_numb_ran
                                                          param2 = lc_range_name.
  IF sy-subrc IS INITIAL.
    lv_rang_name = lst_zcaconstant-low.
  ENDIF. " IF sy-subrc IS INITIAL

* Get The sales order type from constant Table
  DELETE li_zcaconstant WHERE param1 <> lc_auart.
  CLEAR lst_zcaconstant.
  IF li_zcaconstant IS NOT INITIAL .
    LOOP AT li_zcaconstant INTO lst_zcaconstant.
      lst_auart-sign   = lst_zcaconstant-sign.
      lst_auart-option = lst_zcaconstant-opti.
      lst_auart-low    = lst_zcaconstant-low.
      lst_auart-high   = lst_zcaconstant-high.
      APPEND lst_auart TO lr_auart.
      CLEAR lst_auart .
    ENDLOOP. " LOOP AT li_zcaconstant INTO lst_zcaconstant
  ENDIF. " IF li_zcaconstant IS NOT INITIAL
ENDIF. " IF sy-subrc EQ 0

* Check for specific Order Types maintained in ZCACONSTANT table. If this check satisfies, then only proceed further.
IF vbak-auart IN lr_auart AND
   lr_auart   IS NOT INITIAL.
  LOOP AT xvbap INTO lst_vbapvb.
* No Binary search has been used as XVBKD
* will be having very less records.
    READ TABLE xvbkd ASSIGNING <lst_xvbkd>
         WITH KEY vbeln = lst_vbapvb-vbeln
                  posnr = lst_vbapvb-posnr.
    IF sy-subrc EQ 0.
* Begin by AMOHAMMED ON 08/11/2020 TR # ED2K919114
      " When the current iteration line item is rejected,
      "   take the ref id into temp variable
      IF lst_vbapvb-abgru IS NOT INITIAL AND lv_ihrez_temp IS INITIAL.
        lv_ihrez_temp = <lst_xvbkd>-ihrez.
        " When new line item is inserted and rejected line item ref id is picked
        "   assign this ref id to new line item ref id
      ELSEIF <lst_xvbkd>-updkz EQ updkz_new AND lv_ihrez_temp IS NOT INITIAL.
        <lst_xvbkd>-ihrez = lv_ihrez_temp.
      ENDIF.
* End by AMOHAMMED ON 08/11/2020 TR # ED2K919114
      IF <lst_xvbkd>-ihrez IS INITIAL.
        IF <lst_xvbkd>-updkz IS INITIAL.
          APPEND <lst_xvbkd> TO yvbkd.
          <lst_xvbkd>-updkz = updkz_update.
        ENDIF.
        IF lst_vbapvb-uepos IS INITIAL.
          CALL FUNCTION 'NUMBER_GET_NEXT'
            EXPORTING
              nr_range_nr             = lv_rang_name
              object                  = lv_rang_obj
            IMPORTING
              number                  = lv_ref_id
            EXCEPTIONS
              interval_not_found      = 1
              number_range_not_intern = 2
              object_not_found        = 3
              quantity_is_0           = 4
              quantity_is_not_1       = 5
              interval_overflow       = 6
              buffer_overflow         = 7
              OTHERS                  = 8.
          IF sy-subrc = 0.
            CONCATENATE lc_n
                        lv_ref_id
                   INTO <lst_xvbkd>-ihrez.
            CONDENSE <lst_xvbkd>-ihrez.
          ENDIF. " IF sy-subrc = 0
        ELSE.
* No Binary search has been used as XVBKD
* will be having very less records.
          READ TABLE xvbkd ASSIGNING <lst_xvbkd_b>
               WITH KEY vbeln = lst_vbapvb-vbeln
                        posnr = lst_vbapvb-uepos.
          IF sy-subrc EQ 0.
            <lst_xvbkd>-ihrez = <lst_xvbkd_b>-ihrez.
          ENDIF.
        ENDIF.
      ENDIF. " IF <lst_xvbkd>-ihrez IS INITIAL
    ELSE.
* No Binary search has been used as XVBKD
* will be having very less records.
      READ TABLE xvbkd ASSIGNING <lst_xvbkd_h>
           WITH KEY vbeln = lst_vbapvb-vbeln
                    posnr = posnr_low.
      IF sy-subrc EQ 0.
        APPEND INITIAL LINE TO xvbkd ASSIGNING <lst_xvbkd>.
        <lst_xvbkd> = <lst_xvbkd_h>.
        <lst_xvbkd>-posnr = lst_vbapvb-posnr.
        <lst_xvbkd>-updkz = updkz_new.

        IF lst_vbapvb-uepos IS INITIAL.
          CALL FUNCTION 'NUMBER_GET_NEXT'
            EXPORTING
              nr_range_nr             = lv_rang_name
              object                  = lv_rang_obj
            IMPORTING
              number                  = lv_ref_id
            EXCEPTIONS
              interval_not_found      = 1
              number_range_not_intern = 2
              object_not_found        = 3
              quantity_is_0           = 4
              quantity_is_not_1       = 5
              interval_overflow       = 6
              buffer_overflow         = 7
              OTHERS                  = 8.
          IF sy-subrc = 0.
            CONCATENATE lc_n
                        lv_ref_id
                   INTO <lst_xvbkd>-ihrez.
            CONDENSE <lst_xvbkd>-ihrez.
          ENDIF. " IF sy-subrc = 0
        ELSE.
* No Binary search has been used as XVBKD
* will be having very less records.
          READ TABLE xvbkd ASSIGNING <lst_xvbkd_b>
               WITH KEY vbeln = lst_vbapvb-vbeln
                        posnr = lst_vbapvb-uepos.
          IF sy-subrc EQ 0.
            <lst_xvbkd>-ihrez = <lst_xvbkd_b>-ihrez.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP. " LOOP AT xvbap INTO lst_vbapvb
  SORT xvbkd BY vbeln posnr.
ENDIF. " IF xvbak-auart IN lr_auart
