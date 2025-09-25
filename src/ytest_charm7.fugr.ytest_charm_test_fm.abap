FUNCTION ytest_charm_test_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_DEV) TYPE  ZDEVID
*"  EXPORTING
*"     REFERENCE(EX_ZCACONS) TYPE  ZCAT_CONSTANTS
*"----------------------------------------------------------------------

  SELECT devid,
            param1,
            param2,
            srno,
            sign,
            opti,
            low,
            high
            INTO TABLE @ex_zcacons
            FROM zcaconstant
            WHERE devid = @im_dev
              AND activate = @abap_true.



ENDFUNCTION.
