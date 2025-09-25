FUNCTION-POOL zqtc_block_ord_review_w012. "MESSAGE-ID ..

**----------------------------------------------------------------------*
** PROGRAM NAME:         LZQTC_BLOCK_ORD_REVIEW_W012TOP                 *
** PROGRAM DESCRIPTION:  Global constant declaration                    *
** DEVELOPER:            Paramita Bose (PBOSE)                          *
** CREATION DATE:        09/03/2017                                     *
** OBJECT ID:            W012                                           *
** TRANSPORT NUMBER(S):  ED2K904702                                     *
**----------------------------------------------------------------------*
**----------------------------------------------------------------------*
** REVISION HISTORY-----------------------------------------------------*
** REVISION NO: <TRANSPORT NO>
** REFERENCE NO:  <DER OR TPR OR SCR>
** DEVELOPER:
** DATE:  MM/DD/YYYY
** DESCRIPTION:
**----------------------------------------------------------------------*

* Constant Declaration
CONSTANTS : c_devid  TYPE zdevid     VALUE 'W012', " Development ID
            c_update TYPE updkz_d    VALUE 'U',    " Update indicator
            c_err    TYPE bapi_mtype VALUE 'E',    " Message type: S Success, E Error, W Warning, I Info, A Abort
            c_abr    TYPE bapi_mtype VALUE 'A',    " Message type: S Success, E Error, W Warning, I Info, A Abort
            c_id     TYPE symsgid    VALUE 'V1',   " Message Class
            c_num    TYPE symsgno    VALUE '042'.  " Message Number

 " Type of Identification Code

* INCLUDE LZQTC_BLOCK_ORD_REVIEW_W012D...    " Local class definition
