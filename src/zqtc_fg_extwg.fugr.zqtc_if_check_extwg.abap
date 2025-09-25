FUNCTION zqtc_if_check_extwg.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_EXTWG) TYPE  EXTWG
*"     VALUE(IM_EWBEZ) TYPE  EWBEZ OPTIONAL
*"  EXPORTING
*"     VALUE(EX_RETURN) LIKE  BAPIRET2 STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------
  DATA:lst_twewt TYPE twewt.
  CONSTANTS:lc_e TYPE char1 VALUE 'E',
            lc_s TYPE char1 VALUE 'S'.

*-------Check the external Material
  SELECT SINGLE *
    FROM twew
    INTO @DATA(lst_twew)
    WHERE extwg = @im_extwg.
  IF lst_twew IS NOT INITIAL.
    ex_return-type = lc_s.
    CONCATENATE lst_twew-extwg
                '- External Material Group is exist'(001) INTO
                ex_return-message.
  ELSE.
*-----Locking Table
    CALL FUNCTION 'ENQUEUE_E_TABLE'
      EXPORTING
        mode_rstable   = lc_e
        tabname        = 'TWEW'
        x_tabname      = abap_true
        x_varkey       = abap_true
        _wait          = abap_true
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.

    IF sy-subrc EQ 0.
      CLEAR lst_twew.
      lst_twew-mandt = sy-mandt.
      lst_twew-extwg = im_extwg.
      INSERT twew FROM lst_twew.
      IF sy-subrc = 0.
        ex_return-type = lc_s.
        CONCATENATE lst_twew-extwg
                    '- External Material Group Updated'(002) INTO
                      ex_return-message.
        CALL FUNCTION 'DEQUEUE_E_TABLE'
          EXPORTING
            mode_rstable = lc_e
            tabname      = 'TWEW'
            x_tabname    = abap_true
            x_varkey     = abap_true
          EXCEPTIONS
            OTHERS       = 1.
*-----Locking Table e  TWEWT
        CALL FUNCTION 'ENQUEUE_E_TABLE'
          EXPORTING
            mode_rstable   = lc_e
            tabname        = 'TWEWT'
            x_tabname      = abap_true
            x_varkey       = abap_true
            _wait          = abap_true
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.

        IF sy-subrc EQ 0.
          CLEAR lst_twewt.
          lst_twewt-mandt = sy-mandt.
          lst_twewt-spras = sy-langu.
          lst_twewt-extwg = im_extwg.
          lst_twewt-ewbez = im_ewbez.
          INSERT twewt FROM lst_twewt.
          IF sy-subrc = 0.
            CALL FUNCTION 'DEQUEUE_E_TABLE'
              EXPORTING
                mode_rstable = lc_e
                tabname      = 'TWEWT'
                x_tabname    = abap_true
                x_varkey     = abap_true
              EXCEPTIONS
                OTHERS       = 1.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFUNCTION.
