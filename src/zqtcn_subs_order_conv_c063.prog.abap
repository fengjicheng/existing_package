**&---------------------------------------------------------------------*
**&  Include           ZQTCN_SUBS_ORDER_CONV_C063
**&---------------------------------------------------------------------*
**----------------------------------------------------------------------*
** PROGRAM NAME: SAPLZQTCN_SUBS_ORDER_CONV_C063 (Enhancement Implementation)
** PROGRAM DESCRIPTION: Include for Entitlement Usage
** DEVELOPER: PMITRA/SAYANDAS (Priyanka Mitra & Sayantan Das)
** CREATION DATE:   07/02/2017
** OBJECT ID: C063
** TRANSPORT NUMBER(S): ED2K904419
**----------------------------------------------------------------------*
** REVISION HISTORY-----------------------------------------------------*
** REVISION NO: <TRANSPORT NO>
** REFERENCE NO:  <DER OR TPR OR SCR>
** DEVELOPER:
** DATE:  YYYY-MM-DD
** DESCRIPTION:
**----------------------------------------------------------------------*


                CALL FUNCTION 'ZQTC_SUBS_ORDER_CONV_001'
                     EXPORTING
                       im_dxvbak             = dxvbak
                       im_dvtcomag           = dvtcomag
                       im_dlast_dynpro       = dlast_dynpro
                       im_dxmescod           = dxmescod
                     TABLES
                       t_dxbdcdata           = dxbdcdata
                       t_dxvbap              = dxvbap
                       t_dxvbep              = dxvbep
                       t_dyvbep              = dyvbep
                       t_dxvbadr             = dxvbadr
                       t_dyvbadr             = dyvbadr
                       t_dxvbpa              = dxvbpa
                       t_dxvbuv              = dxvbuv
                       t_didoc_data          = didoc_data
                       t_dxkomv              = dxkomv
                       t_dxvekp              = dxvekp
                       t_dyvekp              = dyvekp
                              .
