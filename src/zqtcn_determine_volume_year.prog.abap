*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DETERMINE_VOLUME_YEAR
* PROGRAM DESCRIPTION: Determine Volume Year Product
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 2017-09-10
* OBJECT ID: E106 - CR#591
* TRANSPORT NUMBER(S) ED2K908447
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  lst_contract TYPE vedavb.                                "Contract Data

IF vbap-posnr    IS NOT INITIAL    AND                     "Sales Document Item
 ( svbkd-tabix   EQ 0              OR                      "Create data
   vbap-matnr    NE *vbap-matnr    OR                      "Material Number is changed
   vbap-zzsubtyp NE *vbap-zzsubtyp OR                      "Subscription Type is changed
   veda-vbegdat  NE *veda-vbegdat  OR                      "Contract Start Date is changed
   veda-venddat  NE *veda-venddat ).                       "Contract End Date is changed

* Volume Year needs to be populated for Non-BOM Items Or for BOM Components
  IF vbap-stlnr IS INITIAL OR                              "Non-BOM Item
   ( vbap-stlnr IS NOT INITIAL AND                         "BOM Item
     vbap-uepos IS NOT INITIAL ).                          "BOM Component

*   Read contract data and keep it in internal structure
    CALL FUNCTION 'SD_VEDA_SELECT'
      EXPORTING
        i_document_number = vbap-vbeln                     "Contract Document Number
        i_item_number     = vbap-posnr                     "Item Number
        i_trtyp           = t180-trtyp                     "Transaction Type
      IMPORTING
        e_vedavb          = lst_contract.                  "Contract Data
*   Determine Volume Year Product
    PERFORM zz_determine_volume_year IN PROGRAM sapmv45a IF FOUND
      USING vbak-vbtyp                                     "Document Category
            vbap-pstyv                                     "Item Category
            vbap-matnr                                     "Media Product
            lst_contract-vbegdat                           "Contract Start Date
            lst_contract-venddat                           "Contract End Date
   CHANGING vbap-zzvyp.                                    "Volume Year Product
  ENDIF.
ENDIF.
