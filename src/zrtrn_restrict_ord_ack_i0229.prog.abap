*----------------------------------------------------------------------*
* PROGRAM NAME: ZRTRN_RESTRICT_ORD_ACK_I0229
* PROGRAM DESCRIPTION: Restrict O/P Type if only "Next Date" is changed
* DEVELOPER: Writtick Roy
* CREATION DATE:   2018-03-27
* OBJECT ID: I0229 (ERP-7283)
* TRANSPORT NUMBER(S): ED2K911636
*----------------------------------------------------------------------*
DATA:
  lv_fname_xvbak TYPE char40 VALUE '(SAPMV45A)VBAK',            "Sales Document: Header Data (New)
  lv_fname_yvbak TYPE char40 VALUE '(SAPMV45A)YVBAK',           "Sales Document: Header Data (Old)
  lv_fname_xvbuk TYPE char40 VALUE '(SAPMV45A)XVBUK',           "Sales Document: Header Status and Administrative Data (New)
  lv_next_date   TYPE flag.                                     "Flag: Next date

FIELD-SYMBOLS:
  <lst_xord_hdr> TYPE vbak,                                     "Sales Document: Header Data (New)
  <lst_yord_hdr> TYPE vbak,                                     "Sales Document: Header Data (Old)
  <lst_xord_hst> TYPE vbukvb.                                   "Sales Document: Header Status and Administrative Data (New)

DATA:
  lst_x_ordr_hdr TYPE vbak,                                     "Sales Document: Header Data (New)
  lst_y_ordr_hdr TYPE vbak.                                     "Sales Document: Header Data (Old)

* Retrieve Sales Document: Header Data (New)
ASSIGN (lv_fname_xvbak) TO <lst_xord_hdr>.
IF sy-subrc EQ 0.
  lst_x_ordr_hdr = <lst_xord_hdr>.                              "Sales Document: Header Data (New)
* Retrieve Sales Document: Header Data (Old)
  ASSIGN (lv_fname_yvbak) TO <lst_yord_hdr>.
  IF sy-subrc EQ 0 AND <lst_yord_hdr> IS NOT INITIAL.
    lst_y_ordr_hdr = <lst_yord_hdr>.                            "Sales Document: Header Data (Old)

    IF lst_x_ordr_hdr-cmngv NE lst_y_ordr_hdr-cmngv.            "Next date is changed
      lst_x_ordr_hdr-cmngv = lst_y_ordr_hdr-cmngv.              "Next date
      lst_x_ordr_hdr-aedat = lst_y_ordr_hdr-aedat.              "Changed On

*     Check if Next date is the only field changed
      IF lst_x_ordr_hdr EQ lst_y_ordr_hdr.

        ASSIGN (lv_fname_xvbuk) TO <lst_xord_hst>.              "Sales Document: Header Status and Administrative Data (New)
*       Compare Sales Document: Header Status and Administrative Data
        IF <lst_xord_hst> IS ASSIGNED AND
           <lst_xord_hst>-updkz IS INITIAL.                     "No change in Header Statuses
          lv_next_date = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.

IF lv_next_date IS NOT INITIAL.                                 "Next date is the only field changed
  sy-subrc = 4.                                                 "Do not Send Order Acknowledgement
ELSE.
  sy-subrc = 0.                                                 "Send Order Acknowledgement
ENDIF.
