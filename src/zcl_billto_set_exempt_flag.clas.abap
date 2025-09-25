class ZCL_BILLTO_SET_EXEMPT_FLAG definition
  public
  create public .

public section.

  interfaces /IDT/USER_EXIT_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BILLTO_SET_EXEMPT_FLAG IMPLEMENTATION.


 METHOD /IDT/USER_EXIT_INTERFACE~USER_EXIT.
*------------------------------------------------------------------------*
* PROGRAM NAME        : /IDT/USER_EXIT_INTERFACE~USER_EXIT               *
* PROGRAM DESCRIPTION : Ship-To/Bill-To Tax Exempt Indicator             *
* DEVELOPER           : SGURIJALA                                        *
* CREATION DATE       : 2018-06-07                                       *
* OBJECT ID           : N/A (Logic from TR developer Anshul Garg)        *
* TRANSPORT NUMBER(S) : ED1K907606                                       *
*------------------------------------------------------------------------*
* REVISION HISTORY-------------------------------------------------------*
* REVISION NO: ED1K907606
* REFERENCE NO: INC0197904
* DEVELOPER:
* DATE:
* DESCRIPTION: Ship-To/Bill-To Tax Exempt Indicator
*------------------------------------------------------------------------*
   DATA : mv_kunnr TYPE kunnr,
         mv_soldto  TYPE kunag,
         mv_billto TYPE kunre,
         mv_shipto TYPE kunwe,
         mv_aland TYPE land1,
         mv_taxkd TYPE takld,
         ms_calc_item TYPE /idt/item_calc_fields,
         ms_ref_util_data TYPE REF TO /idt/reference_utility.

***Get the Sold-To Party and Departure Country
  mv_soldto = i_ref_util_source_data->fast_get_value_with_path('KOMK-KUNNR').
  mv_aland = i_ref_util_source_data->fast_get_value_with_path('KOMK-ALAND').

**Back up to get SOLD-TO
  IF mv_soldto IS NOT INITIAL.
    mv_kunnr = mv_soldto.
  ELSE.
***Get the Bill-To party customer number
    mv_billto = i_ref_util_source_data->fast_get_value_with_path('KOMK-KUNRE').
    mv_kunnr = mv_billto.
  ENDIF.

***Get the Ship-To party customer number
  mv_shipto = i_ref_util_source_data->fast_get_value_with_path('KOMK-KUNWE').

**Only if SHIP-TO and BILL_TO are different , below logic should override flag
  IF mv_kunnr IS NOT INITIAL AND mv_kunnr <> mv_shipto.
    SELECT SINGLE taxkd FROM knvi INTO mv_taxkd WHERE kunnr = mv_kunnr AND aland = mv_aland AND TATYP = 'ZITD' .
      IF sy-subrc = 0.
**Exempt Flag per SHIP-TO Customer and Tax classification
**As of now we are not considering checking value because BILL-TO takes priority
      ms_calc_item-is_exempt = i_ref_util_source_data->fast_get_value_with_path('CALC_ITEM-is_exempt').

** Overide exempt flag per BILL-TO and its Tax classification
      CASE mv_taxkd.
        WHEN 0.
          ms_calc_item-is_exempt = 'TRUE'.
        WHEN 1 or 2.
          ms_calc_item-is_exempt = 'FALSE'.
        WHEN OTHERS.
          ms_calc_item-is_exempt = abap_false.
      ENDCASE.
      ENDIF.
    ENDIF.

****Return Bill-To customer number for troubleshooting
    rv_value = ms_calc_item-is_exempt.
  ENDMETHOD.
ENDCLASS.
