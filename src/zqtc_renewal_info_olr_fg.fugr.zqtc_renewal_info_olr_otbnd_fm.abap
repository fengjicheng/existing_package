FUNCTION zqtc_renewal_info_olr_otbnd_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_QUOTEID) TYPE  VBELN_VA
*"  EXPORTING
*"     VALUE(EX_T_RETURN_MSG) TYPE  ZTQTC_RETMSG
*"     VALUE(EX_T_DATA_TAB) TYPE  ZTQTC_SUBSCRPTN_RENEWAL_INFO
*"----------------------------------------------------------------------
*----------------------------------------------------------------------
* PROGRAM NAME        : ZQTC_RENEWAL_INFO_OLR_OTBND_FM
* PROGRAM DESCRIPTION : Subscription Renewal Information
* DEVELOPER           : Shubhanjali Sharma
* CREATION DATE       : 1/11/2017
* OBJECT ID           : I0337
* TRANSPORT NUMBER(S) : ED2K900927
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------
* REVISION NO: ED2K906171, ED2K906173, ED2K906224
* REFERENCE NO: ERP-2160
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 17-MAy-2017
* DESCRIPTION: Tax amounts are not summing up correctly. The issue was due
* to not picking up all the entries from KONV when for all entries is used.
* To correct the same passed the full primary key in the select. Also to
* correct the population logic for Ismpubltype2.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K906474
* REFERENCE NO: JIRA Defect ERP-2444
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 02-Jun-2017
* DESCRIPTION: Added additional conditions in the where clause of KONV to
* to include only statical condition types(KSTAT) and active conditions(KINAK)
*-----------------------------------------------------------------------*
* REVISION NO: ED2K906697
* REFERENCE NO: JIRA Defect ERP-2730
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 02-Jun-2017
* DESCRIPTION: As JKSESCHED will not update for Media issues and SAP confirmed
*              thats JKSESCHED is updated only for subscription but not quotes.
*              Hence we have changed the logic to rerieve from JKSENIP table
*              to get the number of issues and also numbers of orders created.
*              Contract start dates and end dates are taken from quotation as
*              subscription has the previous year dates.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K907521
* REFERENCE NO: JIRA Defect ERP-3548
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 26-Jul-2017
* DESCRIPTION: As per the previous design ISMPUBLTYPE2 field we were passing
*              converted value as 0 or 1. Now they wanted to revert back as
*              TIBCO will do the necessary conversion. Code has been reverted
*              done as part of ERP-2160 relevant for ISMPUBLTYPE2.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K907736
* REFERENCE NO: ERP-3885
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 04-Aug-2017
* DESCRIPTION: As per new changes the mapping for KWERT_H and KWERT_D is
*              Changed to take it from VBAP-KZWI2 and VBAP-KZWI6.
*-----------------------------------------------------------------------*

*Local Data Declaration
  DATA: li_msg      TYPE ztqtc_retmsg,
        lst_msg     TYPE zstqtc_retmsg,
        li_constant TYPE tt_constant.

* Obtain data from database tables
  CALL METHOD lclsubscription_renewal_info=>meth_fetch_data
    EXPORTING
      im_quoteid      = im_quoteid
    IMPORTING
      ex_data_tab     = ex_t_data_tab
      ex_t_return_msg = li_msg
    CHANGING
      ch_constant     = li_constant.

  ex_t_return_msg[] = li_msg[].

* If error messages exist, mail them
  IF li_msg[] IS NOT INITIAL.
* Send email for error notification
    CALL METHOD lclsubscription_renewal_info=>meth_send_email
      EXPORTING
        im_t_error      = li_msg
        im_constant     = li_constant
      CHANGING
        ex_t_return_msg = li_msg.

    ex_t_return_msg[] = li_msg[].

  ENDIF.

* This is needed as TIBCO wants even the success message if data is being pulled.
  IF li_msg IS INITIAL AND ex_t_data_tab IS NOT INITIAL.
    lst_msg-msgty = c_char_s.
    CONCATENATE text-006 im_quoteid INTO lst_msg-message SEPARATED BY space.
    APPEND lst_msg TO ex_t_return_msg.
  ENDIF.

ENDFUNCTION.
