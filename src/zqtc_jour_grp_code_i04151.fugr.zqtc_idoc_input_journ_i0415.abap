*---------------------------------------------------------------------*
*    program for:   VIEWPROC_V_TWEW
*   generation date: 17.02.2022 at 09:48:21 by user Bsaki
*---------------------------------------------------------------------*
FUNCTION zqtc_idoc_input_journ_i0415               .
*"----------------------------------------------------------------------
*"*"Global Interface:
*"  IMPORTING
*"     REFERENCE(INPUT_METHOD) LIKE  BDWFAP_PAR-INPUTMETHD
*"     REFERENCE(MASS_PROCESSING) LIKE  BDWFAP_PAR-MASS_PROC
*"  EXPORTING
*"     VALUE(WORKFLOW_RESULT) LIKE  BDWF_PARAM-RESULT
*"     VALUE(APPLICATION_VARIABLE) LIKE  BDWF_PARAM-APPL_VAR
*"     VALUE(IN_UPDATE_TASK) LIKE  BDWFAP_PAR-UPDATETASK
*"     VALUE(CALL_TRANSACTION_DONE) LIKE  BDWFAP_PAR-CALLTRANS
*"  TABLES
*"      IDOC_CONTRL STRUCTURE  EDIDC
*"      IDOC_DATA STRUCTURE  EDIDD
*"      IDOC_STATUS STRUCTURE  BDIDOCSTAT
*"      RETURN_VARIABLES STRUCTURE  BDWFRETVAR OPTIONAL
*"      SERIALIZATION_INFO STRUCTURE  BDI_SER OPTIONAL
*"  EXCEPTIONS
*"      NO_VALUE_FOR_SUBSET_IDENT
*"      MISSING_CORR_NUMBER
*"      SAVING_CORRECTION_FAILED
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* Initialization: set field-symbols etc.                               *
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_IDOC_INPUT_JOURN_I0415
* PROGRAM DESCRIPTION : v_twew view data records update
* DEVELOPER           : SGUDA
* CREATION DATE       : 01/12/2022
* OBJECT ID           : I0415
* TRANSPORT NUMBER(S) :
*----------------------------------------------------------------------*
  " Data Declarations for Inbound Process
  DATA :
    lst_seg_info    TYPE e1dd03l  ,  " inbound segment.
    lst_seg_info_ob TYPE ze1dd03l , " outbound segment.
    lst_twew        TYPE twew,
    lst_twewt       TYPE twewt,
    lst_idoc_status TYPE bdidocstat,
    v_status        TYPE sy-msgv1.

  CONSTANTS :
    c_seg_data  TYPE edilsegtyp   VALUE 'E1DD03L',
    c_mestyp_ob TYPE edp13-mestyp VALUE 'ZQTC_JOURNAL_CODE_OB',
    c_tabname   TYPE tabname      VALUE 'TWEW',
    c_tabnamet  TYPE tabname      VALUE 'TWEWT',
    c_s         TYPE char1        VALUE 'S',
    c_e         TYPE char1        VALUE 'E',
    c_51        TYPE char2        VALUE '51',
    c_53        TYPE char2        VALUE '53'.

  "Data Declaration for Outbound Declaration
  DATA :
    lst_idoc_data_out    TYPE edidd, lt_idoc_data_out    TYPE TABLE OF edidd WITH HEADER LINE,
    lst_idoc_control_out TYPE edidc, lt_idoc_control_out TYPE TABLE OF edidc WITH HEADER LINE,
    lst_idoc_data_in     TYPE edidd, lt_idoc_data_in     TYPE TABLE OF edidd WITH HEADER LINE,
    lst_idoc_contrl_in   TYPE edidc, lt_idoc_contrl_in   TYPE TABLE OF edidc WITH HEADER LINE,
    lst_idoc_status_in   TYPE edidc, lt_idoc_status_in   TYPE TABLE OF edids WITH HEADER LINE.

  " clear  and refresh wa and ITabs

  CLEAR : lst_idoc_data_out , lst_idoc_control_out , lst_idoc_data_in , lst_idoc_contrl_in , lst_idoc_status_in  ,
          lst_seg_info  , lst_seg_info_ob, lst_twew , lst_twewt , lst_idoc_status, v_status .

  REFRESH : lt_idoc_data_out , lt_idoc_control_out, lt_idoc_data_in , lt_idoc_contrl_in  , lt_idoc_status_in   .

  " Inbound IDocs Process
  LOOP AT idoc_data INTO DATA(lst_idoc) WHERE segnam = c_seg_data.

    lst_seg_info     = lst_idoc-sdata.
    lst_twew-extwg   = lst_seg_info-fieldname.     " ext mat grp
    lst_twewt-extwg  = lst_twew-extwg.             " ext mat grp
    lst_twewt-ewbez  = lst_seg_info-rollname.      " ext mat grp desc
    lst_twewt-spras  = sy-langu .                  " sy langu

    IF lst_twew-extwg IS NOT INITIAL. " segment data missing checking
      " exits data checking
      SELECT SINGLE extwg , ewbez FROM twewt INTO @DATA(lv_extwg) WHERE extwg = @lst_twew-extwg .
      IF sy-subrc NE 0.
        PERFORM lock_table USING c_tabname c_e CHANGING v_status. " locking TWEW Table
        IF v_status IS INITIAL.
          CLEAR : v_status .
          PERFORM lock_table USING c_tabnamet c_e CHANGING v_status. " locking TWEWT Text Table
          IF v_status IS INITIAL.
            IF lv_extwg-extwg IS INITIAL.
              INSERT twew FROM lst_twew. "
            ENDIF.
            IF sy-subrc = 0 .
              MODIFY twewt FROM lst_twewt.
              IF sy-subrc = 0 .
                "----Inbound Success IDOC Filling
                PERFORM idoc_status USING lst_idoc-docnum c_53 c_s text-t01 sy-uname sy-repid CHANGING idoc_status[].
                "----Outbound IDOC Data Filling
                PERFORM idoc_data_ob USING lst_twew-extwg lst_twewt-ewbez c_s text-t06 lst_idoc
                                     CHANGING lst_seg_info_ob lt_idoc_data_out[].

                "unlocking  TWEW  & TWEWT Tables
                PERFORM unlock_table USING c_tabname c_e .
                PERFORM unlock_table USING c_tabnamet c_e .
              ELSEIF sy-subrc <> 0.
                "*----Failing the IDOC Filling
                PERFORM idoc_status USING lst_idoc-docnum c_51 c_e text-t03 sy-uname sy-repid CHANGING idoc_status[].
                "----Outbound IDOC Data Filling
                PERFORM idoc_data_ob USING lst_twew-extwg lst_twewt-ewbez c_e text-t03 lst_idoc
                                     CHANGING lst_seg_info_ob lt_idoc_data_out[].
                DELETE twew FROM lst_twew .
                "unlocking  TWEW  & TWEWT Tables Filling
                PERFORM unlock_table USING c_tabname c_e .
                PERFORM unlock_table USING c_tabnamet c_e .
              ENDIF.
            ELSEIF sy-subrc <> 0.
              "unlocking  TWEW  & TWEWT Tables Filling
              PERFORM unlock_table USING c_tabname c_e .
              PERFORM unlock_table USING c_tabnamet c_e .
              "*----Failing the IDOC Filling
              PERFORM idoc_status USING lst_idoc-docnum c_51 c_e text-t03 sy-uname sy-repid CHANGING idoc_status[].
              "----Outbound IDOC Data Filling
              PERFORM idoc_data_ob USING lst_twew-extwg lst_twewt-ewbez c_e text-t03 lst_idoc
                                     CHANGING lst_seg_info_ob lt_idoc_data_out[].
            ENDIF.
          ELSE.
            "unlocking  TWEW Table Filling
            PERFORM unlock_table USING c_tabname c_e .
            PERFORM idoc_status USING lst_idoc-docnum c_51 c_e v_status sy-uname sy-repid CHANGING idoc_status[].
            "----Outbound IDOC Data Filling
            PERFORM idoc_data_ob USING lst_twew-extwg lst_twewt-ewbez c_e v_status lst_idoc
                                     CHANGING lst_seg_info_ob lt_idoc_data_out[].
          ENDIF.
        ELSE.
          "**----Failing the IDOC Filling
          PERFORM idoc_status USING lst_idoc-docnum c_51 c_e v_status sy-uname sy-repid CHANGING idoc_status[].
          "----Outbound IDOC Data Filling
          PERFORM idoc_data_ob USING lst_twew-extwg lst_twewt-ewbez c_e v_status lst_idoc
                                     CHANGING lst_seg_info_ob lt_idoc_data_out[].
        ENDIF.
      ELSE.
        "**----Failing the IDOC Filling
        PERFORM idoc_status USING lst_idoc-docnum c_51 c_s text-t02 sy-uname sy-repid CHANGING idoc_status[].
        "----Outbound IDOC Data Filling
        PERFORM idoc_data_ob USING lst_twew-extwg lst_twewt-ewbez c_e text-t02 lst_idoc
                                     CHANGING lst_seg_info_ob lt_idoc_data_out[].
      ENDIF.
    ELSE.
      "**----Failing the IDOC Filling
      PERFORM idoc_status USING lst_idoc-docnum c_51 c_e text-t05 sy-uname sy-repid CHANGING idoc_status[].
      "----Outbound IDOC Data Filling
      PERFORM idoc_data_ob USING lst_twew-extwg lst_twewt-ewbez c_e text-t05 lst_idoc
                                     CHANGING lst_seg_info_ob lt_idoc_data_out[].
    ENDIF.

    CLEAR : lst_twew , lst_twewt, lst_seg_info , lst_idoc, v_status , lv_extwg .

  ENDLOOP.

  "outbound idocs process
  IF lt_idoc_data_out[] IS NOT INITIAL.

    "Inbound data moving to Temp Itab
    lt_idoc_status_in[] = idoc_status[].
    lt_idoc_contrl_in[] = idoc_contrl[].
    lt_idoc_data_in[]   = idoc_data[].

    FREE : idoc_status[] , idoc_contrl[] , idoc_data[].

    SELECT SINGLE * FROM edp13 INTO @DATA(lst_edp13) WHERE mestyp = @c_mestyp_ob .
    IF sy-subrc = 0.
      MOVE-CORRESPONDING lst_edp13 TO lst_idoc_control_out .

      lst_idoc_control_out-idoctp = lst_edp13-idoctyp.
      lst_idoc_control_out-maxsegnum = 1.
      APPEND lst_idoc_control_out TO lt_idoc_control_out[].

      CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
        EXPORTING
          master_idoc_control            = lst_idoc_control_out
        TABLES
          communication_idoc_control     = lt_idoc_control_out[]
          master_idoc_data               = lt_idoc_data_out[]
        EXCEPTIONS
          error_in_idoc_control          = 1
          error_writing_idoc_status      = 2
          error_in_idoc_data             = 3
          sending_logical_system_unknown = 4
          OTHERS                         = 5.
      IF sy-subrc <> 0.
*     Implement suitable error handling here
      ENDIF.

    ENDIF. " end if for edp13 select query

    "retain temp data into inb itab data
    idoc_status[] = lt_idoc_status_in[].
    idoc_contrl[] = lt_idoc_contrl_in[].
    idoc_data[]   = lt_idoc_data_in[].

  ENDIF .


ENDFUNCTION.
