class ZQTCCL_MAP_CUSTOMER_VENDOR_BP definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_CVI_CUSTOM_MAPPER .
protected section.
private section.
ENDCLASS.



CLASS ZQTCCL_MAP_CUSTOMER_VENDOR_BP IMPLEMENTATION.


  method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_REL_TO_CUSTOMER_CONTACT.
  endmethod.


  method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_REL_TO_VENDOR_CONTACT.
  endmethod.


  METHOD if_ex_cvi_custom_mapper~map_bp_to_customer.
*--------------------------------------------------------------------------*
* PROGRAM NAME       : ZQTCBI_MAP_CUSTOMER_VENDOR_BP~MAP_BP_TO_CUSTOMER    *
* PROGRAM DESCRIPTION: Address Search and Validation - To default the      *
*                      value of 'Attribute 7' in 'Customer: Additional     *
*                      Data' tab in the transaction: BP - based on user    *
*                      action on Address Doctor BATCH screen, which gets   *
*                      triggered from ADDRESS_CHECK BADI.                  *
* DEVELOPER          : GKINTALI                                            *
* CREATION DATE      : 06/15/2017                                          *
* OBJECT ID          : E159                                                *
* TRANSPORT NUMBER(S): ED2K905920, ED2K906869                              *
*--------------------------------------------------------------------------*
* REVISION HISTORY---------------------------------------------------------*
* REVISION NO           :
* REFERENCE NO/OBJECT NO:
* DEVELOPER             :
* TRANSPORT NUMBER(S)   :
* DATE                  :
* DESCRIPTION           :
*--------------------------------------------------------------------------*
* Begin of ED2K911118 - GKINTALI - 28.02.2018
* To check enhancement is active or not
  CONSTANTS: lc_wricef_id TYPE zdevid VALUE 'E159', " Development ID
             lc_ser_num   TYPE zsno   VALUE '001'.  " Serial Number

  DATA: lv_actv_flag    TYPE zactive_flag . " Active / Inactive Flag

*   To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id
      im_ser_num     = lc_ser_num
    IMPORTING
      ex_active_flag = lv_actv_flag.
  IF lv_actv_flag EQ abap_true.
* End of ED2K911118 - GKINTALI - 28.02.2018
* Local Constants Declaration
    CONSTANTS: lc_ovr  TYPE tvk7-katr7  VALUE 'O', " Override
               lc_val  TYPE tvk7-katr7  VALUE 'B', " Validated
               lc_sug  TYPE tvk7-katr7  VALUE 'S'. " Suggested

* Local Variables Declaration
    DATA:      lv_oaddrflg TYPE char1,
               lv_katr7    TYPE katr7.

* Import the flag to identify 'Use Original Address' or 'Suggested Address' option
* from Address Doctor BATCH screen (9001) PAI event in the fucntion module: ZBP_ADDR_SRCH_VLDT_INCL_E159
    IMPORT lv_flag TO lv_oaddrflg FROM MEMORY ID 'GV_ATTRIB7'.
    IF sy-subrc = 0.
      IF lv_oaddrflg = lc_ovr.         " Original Address
* Validate 'Override' flag in TVK7
        SELECT SINGLE katr7
               FROM   tvk7             " Attribute 7 (customer master)
               INTO   lv_katr7         " Attribute 7
               WHERE  katr7 = lc_ovr.  " O
      ENDIF.  " IF lv_oaddrflg = lc_ovr.

      IF lv_oaddrflg = lc_val.         " Validated Address
* Validate 'Validated' flag in TVK7
        SELECT SINGLE katr7
               FROM   tvk7             " Attribute 7 (customer master)
               INTO   lv_katr7         " Attribute 7
               WHERE  katr7 = lc_val.  " B
      ENDIF.  " IF lv_oaddrflg = lc_val.

      IF lv_oaddrflg = lc_sug.        " Informatica Suggested
