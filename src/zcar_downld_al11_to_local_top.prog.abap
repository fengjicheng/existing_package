*----------------------------------------------------------------------*
* PROGRAM NAME: ZCAR_DOWNLOAD_AL11_FILE
* PROGRAM DESCRIPTION: This report used to download AL11 file to desktop
* DEVELOPER:           Nageswara
* CREATION DATE:       08/23/2019
* OBJECT ID:           Utility
* TRANSPORT NUMBER(S): ED2K915945
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED2K918057
* REFERENCE NO: OTCM-45542
* DEVELOPER: TDIMANTHA
* DATE: 03/31/2022
* DESCRIPTION:File Download for Media Issue Cockpit(R115)
*&---------------------------------------------------------------------*
*&  Include           ZCAN_DOWNLOADFILE_TOP
*&---------------------------------------------------------------------*

  CONSTANTS : c_blocksize  TYPE i            VALUE 99999,
              c_i0256      TYPE zdevid       VALUE 'I0256 ',             " Development ID
              c_i0315      TYPE zdevid       VALUE 'I0315',              " Development ID
              c_x          TYPE zconstactive VALUE 'X',                  " Activation indicator for constant
              c_gnrl_tcode TYPE sy-tcode     VALUE 'ZCA_AL11_DOWNLOAD',  " AL11 download
              c_err_tcode  TYPE sy-tcode     VALUE 'ZQTC_INV_ERR_LOG',   " Inventory Error log download
* BOI ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
              c_r115       TYPE zdevid       VALUE 'R115',               " Development ID
              c_mi_cp_tcode TYPE sy-tcode    VALUE 'ZQTC_MI_CP_DOWNLOAD'," Media Issue Cockpit download
* EOI ED2K918057 OTCM-45542 TDIMANTHA 03/31/2022
              c_i          TYPE c            VALUE 'I'.                  " Informative message

  TYPES : ty_datablock(c_blocksize) TYPE c,
          BEGIN OF ty_zcaconstant,                    " Structure for ZCACONSTANT table
            devid	 TYPE zdevid,
            param1 TYPE rvari_vnam,
            param2 TYPE rvari_vnam,
            srno   TYPE tvarv_numb,
            low	   TYPE salv_de_selopt_low,
          END OF ty_zcaconstant.

  DATA: v_filename     TYPE string,
        v_flag         TYPE c,
        it_zcaconstant TYPE TABLE OF ty_zcaconstant,  " Internal table.
        v_err_dir_path TYPE esh_e_co_path,             " To store directory path for error files
        v_sys          TYPE esh_e_co_path.             " To store current system id
