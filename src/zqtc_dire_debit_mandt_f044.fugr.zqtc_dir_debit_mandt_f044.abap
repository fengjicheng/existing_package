*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTC_DIR_DEBIT_MANDT_F044                      *
* PROGRAM DESCRIPTION:  Function Module for  direct debit mandate  ,   *
*                       used to call the Form for F044                 *
* DEVELOPER:            Sayantan Das (SAYANDAS)                        *
* CREATION DATE:        19/06/2018                                     *
* OBJECT ID:            F044                                           *
* TRANSPORT NUMBER(S):  ED2K912346, ED2K912829                         *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtc_dir_debit_mandt_f044.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VKORG) TYPE  VKORG
*"     REFERENCE(IM_ZLSCH) TYPE  SCHZW_BSEG OPTIONAL
*"     REFERENCE(IM_WAERK) TYPE  WAERK
*"     REFERENCE(IM_SCENARIO) TYPE  CHAR3
*"     REFERENCE(IM_IHREZ) TYPE  IHREZ OPTIONAL
*"     REFERENCE(IM_ADRNR) TYPE  ADRNR
*"     REFERENCE(IM_KUNNR) TYPE  KUNNR
*"     REFERENCE(IM_LANGU) TYPE  SPRAS
*"     REFERENCE(IM_XSTRING) TYPE  XSTRING
*"     REFERENCE(IM_MEM_TEXT) TYPE  CHAR1 OPTIONAL
*"  EXPORTING
*"     REFERENCE(EX_FORMOUTPUT) TYPE  FPFORMOUTPUT
*"----------------------------------------------------------------------
*** Populating global variables
  CLEAR :  v_vkorg , v_waerk , v_scenario , v_langu , v_kunnr.
  v_vkorg = im_vkorg.
  v_waerk = im_waerk.
  v_scenario = im_scenario.
  v_langu = im_langu.
  v_kunnr  = im_kunnr.
  v_ref_text  = im_mem_text.

  DATA : lr_vkorg_uk  TYPE tt_vkorg,
         lr_vkorg_vch TYPE tt_vkorg,
*        Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
         lv_langu_uk  TYPE spras, " Language Key
         lv_langu_vch TYPE spras. " Language Key
*        End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829


*** Fetc Data from Constant table
  PERFORM f_get_constant_data CHANGING lr_vkorg_uk
                                       lr_vkorg_vch
*                                      Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
                                       lv_langu_uk
                                       lv_langu_vch.
*                                      End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829

*** Fetch Data from ADRC Table
  PERFORM f_get_adrc_data USING im_adrnr.

* Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
*** Identify Direct Debit Process
  PERFORM f_get_dd_process.
  IF st_dd_mndt IS INITIAL.
    RETURN.
  ENDIF.
* End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385

*** Inserting Wiley Logo
  v_xstring = im_xstring.

*** Fetch Originators Indentification Number
*   v_langu = im_langu.
* Begin of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385
* IF im_vkorg IN lr_vkorg_uk. "3310
* End   of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385
* Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
  IF st_dd_mndt-dd_process EQ c_dd_uk.
* End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
*   Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
*    IF lv_langu_uk IS NOT INITIAL.
*      v_langu = lv_langu_uk.
*    ENDIF. " IF lv_langu_uk IS NOT INITIAL
*   End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
*      v_langu  =
*** Fetch Direct Debit Guarantee Logo
    PERFORM f_get_drct_dbt_logo USING    im_langu
                                CHANGING v_drct_dbt_logo.

*** Fetch Direct Debit Logo
    PERFORM f_get_direct_debit_logo CHANGING v_direct_debit_logo.

*** Fetch  Originator Identification Number
    PERFORM f_get_oridnum CHANGING st_odnum.

*** Populate your Reference
    PERFORM f_get_ihrez  USING im_ihrez CHANGING st_ihrez.

*** Populate Standard Text for 3310 Company Code
    PERFORM f_get_standard_text1.

*   Begin of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829
****Populate Address for 3310 Company Code
*   PERFORM f_populate_address1.
*   End   of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829

* Begin of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385
* ELSEIF im_vkorg IN lr_vkorg_vch. "5501
* End   of DEL:ERP-7747:WROY:18-SEP-2018:ED2K913385
* Begin of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
  ELSEIF st_dd_mndt-dd_process EQ c_dd_vch.
* End   of ADD:ERP-7747:WROY:18-SEP-2018:ED2K913385
*   Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
*    IF lv_langu_vch IS NOT INITIAL.
*      v_langu = lv_langu_vch.
*    ENDIF. " IF lv_langu_vch IS NOT INITIAL
*   End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829

*** Populate your Reference
    PERFORM f_get_ihrez  USING im_ihrez CHANGING st_ihrez.
*   Begin of DEL:ERP-6302:WROY:07-AUG-2018:ED2K912941
****Populate Address for 5501 Company Code
*   PERFORM f_populate_address2.
*
****Populate Standard Text for 5501 Company Code
*   PERFORM f_get_standard_text2.
*   End   of DEL:ERP-6302:WROY:07-AUG-2018:ED2K912941

  ENDIF. " IF st_dd_mndt-dd_process EQ c_dd_uk

* Perform from where the form has been called and print PDF
* Begin of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
  PERFORM f_adobe_print_output USING lr_vkorg_uk
                                     lr_vkorg_vch.
* End   of ADD:ERP-6302:WROY:30-JUL-2018:ED2K912829
* Begin of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829
* PERFORM f_adobe_print_output.
* End   of DEL:ERP-6302:WROY:30-JUL-2018:ED2K912829
* Populating Export Parameter
  ex_formoutput = st_formoutput.
ENDFUNCTION.
