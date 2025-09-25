*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SD_COND_ACCESS_BUFFER (Include)
*               Called from "SD_COND_ACCESS_BUFFER~ACTIVATE" (BADI Meth)
* PROGRAM DESCRIPTION: Activate Program Buffer for Cond Table A911
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   30-NOV-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K909087
*----------------------------------------------------------------------*
    DATA:
      lst_db_buf_tab_active TYPE if_ex_sd_cond_access_buffer~ty_db_buf_tab_active.

    lst_db_buf_tab_active-kappl = c_kappl_v.                         "Application: V (Sales)
    lst_db_buf_tab_active-kotab = c_kotab_a911.                      "Condition table: A911
    INSERT lst_db_buf_tab_active INTO TABLE ct_db_buf_tab_active.
