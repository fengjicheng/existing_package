CLASS zclqtc_badi_sdoc_wrapper_mass DEFINITION "
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_badi_sdoc_wrapper .
*   Begin of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
    INTERFACES if_sdoc_select .

    CONSTANTS:
*   End   of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
      BEGIN OF c_table,
        tbnam_vbrk TYPE tabname   VALUE 'VBRK', " Table Name
        tbnam_vbrp TYPE tabname   VALUE 'VBRP', " Table Name
        tbnam_vbak TYPE tabname   VALUE 'VBAK', " Table Name
        tbnam_vbap TYPE tabname   VALUE 'VBAP', " Table Name
        tbnam_vbkd TYPE tabname   VALUE 'VBKD', " Table Name
        tbnam_vbuk TYPE tabname   VALUE 'VBUK', " Table Name
        tbnam_vbpa TYPE tabname   VALUE 'VBPA', " Table Name
        tbnam_vbfa TYPE tabname   VALUE 'VBFA', " Table Name
*       Begin of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
        tbnam_knvv TYPE tabname   VALUE 'KNVV', " Table Name
        tbnam_adrc TYPE tabname   VALUE 'ADRC', " Table Name
*       End   of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
        tbnam_veda TYPE tabname   VALUE 'VEDA', " Table Name
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
        tbnam_konv TYPE tabname   VALUE 'KONV', " Table Name
      END OF c_table .
    CONSTANTS:
      BEGIN OF c_field,
        fnam_vbeln         TYPE fieldname VALUE 'VBELN_VF',      " Field Name
        fnam_fkart         TYPE fieldname VALUE 'FKART',         " Field Name
        fnam_fktyp         TYPE fieldname VALUE 'FKTYP',         " Field Name
        fnam_fkdat         TYPE fieldname VALUE 'FKDAT',         " Field Name
        fnam_netwr         TYPE fieldname VALUE 'NETWR',         " Field Name
        fnam_kunrg         TYPE fieldname VALUE 'KUNRG',         " Field Name
        fnam_pstyv         TYPE fieldname VALUE 'PSTYV',         " Field Name
        fnam_vgbel         TYPE fieldname VALUE 'VGBEL',         " Field Name
        fnam_zterm         TYPE fieldname VALUE 'DZTERM',        " Field Name
        fnam_ihrez         TYPE fieldname VALUE 'IHREZ',         " Field Name
        fnam_bsark         TYPE fieldname VALUE 'BSARK',         " Field Name
        fnam_zzsfdccase    TYPE fieldname VALUE 'ZZSFDCCASE',    " Field Name
        fnam_zzfice        TYPE fieldname VALUE 'ZZFICE',        " Field Name
        fnam_zznoreturn    TYPE fieldname VALUE 'ZZNORETURN',    " Field Name
        fnam_zzholdfrom    TYPE fieldname VALUE 'ZZHOLDFROM',    " Field Name
        fnam_zzholdto      TYPE fieldname VALUE 'ZZHOLDTO',      " Field Name
        fnam_zzpromo       TYPE fieldname VALUE 'ZZPROMO',       " Field Name
        fnam_zzwhs         TYPE fieldname VALUE 'ZZWHS',         " Field Name
        fnam_zzlicgrp      TYPE fieldname VALUE 'ZZLICGRP',      " Field Name
        fnam_mwsbp         TYPE fieldname VALUE 'MWSBP',         " Field Name
        fnam_zzrgcode      TYPE fieldname VALUE 'ZZRGCODE',      " Field Name
        fnam_zzcancdate    TYPE fieldname VALUE 'ZZCANCDATE',    " Field Name
        fnam_zzartno       TYPE fieldname VALUE 'ZZARTNO',       " Field Name
        fnam_zzisbnlan     TYPE fieldname VALUE 'ZZISBNLAN',     " Field Name
        fnam_zzshpocanc    TYPE fieldname VALUE 'ZZSHPOCANC',    " Field Name
        fnam_zzsubtyp      TYPE fieldname VALUE 'ZZSUBTYP',      " Field Name
        fnam_zzvyp         TYPE fieldname VALUE 'ZZVYP',         " Field Name
        fnam_zzaccess_mech TYPE fieldname VALUE 'ZZACCESS_MECH', " Field Name
        fnam_zzconstart    TYPE fieldname VALUE 'ZZCONSTART',    " Field Name
        fnam_zzconend      TYPE fieldname VALUE 'ZZCONEND',      " Field Name
        fnam_zzlicstart    TYPE fieldname VALUE 'ZZLICSTART',    " Field Name
        fnam_zzlicend      TYPE fieldname VALUE 'ZZLICEND',      " Field Name
        fnam_buchk         TYPE fieldname VALUE 'BUCHK',         " Field Name
        fnam_mvgr1         TYPE fieldname VALUE 'MVGR1',         " Field Name
        fnam_mvgr2         TYPE fieldname VALUE 'MVGR2',         " Field Name
        fnam_mvgr3         TYPE fieldname VALUE 'MVGR3',         " Field Name
        fnam_mvgr4         TYPE fieldname VALUE 'MVGR4',         " Field Name
        fnam_mvgr5         TYPE fieldname VALUE 'MVGR5',         " Field Name
        fnam_kvgr1         TYPE fieldname VALUE 'KVGR1',         " Field Name
        fnam_kvgr2         TYPE fieldname VALUE 'KVGR2',         " Field Name
        fnam_kvgr3         TYPE fieldname VALUE 'KVGR3',         " Field Name
        fnam_kvgr4         TYPE fieldname VALUE 'KVGR4',         " Field Name
        fnam_kvgr5         TYPE fieldname VALUE 'KVGR5',         " Field Name
        fnam_lifsk         TYPE fieldname VALUE 'LIFSK',         " Field Name
        fnam_faksk         TYPE fieldname VALUE 'FAKSK',         " Field Name
        fnam_gjahr         TYPE fieldname VALUE 'GJAHR',         " Field Name
        fnam_poper         TYPE fieldname VALUE 'POPER',         " Field Name
        fnam_konda         TYPE fieldname VALUE 'KONDA',         " Field Name
        fnam_kdgrp         TYPE fieldname VALUE 'KDGRP',         " Field Name
        fnam_pltyp         TYPE fieldname VALUE 'PLTYP',         " Field Name
        fnam_inco1         TYPE fieldname VALUE 'INCO1',         " Field Name
        fnam_zlsch         TYPE fieldname VALUE 'SCHZW_BSEG',    " Field Name
        fnam_ktgrd         TYPE fieldname VALUE 'KTGRD',         " Field Name
        fnam_zukri         TYPE fieldname VALUE 'DZUKRI',        " Field Name
        fnam_ernam         TYPE fieldname VALUE 'ERNAM',         " Field Name
        fnam_erzet         TYPE fieldname VALUE 'ERZET',         " Field Name
        fnam_erdat         TYPE fieldname VALUE 'ERDAT',         " Field Name
        fnam_stceg         TYPE fieldname VALUE 'STCEG',         " Field Name
        fnam_sfakn         TYPE fieldname VALUE 'SFAKN',         " Field Name
        fnam_kurst         TYPE fieldname VALUE 'KURST',         " Field Name
        fnam_mschl         TYPE fieldname VALUE 'MSCHL',         " Field Name
        fnam_zuonr         TYPE fieldname VALUE 'ORDNR_V',       " Field Name
        fnam_mwsbk         TYPE fieldname VALUE 'MWSBP',         " Field Name
        fnam_kidno         TYPE fieldname VALUE 'KIDNO',         " Field Name
        fnam_posnr         TYPE fieldname VALUE 'POSNR_VF',      " Field Name
        fnam_uepos         TYPE fieldname VALUE 'UEPOS',         " Field Name
        fnam_kzwi1         TYPE fieldname VALUE 'KZWI1',         " Field Name
        fnam_kzwi2         TYPE fieldname VALUE 'KZWI2',         " Field Name
        fnam_kzwi3         TYPE fieldname VALUE 'KZWI3',         " Field Name
        fnam_kzwi4         TYPE fieldname VALUE 'KZWI4',         " Field Name
        fnam_kzwi5         TYPE fieldname VALUE 'KZWI5',         " Field Name
        fnam_kzwi6         TYPE fieldname VALUE 'KZWI6',         " Field Name
        fnam_prctr         TYPE fieldname VALUE 'PRCTR',         " Field Name
        fnam_txjcd         TYPE fieldname VALUE 'TXJCD',         " Field Name
        fnam_kdkg2         TYPE fieldname VALUE 'KDKG2',         " Field Name
        fnam_parvw         TYPE fieldname VALUE 'PARVW',         " Field Name
        fnam_vbtyp_n       TYPE fieldname VALUE 'VBTYP_N',       " Field Name
        fnam_vbeln_vbfa    TYPE fieldname VALUE 'VBELN_NACH',    " Field Name
        fnam_vkgrp         TYPE fieldname VALUE 'VKGRP',         " Field Name
        fnam_zuonrk        TYPE fieldname VALUE 'ZUONR',         " Field Name