* Validate 'Informatica Suggest' flag in TVK7
        SELECT SINGLE katr7
               FROM   tvk7             " Attribute 7 (customer master)
               INTO   lv_katr7         " Attribute 7
               WHERE  katr7 = lc_sug.  " S
      ENDIF.  " IF lv_oaddrflg = lc_sug1.

      c_customer-central_data-central-data-katr7  = lv_katr7.
      c_customer-central_data-central-datax-katr7 = 'X'.
    ENDIF.  " IF sy-subrc = 0.

    FREE MEMORY ID 'GV_ATRRIB7'.
   ENDIF.  " IF lv_actv_flag EQ abap_true.   " ++ by GKINTALI : ED2K911118
  ENDMETHOD.


  method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_TO_CUSTOMER_CONTACT.
  endmethod.


  method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_TO_VENDOR.
  endmethod.


  method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_TO_VENDOR_CONTACT.
  endmethod.


  METHOD if_ex_cvi_custom_mapper~map_customer_to_bp.
*------------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCBI_MAP_CUSTOMER_VENDOR_BP~MAP_BP_TO_CUSTOMER *
* PROGRAM DESCRIPTION : Map Business Partner Names to Customer fields    *
*                       OSS Note 1830886 - BP_CVI: Mapping the last name *
*                       and first name for CVI synchronization           *
* DEVELOPER           : WROY (Writtick Roy)                              *
* CREATION DATE       : 2016-11-29                                       *
* OBJECT ID           : C041                                             *
* TRANSPORT NUMBER(S) : ED2K903162                                       *
*------------------------------------------------------------------------*
* REVISION HISTORY-------------------------------------------------------*
* REVISION NO: ED2K906545
* REFERENCE NO: ERP-1998 (SAP Message: 249123/2017)
* DEVELOPER: Writtick Roy (WROY)
* DATE:  08-JUN-2017
* DESCRIPTION: Map from Customer to BP- First/Last name should not change
*------------------------------------------------------------------------*
* Begin of ADD:ERP-1998:WROY:08-JUN-2017:ED2K906545
    DATA:
      lst_data_person TYPE bapibus1006_central_person.                   "Structure for Personal Data

    DATA:
      lv_bus_category TYPE bu_type.                                      "Business partner category

    CONSTANTS:
      lc_category_prs TYPE bu_type    VALUE '1'.                         "Business partner category: Person

    CALL FUNCTION 'BUPA_CENTRAL_READ_DETAIL'
      EXPORTING
        iv_partner            = i_customer-header-object_instance-kunnr  "Customer / Business Partner number
      IMPORTING
        es_data_person        = lst_data_person                          "Personal data
        ev_category           = lv_bus_category                          "Business partner Category
      EXCEPTIONS
        no_partner_specified  = 1
        no_valid_record_found = 2
        not_found             = 3
        blocked_partner       = 4
        OTHERS                = 5.
    IF sy-subrc EQ 0 AND
       lv_bus_category = lc_category_prs.                                "Business partner category: Person
      c_partner-central_data-common-data-bp_person-lastname
        = lst_data_person-lastname.                                      "Last Name
      c_partner-central_data-common-data-bp_person-firstname
        = lst_data_person-firstname.                                     "First Name
    ENDIF.
* End   of ADD:ERP-1998:WROY:08-JUN-2017:ED2K906545
  ENDMETHOD.


  method IF_EX_CVI_CUSTOM_MAPPER~MAP_CUST_CONT_TO_BP_AND_REL.
  endmethod.


  method IF_EX_CVI_CUSTOM_MAPPER~MAP_PERSON_TO_CUSTOMER_CONTACT.
  endmethod.


  method IF_EX_CVI_CUSTOM_MAPPER~MAP_PERSON_TO_VENDOR_CONTACT.
  endmethod.


  method IF_EX_CVI_CUSTOM_MAPPER~MAP_VENDOR_TO_BP.
  endmethod.


  method IF_EX_CVI_CUSTOM_MAPPER~MAP_VEND_CONT_TO_BP_AND_REL.
  endmethod.
ENDCLASS.
