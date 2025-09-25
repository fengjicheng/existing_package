*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DB_BOM_ALLOCATION_O01 (Include)
*               [PBO Modules - Modify Screen Properties]
* PROGRAM DESCRIPTION: Add Custom Fields for [1] Year, [2] Currency at
*                      the BOM Header level and for [3] Percentage
*                      Allocation at the BOM Component level
* DEVELOPER: Writtick Roy
* CREATION DATE:   10/30/2017
* OBJECT ID: E162 - CR#607
* TRANSPORT NUMBER(S): ED2K908513
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1100  OUTPUT
*&---------------------------------------------------------------------*
*       Process Before Output (PBO) - Screen 1100
*----------------------------------------------------------------------*
MODULE status_1100 OUTPUT.
  IF st_ctrldata-trtyp EQ c_disp_mode.                "Transaction type: Display
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN c_grp_dbm.                               "Screen Group: DBM
          screen-input = 0.
          MODIFY SCREEN.
        WHEN OTHERS.
*         Nothing to Do
      ENDCASE.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_1000  OUTPUT
*&---------------------------------------------------------------------*
*       Process Before Output (PBO) - Screen 1000
*----------------------------------------------------------------------*
MODULE status_1000 OUTPUT.
  IF st_ctrldata-trtyp EQ c_disp_mode.                "Transaction type: Display
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN c_grp_dbm.                               "Screen Group: DBM
          screen-input = 0.
          MODIFY SCREEN.
        WHEN OTHERS.
*         Nothing to Do
      ENDCASE.
    ENDLOOP.
  ENDIF.
ENDMODULE.
