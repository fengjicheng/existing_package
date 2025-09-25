*---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_REL_ORD_BUS (Include)
* [Called from Sales Orders Data Transfer Routine - 907 (RV45C907)]
* PROGRAM DESCRIPTION: Additional fields for Release Ord Business Data
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       12/07/2017
* OBJECT ID:           E141
* TRANSPORT NUMBER(S): ED2K909765
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: ED2K911914
* REFERENCE NO:  ERP-7404
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE:  04/19/2018
* DESCRIPTION: Copy the field value from the SAP Subscription order
*              to Sales order when Release order are created
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*---------------------------------------------------------------------*
vbkd-konda = cvbkd-konda.                        "Price group (customer)
vbkd-kdgrp = cvbkd-kdgrp.                        "Customer group
vbkd-pltyp = cvbkd-pltyp.                        "Price list type
* BOC - HIPATEL - ERP-7404 - ED2K911914 - 19.04.2018
vbkd-ihrez_e = cvbkd-ihrez_e.                    "Ship-to party character
vbkd-ihrez   = cvbkd-ihrez.                      "Your Reference
vbkd-kdkg2   = cvbkd-kdkg2.                      "Customer condition group 2
vbkd-kdkg5   = cvbkd-kdkg5.                      "Customer condition group 5
* EOC - HIPATEL - ERP-7404 - ED2K911914 - 19.04.2018
