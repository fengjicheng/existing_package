REPORT zqtcc_cust_acc_grp_conv  NO STANDARD PAGE HEADING LINE-COUNT 80 LINE-SIZE 255  .
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCC_CUST_ACC_GRP_CONV
* PROGRAM DESCRIPTION: Account Group conversion
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   08/30/2016
* OBJECT ID: C061
* TRANSPORT NUMBER(S): ED2K902790
*----------------------------------------------------------------------*
INCLUDE zqtcn_cust_acc_grp_conv_top.
INCLUDE zqtcn_cust_acc_grp_conv_sel.
INCLUDE zqtcn_cust_acc_grp_conv_sub.

AT SELECTION-SCREEN OUTPUT.
* Modify Field Properties of Selection Screen
  PERFORM f_modify_screen USING    rb_ktokd
                                   rb_rltyp.

AT SELECTION-SCREEN ON p_ktokdf.
* Validate Customer Account Group (From)
  PERFORM f_validate_acc_grp USING p_ktokdf.

AT SELECTION-SCREEN ON p_ktokdt.
* Validate Customer Account Group (To)
  PERFORM f_validate_acc_grp USING p_ktokdt.

AT SELECTION-SCREEN ON p_rltypf.
* Validate Business Partner Role (From)
  PERFORM f_validate_bp_role USING p_rltypf.

AT SELECTION-SCREEN ON p_rltypt.
* Validate Business Partner Role (To)
  PERFORM f_validate_bp_role USING p_rltypt.

AT SELECTION-SCREEN.
* Compare Customer Account Group
  PERFORM f_compare_acc_grps USING rb_ktokd
                                   p_ktokdf
                                   p_ktokdt.

START-OF-SELECTION.
* Convert Customer Account Group
  PERFORM f_process_acc_grp USING  rb_ktokd
                                   p_ktokdf
                                   p_ktokdt
                                   s_kunnr[]
                          CHANGING i_customers.

* Convert Business Partner Role
  PERFORM f_process_bp_role USING  rb_rltyp
                                   p_rltypf
                                   p_rltypt
                                   s_kunnr[]
                          CHANGING i_customers.

END-OF-SELECTION.
* Display Status Messages
  PERFORM f_display_status  USING  i_customers.