*       Begin of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
        fnam_kunnr         TYPE fieldname VALUE 'KUNNR',      " Field Name
        fnam_vkorg         TYPE fieldname VALUE 'VKORG',      " Field Name
        fnam_vtweg         TYPE fieldname VALUE 'VTWEG',      " Field Name
        fnam_spart         TYPE fieldname VALUE 'SPART',      " Field Name
        fnam_zzfte         TYPE fieldname VALUE 'ZZFTE',      " Field Name
        fnam_addrn         TYPE fieldname VALUE 'ADDRNUMBER', " Field Name
        fnam_email         TYPE fieldname VALUE 'AD_SMTPADR', " Field Name
*       End   of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
*** BOC BY SAYANDAS FOR CR706 on 12-OCT-2017
        fnam_bname         TYPE fieldname VALUE 'BNAME',   " Field Name
        fnam_ihrez_e       TYPE fieldname VALUE 'IHREZ_E', " Field Name
        fnam_bstkd_e       TYPE fieldname VALUE 'BSTKD_E', " Field Name
*** BOC BY SAYANDAS FOR CR778 on 04-MAY-2018
        fnam_kdmat         TYPE fieldname VALUE 'KDMAT', " Field Name
*** EOC BY SAYANDAS FOR CR778 on 04-MAY-2018
*** EOC BY SAYANDAS FOR CR706 on 12-OCT-2017
*---Begin of change VDPATABALL DM1748 03/19/2019
        fnam_shipto        TYPE fieldname VALUE 'KUNWE',
        fnam_name          TYPE fieldname VALUE 'CHAR200',
        fnam_media_type    TYPE fieldname VALUE 'ISMMEDIATYPE_KTXT',
        fnam_street        TYPE fieldname VALUE 'AD_STREET',
        fnam_street2       TYPE fieldname VALUE 'AD_STRSPP1',
        fnam_city          TYPE fieldname VALUE 'AD_CITY1',
        fnam_region        TYPE fieldname VALUE 'REGIO',
        fnam_postal        TYPE fieldname VALUE 'AD_PSTCD1',
        fnam_country       TYPE fieldname VALUE 'LAND1',
        fnam_msg           TYPE fieldname VALUE 'TDLINE',
*---End of change VDPATABALL DM1748 03/19/2019
*---Begin of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
        fnam_lifnr         TYPE fieldname VALUE 'LIFNR',        " Frieght Forwader
        fnam_fwname        TYPE fieldname VALUE 'CHAR200',
*---End of change by Lahiru on 10/02/2020 ERPM-9418 with  ED2K917536
*---Begin of change by Lahiru on 03/10/2020 ERPM-10485 with ED2K917757
        fnam_ebeln         TYPE fieldname VALUE 'EBELN',    " PO Number
        fnam_delno         TYPE fieldname VALUE 'VBELN',    " Outbound delivery number
        fnam_bedat         TYPE fieldname VALUE 'BEDAT',    " Purchasing Document Date
        fnam_bldat         TYPE fieldname VALUE 'BLDAT',    " Delivery date
        fnam_vtext         TYPE fieldname VALUE 'VTEXT',    " Shipping conditions
        fnam_auart         TYPE fieldname VALUE 'AUART',    " subscription order type
        fnam_cmgst         TYPE fieldname VALUE 'CMGST',    " Credit Status
        fnam_bezei         TYPE fieldname VALUE 'BEZEI',   " Credit status descrption
*---End of change by Lahiru on 03/10/2020 ERPM-10485 with ED2K917536
*---Begin of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229
        fnam_abgru         TYPE fieldname VALUE 'ABGRU',    " Rejection Reason
        fnam_zlsch_1       TYPE fieldname VALUE 'ZLSCH',    " Payment method
        fnam_vtext_1       TYPE fieldname VALUE 'VTEXT',    " Billing type description
        fnam_pstatus       TYPE fieldname VALUE 'CHAR8',    " Paid status
        fnam_crlimit       TYPE fieldname VALUE 'NETWR',    " Credit Limit
