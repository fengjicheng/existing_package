*----------------------------------------------------------------------*
***INCLUDE LZQTC_SALES_ORDER_CONVF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_HEADER_ITEM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_DIDOC_DATA  text
*      <--P_LV_AUNUM  text
*      <--P_LV_ZLSCH  text
*      <--P_LI_ITEM  text
*----------------------------------------------------------------------*
FORM f_get_header_item_data  USING    fp_li_didoc_data TYPE tty_edidd
                             CHANGING fp_lv_aunum      TYPE char10 " Lv_aunum of type CHAR10
                                      fp_lv_zlsch      TYPE char1  " Lv_zlsch of type CHAR1
                                      fp_li_item       TYPE tty_item.

  DATA:      lst_z1qtc_e1edk01_01 TYPE z1qtc_e1edk01_01, " Header General Data Entension
             lst_z1qtc_e1edp01_01 TYPE z1qtc_e1edp01_01, " IDOC Segment for STATUS Field in Item Level
             lst_item             TYPE ty_item,
             lst_didoc_data       TYPE edidd,            " Data record (IDoc)
             lst_e1edp01          TYPE e1edp01,          " IDoc: Document Item General Data
             lv_posex             TYPE string,
             lv_faksp             TYPE string.

****Loop at didoc_data to get data from custom header segment

CLEAR lst_didoc_data-segnam.
   LOOP AT fp_li_didoc_data INTO lst_didoc_data.

    CASE lst_didoc_data-segnam.

      WHEN  c_z1qtc_e1edk01_01. "Header segment : to be populated once for every set of records

        CLEAR: lst_z1qtc_e1edk01_01.

        lst_z1qtc_e1edk01_01 = lst_didoc_data-sdata.
        fp_lv_aunum          = lst_z1qtc_e1edk01_01-aunum.
        fp_lv_zlsch          = lst_z1qtc_e1edk01_01-zlsch.
        CLEAR lst_didoc_data.

      WHEN  c_e1edp01. "item segment
        CLEAR: lst_e1edp01,
               lst_item,
               lv_posex.

        lst_e1edp01    = lst_didoc_data-sdata.
        lst_item-posex = lst_e1edp01-posex.
        lv_posex       = lst_e1edp01-posex.

      WHEN  c_z1qtc_e1edp01_01. "item segment

        CLEAR:lst_z1qtc_e1edp01_01,
              lst_item,
              lv_faksp.

        lst_z1qtc_e1edp01_01 = lst_didoc_data-sdata.
        lst_item-faksp       = lst_z1qtc_e1edp01_01-faksp.
        lv_faksp             = lst_z1qtc_e1edp01_01-faksp.

      WHEN OTHERS.
*        No Actions
    ENDCASE.

    IF  lv_posex  IS NOT INITIAL
    AND lv_faksp  IS NOT INITIAL.

      APPEND lst_item TO fp_li_item.

      CLEAR: lst_item,
             lv_faksp,
             lv_posex ,
             lst_didoc_data.
    ENDIF. " IF lv_posex IS NOT INITIAL

  ENDLOOP. " LOOP AT fp_didoc_data INTO lst_didoc_data


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BDCDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_LV_FNAM  text
*      -->FP_LV_FVAL  text
*      <--FP_LI_BDCDATA  text
*----------------------------------------------------------------------*
FORM f_bdcdata  USING    fp_lv_fnam    TYPE fnam_____4 " Field name
                         fp_lv_fval    TYPE bdc_fval   " BDC field value
                CHANGING fp_li_bdcdata TYPE tty_bdcdata.
*--------------------------------------------------------------------*
*  L O C A L  W O R K - A R E A
*--------------------------------------------------------------------*
  DATA:   lst_bdcdata TYPE bdcdata. " Batch input: New table field structure

  lst_bdcdata-fnam = fp_lv_fnam.
  lst_bdcdata-fval = fp_lv_fval.
  APPEND lst_bdcdata TO fp_li_bdcdata.
  CLEAR lst_bdcdata.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BDCDYNPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0255   text
*      -->P_0256   text
*      -->P_0257   text
*      <--P_LI_BDCDATA  text
*----------------------------------------------------------------------*
FORM f_bdcdynpro  USING    fp_v_program  TYPE bdc_prog  " BDC module pool
                           fp_v_dynpro   TYPE bdc_dynr  " BDC Screen number
                           fp_v_dynbegin TYPE bdc_start " BDC screen start
                  CHANGING fp_li_bdcdata TYPE tty_bdcdata.
*--------------------------------------------------------------------*
*  L O C A L  W O R K - A R E A
*--------------------------------------------------------------------*
  DATA:   lst_bdcdata TYPE bdcdata. " Batch input: New table field structure

  lst_bdcdata-program    = fp_v_program.  " 'SAPLV60F'.
  lst_bdcdata-dynpro     = fp_v_dynpro.   " '4001'.
  lst_bdcdata-dynbegin   = fp_v_dynbegin. "'X'.
  APPEND lst_bdcdata TO fp_li_bdcdata.
  CLEAR lst_bdcdata.
ENDFORM.
