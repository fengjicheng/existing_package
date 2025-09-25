*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_EXPIRE_ORD_WOA_E229
* PROGRAM DESCRIPTION : Idoc generation &  release order
* DEVELOPER           : NPOLINA
* CREATION DATE       : 23/Jan/2020
* OBJECT ID           : I0378
* TRANSPORT NUMBER(S) : ED2K917365.
*----------------------------------------------------------------------*
REPORT zqtcr_expire_ord_woa_e229.

* Top Include contains Variable and Declrations.
INCLUDE zqtcr_exp_ord_woa_top IF FOUND..

* Selection Screen
INCLUDE zqtcr_exp_ord_woa_sel IF FOUND..

* Subroutne declaration.
INCLUDE zqtcr_exp_ord_woa_form IF FOUND..


INITIALIZATION.

* Populate Selection Screen Default Values
  PERFORM f_populate_defaults CHANGING s_auart[]
                                       s_pstyv[]
                                       p_enddt.

START-OF-SELECTION.
* Clear Global Variable + Internal Table.
  PERFORM f_clear_all.

* Populate Selection Screen Default Values
  PERFORM f_populate_defdate CHANGING  p_enddt.


* Fetch and Process Records
  PERFORM f_fetch_n_process   USING    s_auart[]
                                       s_pstyv[]
                                       p_enddt.

END-OF-SELECTION.
* Display Alv Grid as log for IDOC.
  PERFORM f_display_alv_grid .