*---End of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
        fnam_vbegdat       TYPE fieldname VALUE 'VBEGDAT',    " Contract Start date
        fnam_venddat       TYPE fieldname VALUE 'VENDDAT',    " Contract end date
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
        fnam_kbetr         TYPE fieldname VALUE 'KBETR',      " Tax Line Item
      END OF c_field .
    CONSTANTS:
      BEGIN OF c_table_field,
        vbrk_vbeln         TYPE fieldname VALUE 'VBRK_VBELN',         " Field Name
        vbrk_fkart         TYPE fieldname VALUE 'VBRK_FKART',         " Field Name
        vbrk_fktyp         TYPE fieldname VALUE 'VBRK_FKTYP',         " Field Name
        vbrk_fkdat         TYPE fieldname VALUE 'VBRK_FKDAT',         " Field Name
        vbrk_netwr         TYPE fieldname VALUE 'VBRK_NETWR',         " Field Name
        vbrk_kunrg         TYPE fieldname VALUE 'VBRK_KUNRG',         " Field Name
        vbak_zzsfdccase    TYPE fieldname VALUE 'VBAK_ZZSFDCCASE',    " Field Name
        vbak_zzfice        TYPE fieldname VALUE 'VBAK_ZZFICE',        " Field Name
        vbak_zznoreturn    TYPE fieldname VALUE 'VBAK_ZZNORETURN',    " Field Name
        vbak_zzholdfrom    TYPE fieldname VALUE 'VBAK_ZZHOLDFROM',    " Field Name
        vbak_zzholdto      TYPE fieldname VALUE 'VBAK_ZZHOLDTO',      " Field Name
        vbak_zzpromo       TYPE fieldname VALUE 'VBAK_ZZPROMO',       " Field Name
        vbak_zzwhs         TYPE fieldname VALUE 'VBAK_ZZWHS',         " Field Name
        vbak_zzlicgrp      TYPE fieldname VALUE 'VBAK_ZZLICGRP',      " Field Name
        vbap_mwsbp         TYPE fieldname VALUE 'VBAP_MWSBP',         " Field Name
        vbap_pstyv         TYPE fieldname VALUE 'VBAP_PSTYV',         " Field Name
        vbap_mvgr1         TYPE fieldname VALUE 'VBAP_MVGR1',         " Field Name
        vbap_mvgr2         TYPE fieldname VALUE 'VBAP_MVGR2',         " Field Name
        vbap_mvgr3         TYPE fieldname VALUE 'VBAP_MVGR3',         " Field Name
        vbap_mvgr4         TYPE fieldname VALUE 'VBAP_MVGR4',         " Field Name
        vbap_mvgr5         TYPE fieldname VALUE 'VBAP_MVGR5',         " Field Name
        vbap_zzpromo       TYPE fieldname VALUE 'VBAP_ZZPROMO',       " Field Name
        vbap_zzrgcode      TYPE fieldname VALUE 'VBAP_ZZRGCODE',      " Field Name
        vbap_zzcancdate    TYPE fieldname VALUE 'VBAP_ZZCANCDATE',    " Field Name
        vbap_zzartno       TYPE fieldname VALUE 'VBAP_ZZARTNO',       " Field Name
        vbap_zzisbnlan     TYPE fieldname VALUE 'VBAP_ZZISBNLAN',     " Field Name
        vbap_zzshpocanc    TYPE fieldname VALUE 'VBAP_ZZSHPOCANC',    " Field Name
        vbap_zzsubtyp      TYPE fieldname VALUE 'VBAP_ZZSUBTYP',      " Field Name
        vbap_zzvyp         TYPE fieldname VALUE 'VBAP_ZZVYP',         " Field Name
        vbap_zzaccess_mech TYPE fieldname VALUE 'VBAP_ZZACCESS_MECH', " Field Name
        vbap_zzconstart    TYPE fieldname VALUE 'VBAP_ZZCONSTART',    " Field Name
        vbap_zzconend      TYPE fieldname VALUE 'VBAP_ZZCONEND',      " Field Name
        vbap_zzlicstart    TYPE fieldname VALUE 'VBAP_ZZLICSTART',    " Field Name
        vbap_zzlicend      TYPE fieldname VALUE 'VBAP_ZZLICEND',      " Field Name
        vbuk_buchk         TYPE fieldname VALUE 'VBUK_BUCHK',         " Field Name
        vbkd_bsark         TYPE fieldname VALUE 'VBKD_BSARK',         " Field Name
        vbkd_ihrez         TYPE fieldname VALUE 'VBKD_IHREZ',         " Field Name
        vbak_kvgr1         TYPE fieldname VALUE 'VBAK_KVGR1',         " Field Name
        vbak_kvgr2         TYPE fieldname VALUE 'VBAK_KVGR2',         " Field Name
        vbak_kvgr3         TYPE fieldname VALUE 'VBAK_KVGR3',         " Field Name
        vbak_kvgr4         TYPE fieldname VALUE 'VBAK_KVGR4',         " Field Name
        vbak_kvgr5         TYPE fieldname VALUE 'VBAK_KVGR5',         " Field Name
        vbak_lifsk         TYPE fieldname VALUE 'VBAK_LIFSK',         " Field Name
        vbak_faksk         TYPE fieldname VALUE 'VBAK_FAKSK',         " Field Name
        vbak_vgbel         TYPE fieldname VALUE 'VBAK_VGBEL',         " Field Name
        vbrk_gjahr         TYPE fieldname VALUE 'VBRK_GJAHR',         " Field Name
        vbrk_poper         TYPE fieldname VALUE 'VBRK_POPER',         " Field Name
        vbrk_konda         TYPE fieldname VALUE 'VBRK_KONDA',         " Field Name
        vbrk_kdgrp         TYPE fieldname VALUE 'VBRK_KDGRP',         " Field Name
        vbrk_pltyp         TYPE fieldname VALUE 'VBRK_PLTYP',         " Field Name
        vbrk_inco1         TYPE fieldname VALUE 'VBRK_INCO1',         " Field Name
        vbrk_zterm         TYPE fieldname VALUE 'VBRK_ZTERM',         " Field Name
        vbrk_zlsch         TYPE fieldname VALUE 'VBRK_ZLSCH',         " Field Name
        vbrk_ktgrd         TYPE fieldname VALUE 'VBRK_KTGRD',         " Field Name
        vbrk_zukri         TYPE fieldname VALUE 'VBRK_ZUKRI',         " Field Name
        vbrk_ernam         TYPE fieldname VALUE 'VBRK_ERNAM',         " Field Name
        vbrk_erzet         TYPE fieldname VALUE 'VBRK_ERZET',         " Field Name
        vbrk_erdat         TYPE fieldname VALUE 'VBRK_ERDAT',         " Field Name
        vbrk_stceg         TYPE fieldname VALUE 'VBRK_STCEG',         " Field Name
        vbrk_sfakn         TYPE fieldname VALUE 'VBRK_SFAKN',         " Field Name
        vbrk_kurst         TYPE fieldname VALUE 'VBRK_KURST',         " Field Name
        vbrk_mschl         TYPE fieldname VALUE 'VBRK_MSCHL',         " Field Name
        vbrk_zuonr         TYPE fieldname VALUE 'VBRK_ZUONR',         " Field Name
        vbrk_mwsbk         TYPE fieldname VALUE 'VBRK_MWSBK',         " Field Name
        vbrk_kidno         TYPE fieldname VALUE 'VBRK_KIDNO',         " Field Name
        vbrp_vbeln         TYPE fieldname VALUE 'VBRP_VBELN',         " Field Name
        vbrp_posnr         TYPE fieldname VALUE 'VBRP_POSNR',         " Field Name
        vbrp_uepos         TYPE fieldname VALUE 'VBRP_UEPOS',         " Field Name
        vbrp_netwr         TYPE fieldname VALUE 'VBRP_NETWR',         " Field Name
        vbrp_kzwi1         TYPE fieldname VALUE 'VBRP_KZWI1',         " Field Name
        vbrp_kzwi2         TYPE fieldname VALUE 'VBRP_KZWI2',         " Field Name
        vbrp_kzwi3         TYPE fieldname VALUE 'VBRP_KZWI3',         " Field Name
        vbrp_kzwi4         TYPE fieldname VALUE 'VBRP_KZWI4',         " Field Name
        vbrp_kzwi5         TYPE fieldname VALUE 'VBRP_KZWI5',         " Field Name
        vbrp_kzwi6         TYPE fieldname VALUE 'VBRP_KZWI6',         " Field Name
        vbrp_prctr         TYPE fieldname VALUE 'VBRP_PRCTR',         " Field Name
        vbrp_txjcd         TYPE fieldname VALUE 'VBRP_TXJCD',         " Field Name
        vbak_bsark         TYPE fieldname VALUE 'VBAK_BSARK',         " Field Name
        vbkd_kdkg2         TYPE fieldname VALUE 'VBKD_KDKG2',         " Field Name
        vbkd_konda         TYPE fieldname VALUE 'VBKD_KONDA',         " Field Name
        vbpa_parvw         TYPE fieldname VALUE 'VBPA_PARVW',         " Field Name
        vbfa_vbtyp_n       TYPE fieldname VALUE 'VBFA_VBTYP_N',       " Field Name
        vbfa_vbeln         TYPE fieldname VALUE 'VBFA_VBELN',         " Field Name
        vbak_vkgrp         TYPE fieldname VALUE 'VBAK_VKGRP',         " Field Name
        vbak_zuonr         TYPE fieldname VALUE 'VBAK_ZUONR',         " Field Name
*       Begin of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
        knvv_zzfte         TYPE fieldname VALUE 'KNVV_ZZFTE',         " Field Name
        sp_addrn           TYPE fieldname VALUE 'SP_ADDRNUMBER',      " Field Name
        sp_email           TYPE fieldname VALUE 'SP_EMAIL',           " Field Name
*       End   of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
*** BOC BY SAYANDAS FOR CR706 on 12-OCT-2017
        vbak_bname         TYPE fieldname VALUE 'VBAK_BNAME',   " Field Name
        vbkd_ihrez_e       TYPE fieldname VALUE 'VBKD_IHREZ_E', " Field Name
        vbkd_bstkd_e       TYPE fieldname VALUE 'VBKD_BSTKD_E', " Field Name
*** EOC BY SAYANDAS FOR CR706 on 12-OCT-2017
*** BOC BY SAYANDAS FOR CR778 on 04-May-2018
        vbap_kdmat         TYPE fieldname VALUE 'VBAP_KDMAT', " Field Name
