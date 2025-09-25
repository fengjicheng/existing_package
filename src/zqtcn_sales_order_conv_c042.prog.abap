*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SALES_ORDER_CONV_C042
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: SAPLZQTC_SALES_ORDER_CONV (Sales Order Conversion)
* PROGRAM DESCRIPTION: Function Module for Sales Order Conversion
* DEVELOPER: Swagata Mukherjee (SWMUKHERJE)
* CREATION DATE:   05/10/2016
* OBJECT ID: C042
* TRANSPORT NUMBER(S):  ED2K902885
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *

                    CALL FUNCTION 'ZQTC_SALES_ORDER_CONV_002'
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
