*---------------------------------------------------------------------*
*PROGRAM NAME : ZQTCN_BP_IDENTIFICATION_UPD_TP (Include Program)           *
*REVISION NO :  ED2K919818                                            *
*REFERENCE NO:  OTCM-29968                                                      *
*DEVELOPER  :  Lahiru Wathudura (LWATHUDURA)                          *
*WRICEF ID  :  E344                                                       *
*DATE       :  02/03/2021                                             *
*DESCRIPTION:  BP Identification creation                             *
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*PROGRAM NAME : ZQTCN_BP_IDENTIFICATION_UPD_F1 (Include Program)      *
*REVISION NO :  ED2K923715                                            *
*REFERENCE NO:  OTCM-46084                                            *
*DEVELOPER  :   Rajkumar Madavoina(MRAJKUMAR)                         *
*WRICEF ID  :   E344                                                  *
*DATE       :  15/06/2021                                             *
*DESCRIPTION:  SFDC ID update in ZQTC_EXT_IDENT                       *
*---------------------------------------------------------------------*

TYPES:BEGIN OF ity_file,
        bp          TYPE bu_partner,
        id_category TYPE bu_id_category,
        id_number   TYPE bu_id_number,
* BOC by Lahiru on 02/03/2021 OTCM-29968 with ED2K919818*
        email       TYPE ad_smtpadr,
        valid_f     TYPE bu_id_valid_date_from,
        valid_t     TYPE bu_id_valid_date_to,
* EOC by Lahiru on 02/03/2021 OTCM-29968 with ED2K919818*
      END OF ity_file.

TYPES:BEGIN OF ity_output,
        sel,
        bp          TYPE bu_partner,
        id_category TYPE bu_id_category,
        id_number   TYPE bu_id_number,
* BOC by Lahiru on 02/03/2021 OTCM-29968 with ED2K919818 *
        email       TYPE ad_smtpadr,
        valid_f     TYPE bu_id_valid_date_from,
        valid_t     TYPE bu_id_valid_date_to,
* EOC by Lahiru on 02/03/2021 OTCM-29968 with ED2K919818 *
        type        TYPE bapi_mtype,   "Msg Type
        message     TYPE bapi_msg,     " Message Description
"SOC of MRAJKUMAR OTCM-46084
        log         TYPE char100,      "Log
"EOC of MRAJKUMAR OTCM-46084
      END OF ity_output.

DATA: i_file_data TYPE STANDARD TABLE OF ity_file,
      i_final     TYPE STANDARD TABLE OF ity_output,
      i_fcat_out  TYPE slis_t_fieldcat_alv.
CONSTANTS:c_e TYPE char1 VALUE 'E',
          c_s TYPE char1 VALUE 'S'.
"SOC of MRAJKUMAR OTCM-46084
DATA : v_log_handle TYPE balloghndl, " Application Log: Log Handle
       v_days       TYPE i,
       v_msgno      TYPE sy-msgno,
       v_exter      TYPE balhdr-extnumber,
       lv_fval(200)          TYPE c.
CONSTANTS: lc_i      TYPE char1 VALUE 'I',
           lc_e      TYPE char1 VALUE 'E',
           lc_slash  TYPE char1 VALUE '/',
           gc_object TYPE balobj_d    VALUE 'ZQTC',
           gc_subobj TYPE balsubobj   VALUE 'ZBPID_EXT'.
"EOC of MRAJKUMAR OTCM-46084