*** BOC BY SAYANDAS FOR CR778 on 04-May-2018
*---Begin of change VDPATABALL DM1748 03/19/2019
        sp_stras           TYPE fieldname VALUE 'SP_STREET',    "Soldto street
        sp_ort01           TYPE fieldname VALUE 'SP_CITY',      "Soldto city
        sp_regio           TYPE fieldname VALUE 'SP_REGION',    "Soldto Region/state
        sp_pstlz           TYPE fieldname VALUE 'SP_POSTAL',    "Soldto Postal code
        sp_land1           TYPE fieldname VALUE 'SP_COUNTRY',   "Soldto COuntry
        sp_street2         TYPE fieldname VALUE 'SP_STREET2',   "Sold to street2
        shipto             TYPE fieldname VALUE 'SHIPTO',       "Shipto
        matnr              TYPE fieldname VALUE 'MATNR',
        " shipto_name        TYPE fieldname VALUE 'SHIPTO_NAME',   "Shipto Name
        shipto_name1       TYPE fieldname VALUE 'SHIPTO_NAME1',   "Shipto Name
        shipto_name2       TYPE fieldname VALUE 'SHIPTO_NAME2',   "Shipto Name
        ship_email         TYPE fieldname VALUE 'SHIP_EMAIL',   "Shipto Email
        sh_stras           TYPE fieldname VALUE 'SH_STREET',    "Shipto street
        sh_street2         TYPE fieldname VALUE 'SH_STREET2',   "Shipto street2
        sh_ort01           TYPE fieldname VALUE 'SH_CITY',      "Shipto City
        sh_regio           TYPE fieldname VALUE 'SH_REGION',    "Shipto Rehion/state
        sh_pstlz           TYPE fieldname VALUE 'SH_POSTAL',    "Shipto Postal code
        sh_land1           TYPE fieldname VALUE 'SH_COUNTRY',   "Shipto Country
        mediatype          TYPE fieldname VALUE 'MEDIATYPE',
        vbap_vbeln         TYPE fieldname VALUE 'VBELN',
        vbap_posnr         TYPE fieldname VALUE 'POSNR',
        vbap_text          TYPE fieldname VALUE 'TDLINE',
*---End of change VDPATABALL DM1748 03/19/2019
*---Begin of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
        vbpa_lifnr         TYPE fieldname VALUE 'VBPA_LIFNR',   " Frieght Forwader
        fw_name            TYPE fieldname VALUE 'FW_NAME',      " Forwader Name
        fw_street          TYPE fieldname VALUE 'FW_STREET',    " Forwader street
        fw_ort01           TYPE fieldname VALUE 'FW_CITY',      " Forwader City
        fw_postal          TYPE fieldname VALUE 'FW_POSTAL',    " Forwader Postal code
        fw_land1           TYPE fieldname VALUE 'FW_COUNTRY',   " Forwader Country
*---End of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
*---Begin of change by Lahiru on 03/10/2020 ERPM-10485 with ED2K917757
        ekko_ebeln         TYPE fieldname VALUE 'EKKO_EBELN',
        likp_vbeln         TYPE fieldname VALUE 'LIKP_VBELN',
        po_date            TYPE fieldname VALUE 'PO_DATE',     " Purchasing Document Date
        del_date           TYPE fieldname VALUE 'DEL_DATE',    " Delivery date
        ship_cond          TYPE fieldname VALUE 'SH_COND',     " Shipping conditions
        order_type         TYPE fieldname VALUE 'ORD_TYPE',    " subscription order type
        credit_stat        TYPE fieldname VALUE 'CR_STATUS',   " Credit Status
        credit_desc        TYPE fieldname VALUE 'CR_DESC',     " credit status descrption
*---End of change by Lahiru on 03/10/2020 ERPM-10485 with ED2K917536
*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*
        vbkd_zlsch         TYPE fieldname VALUE 'VBKD_ZLSCH',   " Payment method
        bill_desc          TYPE fieldname VALUE 'BILL_DESC',    " Billing document type description
        paid_status        TYPE fieldname VALUE 'PAID_STATUS',  " Paid Status
        cr_limit           TYPE fieldname VALUE 'CREDIT_LIMIT', " Credit Limit
        slodto_name2       TYPE fieldname VALUE 'SOLDTO_NAME2',   "Soldto Name
*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
*        veda_vbegdat       TYPE fieldname VALUE 'VEDA_VBEGDAT',    " Contract Start date
*        veda_venddat       TYPE fieldname VALUE 'VEDA_VENDDAT',    " Contract end date
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
*       Begin of ADD:OCTM-49065:NPALLA:20-Oct-2021:
        vbap_kzwi6         TYPE fieldname VALUE 'VBAP_KZWI6',         " Tax Line Item
        vbak_kzwi6         TYPE fieldname VALUE 'VBAK_KZWI6',         " Tax Header
        konv_kbetr         TYPE fieldname VALUE 'KONV_KBETR',         " Condition Type
*       End of ADD:OCTM-49065:NPALLA:20-Oct-2021:
      END OF c_table_field .
    CONSTANTS:
      BEGIN OF c_sel_scrn_field,
        sel_scrn_fld_pstyv       TYPE scrfffld  VALUE 'S_PSTYV',  " Get table field or program field (generic)
        sel_scrn_fld_vgbel       TYPE scrfffld  VALUE 'S_VGBEL',  " Get table field or program field (generic)
        sel_scrn_fld_zterm       TYPE scrfffld  VALUE 'S_ZTERM',  " Get table field or program field (generic)
        sel_scrn_fld_ztrmr       TYPE scrfffld  VALUE 'S_ZTRMR',  " Get table field or program field (generic)
        sel_scrn_fld_ihrez       TYPE scrfffld  VALUE 'S_IHREZ',  " Get table field or program field (generic)
        sel_scrn_fld_sbtyp       TYPE scrfffld  VALUE 'S_SBTYP',  " Get table field or program field (generic)
        sel_scrn_fld_bsark       TYPE scrfffld  VALUE 'S_BSARK',  " Get table field or program field (generic)
        sel_scrn_fld_bldoc       TYPE scrfffld  VALUE 'S_BLDOC',  " Get table field or program field (generic)
        sel_scrn_fld_bltyp       TYPE scrfffld  VALUE 'S_BLTYP',  " Get table field or program field (generic)
        sel_scrn_fld_ernam       TYPE scrfffld  VALUE 'S_ERNAM',  " Get table field or program field (generic)
        sel_scrn_fld_erdat       TYPE scrfffld  VALUE 'S_ERDAT',  " Get table field or program field (generic)
        sel_scrn_fld_kunrg       TYPE scrfffld  VALUE 'S_KUNRG',  " Get table field or program field (generic)
        sel_scrn_fld_vbtyp       TYPE scrfffld  VALUE 'S_VBTY_N', " Get table field or program field (generic)
        sel_scrn_fld_vblen       TYPE scrfffld  VALUE 'S_VBELN',  " Get table field or program field (generic)
        sel_scrn_fld_promo       TYPE scrfffld  VALUE 'S_PROMO',  " Get table field or program field (generic)
        sel_scrn_fld_zligp       TYPE scrfffld  VALUE 'S_ZZLIGP', " Get table field or program field (generic)
        sel_scrn_fld_lcgrp       TYPE scrfffld  VALUE 'S_LICGRP', " Get table field or program field (generic)
        sel_scrn_fld_mvgr1       TYPE scrfffld  VALUE 'S_MVGR1',  " Get table field or program field (generic)
        sel_scrn_fld_mvgr2       TYPE scrfffld  VALUE 'S_MVGR2',  " Get table field or program field (generic)
        sel_scrn_fld_mvgr3       TYPE scrfffld  VALUE 'S_MVGR3',  " Get table field or program field (generic)
        sel_scrn_fld_mvgr4       TYPE scrfffld  VALUE 'S_MVGR4',  " Get table field or program field (generic)
        sel_scrn_fld_mvgr5       TYPE scrfffld  VALUE 'S_MVGR5',  " Get table field or program field (generic)
        sel_scrn_fld_zuonr       TYPE scrfffld  VALUE 'S_ZUONR',  " Get table field or program field (generic)
