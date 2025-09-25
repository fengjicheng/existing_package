*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_CUSTOM_CLICK_SUB_E335 (Set Custom Click event)
* REVISION NO: ED2K919561                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  09/28/2020                                                    *
* DESCRIPTION: Add new fields to V_RA report
*----------------------------------------------------------------------*
* REVISION NO: ED2K919844                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/08/2020                                                    *
* DESCRIPTION: Logic changes in FUT level for Volume year, PO number , Del number
*              and ALV output/excel display for PO and deivery number
*----------------------------------------------------------------------*

CONSTANTS : lc_history      TYPE rvari_vnam  VALUE 'ZZHISTORY',             " Order History
            lc_shipinstruct TYPE rvari_vnam  VALUE 'ZZSHIP_INTRODUCTION'.   " Special Shipping Instructions


IF rs_selfield-tabindex <> 0.
  READ TABLE postab INDEX rs_selfield-tabindex.
ENDIF.

CASE r_ucomm.
  WHEN '&EXCEL'.        " Excel download option
    INCLUDE zqtc_generate_excel_sub_e335.     " Subroutine for Excel file genaration
  WHEN 'AUSW'.                       " hotspot click
    CASE rs_selfield-fieldname.               " Check the clicked field name.
      WHEN lc_history.                        " Order History
        INCLUDE zqtc_orderdetail_sub_e335 IF FOUND.
        EXIT.
      WHEN lc_shipinstruct.                   " Special shipping instruction
        INCLUDE zqtc_shipintruction_sub_e335 IF FOUND.
        EXIT.
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
      WHEN c_ponumber.
        INCLUDE zqtc_pohistory_sub_e335 IF FOUND.
        EXIT.
      WHEN c_delnumber.
        INCLUDE zqtc_deliveryhistory_sub_e335 IF FOUND.
        EXIT.
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
      WHEN OTHERS.
    ENDCASE.
ENDCASE.
