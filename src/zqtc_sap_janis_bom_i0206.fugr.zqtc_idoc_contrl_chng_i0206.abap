*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTC_SAP_TO_JANIS_BOM_I0206                    *
* PROGRAM DESCRIPTION:  Function module to change idoc contol data for *
*                       implementing extension of BOMMAT
* DEVELOPER:            Paramita Bose (PBOSE)                          *
* CREATION DATE:        25/01/2017                                     *
* OBJECT ID:            I0206                                          *
* TRANSPORT NUMBER(S):  ED2K904011                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtc_idoc_contrl_chng_i0206.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     REFERENCE(IDOC_CONTROL) LIKE  EDIDC STRUCTURE  EDIDC
*"  EXCEPTIONS
*"      ERROR
*"      IDOC_ERROR
*"--------------------------------------------------------------------

* Any changes to IDOC_CONTROL-MESTYP will not be processed
* Any changes to IDOC_CONTROL-IDOCTP will not be processed

* BE CAREFUL WITH ANY CHANGES TO IDOC_CONTROL. IT MAY EFFECT YOUR WHOLE
* ALE-SCENARIO

* Constant declaration
  CONSTANTS : lc_extn TYPE edi_cimtyp VALUE 'ZQTCE_BOMMAT04_01'. " Extension

* Populate extension name in idoc control data
  idoc_control-cimtyp = lc_extn.  " Extension name of basic type BOMMAT

ENDFUNCTION.