*** BOC BY SAYANDAS FOR CR706 on 12-OCT-2017
        sel_scrn_fld_ihrez_e     TYPE scrfffld VALUE 'S_IHREZE', " Get table field or program field (generic)
        sel_scrn_fld_bname       TYPE scrfffld VALUE 'S_BNAME',  " Get table field or program field (generic)
*** BOC BY SAYANDAS FOR CR706 on 12-OCT-2017
*** BOC BY SAYANDAS for CR778 on 04-MAY-2018
        sel_scrn_fld_kdmat       TYPE scrfffld VALUE 'S_KDMAT',  " Get table field or program field (generic)
        sel_scrn_fld_tmatnr      TYPE scrfffld VALUE 'S_MATNR2', " Get table field or program field (generic)
*** BOC BY SAYANDAS for CR778 on 04-MAY-2018
        sel_scrn_blk_z01         TYPE scrfffld  VALUE 'Z01',      " Get table field or program field (generic)
        sel_scrn_blk_z02         TYPE scrfffld  VALUE 'Z02',      " Get table field or program field (generic)
        sel_scrn_blk_z03         TYPE scrfffld  VALUE 'Z03',      " Get table field or program field (generic)
        sel_scrn_blk_z04         TYPE scrfffld  VALUE 'Z04',      " Get table field or program field (generic)
        sel_scrn_text            TYPE scrfffld  VALUE '-TEXT',    " Get table field or program field (generic)
        sel_scrn_block           TYPE scrfffld  VALUE 'BLOCK',    " Get table field or program field (generic)
        sel_scrn_fld_kdkg2       TYPE scrfffld  VALUE 'S_KDKG2',  " Get table field or program field (generic)
        sel_scrn_fld_lifsk       TYPE scrfffld  VALUE 'S_LIFSK',  " Get table field or program field (generic)
        sel_scrn_fld_faksk       TYPE scrfffld  VALUE 'S_FAKSK',  " Get table field or program field (generic)
        sel_scrn_fld_custcn      TYPE scrfffld  VALUE 'S_CUSTCN', " Get table field or program field (generic)
        sel_scrn_fld_dlvblk      TYPE scrfffld  VALUE 'S_DLVBLK', " Get table field or program field (generic)
        sel_scrn_fld_bilblk      TYPE scrfffld  VALUE 'S_BILBLK', " Get table field or program field (generic)
*---Begin of change VDPATABALL DM1748 03/19/2019
        sel_scrn_fld_lang        TYPE scrfffld  VALUE 'S_LANG',
        sel_scrn_fld_object      TYPE scrfffld  VALUE 'S_OBJECT',
        sel_scrn_fld_tdid        TYPE scrfffld  VALUE 'S_TDID',
        sel_scrn_blk_z05         TYPE scrfffld  VALUE 'Z05',
        sel_scrn_layout          TYPE scrfffld  VALUE 'P_LAYOUT',
*---End of change VDPATABALL DM1748 03/19/2019

*** Begin of adding by Lahiru on 07/25/2019 ***
        " ZQTC_VA05
        sel_scrn_blk_z07         TYPE scrfffld  VALUE 'Z07',        " Get table field or program field (generic)
*** End of adding by Lahiru on 07/25/2019 ***
*---Begin of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
        sel_scrn_blk_z06         TYPE scrfffld VALUE 'Z06',
        sel_scrn_fld_lifnr       TYPE scrfffld VALUE 'S_LIFNR',
*---End of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229
        sel_scrn_fld_ship2p      TYPE scrfffld VALUE 'S_SHIP2P',
        sel_scrn_fld_konda       TYPE scrfffld VALUE 'S_KONDA',
        sel_scrn_fld_abgru       TYPE scrfffld VALUE 'S_ABGRU',
        sel_scrn_fld_zlsch       TYPE scrfffld VALUE 'S_ZLSCH',
        sel_scrn_fld_bom         TYPE scrfffld VALUE 'CB_BOM',
        sel_scrn_blk_z08         TYPE scrfffld VALUE 'Z08',
*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
        sel_scrn_fld_itemval     TYPE scrfffld VALUE 'SITEMVAL',
        sel_scrn_fld_fromitemval TYPE scrfffld VALUE 'S_START',
        sel_scrn_fld_toitemval   TYPE scrfffld VALUE 'S_END',
        sel_scrn_blk_z09         TYPE scrfffld VALUE 'Z09',
        sel_scrn_blk_z10         TYPE scrfffld VALUE 'Z10',
        sel_scrn_blk_s06         TYPE scrfffld VALUE 'S06',
        sel_scrn_blk_s07         TYPE scrfffld VALUE 'S07',
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
        sel_scrn_fkdat           TYPE scrfffld VALUE 'S_FKDAT', "++ VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
        sel_scrn_unren           TYPE scrfffld VALUE 'CH_UNREN', "++ VDPATABALL 10/29/2021 ED2K924869 OTC-49605 Parameter Heading text
      END OF c_sel_scrn_field .
    CONSTANTS:
      BEGIN OF c_mandatory_field,
        sel_scrn_fld_auart    TYPE scrfffld  VALUE 'SAUART-LOW', " Get table field or program field (generic)
        sel_scrn_fld_vkorg    TYPE scrfffld  VALUE 'SVKORG-LOW', " Get table field or program field (generic)
        sel_scrn_fld_audat    TYPE scrfffld  VALUE 'SAUDAT-LOW', " Get table field or program field (generic)
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
        sel_scrn_fld_itmvalid TYPE scrfffld  VALUE 'SITEMVAL-LOW', " Get table field or program field (generic)
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
      END OF c_mandatory_field .
    CONSTANTS:
      BEGIN OF c_tran_codes,
        tcode_va45 TYPE sytcode           VALUE 'ZQTC_VA45', " Transaction Code - ZQTC_VA45
        tcode_va25 TYPE sytcode           VALUE 'ZQTC_VA25', " Transaction Code - ZQTC_VA25
        tcode_va05 TYPE sytcode           VALUE 'ZQTC_VA05', " Transaction Code - ZQTC_VA05
      END OF c_tran_codes .

    CONSTANTS:
      BEGIN OF c_sel_scrn_property,
        active   TYPE char1               VALUE '1', " Field - Active
        inactive TYPE char1               VALUE '0', " Field - Inactive
      END OF c_sel_scrn_property .

    CLASS-METHODS meth_get_sel_screen_text
      IMPORTING
        !im_application_id TYPE string
        !im_fld_name       TYPE scrfffld           " Get table field or program field (generic)
      EXPORTING
        !ex_fld_text       TYPE scrfstxg .         " Text/template for a screen element
protected section.
private section.

  constants C_WRICEF_ID_R050 type ZDEVID value 'R050' ##NO_TEXT.
  constants C_SER_NUM_1_R050 type ZSNO value '001' ##NO_TEXT.
  constants C_WRICEF_ID_R052 type ZDEVID value 'R052' ##NO_TEXT.
  constants C_SER_NUM_1_R052 type ZSNO value '001' ##NO_TEXT.
  constants C_WRICEF_ID_R054 type ZDEVID value 'R054' ##NO_TEXT.
  constants C_SER_NUM_1_R054 type ZSNO value '001' ##NO_TEXT.
ENDCLASS.



CLASS ZCLQTC_BADI_SDOC_WRAPPER_MASS IMPLEMENTATION.


  METHOD if_badi_sdoc_wrapper~adapt_result_comp.
