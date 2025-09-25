*&---------------------------------------------------------------------*
*& Report  ZBRF_REL_ORD_MAINT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZBRF_REL_ORD_MAINT.
CONSTANTS:lv_function_id TYPE if_fdt_types=>id VALUE '00505689066D1EDCB1DFA6872F4AD779'.

Types: BEGIN OF ty_const,
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

  DATA:lv_timestamp TYPE timestamp,
       lt_name_value TYPE abap_parmbind_tab,
       ls_name_value TYPE abap_parmbind,
       lr_data TYPE REF TO data,
       lx_fdt TYPE REF TO cx_fdt,
       la_devid TYPE if_fdt_types=>element_text.

  FIELD-SYMBOLS <la_any> TYPE any.

  DATA: li_tab type STANDARD TABLE OF ty_const,
        li_out type ref to cl_salv_table,
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
  ls_name_value-name = 'DEVID'.
  la_DEVID = 'E231'.
  GET REFERENCE OF la_DEVID INTO lr_data.
  ls_name_value-value = lr_data.
  INSERT ls_name_value INTO TABLE lt_name_value.
****************************************************************************************************
* Create the data to store the result value after processing the function
* You can skip the following call, if you already have
* a variable for the result. Please replace also the parameter
* EA_RESULT in the method call CL_FDT_FUNCTION_PROCESS=>PROCESS
* with the desired variable.
****************************************************************************************************
  cl_fdt_function_process=>get_data_object_reference( EXPORTING iv_function_id      = lv_function_id
                                                                iv_data_object      = '_V_RESULT'
                                                                iv_timestamp        = lv_timestamp
                                                                iv_trace_generation = abap_false
                                                      IMPORTING er_data             = lr_data ).
  ASSIGN lr_data->* TO <la_any>.
  TRY.
      cl_fdt_function_process=>process( EXPORTING iv_function_id = lv_function_id
                                                  iv_timestamp   = lv_timestamp
                                        IMPORTING ea_result      = li_tab
                                        CHANGING  ct_name_value  = lt_name_value ).

       cl_salv_table=>factory( importing r_salv_table = li_out
                              changing t_table = li_tab ).

        li_functions = li_out->get_functions( ).
        li_functions->set_all( abap_true ).

        li_out->get_columns( )->set_optimize( ).
        li_out->display( ).

      CATCH cx_fdt into lx_fdt.
****************************************************************************************************
* You can check CX_FDT->MT_MESSAGE for error handling.
****************************************************************************************************
  ENDTRY.
