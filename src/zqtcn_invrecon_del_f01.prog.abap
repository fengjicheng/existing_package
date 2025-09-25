*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_INVRECON_DEL_F01
* PROGRAM DESCRIPTION: To Delete Data from Inventory Recon table
*                      ZQTC_INVEN_RECON based on
*                      Adjustment Type
*                      Material No
*                      Date
*                      Plant
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* CREATION DATE: 21/03/2019
* OBJECT ID: RITM0126734
* TRANSPORT NUMBER(S): ED1K909853
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTC_INVRECON_DEL_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_TABLE_DATA
*&---------------------------------------------------------------------*
* To Retrieve the data from table ZQTC_INVEN_RECON based on
* Adjustment Type(ZADJTYP)
* Material No(MATNR)
* Transactional Date(ZDATE)
* Delivery Plant (WERKS)
*----------------------------------------------------------------------*
FORM f_get_table_data .

* Define local range type for zqtc_inven_recon-zdate
  DATA : lr_zdate  TYPE RANGE OF zqtc_inven_recon-zdate,
* Work area for range table
         lst_zdate LIKE LINE OF lr_zdate.

  SELECT * FROM zqtc_inven_recon INTO TABLE i_invrecon
           WHERE zadjtyp EQ p_adjtyp
             AND matnr   IN s_matnr
             AND zdate   IN s_zdate
             AND werks   IN s_werks.

  IF sy-subrc NE 0.

    lst_zdate-sign   = 'I'.
    lst_zdate-option = 'EQ'.
    lst_zdate-low    = '20181411'.
    APPEND lst_zdate TO lr_zdate .

    SELECT * FROM zqtc_inven_recon INTO TABLE i_invrecon
       WHERE zadjtyp EQ p_adjtyp
         AND matnr   IN s_matnr
         AND zdate   IN lr_zdate
         AND werks   IN s_werks.

  ENDIF.

  IF sy-subrc EQ 0 AND
     p_chk IS INITIAL.
    DELETE zqtc_inven_recon FROM TABLE i_invrecon.

    IF sy-subrc EQ 0.
      MESSAGE 'Deleted Sucessfully' TYPE 'I'.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILED_CATELOG
*&---------------------------------------------------------------------*
*    To Prepare field Catelog based on internal table i_invrecon
*----------------------------------------------------------------------*

FORM f_filed_catelog .

*Merge Field Catalog
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZQTC_INVEN_RECON'
    CHANGING
      ct_fieldcat            = i_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_LIST_DISPLAY
*&---------------------------------------------------------------------*
*  To Display ALV REport
*----------------------------------------------------------------------*

FORM f_alv_list_display .

*Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = i_fieldcat
    TABLES
      t_outtab      = i_invrecon
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.

ENDFORM.