*----------------------------------------------------------------------*
* PROGRAM NAME:IF_BADI_SDOC_WRAPPER~ADAPT_RESULT_COMP
* PROGRAM DESCRIPTION:BADI Implemention for populating Promo code
*                     in Out Put list in va25/va45
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-12-10
* OBJECT ID:E099
* TRANSPORT NUMBER(S)ED2K903485
*-------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912181
* REFERENCE NO:  JIRA# 6289
* DEVELOPER: Sayantan Das
* DATE:  2018-05-04
* DESCRIPTION: Additional fields for VA05/45/25
*----------------------------------------------------------------------*
* REVISION NO   : ED2K919999
* REFERENCE NO  : OTCM-27113/ E342
* DEVELOPER     : VDPATABALL
* DATE          : 11/02/2020
* DESCRIPTION   : This change will carry ‘Mass update of billing date using VA45
*----------------------------------------------------------------------*
    CONSTANTS: lc_field TYPE fieldname VALUE 'ZZPROMO', " constants for field name
               lc_name  TYPE fieldname VALUE 'ZZPROMO'. " constans for out put field name

    IF iv_application_id = if_sdoc_select=>co_application_id-va25nn OR
       iv_application_id = if_sdoc_select=>co_application_id-va45nn.
* Display VBAP-ZZPROMO (Promo code)
      INSERT VALUE #( table = if_sdoc_select=>co_tablename-vbap
      field = lc_field
      name =  lc_name ) INTO TABLE ct_result_comp.
    ENDIF. " IF iv_application_id = if_sdoc_select=>co_application_id-va25nn OR

*** BOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018
    IF iv_application_id = if_sdoc_select=>co_application_id-va45nn.

*      IF sy-uname = 'MODUTTA' OR sy-uname = 'SAYANDAS'.
*** Ship-to Purchase Order Number
      IF sy-tcode = 'ZQTC_VA45'.
        INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                        field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_bstkd_e
                        name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_bstkd_e
                        text  = 'Ship-to Party Purchase Order Number' )
          INTO TABLE ct_result_comp.
      ENDIF.
*** Ship-to Your Reference
      INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                      field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ihrez_e
                      name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_ihrez_e
                      text  = 'Ship-to party Your Reference' )
        INTO TABLE ct_result_comp.

* Customer Material Number
      INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                      field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdmat
                      name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_kdmat )
        INTO TABLE ct_result_comp.
*      ENDIF. " IF sy-uname = 'MODUTTA' OR sy-uname = 'SAYANDAS'
    ENDIF. " IF iv_application_id = if_sdoc_select=>co_application_id-va45nn
*** EOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018

*** BOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018
    IF iv_application_id = if_sdoc_select=>co_application_id-va25nn.

*      IF sy-uname = 'MODUTTA' OR sy-uname = 'SAYANDAS'.

**** Ship-to Your Reference
*        INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
*                        field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ihrez_e
*                        name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_ihrez_e )
*          INTO TABLE ct_result_comp.

* Customer Material Number
      INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
                      field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdmat
                      name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_kdmat )
        INTO TABLE ct_result_comp.

*      ENDIF. " IF sy-uname = 'MODUTTA' OR sy-uname = 'SAYANDAS'
    ENDIF. " IF iv_application_id = if_sdoc_select=>co_application_id-va45nn
*** EOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018

*** BOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018
    IF iv_application_id = if_sdoc_select=>co_application_id-va05nn.

*      IF sy-uname = 'MODUTTA' OR sy-uname = 'SAYANDAS'.

*** Ship-to Your Reference
      INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbkd
                      field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_ihrez_e
                      name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_ihrez_e
                      text  = 'Ship-to party Your Reference' )
        INTO TABLE ct_result_comp.

** Customer Material Number
*        INSERT VALUE #( table = zclqtc_badi_sdoc_wrapper_mass=>c_table-tbnam_vbap
*                        field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_kdmat
*                        name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_kdmat )
*          INTO TABLE ct_result_comp.

*** Token Material
      INSERT VALUE #( field = 'MATNR'
                      name = 'TOKEN_MATNR'
                      text = 'Token Material' )
         INTO TABLE  ct_result_comp.

*      ENDIF. " IF sy-uname = 'MODUTTA' OR sy-uname = 'SAYANDAS'
    ENDIF. " IF iv_application_id = if_sdoc_select=>co_application_id-va45nn
*** EOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018



*ENDIF.

*   Begin of ADD:R050:WROY:30-MAY-2017:ED2K906227
    DATA:
      lv_actv_flag_r050 TYPE zactive_flag, "Active / Inactive Flag
      lv_var_key_r050   TYPE zvar_key.     "Variable Key

*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
    IF sy-tcode = 'VA45'.
      INSERT VALUE #( field = zclqtc_badi_sdoc_wrapper_mass=>c_field-fnam_fkdat
                      name  = zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_fkdat )
        INTO TABLE ct_result_comp.
    ENDIF.
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45

*   To check enhancement is active or not
*** BOC BY SAYANDAS on 02-JAN-2018 for ERP-5688
*   lv_var_key_r050 = iv_application_id.
    lv_var_key_r050 = sy-tcode.
*** EOC BY SAYANDAS on 02-JAN-2018 for ERP-5688
*---Begin of change VDPATABALL INC0245900 - ZQTC_VA45
*--For batch job need to include the custom fields in layout
    IF sy-batch = abap_true.
      IF sy-cprog = 'SD_SALES_DOCUMENT_VA45'.
        lv_var_key_r050 = 'ZQTC_VA45'.
      ENDIF.
    ENDIF.
*---End of change VDPATABALL INC0245900 - ZQTC_VA45
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_r050
        im_ser_num     = c_ser_num_1_r050
        im_var_key     = lv_var_key_r050
      IMPORTING
        ex_active_flag = lv_actv_flag_r050.

    IF lv_actv_flag_r050 EQ abap_true.
      INCLUDE zqtcn_sdoc_wrapper_va45 IF FOUND.
    ENDIF. " IF lv_actv_flag_r050 EQ abap_true
*   End   of ADD:R050:WROY:30-MAY-2017:ED2K906227

*   Begin of ADD:R052:SAYANDAS:16-JUNE-2017:ED2K906705
    DATA:
      lv_actv_flag_r052 TYPE zactive_flag, "Active / Inactive Flag
      lv_var_key_r052   TYPE zvar_key.     "Variable Key

*   To check enhancement is active or not
    lv_var_key_r052 = iv_application_id.
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_r052
        im_ser_num     = c_ser_num_1_r052
        im_var_key     = lv_var_key_r052
      IMPORTING
        ex_active_flag = lv_actv_flag_r052.

    IF lv_actv_flag_r052 EQ abap_true.
      INCLUDE zqtcn_sdoc_wrapper_va05 IF FOUND.
    ENDIF. " IF lv_actv_flag_r052 EQ abap_true
*   End   of ADD:R052:SAYANDAS:16-JUNE-2017:ED2K906705
*   Begin of ADD:R054:NMOUNIKA:22-JUNE-2017:ED2K906855
    DATA:
      lv_actv_flag_r054 TYPE zactive_flag, "Active / Inactive Flag
      lv_var_key_r054   TYPE zvar_key.     "Variable Key

*   To check enhancement is active or not
    lv_var_key_r054 = iv_application_id.
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_r054
        im_ser_num     = c_ser_num_1_r054
        im_var_key     = lv_var_key_r054
      IMPORTING
        ex_active_flag = lv_actv_flag_r054.

    IF lv_actv_flag_r054 EQ abap_true.
      INCLUDE zqtcn_sdoc_wrapper_va25 IF FOUND.
    ENDIF. " IF lv_actv_flag_r054 EQ abap_true
*   End   of ADD:R054:NMOUNIKA:22-JUNE-2017:ED2K906855
  ENDMETHOD.


  METHOD if_badi_sdoc_wrapper~post_processing.
*----------------------------------------------------------------------*
* PROGRAM NAME:IF_BADI_SDOC_WRAPPER~POST_PROCESSING
* PROGRAM DESCRIPTION:BADI Implemention for populating Promo code
*                     in Out Put list in va25/va45
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-12-10
* OBJECT ID:E099
* TRANSPORT NUMBER(S)ED2K903485
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
    RETURN.
  ENDMETHOD.


  METHOD meth_get_sel_screen_text.
