FUNCTION zqtc_block_ord_trig_cond_w012 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VBELN) TYPE  VBELN
*"     REFERENCE(IM_TASK) TYPE  SWW_TASK
*"  EXPORTING
*"     REFERENCE(EX_FLAG) TYPE  CHAR1
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTC_BLOCK_ORD_TRIG_COND_W012                  *
* PROGRAM DESCRIPTION:  Function Module implemented to state the       *
*                       triggering mechanism of blocked order review   *
*                       workflow.                                      *
* DEVELOPER:            Paramita Bose (PBOSE)                          *
* CREATION DATE:        27/02/2017                                     *
* OBJECT ID:            W012                                           *
* TRANSPORT NUMBER(S):  ED2K904702                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

* Fetch sales data from VBAK table
  SELECT SINGLE vbeln, " Sales Doc
                auart, " Order type
                lifsk, " Delivery Block
                faksk, " Billing Block
                vkorg, " Sales Org
                vtweg, " Distribution Channel
                spart  " Division
    FROM vbak          " Sales Document: Header Data
    INTO @DATA(lst_vbak)
    WHERE vbeln EQ @im_vbeln.
  IF sy-subrc EQ 0.

* Fetch delivery bolck and billing block from approval matrix
    SELECT SINGLE lifsk,    " Delivery block (document header)
                  faksk     " Billing block in SD document
      FROM zqtc_apprvl_mtrx " Approval table for Subs WF
      INTO @DATA(lst_appvl_matrix)
      WHERE vkorg EQ @lst_vbak-vkorg
        AND vtweg EQ @lst_vbak-vtweg
        AND spart EQ @lst_vbak-spart
        AND auart EQ @lst_vbak-auart
        AND lifsk EQ @lst_vbak-lifsk
        AND faksk EQ @lst_vbak-faksk.
    IF sy-subrc EQ 0.
*     Check if delivery block and billing block is in VBAK
*     matched with the value maintained in the custom
*     table, then assign X to the flag to trigger the WF.
      IF lst_appvl_matrix-lifsk EQ lst_vbak-lifsk
       AND lst_appvl_matrix-faksk EQ lst_vbak-faksk.

*        Check if a valid WF is already triggered. If not or if the status is any
*        of the following then only WF will be triggered.
        SELECT
          a~wi_id        AS wi_id,
          a~instid       as instid,
          b~wi_stat      AS wi_stat " Processing Status of a Work Item
          FROM sww_wi2obj AS a
          INNER JOIN swwwihead AS b
          ON a~wi_id = b~wi_id
          INTO TABLE @DATA(li_status)
          WHERE a~instid = @im_vbeln
            and a~WI_RH_TASK = @im_task"'WS90100013'
          ORDER BY a~wi_id ASCENDING.

        IF sy-subrc EQ 0.
          READ TABLE li_status INTO DATA(lv_status) INDEX sy-tfill.
          IF lv_status-wi_stat EQ 'ERROR'         "Error
            OR lv_status-wi_stat EQ 'CANCELLED'   "Logically Deleted
            OR lv_status-wi_stat EQ 'COMPLETED'   "Completed
            OR lv_status-wi_stat EQ 'EXCPCAUGHT'  "Exception Caught
            OR lv_status-wi_stat EQ 'EXCPHANDLR'. "Exception Being Handled
            ex_flag = abap_true. " X
          ENDIF. " IF lv_status-wi_stat EQ 'ERROR'
        ELSE. " ELSE -> IF sy-subrc EQ 0
          ex_flag = abap_true. " X
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF lst_appvl_matrix-lifsk EQ lst_vbak-lifsk
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0

ENDFUNCTION.
