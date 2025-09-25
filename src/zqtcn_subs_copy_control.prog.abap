*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SUBS_COPY_CONTROL (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used for changes or checks,
*                      before a document is saved.
*	This include will copy the  Sub ref ID unique number to the follow on
* document like Quotation, Renewal Subscription which is created with
* reference to the first time created subscription.
* DEVELOPER: Lucky Kodwani(lkodwani)
* CREATION DATE:   10/20/2016
* OBJECT ID: E112
* TRANSPORT NUMBER(S): ED2K903129
*----------------------------------------------------------------------*
*----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------
* REVISION NO: ED2K907844
* REFERENCE NO: ERP-3828
* DEVELOPER: WROY (Writtick Roy)
* DATE: 09-AUG-2017
* DESCRIPTION: Additional Business Data fields are mapped
*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_SUBS_COPY_CONTROL
* DEVELOPER: Lahiru Wathudura(lwathdura)
* CREATION DATE:  05/19/2020
* WRICEF ID: E096
* TRANSPORT NUMBER(S):  ED2K918411
* REFERENCE NO: ERPM-16504
* Change : Additional Business Data fields are mapped(Customer Purchase order No)
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SUBS_COPY_CONTROL
*&---------------------------------------------------------------------*

  vbkd-ihrez   =  cvbkd-ihrez.           "Your Reference
* Begin of ADD:ERP-3828:WROY:09-AUG-2017:ED2K907844
  vbkd-bstdk   =  cvbkd-bstdk.           "Customer purchase order date
  vbkd-bsark   =  cvbkd-bsark.           "Customer purchase order type

  vbkd-bstkd_e =  cvbkd-bstkd_e.         "Ship-to Party's Purchase Order Number
  vbkd-bstdk_e =  cvbkd-bstdk_e.         "Ship-to party's PO date
  vbkd-bsark_e =  cvbkd-bsark_e.         "Ship-to party purchase order type
  vbkd-ihrez_e =  cvbkd-ihrez_e.         "Ship-to party character
  vbkd-posex_e =  cvbkd-posex_e.         "Item Number of the Underlying Purchase Order
* End   of ADD:ERP-3828:WROY:09-AUG-2017:ED2K907844
**** Begin of adding by Lahiru on 06/17/2020 for ERPM-16504 with ED2K918411 ****
  vbkd-bstkd  =  cvbkd-bstkd.            " Customer Po number
**** End of adding by Lahiru on 06/17/2020 for ERPM-16504 with ED2K918411 ****
