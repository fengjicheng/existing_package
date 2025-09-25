FUNCTION-POOL zqtc_renew. "MESSAGE-ID ..

* INCLUDE LZQTC_RENEWD...                    " Local class definition
*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_RENEWTOP(Subscription Inbound Order)
* PROGRAM DESCRIPTION: Include for Subscription Inbound Order
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   30/01/2017
* OBJECT ID: I0338
* TRANSPORT NUMBER(S):  ED2K904103
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909052
* REFERENCE NO: I0338 (CR#696 / ERP-4665)
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 19-OCT-2017
* DESCRIPTION: Code has been enhanced to include the change of email address
*               for bill to and ship to Parters. In Idoc email address will
*               be in E1EDKA3 for Qualf 005.
*-----------------------------------------------------------------------*
*====================================================================*
*  Constants
*====================================================================*
CONSTANTS :
  c_id_s      TYPE symsgid VALUE 'V1',    " Success message type
* Begin of ADD by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
  c_sign_i    TYPE ddsign  VALUE 'I',     " Sign Include
  c_opt_eq    TYPE ddoption VALUE 'EQ',   " Option Equal
* End of ADD by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
  c_msg_no_e  TYPE symsgno VALUE '899',   " Message number
  c_status    TYPE edi_status VALUE '51', " Status
  c_error     TYPE symsgty VALUE 'E',     " Error
  c_e1edk36   TYPE char7 VALUE 'E1EDK36', " E1EDK36
  c_e1edk14   TYPE char7 VALUE 'E1EDK14', " E1EDK14
  c_e1edk02   TYPE char7 VALUE 'E1EDK02', " E1EDK02
* Begin of ADD by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
  c_e1edka1   TYPE char7 VALUE 'E1EDKA1',   " E1EDKA1 segment
  c_e1edka3   TYPE char7 VALUE 'E1EDKA3',   " E1EDKA1 segment
  c_parvw_re  TYPE parvw VALUE 'RE',        " Bill to Party
  c_parvw_rg  TYPE parvw VALUE 'RG',        " Payer
  c_parvw_we  TYPE parvw VALUE 'WE',        " Ship to Party
  c_qualf_005 TYPE edi_qualfo VALUE '005', " Email
  c_itmno_hdr TYPE posnr VALUE '000000',   " Item number header
* End of ADD by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
  c_id        TYPE symsgid VALUE 'V1',    " Success message type
  c_msg_no    TYPE symsgno VALUE '311',   " Message number
  c_succ      TYPE edi_status VALUE '53', " Success
  c_error_a   TYPE symsgty VALUE 'A',     " Error type A
  c_type      TYPE symsgty VALUE 'S',     " Success
* BOC:ED2K913394:GKINTALI:09/19/2018:INC0206656
  c_retv_error_idocs TYPE wfvariable VALUE 'Error_IDOCs'.              "Name of Output Parameter of Workflow Method
* EOC:ED2K913394:GKINTALI:09/19/2018:INC0206656

* Begin of ADD by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
TYPES: BEGIN OF ty_vbpa,
         vbeln TYPE vbeln,
         parvw TYPE parvw,
         kunnr TYPE kunnr,
         adrnr TYPE adrnr,
       END OF ty_vbpa.

DATA:
  v_email_bp    TYPE char70,   " Bill to Party Email
  v_email_sh    TYPE char70,   " Ship to Party Email
  st_e1edka1_rg TYPE e1edka1,  " Payer details
  st_e1edka1_re TYPE e1edka1,  " Bill to Party
  st_e1edka1_we TYPE e1edka1.  " Ship to Party
* End of ADD by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
