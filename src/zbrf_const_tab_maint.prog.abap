*&---------------------------------------------------------------------*
*& Report  ZBRF_CONST_TAB_MAINT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZBRF_CONST_TAB_MAINT.
 CONSTANTS:lv_function_id TYPE if_fdt_types=>id VALUE '00505689066D1EDCB1F820C0F3740483'.

  DATA:lv_timestamp TYPE timestamp,
       lt_name_value TYPE abap_parmbind_tab,
       ls_name_value TYPE abap_parmbind,
       lr_data TYPE REF TO data,
       lx_fdt TYPE REF TO cx_fdt,
       la_lv_devid TYPE if_fdt_types=>element_text.

  FIELD-SYMBOLS <la_any> TYPE any.

   types: BEGIN OF ty_const,
          devid  type zcaconstant-devid,
          param1 TYPE zcaconstant-param1,
          param2 TYPE zcaconstant-param2,
          srno TYPE zcaconstant-srno,
          sign TYPE zcaconstant-sign,
          opti TYPE zcaconstant-opti,
          low TYPE zcaconstant-low,
          high TYPE zcaconstant-high,
          activate TYPE zcaconstant-activate,
          description TYPE zcaconstant-description,
          aenam TYPE zcaconstant-aenam,
          aedat TYPE zcaconstant-aedat,
          END OF ty_const.

   DATA: li_result type STANDARD TABLE OF ty_const,
         li_alvout type ref to cl_salv_table,
         li_functions type ref to cl_salv_functions.
****************************************************************************************************
* All method calls within one processing cycle calling the same function must use the same timestamp.
* For subsequent calls of the same function, we recommend to use the same timestamp for all calls.
* This is to improve the system performance.
****************************************************************************************************
* If you are using structures or tables without DDIC binding, you have to declare the respective types
* by yourself. Insert the according data type at the respective source code line.
****************************************************************************************************
  GET TIME STAMP FIELD lv_timestamp.
****************************************************************************************************
* Process a function without recording trace data, passing context data objects via a name/value table.
****************************************************************************************************
* Prepare function processing:
****************************************************************************************************
  SELECTION-SCREEN: begin of block b1 with frame title text-001 .
           Parameters:        p_devid type zdevid.
  SELECTION-SCREEN:end of block b1.

  START-OF-SELECTION.
  ls_name_value-name = 'LV_DEVID'.
  la_LV_DEVID = p_devid.
  GET REFERENCE OF la_LV_DEVID INTO lr_data.
  ls_name_value-value = lr_data.
  INSERT ls_name_value INTO TABLE lt_name_value.
****************************************************************************************************
* Create the data to store the result value after processing the function
* You can skip the following call, if you already have
* a variable for the result. Please replace also the parameter
* EA_RESULT in the method call CL_FDT_FUNCTION_PROCESS=>PROCESS
* with the desired variable.
****************************************************************************************************
*  cl_fdt_function_process=>get_data_object_reference( EXPORTING iv_function_id      = lv_function_id
*                                                                iv_data_object      = '_V_RESULT'
*                                                                iv_timestamp        = lv_timestamp
*                                                                iv_trace_generation = abap_false
*                                                      IMPORTING er_data             = lr_data ).
*  ASSIGN lr_data->* TO <la_any>.
  TRY.
      cl_fdt_function_process=>process( EXPORTING iv_function_id = lv_function_id
                                                  iv_timestamp   = lv_timestamp
                                        IMPORTING ea_result      = li_result
                                        CHANGING  ct_name_value  = lt_name_value ).

      cl_salv_table=>factory( importing r_salv_table = li_alvout
                              changing t_table = li_result ).

        li_functions = li_alvout->get_functions( ).
        li_functions->set_all( abap_true ).

        li_alvout->get_columns( )->set_optimize( ).

        li_alvout->display( ).

      CATCH cx_fdt into lx_fdt.
****************************************************************************************************
* You can check CX_FDT->MT_MESSAGE for error handling.
****************************************************************************************************
  ENDTRY.
