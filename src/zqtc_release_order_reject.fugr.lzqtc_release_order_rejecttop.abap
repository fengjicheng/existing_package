FUNCTION-POOL ZQTC_RELEASE_ORDER_REJECT.    "MESSAGE-ID ..

CONSTANTS : c_g(1)  TYPE c     VALUE 'G', " Constant Value G
            c_c(1)  TYPE c     VALUE 'C'. " Constant Value C

DATA: lv_jobname TYPE btcjob,
      lv_number  TYPE tbtcjob-jobcount,      "Job number
      li_params  TYPE TABLE OF rsparamsl_255, "Selection table parameter
      lst_params TYPE rsparamsl_255.         "Selection table parameter

* INCLUDE LZQTC_RELEASE_ORDER_REJECTD...     " Local class definition
