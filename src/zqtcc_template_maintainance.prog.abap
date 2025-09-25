*&---------------------------------------------------------------------*
*& Report  ZQTCC_TEMPLATE_MAINTAINANCE
* PROGRAM DESCRIPTION: File layout maintain Main Program
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*
REPORT zqtcc_template_maintainance NO STANDARD PAGE HEADING
                                      MESSAGE-ID zfilupload..


INCLUDE zqtcn_template_maintain_top IF FOUND.        " Define global data

INCLUDE zqtcn_template_maintain_sel IF FOUND.        " Define selection screen

INCLUDE zqtcn_template_maintain_sub IF FOUND.        " Subroutines

INCLUDE fzqtc_template_maintain_onn IF FOUND.        " Template maintainance PBO Include

INCLUDE fzqtc_template_maintain_inn IF FOUND.        " Template maintainance PAI Include