*----------------------------------------------------------------------*
* PROGRAM NAME: METH_GET_SEL_SCREEN_TEXT (Method)
* PROGRAM DESCRIPTION:
* DEVELOPER: Writtick Roy (WROY) / Sayantan Das (SAYANDAS)
* CREATION DATE:   05/30/2017
* OBJECT ID: R050, R052 and R054.
* TRANSPORT NUMBER(S): ED2K906227
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912181
* REFERENCE NO:  JIRA# 6289
* DEVELOPER: Sayantan Das
* DATE:  2018-05-04
* DESCRIPTION: Additional fields for VA05/45/25
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914716
* REFERENCE NO: DM1791
* DEVELOPER: PRABHU
* DATE:  05/15/2019
* DESCRIPTION: Layout field on ZQTC_VA45 selection screen
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915777
* REFERENCE NO: DM7836
* DEVELOPER: NPOLINA
* DATE:  08/13/2019
* DESCRIPTION: Layout field on ZQTC_VA05 selection screen
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910841 / ED2K916019
* REFERENCE NO: INC0248483
* DEVELOPER: Bharani
* DATE:  08/15/2019
* DESCRIPTION: Preceding document category field is added on the
*              selection screen and text is pulled from here
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917574
* REFERENCE NO:  ERPM-9418
* WRICEF ID: R054
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  02/17/2020
* DESCRIPTION: Add frieght forwarding agent for selection and report output
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K918259 / ED2K918229
* REFERENCE NO:  ERPM-14773
* WRICEF ID: R054/RO50/R052
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  05/20/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K918827
* REFERENCE NO:  ERPM-21199
* WRICEF ID: R054/RO50/R052
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  07/09/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K918827
* REFERENCE NO:  ERPM-15415
* WRICEF ID: R054/RO50/R052
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  07/15/2020
* DESCRIPTION: Change the existing Memebership catory field name as Condition group 2
*---------------------------------------------------------------------*
* REVISION NO   : ED2K919999
* REFERENCE NO  : OTCM-27113/ E342
* DEVELOPER     : VDPATABALL
* DATE          :  11/02/2020
* DESCRIPTION   : This change will carry ‘Mass update of billing date using VA45
***---Selection screen parameter Description ----***
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K922945
* REFERENCE NO:  OTCM-42980
* WRICEF ID: R052
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  04/08/2021
* DESCRIPTION: Add Customer material no to Selection and report output
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO : ED2K924869
* REFERENCE NO: OTCM-54011
* WRICEF ID   : R054
* DEVELOPER   : VDPATABALL
* DATE        : 10/29/2021
* DESCRIPTION : Indian Agent Changes for Unrenewed Quotation list
*---------------------------------------------------------------------*

    CASE im_application_id.
      WHEN if_sdoc_select=>co_application_id-va45nn.
*       Texts for Selection Screen Fields
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_text.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_pstyv.
            ex_fld_text = 'Item Category'(401).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_vgbel.
            ex_fld_text = 'Reference Document'(402).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_zterm.
            ex_fld_text = 'Terms of Payment'(403).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_ihrez.
            ex_fld_text = 'Your Reference'(404).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_sbtyp.
            ex_fld_text = 'Subscription Type'(405).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bsark.
            ex_fld_text = 'Purchase Order Type'(406).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_mvgr1.
            ex_fld_text = 'Material Group 1'(413).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_mvgr2.
            ex_fld_text = 'Material Group 2'(414).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_mvgr3.
            ex_fld_text = 'Material Group 3'(415).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_mvgr4.
            ex_fld_text = 'Material Group 4'(416).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_mvgr5.
            ex_fld_text = 'Material Group 5'(417).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_promo.
            ex_fld_text = 'Promo Code'(418).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_lcgrp.
            ex_fld_text = 'License Group'(419).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_zuonr.
            ex_fld_text = 'Assignment'(420).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bldoc.
            ex_fld_text = 'Billing Document'(407).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bltyp.
            ex_fld_text = 'Billing Type'(408).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_ernam.
            ex_fld_text = 'Created By'(409).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_erdat.
            ex_fld_text = 'Created On'(410).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_kunrg.
            ex_fld_text = 'Payer'(411).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_ztrmr.
            ex_fld_text = 'Terms of Payment'(412).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_kdkg2.
*---Begin of change by Lahiru on 07/15/2020 ERPM-15415 with ED2K918914
            "ex_fld_text = 'Membership Category'(421).
            ex_fld_text = 'Condition Group 2'(471).
*---End of change by Lahiru on 07/15/2020 ERPM-15415 with ED2K918914
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_lifsk.
            ex_fld_text = 'Delivery Block'(422).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_faksk.
            ex_fld_text = 'Billing Block'(423).
          ENDIF.
*** BOC BY SAYANDAS FOR CR706 on 12-OCT-2017
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_ihrez_e.
            ex_fld_text = 'Ship-to party Your Reference'(426).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bname.
            ex_fld_text = 'Orderer Name'(022).
          ENDIF.
*** EOC BY SAYANDAS FOR CR706 on 12-OCT-2017
*** BOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_kdmat.
            ex_fld_text = 'Customer Material Number'(424).
          ENDIF.
*** EOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018
* BOC - BTIRUVATHU - INC0248483- 2019/07/19 - ED1K910841
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_vbtyp.
            ex_fld_text = 'Preceding Document Category'(429).
          ENDIF.
* EOC - BTIRUVATHU - INC0248483- 2019/07/19 - ED1K910841
*--Begin of change VDPATABALL 03/19/2019 DM1748
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_lang.
            ex_fld_text = 'Language'(023).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_object.
            ex_fld_text = 'Text Object'(024).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_tdid.
            ex_fld_text = 'Text Id'(025).
          ENDIF.
*--Begin of change PRABHU 05/15/2019 DM1791
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_layout.
            ex_fld_text = 'Layout'(044).
          ENDIF.
*--End of change PRABHU 05/15/2019 DM1791
*---Begin of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_lifnr.
            ex_fld_text = 'Forwarding Agent'(430).
          ENDIF.
*---End of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_ship2p.
            ex_fld_text = 'Ship-to Party'(447).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_konda.
            ex_fld_text = 'Price Group'(448).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_abgru.
            ex_fld_text = 'Rejection Reason'(449).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_zlsch.
            ex_fld_text = 'Payment Method'(450).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bom.
            ex_fld_text = 'Do not Display BOM Component'(451).
          ENDIF.
*---End of change by Lahiru on 10/02/2020 ERPM-14773 with ED2K918229
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_itemval.
            ex_fld_text = 'Validity Period'(464).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_fromitemval.
            ex_fld_text = 'Valid From Date'(465).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_toitemval.
            ex_fld_text = 'Valid To Date'(466).
          ENDIF.
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fkdat.
            ex_fld_text = 'Billing Date'.
          ENDIF.
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
        ENDIF.
*       Texts for Selection Screen Blocks
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_block.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z01.
            ex_fld_text = 'Additional Filter Criteria (Contracts)'(4b1).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z02.
            ex_fld_text = 'Billing Document Data'(4b2).
          ENDIF.
*--Begin of change VDPATABALL 03/19/2019 DM1748
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z05.
            ex_fld_text = 'Text Object Criteria'(026).
          ENDIF.
*--End of change VDPATABALL 03/19/2019 DM1748
*---Begin of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z06.
            ex_fld_text = 'Partner Details'(446).
          ENDIF.
*---End of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
*---Begin of change by Lahiru on 10/02/2020 ERPM-14773 with ED2K918229
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z08.
            ex_fld_text = 'Other Additional Data'(452).
          ENDIF.
