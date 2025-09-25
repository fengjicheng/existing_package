***------------------------------------------------------------------------*
*** PROGRAM NAME: ZQTCN_BILL_PLAN_START_DATE (Include)
*** PROGRAM DESCRIPTION: Update the Bill Date in Billing Plan tab
*** at item level for Inbound Subscription Order
*** DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
*** CREATION DATE: 06/18/2018
*** OBJECT ID: I0230 - CR#6122
*** TRANSPORT NUMBER: ED2K912335
***------------------------------------------------------------------------*
*
** Begin of: Local TYPES Declarations
*TYPES: BEGIN OF ty_item_bedat,
*         docnum TYPE edi_docnum,
*         posnr  TYPE posnr_va,
*         bedat  TYPE bedat_fp,
*       END OF ty_item_bedat.
** End of: Local TYPES Declarations
*
** Begin of: Local Data Declarations
*DATA: lv_mem_name    TYPE char30,
*      igt_item_bedat TYPE STANDARD TABLE OF ty_item_bedat INITIAL SIZE 0,
*      ls_item_bedat  TYPE ty_item_bedat,
*      ls_xfplt       TYPE fpltvb.
** End of: Local Data Declarations
*
*
*IF t180-trtyp EQ 'H' AND rv45a-docnum IS NOT INITIAL.
*  CONCATENATE rv45a-docnum '_BILL_DATES' INTO lv_mem_name.
*  IMPORT igt_item_bedat FROM MEMORY ID lv_mem_name.
*  IF igt_item_bedat[] IS NOT INITIAL.
** Iterate the XVBKD table and update the Billing Plan Start date
** and Bill date at Item level
** Here we have considered the XVBKD table because it has a field
** FPLNR (Billing plan number) which is reference to read the data
** from XFPLA and XFPLT
*    LOOP AT xvbkd ASSIGNING FIELD-SYMBOL(<lif_xvbkd>) WHERE fplnr <> ''.
*      READ TABLE igt_item_bedat INTO ls_item_bedat WITH KEY
*                                posnr = <lif_xvbkd>-posnr
*                                BINARY SEARCH.
**      READ TABLE xvbkd INTO DATA(liv_xvbkd) WITH KEY
**                       posnr = ls_item_bedat-posnr
**                       BINARY SEARCH.
*      IF sy-subrc = 0.
*        READ TABLE xfpla INTO DATA(lis_xfpla) WITH KEY
*                         fplnr = <lif_xvbkd>-fplnr
*                         BINARY SEARCH.
*        IF sy-subrc = 0.
*          lis_xfpla-bedat = ls_item_bedat-bedat.
*          lis_xfpla-bedar = ''.
*          ls_xfplt-afdat = ls_item_bedat-bedat.
** Updation of XFPLA internal table
*          MODIFY xfpla FROM lis_xfpla INDEX sy-tabix
*                       TRANSPORTING bedat bedar.
*          READ TABLE xfplt TRANSPORTING NO FIELDS
*                           WITH KEY fplnr = lis_xfpla-fplnr
*                           BINARY SEARCH.
*          IF sy-subrc = 0.
** Updation of XFPLT internal table
*            MODIFY xfplt FROM ls_xfplt INDEX sy-tabix
*                         TRANSPORTING afdat.
*          ENDIF.
**            DELETE igt_item_bedat INDEX 1.
**            IF sy-subrc = 0.
**              EXPORT igt_item_bedat TO MEMORY ID lv_mem_name.
**            ENDIF.
*        ENDIF.
*      ENDIF.
**  ELSE.
**    DELETE FROM MEMORY ID lv_mem_name.
*      CLEAR: lis_xfpla, ls_xfplt.
*    ENDLOOP.
*  ENDIF. " IF igt_item_bedat[] IS NOT INITIAL.
*ENDIF. " IF t180-trtyp EQ 'H' AND rv45a-docnum IS NOT INITIAL.
