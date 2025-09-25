*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_TRANSFER_REASON_051
* PROGRAM DESCRIPTION: Validate and update Order Reason A10
* DEVELOPER: Nageswara (NPOLINA)
* CREATION DATE:   01/July/2019
* OBJECT ID:  E209
* TRANSPORT NUMBER(S):  ED2K915483
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_TRANSFER_REASON_051
*&---------------------------------------------------------------------*
TYPES : BEGIN OF lty_constants,
          devid  TYPE zdevid,                                       "Devid
          param1 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,                                   "Current selection number
          sign   TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high,                          "higher Value of Selection Condition
        END OF lty_constants.

STATICS:
  lis_constants  TYPE STANDARD TABLE OF lty_constants.              "Itab for constants

CONSTANTS:
  lc_devid_e209 TYPE zdevid      VALUE 'E209'.

data: lc_augru   type rvari_vnam value 'AUGRU',
      lc_auart   type rvari_vnam value 'AUART'.

IF lis_constants[] IS INITIAL.
* Get Cnonstant values
  SELECT devid                                                   "Devid
         param1                                                  "ABAP: Name of Variant Variable
         param2                                                  "ABAP: Name of Variant Variable
         srno                                                    "Current selection number
         sign                                                    "ABAP: ID: I/E (include/exclude values)
         opti                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low                                                     "Lower Value of Selection Condition
         high                                                    "Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE lis_constants
    WHERE devid    EQ lc_devid_e209 AND                          "Development ID
          activate EQ abap_true.                                 "Only active record
  IF sy-subrc EQ 0.
    SORT lis_constants[] .
  ENDIF.
ENDIF.

* Check Order Reason match with ZCACONSTANT
READ TABLE lis_constants ASSIGNING FIELD-SYMBOL(<lfs_cons1>) WITH KEY devid = lc_devid_e209
                                                                      param1 = lc_augru
                                                                      low = cvbak-augru.
IF sy-subrc EQ 0.
* Check Source and Target Order types  match with ZCACONSTANT
  READ TABLE lis_constants ASSIGNING FIELD-SYMBOL(<lfs_cons>) WITH KEY devid = lc_devid_e209
                                                                       param1 = lc_auart
                                                                       low = cvbak-auart
                                                                       high = vbak-auart.
  IF sy-subrc EQ 0.
    CLEAR :vbak-augru.
  ENDIF.
ENDIF.
