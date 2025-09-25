CLASS zcl_im_qtc_delivery_header DEFINITION " Imp. class for BAdI imp. ZQTC_DELIVERY_HEADER
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ex_le_shp_tab_cust_head .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_QTC_DELIVERY_HEADER IMPLEMENTATION.


  METHOD if_ex_le_shp_tab_cust_head~activate_tab_page.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZCL_IM_QTC_DELIVERY_HEADER(Name of the implementing class)
* PROGRAM DESCRIPTION: To activate the tab in Outbound Delivery Header
*                      in the 4th position of the Header Details.
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   10/18/2016
* OBJECT ID: E060
* TRANSPORT NUMBER(S): ED2K903037
*----------------------------------------------------------------------*

    CONSTANTS : lc_scrn TYPE char4 VALUE '9000',                    " Scrn of type CHAR4
                lc_prog TYPE char22 VALUE 'SAPLZQTC_ADD_FLDS_LIKP', " Prog of type CHAR22
                lc_cust TYPE char1 VALUE 'X'.                       " Cust of type CHAR1

    ef_caption = text-000. "Screen Caption
    ef_program = lc_prog. "SAPL Followed by the Function group created ZQTC_ADD_FLDS_LIKP
    ef_position = 4. "Tab Position
    ef_dynpro  = lc_scrn. "Screen Number
    cs_v50agl_cust = lc_cust.

  ENDMETHOD.


  METHOD if_ex_le_shp_tab_cust_head~pass_fcode_to_subscreen.
  ENDMETHOD.


  METHOD if_ex_le_shp_tab_cust_head~transfer_data_from_subscreen.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZCL_IM_QTC_DELIVERY_HEADER(Name of the implementing class)
* PROGRAM DESCRIPTION: To get data from screen
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   10/18/2016
* OBJECT ID: E060
* TRANSPORT NUMBER(S): ED2K903037
*----------------------------------------------------------------------*

    CALL FUNCTION 'ZQTC_GET_DATA_LIKP'
      IMPORTING
        ex_likp = cs_likp.


  ENDMETHOD.


  METHOD if_ex_le_shp_tab_cust_head~transfer_data_to_subscreen.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZCL_IM_QTC_DELIVERY_HEADER(Name of the implementing class)
* PROGRAM DESCRIPTION: To transfer data to screen
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   10/18/2016
* OBJECT ID: E060
* TRANSPORT NUMBER(S): ED2K903037
*----------------------------------------------------------------------*

    CALL FUNCTION 'ZQTC_SET_DATA_LIKP'
      EXPORTING
        im_likp = is_likp.

  ENDMETHOD.
ENDCLASS.
