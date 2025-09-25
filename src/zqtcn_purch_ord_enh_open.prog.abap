*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_PURCH_ORD_ENH_OPEN                       *
* PROGRAM DESCRIPTION : Purchase Initialization  Enhancement           *
* In this include initializating all the global variables .
* DEVELOPER           : Lucky Kodwani(LKODWANI)                        *
* CREATION DATE       : 28/02/2016                                     *
* OBJECT ID           : E0143                                          *
* TRANSPORT NUMBER(S) : ED2K904444                                     *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PURCH_ORD_ENH_INIT
*&---------------------------------------------------------------------*

* clear all the global varibles
    CLEAR: i_eban[],
           i_eban_nb[],
           st_mat_detl,
           v_first_print,
           v_mat_old,
           v_itm_qty,
           v_dropship_fg,
           v_conf_qunt,
*          Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
           v_netpr.
*          End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
