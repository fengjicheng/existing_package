*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MODIFY_DATA_UKCORE_I0511
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MODIFY_DATA_UKCORE_I0511
* PROGRAM DESCRIPTION: Logic to modify sales order internal tables based
*                      on confirmed quantity for UK Core
*                      Consider the tables records where the line item
*                      has some confirmed quantity
* DEVELOPER          : Jagadeeswara Rao M (JMADAKA)
* CREATION DATE      : 2022-04-21
* OBJECT ID          : I0511 (EAM-6881)
* TRANSPORT NUMBER(S): ED2K926813
*----------------------------------------------------------------------*
DATA: lv_index TYPE sytabix,
      lv_flag  TYPE char1.
CONSTANTS: lc_msgid TYPE syst_msgid  VALUE 'ZQTC_R2',
           lc_msgno TYPE syst_msgno VALUE '616',
           lc_msgty TYPE syst_msgty VALUE 'E'.
CLEAR: lv_index.

IF dxvbap[] IS NOT INITIAL.
  LOOP AT dxvbap INTO DATA(lst_dxvbap).
    lv_index = sy-tabix.
    CLEAR lv_flag.
*** Check if any line item does not has confirmed quantity
    LOOP AT dxvbep INTO DATA(lst_dxvbep) WHERE posnr = lst_dxvbap-posnr.
      IF lst_dxvbep-bmeng IS NOT INITIAL.
        lv_flag = abap_true.
      ENDIF.
    ENDLOOP.

*** If no confirmed quantity for current line item then delete the records from relavant tables with item no
    IF lv_flag IS INITIAL.
      DELETE dxvbap INDEX lv_index.
      DELETE dxvbep WHERE posnr = lst_dxvbap-posnr.
      DELETE dxvbkd WHERE posnr = lst_dxvbap-posnr.
    ENDIF.
  ENDLOOP.

*** If confirmed quantity is not available at all the line items then fail processing output type
  IF dxvbap[] IS INITIAL.
    sy-subrc = 2.

    sy-msgid = lc_msgid.
    sy-msgno = lc_msgno.
    sy-msgty = lc_msgty.
    CLEAR: sy-msgv1, sy-msgv2, sy-msgv3, sy-msgv4.

    MESSAGE ID      sy-msgid
              TYPE    sy-msgty
              NUMBER  sy-msgno
              WITH    sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              RAISING data_not_relevant_for_sending.

**  ELSE.
**    WAIT UP TO 5 SECONDS.
  ENDIF.
ENDIF.
