*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SAP_CWS_SHPD_FROM_SCR (Include Program)
* PROGRAM DESCRIPTION: For print media at Wiley, all journals are initially
* shipped directly from a third party distributor, therefore the distributor
* address will be used. The distributor for each journal will be designated
* as the fixed vendor on the source list. From the source list we will pull
* the fixed vendor and send the address of the vendor as the “ship-from”
* for that product.
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   02/08/2017
* OBJECT ID:  I0322
* TRANSPORT NUMBER(S):  ED2K904348
*----------------------------------------------------------------------*
*======================================================================*
* SELECTION SCREEN
*======================================================================*
SELECTION-SCREEN : BEGIN OF BLOCK a1 WITH FRAME TITLE text-001.

PARAMETERS : p_rcvpor TYPE edoc_stli-rcvpor OBLIGATORY, " Port (Partner System)
             p_rcvprn TYPE edoc_stat-rcvprn OBLIGATORY, " Partner Number of Receiver
             p_rcvprt TYPE edi_rcvprt DEFAULT c_ls.     " Partner Type of Receiver

SELECTION-SCREEN : END OF BLOCK a1 .
