*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_INBOUND_TOKEN
* PROGRAM DESCRIPTION : Idoc generation & Token release order
* DEVELOPER           : Yraulji
* CREATION DATE       : 11/08/2017
* OBJECT ID           : I0234
* TRANSPORT NUMBER(S) : ED2K909379.
*----------------------------------------------------------------------*
REPORT zqtcr_bur_exp_token.

* Top Include contains Variable and Declrations.
INCLUDE zqtcn_bur_exp_token_top IF FOUND. " Include zqtcn_bur_exp_token_top

* Selection Screen
INCLUDE zqtcn_bur_exp_token_sel IF FOUND. " Include zqtcn_bur_exp_token_sel

* Subroutne declaration.
INCLUDE zqtcn_bur_exp_token_form IF FOUND. " Include zqtcn_bur_exp_token_form

INITIALIZATION.

* Populate Selection Screen Default Values
  PERFORM f_populate_defaults CHANGING s_auart[]
                                       s_pstyv[]
                                       s_enddt[].

START-OF-SELECTION.
* Clear Global Variable + Internal Table.
  PERFORM f_clear_all.

* Fetch and Process Records
  PERFORM f_fetch_n_process   USING    s_auart[]
                                       s_pstyv[]
                                       s_enddt[].

END-OF-SELECTION.
* Display Alv Grid as log for IDOC.
  PERFORM f_display_alv_grid .
