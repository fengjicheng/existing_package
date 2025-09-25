*----------------------------------------------------------------------*
* PROGRAM NAME        : ZXCLFU02
* PROGRAM DESCRIPTION : Creating and Updating issues from JANIS
* In order to create the new Media Issue with reference to the existing
* Media Issue called “Issue Template”, we hace refered the logic implemented
* inside standard program RJPMPGEN (specifically 2 of the Subroutines
* MARA_SICHERN_PREPARE and MARA_SICHERN).  Standard logic is not considering
* MPOP (table MVOP) values , we have implemented additional logic to consider these,
* since those field values are part of our Conversion / Interface requirement.
* DEVELOPER           : Writtick Roy(WROY)
* CREATION DATE       : 01/11/2017
* OBJECT ID           : I0344
* TRANSPORT NUMBER(S) : ED2K903907
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZXCLFU02
*&---------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_i0344 TYPE zdevid VALUE 'I0344', " Development ID
    lc_ser_num_i0344_1 TYPE zsno   VALUE '001'.   " Serial Number

  DATA:
    lv_actv_flag_i0344 TYPE zactive_flag.         " Active / Inactive Flag

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0344
      im_ser_num     = lc_ser_num_i0344_1
    IMPORTING
      ex_active_flag = lv_actv_flag_i0344.

  IF lv_actv_flag_i0344 EQ abap_true.
    INCLUDE zqtcn_classification_data IF FOUND.
  ENDIF.
