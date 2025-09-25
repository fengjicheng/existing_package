"Name: \PR:SAPLMV01\EX:MASTERIDOC_CREATE_MATMAS_09\EI
ENHANCEMENT 0 ZQTCEI_ISM_MATMAS_SEGMENTS.
* ENHANCEMENT NAME:ZQTCEI_ISM_MATMAS_SEGMENTS
* ENHANCEMENT DESCRIPTION: Generating Sales text segment always  in outbound Idoc
* (Irrespective of whatever is changed on Material master eg : Basic data
*  from tcode MM02) .
* DEVELOPER: Murali(mimmadiset)
* CREATION DATE:   02/22/2020
* OBJECT ID:       I0369.1(OTCM-42871)
* TRANSPORT NUMBER(S):ED2K922113,ED2K922154
**********************************************************
* ENHANCEMENT NAME:ZQTCEI_ISM_MATMAS_SEGMENTS
* DEVELOPER: Murali(mimmadiset)
* CREATION DATE:   03/22/2020
* OBJECT ID:       I0369.1(OTCM-43137)
* TRANSPORT NUMBER(S): ED2K922154
* DESCRIPTION:Requirement is to send the parent course when a basic data change done
* in child course material.
*----------------------------------------------------------------------*
      CONSTANTS:
        lc_wricef_id_i0204 TYPE zdevid   VALUE 'I0204', " Development ID
        lc_ser_num_2_i0204 TYPE zsno     VALUE '002'.   " Serial Number

      DATA:
        lv_var_key_i0204   TYPE ZVAR_KEY,               " Variable Key
        lv_actv_flag_i0204 TYPE zactive_flag.           " Active / Inactive Flag

      CLEAR: lv_actv_flag_i0204.
      lv_var_key_i0204 = message_type.                  " Message Type

*     To check enhancement is active or not
      CALL FUNCTION 'ZCA_ENH_CONTROL'
        EXPORTING
          im_wricef_id   = lc_wricef_id_i0204
          im_ser_num     = lc_ser_num_2_i0204
          im_var_key     = lv_var_key_i0204
        IMPORTING
          ex_active_flag = lv_actv_flag_i0204.

      IF lv_actv_flag_i0204 EQ abap_true.
        INCLUDE zqtcn_ism_matmas_segments_01 IF FOUND.
      ENDIF.
**BOC I0369.1--ED2K922113-mimmadiset OTCM-42871
  CONSTANTS:
        lc_wricef_id_I0369 TYPE zdevid   VALUE 'I0369.1', " Development ID
        lc_ser_num_1_I0369 TYPE zsno     VALUE '001'.  	  " Serial Number

      DATA:
        lv_var_key_I0369   TYPE ZVAR_KEY,                 " Variable Key
        lv_actv_flag_I0369 TYPE zactive_flag.             " Active / Inactive Flag

      CLEAR: lv_actv_flag_I0369.
      lv_var_key_I0369 = message_type.                    " Message Type

*     To check enhancement is active or not
      CALL FUNCTION 'ZCA_ENH_CONTROL'
        EXPORTING
          im_wricef_id   = lc_wricef_id_I0369
          im_ser_num     = lc_ser_num_1_I0369
          im_var_key     = lv_var_key_I0369
        IMPORTING
          ex_active_flag = lv_actv_flag_I0369.

      IF lv_actv_flag_I0369 EQ abap_true.
        INCLUDE ZQTCN_I0369_1_MATMAS_SEG_SALES IF FOUND.
      ENDIF.
**EOC ED2K922113 I0369.1 mimmadiset OTCM-42871
ENDENHANCEMENT.