*---End of change by Lahiru on 10/02/2020 ERPM-14773 with ED2K918229
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z09.
            ex_fld_text = 'Item Validity Period'(467).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z10.
            ex_fld_text = 'Item Validity Dates'(468).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_s06.
            ex_fld_text = 'Header Validity Period'(469).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_s07.
            ex_fld_text = 'Header Validity Dates'(470).
          ENDIF.
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
        ENDIF.

      WHEN if_sdoc_select=>co_application_id-va25nn.
*       Texts for Selection Screen Fields
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_text.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_vgbel.
            ex_fld_text = 'Reference Document'(201).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_zligp.
            ex_fld_text = 'License Group'(202).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_pstyv.
            ex_fld_text = 'Item Category'(203).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_vbtyp.
            ex_fld_text = 'Sub.Doc.Category'(204).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_vblen.
            ex_fld_text = 'Follow on document'(205).
          ENDIF.
*** BOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_kdmat.
            ex_fld_text = 'Customer Material Number'(424).
          ENDIF.

*          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_ihrez_e.
*            ex_fld_text = 'Ship-to party Your Reference'(426).
*          ENDIF.
*** EOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018
* BOC - BTIRUVATHU - INC0248483- 2019/07/19 - ED1K910841
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_vbtyp.
            ex_fld_text = 'Preceding Document Category'(429).
          ENDIF.
* EOC - BTIRUVATHU - INC0248483- 2019/07/19 - ED1K910841

*---Begin of change by Lahiru on 17/02/2020 ERPM-9418 with ED2K917574
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_lifnr.
            ex_fld_text = 'Forwarding Agent'(430).
          ENDIF.
*---End of change by Lahiru on 17/02/2020 ERPM-9418 with ED2K917574
*---Begin of change by Lahiru on 05/20/2020 ERPM-14773 with ED2K918259---*
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_ship2p.
            ex_fld_text = 'Ship-to Party'(447).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_konda.
            ex_fld_text = 'Price Group'(448).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_abgru.
            ex_fld_text = 'Rejection Reason'(449).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_zlsch.
            ex_fld_text = 'Payment Method'(450).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bom.
            ex_fld_text = 'Do not Display BOM Component'(451).
          ENDIF.
*---End of change by Lahiru on 05/20/2020 ERPM-14773 with ED2K918259---*
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_itemval.
            ex_fld_text = 'Validity Period'(464).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_fromitemval.
            ex_fld_text = 'Valid From Date'(465).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_toitemval.
            ex_fld_text = 'Valid To Date'(466).
          ENDIF.
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
        ENDIF.

*       Texts for Selection Screen Blocks
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_block.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z01.
            ex_fld_text = 'Additional Filter Criteria'(2b1).
          ENDIF.
        ENDIF.
*---Begin of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z06.
          ex_fld_text = 'Partner Details'(446).
        ENDIF.
*---End of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
*---Begin of change by Lahiru on 05/20/2020 ERPM-14773 with ED2K918259---*
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z08.
          ex_fld_text = 'Other Additional Data'(452).
        ENDIF.
*---End of change by Lahiru on 05/20/2020 ERPM-14773 with ED2K918259---*
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z09.
          ex_fld_text = 'Item Validity Period'(467).
        ENDIF.
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z10.
          ex_fld_text = 'Item Validity Dates'(468).
        ENDIF.
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_s06.
          ex_fld_text = 'Header Validity Period'(469).
        ENDIF.
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_s07.
          ex_fld_text = 'Header Validity Dates'(470).
        ENDIF.
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
*** BOC BY NPALLA/ VDPATABALL for JIRA# OCTM-49605 on 20-OCT-2021 - ED2K924869
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bsark.
          ex_fld_text = 'Purchase Order Type'(010).
        ENDIF.
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_unren.
          ex_fld_text = 'Un-Renewed Quotations'.
        ENDIF.
*** EOC BY NPALLA VDPATABALL for JIRA# OCTM-49605 on 20-OCT-2021 - ED2K924869
      WHEN if_sdoc_select=>co_application_id-va05nn.
*       Texts for Selection Screen Fields
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_text.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_vgbel.
            ex_fld_text = 'Reference Document'(001).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_promo.
            ex_fld_text = 'Promo Code'(002).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_lcgrp.
            ex_fld_text = 'License Group'(003).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_pstyv.
            ex_fld_text = 'Item Category'(004).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_mvgr1.
            ex_fld_text = 'Material group 1'(005).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_mvgr2.
            ex_fld_text = 'Material Group 2'(006).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_mvgr3.
            ex_fld_text = 'Material Group 3'(007).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_mvgr4.
            ex_fld_text = 'Material Group 4'(008).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_mvgr5.
            ex_fld_text = 'Material Group 5'(009).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bsark.
            ex_fld_text = 'Purchase Order Type'(010).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_ihrez.
            ex_fld_text = 'Your Reference'(011).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bldoc.
            ex_fld_text = 'Billing Document'(012).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bltyp.
            ex_fld_text = 'Billing Type'(013).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_zterm.
            ex_fld_text = 'Terms of Payment'(014).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_ernam.
            ex_fld_text = 'Created By'(015).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_erdat.
            ex_fld_text = 'Created On'(016).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_kunrg.
            ex_fld_text = 'Payer'(017).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_custcn.
            ex_fld_text = 'Membership Category'(018).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_dlvblk.
            ex_fld_text = 'Delivery Block'(019).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bilblk.
            ex_fld_text = 'Billing Block'(020).
          ENDIF.
*** BOC BY SAYANDAS for JIRA# 6289 on 08-MAY-2018
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_tmatnr.
            ex_fld_text = 'Token Material'(425).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_ihrez_e.
            ex_fld_text = 'Ship-to party Your Reference'(426).
          ENDIF.
*** EOC BY SAYANDAS for JIRA# 6289 on 08-MAY-2018

***** Begin of added by Lahiru on 25/07/2019 ***
*          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_lifsk.
*            ex_fld_text = 'Delivery Block'(019).
*          ENDIF.
***** End of added by Lahiru on 25/07/2019 ***

*---Begin of change by Lahiru on 05/21/2020 ERPM-9418 with ED2K918275
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_lifnr.
            ex_fld_text = 'Forwarding Agent'(430).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_ship2p.
            ex_fld_text = 'Ship-to Party'(447).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_konda.
            ex_fld_text = 'Price Group'(448).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_abgru.
            ex_fld_text = 'Rejection Reason'(449).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_zlsch.
            ex_fld_text = 'Payment Method'(450).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_bom.
            ex_fld_text = 'Do not Display BOM Component'(451).
          ENDIF.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
* BOC by Lahiru on 04/08/2021 for OTCM-42980 with ED2K922945  *
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_fld_kdmat.
            ex_fld_text = 'Customer Material Number'(424).
          ENDIF.
* EOC by Lahiru on 04/08/2021 for OTCM-42980 with ED2K922945  *

        ENDIF.

*--SOC NPOLINA 08/13/2019 DM7836 ED2K915777
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_layout.
          ex_fld_text = 'Layout'(044).
        ENDIF.
*--EOC NPOLINA 08/13/2019 DM7836 ED2K915777
*       Texts for Selection Screen Blocks
        IF im_fld_name CS c_sel_scrn_field-sel_scrn_block.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z01.
            ex_fld_text = 'Additional Filter Criteria'(0b1).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z02.
            ex_fld_text = 'Item Catg. and Material Groups'(0b2).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z03.
            ex_fld_text = 'PO Type and your Reference'(0b3).
          ENDIF.

          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z04.
            ex_fld_text = 'Billing Document Data'(0b4).
          ENDIF.

***** Begin Of Adding BY Lahiru on 07/25/2019 ***
*          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z07.
*            ex_fld_text = 'Block Type'(0b5).
*          ENDIF.
***** End Of Adding BY Lahiru on 07/25/2019 ***

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z06.
            ex_fld_text = 'Partner Details'(446).
          ENDIF.
          IF im_fld_name CS c_sel_scrn_field-sel_scrn_blk_z08.
            ex_fld_text = 'Other Additional Data'(452).
          ENDIF.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
        ENDIF.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
