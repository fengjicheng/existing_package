*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTC_ROYALTY_INVC_CRDT_I0340
* PROGRAM DESCRIPTION: Royalty Feed From Invoice_Credit.SAP system will
*                      trigger the interface to CORE via TIBCO.
* DEVELOPER(S):        Aratrika Banerjee
* CREATION DATE:       03/23/2017
* OBJECT ID:           I0340
* TRANSPORT NUMBER(S): ED2K905073
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910467
* REFERENCE NO: ERP-6094
* DEVELOPER: Writtick Roy (WROY)
* DATE:  01/24/2018
* DESCRIPTION: Use Material Group 1 instead of Publication Type
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*======================================================================*
* SELECTION SCREEN
*======================================================================*
SELECTION-SCREEN BEGIN OF BLOCK a1.
SELECTION-SCREEN BEGIN OF LINE.
*-----Run from last run date ------*
PARAMETERS: rb_1st RADIOBUTTON GROUP rad1 DEFAULT 'X' USER-COMMAND ucom.
SELECTION-SCREEN COMMENT 3(30) text-005.
*-----Selection date range------*
PARAMETERS: rb_2nd RADIOBUTTON GROUP rad1.
SELECTION-SCREEN COMMENT 36(30) text-006.
SELECTION-SCREEN END OF LINE.

SELECT-OPTIONS: s_date FOR v_pdate NO-EXTENSION MODIF ID dat.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN END OF BLOCK a1.

SELECTION-SCREEN : BEGIN OF BLOCK a2 WITH FRAME TITLE text-001.

PARAMETERS : p_rcvpor TYPE edoc_stli-rcvpor OBLIGATORY, " Port (Partner System)
             p_rcvprn TYPE edoc_stat-rcvprn OBLIGATORY, " Partner Number of Receiver
             p_rcvprt TYPE edi_rcvprt DEFAULT c_ls.     " Partner Type of Receiver

SELECTION-SCREEN : END OF BLOCK a2 .

SELECTION-SCREEN BEGIN OF BLOCK a3 WITH FRAME TITLE text-002.
*Begin of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*SELECT-OPTIONS: s_ismtyp FOR v_pubtyp , " Publication Type
*End   of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
SELECT-OPTIONS: s_mvgr1  FOR v_mat_grp_1 , " Material Group 1
*End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
                s_doctyp FOR v_doctyp , " Source Document Item Type
                s_raic   FOR v_raic ,   " Revenue Accounting Item Class
                s_status FOR v_status,  " Revenue Accounting Item Class Type
*               Begin of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
                s_pst_ct FOR v_post_cat," Category for Posting Document
*               End   of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
                s_rec_st FOR v_rec_status. " Status of Revenue Reconciliation Key
SELECTION-SCREEN END OF BLOCK a3.
