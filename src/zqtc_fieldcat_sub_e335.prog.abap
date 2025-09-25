*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_FIELDCAT_SUB_E335 (Build the field catalog for newly added fields)
* REVISION NO: ED2K919561                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  09/21/2020                                                    *
* DESCRIPTION: Add new fields to V_RA report
*----------------------------------------------------------------------*
* REVISION NO: ED2K919844                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/08/2020                                                    *
* DESCRIPTION: Logic changes in FUT level for Volume year, PO number , Del number
*              and ALV output/excel display for PO and deivery number
*----------------------------------------------------------------------*
* REVISION NO: ED2K919899                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  10/14/2020                                                    *
* DESCRIPTION: Logic changes for Subscrition order/Po count/add new Print vendor
*              display and remove duplicate from the PO number
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
** REVISION NO: ED2K925275                                             *
* REFERENCE NO: OTCM-51316                                             *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  12/20/2021                                                    *
* DESCRIPTION: Add new fields to input and output of V_RA Report
*------------------------------------------------------------------------*

DATA : lt_fieldcat_tmp    TYPE slis_t_fieldcat_alv.

" Build the new field catalog for additional fields
REFRESH : lt_fieldcat_tmp[] , i_fieldcat[].
CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
  EXPORTING
    i_program_name         = sy-repid
    i_structure_name       = 'V03RB'
    i_client_never_display = abap_true
  CHANGING
    ct_fieldcat            = lt_fieldcat_tmp
  EXCEPTIONS
    inconsistent_interface = 1
    program_error          = 2
    OTHERS                 = 3.
IF sy-subrc EQ 0.
  LOOP AT lt_fieldcat_tmp INTO DATA(lst_fieldcat_tmp).
    CASE lst_fieldcat_tmp-fieldname.
      WHEN c_ship2party.                                   " Ship to party
        lst_fieldcat_tmp-seltext_s = 'Ship-to Party'.
        lst_fieldcat_tmp-seltext_l = 'Ship-to Party'.
      WHEN c_forwdagnt.                                   " Forwarding Agent
        lst_fieldcat_tmp-seltext_s = 'Forwarding Agent'.
        lst_fieldcat_tmp-seltext_m = 'Forwarding Agent'.
        lst_fieldcat_tmp-seltext_l = 'Forwarding Agent'.
      WHEN c_refdoc.                                      " Subscription Order Number
        lst_fieldcat_tmp-seltext_s = 'Subscription Order Number'.
        lst_fieldcat_tmp-seltext_l = 'Subscription Order Number'.
      WHEN c_yourref.                                     " Subs Reference Number/ Your reference
        lst_fieldcat_tmp-seltext_m = 'Subs Reference Number/ Your reference'.
        lst_fieldcat_tmp-seltext_l = 'Subs Reference Number/ Your reference'.
* BOC by NPOLINA on 12/15/2021 for OTCM-51316 with ED2K925275 *
      WHEN c_erdat.
        lst_fieldcat_tmp-seltext_s = 'Order Creation Date'.                                     " Order Creation Date
        lst_fieldcat_tmp-seltext_m = 'Order Creation Date'.
        lst_fieldcat_tmp-seltext_l = 'Order Creation Date'.
        lst_fieldcat_tmp-outputlen = 20.
*  EOC by NPOLINA on 12/15/2021 for OTCM-51316 with ED2K925275 *
      WHEN c_arriavaldat.                                 " Material’s Actual Goods Arrival Date
        lst_fieldcat_tmp-seltext_m = 'Material’s Actual Goods Arrival Date'.
        lst_fieldcat_tmp-seltext_l = 'Material’s Actual Goods Arrival Date'.
      WHEN c_plant.                                       " Delivery Plant
        lst_fieldcat_tmp-seltext_s = 'Delivery Plant'.
        lst_fieldcat_tmp-seltext_l = 'Delivery Plant'.
      WHEN c_shippoint.                                   " Shipping Point
        lst_fieldcat_tmp-seltext_s = 'Shipping Point'.
        lst_fieldcat_tmp-seltext_l = 'Shipping Point'.
      WHEN c_conuntryky.                                  " Country
        lst_fieldcat_tmp-seltext_s = 'Country'.
        lst_fieldcat_tmp-seltext_l = 'Country'.
      WHEN c_ordertype.                                   " Order Type
        lst_fieldcat_tmp-seltext_m = 'Order Type'.
        lst_fieldcat_tmp-seltext_l = 'Order Type'.
* BOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
      WHEN c_prtvendor.                                  " Print vendor
        lst_fieldcat_tmp-seltext_s = 'Print Vendor'.
        lst_fieldcat_tmp-seltext_l = 'Print Vendor'.
* EOC by Lahiru on 10/14/2020 for OTCM-10487 with ED2K919899 *
      WHEN c_vendor.                                      " Vendor Code and name
        lst_fieldcat_tmp-seltext_s = 'Distributor'.
        lst_fieldcat_tmp-seltext_l = 'Distributor'.
        lst_fieldcat_tmp-lowercase = abap_true.
      WHEN c_volumyear.                                   " Volume Year
        lst_fieldcat_tmp-seltext_m = 'Volume Year'.
        lst_fieldcat_tmp-seltext_m = 'Volume Year'.
        lst_fieldcat_tmp-seltext_l = 'Volume Year'.
      WHEN c_history.                                     " Order History
        lst_fieldcat_tmp-seltext_s = 'Order History'.
        lst_fieldcat_tmp-seltext_l = 'Order History'.
        lst_fieldcat_tmp-hotspot = abap_true.
      WHEN c_ponumber.                                    " Purchase Order total count
* BOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
        lst_fieldcat_tmp-seltext_m = 'Purchase Order - Total Count'.
        lst_fieldcat_tmp-seltext_l = 'Purchase Order - Total Count'.
        lst_fieldcat_tmp-hotspot = abap_true.
      WHEN c_delnumber.                                   " Outbound delivery total count
        lst_fieldcat_tmp-seltext_s = 'Outbound Delivery - Total Count'.
        lst_fieldcat_tmp-seltext_l = 'Outbound Delivery - Total Count'.
        lst_fieldcat_tmp-hotspot = abap_true.
* EOC by Lahiru on 10/08/2020 for OTCM-10487 with ED2K919844 *
      WHEN c_shipcondit.                                  " Shipping Condition
        lst_fieldcat_tmp-seltext_s = 'Shipping Condition'.
        lst_fieldcat_tmp-seltext_l = 'Shipping Condition'.
      WHEN c_shipinstruct.                                " Special Shipping Instructions
        lst_fieldcat_tmp-seltext_s = 'Special Shipping Instructions'.
        lst_fieldcat_tmp-seltext_l = 'Special Shipping Instructions'.
        lst_fieldcat_tmp-hotspot = abap_true.
        lst_fieldcat_tmp-outputlen = 10.
      WHEN c_delblock.                                    " Delivery Block
        lst_fieldcat_tmp-seltext_s = 'Delivery Block'.
        lst_fieldcat_tmp-seltext_l = 'Delivery Block'.
      WHEN c_delblkdes.                                   " Delivery Block description
        lst_fieldcat_tmp-seltext_s = 'Delivery Block Description'.
        lst_fieldcat_tmp-seltext_l = 'Delivery Block Description'.
        lst_fieldcat_tmp-lowercase = abap_true.
      WHEN c_bilblock.                                    " Billing Block
        lst_fieldcat_tmp-seltext_s = 'Billing Block'.
        lst_fieldcat_tmp-seltext_l = 'Billing Block'.
      WHEN c_bilblockdes.                                 " Billing Block Description
        lst_fieldcat_tmp-seltext_s = 'Billing Block Description'.
        lst_fieldcat_tmp-seltext_l = 'Billing Block Description'.
        lst_fieldcat_tmp-lowercase = abap_true.
      WHEN c_crdblock.                                    " Credit Hold
        lst_fieldcat_tmp-seltext_s = 'Credit Hold'.
        lst_fieldcat_tmp-seltext_m = 'Credit Hold'.
        lst_fieldcat_tmp-seltext_l = 'Credit Hold'.
      WHEN c_crdblockdes.                                 " Credit Hold Description
        lst_fieldcat_tmp-seltext_s = 'Credit Hold Description'.
        lst_fieldcat_tmp-seltext_l = 'Credit Hold Description'.
        lst_fieldcat_tmp-lowercase = abap_true.
      WHEN OTHERS.                                         " when other field match loop return to reprocessing without taking any action
        CLEAR : lst_fieldcat_tmp.
        CONTINUE.
    ENDCASE.
    APPEND lst_fieldcat_tmp TO lt_fieldcat.
    CLEAR : lst_fieldcat_tmp.
  ENDLOOP.

  " Assign complete fieldcatalog to Global variable. To use excel export functionality
  i_fieldcat[] = lt_fieldcat[].

ENDIF.
