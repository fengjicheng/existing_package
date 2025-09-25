*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_PURCH_ORD_ENH_CHECK                      *
* PROGRAM DESCRIPTION : Enhance Purchase Order                         *
* Inside this include checking If the Purchase order created for ZNB
* is not equal to ZJIP then error would be populated.
* DEVELOPER           : Writtick Roy(WROY)/Lucky Kodwani(LKODWANI)     *
* CREATION DATE       : 28/02/2016                                     *
* OBJECT ID           : E0143                                          *
* TRANSPORT NUMBER(S) : ED2K904444                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PURCH_ORD_ENH_CHECK
*&---------------------------------------------------------------------*

* Local Work Area Declaration
DATA:  lst_hdr_data  TYPE mepoheader, "Purchase Order Item
       lst_constants TYPE ty_constants.

* Constant Declaration
CONSTANTS : lc_distr_po TYPE rvari_vnam  VALUE 'DISTR_PO',   " ABAP: Name of Variant Variable
            lc_mat_type TYPE rvari_vnam  VALUE 'MAT_TYPE',   " ABAP: Name of Variant Variable
            lc_mtart    TYPE rvari_vnam  VALUE 'MTART',   " ABAP: Name of Variant Variable
            lc_ord_type TYPE rvari_vnam  VALUE 'ORDER_TYPE'. " ABAP: Name of Variant Variable

* Local Variable
DATA : lv_ord_type TYPE esart,
       lv_mat_type TYPE mtart.

* Get the Order Type and Material Type maintain in zcaconstants table.

* Binary search is not required as table will have very few records.
CLEAR lst_constants.
READ TABLE i_constants INTO lst_constants WITH KEY param1 = lc_ord_type
                                                   param2 = lc_distr_po.
IF sy-subrc EQ 0.
  lv_ord_type = lst_constants-low.
ENDIF. " IF sy-subrc EQ 0

* Binary search is not required as table will have very few records.
CLEAR lst_constants.
READ TABLE i_constants INTO lst_constants WITH KEY param1 = lc_mat_type
                                                   param2 = lc_mtart.
IF sy-subrc EQ 0.
  lv_mat_type = lst_constants-low.
ENDIF. " IF sy-subrc EQ 0

* Get Header Data
CALL METHOD im_header->get_data
  RECEIVING
    re_data = lst_hdr_data. "Purchase Order Item

* Distributor Purchase Orders should always be ‘ZNB-Free of Cost’
* for Material Type ‘ZJIP'.
IF lst_hdr_data-bsart = lv_ord_type.
  IF st_mat_detl-mtart NE lv_mat_type.
    MESSAGE e159(zqtc_r2) with lv_mat_type. " Only Distributor Purchase order can be created for material type &.
    ch_failed = abap_true.
    CALL METHOD im_header->invalidate( ).

  ENDIF. " IF st_mat_detl-mtart NE lv_mat_type
ENDIF. " IF lst_hdr_data-bsart = lv_ord_type
