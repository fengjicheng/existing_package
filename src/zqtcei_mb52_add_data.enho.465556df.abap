"Name: \PR:RM07MLBS\EX:EHP604_RM07MLBS_03\EI
ENHANCEMENT 0 ZQTCEI_MB52_ADD_DATA.
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCEI_MB52_ADD_DATA
* PROGRAM DESCRIPTION: To Add New Fields to the MB52 Standrd report
* DEVELOPER:           Siva Guda
* CREATION DATE:       07/24/2020
* OBJECT ID:           E255
* TRANSPORT NUMBER(S): ED2K918997
*----------------------------------------------------------------------*
 DATA: ismyearnr        LIKE mara-ismyearnr,         "Media issue year number
       ismarrivaldateac LIKE marc-ismarrivaldateac,  "Actual Goods Arrival Date
       omeng            LIKE vbbe-omeng.             "Open Qty in Stockkeeping Units for Transfer of Reqmts to MRP
ENDENHANCEMENT.
