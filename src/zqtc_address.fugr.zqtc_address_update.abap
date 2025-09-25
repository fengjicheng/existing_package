FUNCTION zqtc_address_update.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(VBELN) TYPE  VBELN
*"     VALUE(ADRNR) TYPE  ADRNR
*"     VALUE(PARVW) TYPE  PARVW
*"----------------------------------------------------------------------
  TYPE-POOLS:szadr.

  DATA:lv_ret     TYPE ad_retcode,
       lv_adgroup TYPE ad_group,
       li_out     TYPE TABLE OF szadr_addr1_complete,
       li_compl   TYPE TABLE OF szadr_addr1_complete,
       li_oadr    TYPE TABLE OF szadr_addr1_complete.
  CONSTANTS:lc_u  TYPE ad_updflag VALUE 'U',
            lc_we TYPE parvw VALUE 'WE'.

  IF vbeln IS NOT INITIAL.
    SELECT SINGLE adrnr FROM vbpa INTO @DATA(lv_adrnr)
      WHERE vbeln = @vbeln
        AND parvw = @lc_we
        AND posnr = '000000'.
    IF sy-subrc EQ 0.

      CALL FUNCTION 'ADDR_GET_COMPLETE'
        EXPORTING
          addrnumber              = lv_adrnr
*         ADDRHANDLE              =
*         ARCHIVE_HANDLE          =
*         IV_CURRENT_COMM_DATA    = 'X'
*         BLK_EXCPT               =
        IMPORTING
          addr1_complete          = li_oadr
        EXCEPTIONS
          parameter_error         = 1
          address_not_exist       = 2
          internal_error          = 3
          wrong_access_to_archive = 4
          address_blocked         = 5
          OTHERS                  = 6.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'ADDR_MAINTAIN_COMPLETE'
          EXPORTING
            updateflag         = lc_u
            addr1_complete     = li_compl
            address_group      = lv_adgroup
*           SUBSTITUTE_ALL_COMM_DATA             = ' '
*           CHECK_ADDRESS      = 'X'
*           CONSIDER_CONSNUMBER_FOR_INSERT       = ' '
*           IV_TIME_DEPENDENT_COMM_DATA          = ' '
*           BLK_EXCPT          =
          IMPORTING
            returncode         = lv_ret
            addr1_complete_out = li_out
*      TABLES
*           ERROR_TABLE        =
          EXCEPTIONS
            parameter_error    = 1
            address_not_exist  = 2
            handle_exist       = 3
            internal_error     = 4
            address_blocked    = 5
            OTHERS             = 6.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.



      ENDIF.
    ENDIF.
  ENDIF.


ENDFUNCTION.
