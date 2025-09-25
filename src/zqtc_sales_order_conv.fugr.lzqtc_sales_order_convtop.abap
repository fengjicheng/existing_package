FUNCTION-POOL zqtc_sales_order_conv.        "MESSAGE-ID ..

* INCLUDE LZQTC_SALES_ORDER_CONVD...         " Local class definition

*====================================================================*
* G L O B A L   S T R U C T U R E S
*====================================================================*
TYPES: BEGIN OF ty_item,
         posex    TYPE posex, " Item Number of the Underlying Purchase Order
         faksp    TYPE char2, " Faksp of type CHAR2
         vbegdat  TYPE vbdat_veda,
         venddat  TYPE vndat_veda,
         mvgr3    TYPE mvgr3,
         zzsubtyp TYPE zsubtyp,
         vbelkue  TYPE vbelk_veda,
       END OF ty_item,

       BEGIN OF ty_item1,
         posex TYPE posex,
         ihrez TYPE ihrez,
       END OF ty_item1,
*====================================================================*
* G L O B A L   T A B L E  T Y P E S
*====================================================================*
       tty_item    TYPE STANDARD TABLE OF ty_item INITIAL SIZE 0,
       tty_item1   TYPE STANDARD TABLE OF ty_item1 INITIAL SIZE 0,
       tty_bdcdata TYPE STANDARD TABLE OF bdcdata INITIAL SIZE 0,
       tty_edidd   TYPE STANDARD TABLE OF edidd   INITIAL SIZE 0.
*---- Sales Document: item data ---------------------------------------*
"Changed OCCURS 50 to OCCURS 0
DATA: BEGIN OF xvbap OCCURS 0.        "Position
        INCLUDE STRUCTURE vbap.
DATA:  matnr_output(40) TYPE c.
DATA:  wmeng(18) TYPE c.
DATA:  lfdat LIKE vbap-abdat.
DATA:  kschl LIKE komv-kschl.
DATA:  kbtrg(16) TYPE c.
DATA:  kschl_netwr LIKE komv-kschl.
DATA:  kbtrg_netwr(16) TYPE c.
DATA:  inco1 LIKE vbkd-inco1.          "Incoterms 1
DATA:  inco2 LIKE vbkd-inco2.          "Incoterms 2
DATA:  yantlf(1) TYPE c.
DATA:  prsdt LIKE vbkd-prsdt.
DATA:  hprsfd LIKE tvap-prsfd.
DATA:  bstkd_e LIKE vbkd-bstkd_e.
DATA:  bstdk_e LIKE vbkd-bstdk_e.
DATA:  bsark_e LIKE vbkd-bsark_e.
DATA:  ihrez_e LIKE vbkd-ihrez_e.
DATA:  posex_e LIKE vbkd-posex_e.
DATA:  lpnnr LIKE vbak-vbeln.
DATA:  empst LIKE vbkd-empst.
DATA:  ablad LIKE vbpa-ablad.
DATA:  knref LIKE vbpa-knref.
DATA:  lpnnr_posnr LIKE vbap-posnr.
DATA:  kdkg1 LIKE vbkd-kdkg1.
DATA:  kdkg2 LIKE vbkd-kdkg2.
DATA:  kdkg3 LIKE vbkd-kdkg3.
DATA:  kdkg4 LIKE vbkd-kdkg4.
DATA:  kdkg5 LIKE vbkd-kdkg5.
DATA:  abtnr LIKE vbkd-abtnr.
DATA:  delco LIKE vbkd-delco.
DATA:  angbt LIKE vbak-vbeln.
DATA:  angbt_posnr LIKE vbap-posnr.
DATA:  contk LIKE vbak-vbeln.
DATA:  contk_posnr LIKE vbap-posnr.
DATA:  angbt_ref LIKE vbkd-bstkd.
DATA:  angbt_posex LIKE vbap-posex.
DATA:  contk_ref LIKE vbkd-bstkd.
DATA:  contk_posex LIKE vbap-posex.

*- positionen ---------------------------------------------------------*
*- external config-id to set fcode 'POUP' on sub-item level ----*
DATA:  config_id LIKE e1curef-config_id.
*- Instanznummer der Konfiguaration zum Setzen des FCODES 'POUP' bei --*
*- Unterpositionen ----------------------------------------------------*
*- instancenumber of the configuration to set fcode 'POUP' on sub-item *
*- level --------------------------------------------------------------*
DATA:  inst_id LIKE e1curef-inst_id.
DATA:  kompp LIKE tvap-kompp.
DATA:  currdec LIKE tcurx-currdec.
DATA:  curcy LIKE e1edp01-curcy.
DATA:  valdt LIKE vbkd-valdt.
DATA:  valtg LIKE vbkd-valtg.
*- Flag  -------------------------------------------*
*- internal field additional ------------------------------------------*
DATA:  vaddi(1) TYPE c.
DATA: END OF xvbap.
DATA: g_custom_data_processed   TYPE flag.
DATA: wa_xvbap LIKE LINE OF xvbap.
DATA: wa_xvbap1 LIKE LINE OF xvbap.





*** Local Structure declaration for XVBAK
TYPES: BEGIN OF xvbak. "Kopfdaten
        INCLUDE STRUCTURE vbak. " Sales Document: Header Data
TYPES:  bstkd LIKE vbkd-bstkd. " Customer purchase order number
*DATA:  KURSK(8)   TYPE C.
TYPES:  kursk LIKE vbkd-kursk.
TYPES:  zterm LIKE vbkd-zterm.
TYPES:  incov LIKE vbkd-incov.
TYPES:  inco1 LIKE vbkd-inco1.
TYPES:  inco2 LIKE vbkd-inco2.
TYPES:  inco2_l LIKE vbkd-inco2_l.
TYPES:  inco3_l LIKE vbkd-inco3_l.
TYPES:  prsdt LIKE vbkd-prsdt.
TYPES:  angbt LIKE vbak-vbeln.
TYPES:  contk LIKE vbak-vbeln.
TYPES:  kzazu LIKE vbkd-kzazu.
TYPES:  fkdat LIKE vbkd-fkdat.
TYPES:  fbuda LIKE vbkd-fbuda.
TYPES:  empst LIKE vbkd-empst.
TYPES:  valdt LIKE vbkd-valdt.
TYPES:  kdkg1 LIKE vbkd-kdkg1.
TYPES:  kdkg2 LIKE vbkd-kdkg2.
TYPES:  kdkg3 LIKE vbkd-kdkg3.
TYPES:  kdkg4 LIKE vbkd-kdkg4.
TYPES:  kdkg5 LIKE vbkd-kdkg5.
TYPES:  delco LIKE vbkd-delco.
TYPES:  abtnr LIKE vbkd-abtnr.
TYPES:  dwerk LIKE rv45a-dwerk.
TYPES:  angbt_ref LIKE vbkd-bstkd.
TYPES:  contk_ref LIKE vbkd-bstkd.
TYPES:  currdec LIKE tcurx-currdec.
TYPES:  bstkd_e LIKE vbkd-bstkd_e.
TYPES:  bstdk_e LIKE vbkd-bstdk_e.
TYPES: END OF xvbak.


*-------------------->>> XVBAP
TYPES: BEGIN OF xvbap1.        "Position
        INCLUDE STRUCTURE vbap.
TYPES:  matnr_output(40) TYPE c,
        wmeng(18)        TYPE c,
        lfdat            LIKE vbap-abdat,
        kschl            LIKE komv-kschl,
        kbtrg(16)        TYPE c,
        kschl_netwr      LIKE komv-kschl,
        kbtrg_netwr(16)  TYPE c,
        inco1            LIKE vbkd-inco1,
        inco2            LIKE vbkd-inco2,
        inco2_l          LIKE vbkd-inco2_l,
        inco3_l          LIKE vbkd-inco3_l,
        incov            LIKE vbkd-incov,
        yantlf(1)        TYPE c,
        prsdt            LIKE vbkd-prsdt,
        hprsfd           LIKE tvap-prsfd,
        bstkd_e          LIKE vbkd-bstkd_e,
        bstdk_e          LIKE vbkd-bstdk_e,
        bsark_e          LIKE vbkd-bsark_e,
        ihrez_e          LIKE vbkd-ihrez_e,
        posex_e          LIKE vbkd-posex_e,
        lpnnr            LIKE vbak-vbeln,
        empst            LIKE vbkd-empst,
        ablad            LIKE vbpa-ablad,
        knref            LIKE vbpa-knref,
        lpnnr_posnr      LIKE vbap-posnr,
        kdkg1            LIKE vbkd-kdkg1,
        kdkg2            LIKE vbkd-kdkg2,
        kdkg3            LIKE vbkd-kdkg3,
        kdkg4            LIKE vbkd-kdkg4,
        kdkg5            LIKE vbkd-kdkg5,
        abtnr            LIKE vbkd-abtnr,
        delco            LIKE vbkd-delco,
        angbt            LIKE vbak-vbeln,
        angbt_posnr      LIKE vbap-posnr,
        contk            LIKE vbak-vbeln,
        contk_posnr      LIKE vbap-posnr,
        angbt_ref        LIKE vbkd-bstkd,
        angbt_posex      LIKE vbap-posex,
        contk_ref        LIKE vbkd-bstkd,
        contk_posex      LIKE vbap-posex,
        config_id        LIKE e1curef-config_id,
        inst_id          LIKE e1curef-inst_id,
        kompp            LIKE tvap-kompp,
        currdec          LIKE tcurx-currdec,
        curcy            LIKE e1edp01-curcy,
        valdt            LIKE vbkd-valdt,
        valtg            LIKE vbkd-valtg,
        vaddi(1)         TYPE c,
        END OF xvbap1.

TYPES: BEGIN OF d_flag_k3,
         eins(1)   TYPE c, " Eins(1) of type Character
         kkau(1)   TYPE c, " Kkau(1) of type Character
         uer2(1)   TYPE c, " Uer2(1) of type Character
         kbes(1)   TYPE c, " Kbes(1) of type Character
         pbes(1)   TYPE c, " Pbes(1) of type Character
         pkau(1)   TYPE c, " Pkau(1) of type Character
         pein(1)   TYPE c, " Pein(1) of type Character
         eid1(1)   TYPE c, " Eid1(1) of type Character
         eian(1)   TYPE c, " Eian(1) of type Character
         kparag(1) TYPE c, " Kparag(1) of type Character
         psdeag(1) TYPE c, " Psdeag(1) of type Character
         kparlf(1) TYPE c, " Kparlf(1) of type Character
         psdelf(1) TYPE c, " Psdelf(1) of type Character
         kparwe(1) TYPE c, " Kparwe(1) of type Character
         psdewe(1) TYPE c, " Psdewe(1) of type Character
         kparre(1) TYPE c, " Kparre(1) of type Character
         psdere(1) TYPE c, " Psdere(1) of type Character
         kparrg(1) TYPE c, " Kparrg(1) of type Character
         psderg(1) TYPE c, " Psderg(1) of type Character
         kparsp(1) TYPE c, " Kparsp(1) of type Character
         psdesp(1) TYPE c, " Psdesp(1) of type Character
         kparzz(1) TYPE c, " Kparzz(1) of type Character
         psdezz(1) TYPE c, " Psdezz(1) of type Character
         rang(1)   TYPE c, " Rang(1) of type Character
         rkon(1)   TYPE c, " Rkon(1) of type Character
         kde1(1)   TYPE c, " Kde1(1) of type Character
         kde2(1)   TYPE c, " Kde2(1) of type Character
         kkon(1)   TYPE c, " Kkon(1) of type Character
         uer1(1)   TYPE c, " Uer1(1) of type Character
         kde3(1)   TYPE c, " Kde3(1) of type Character
         kgru(1)   TYPE c, " Kgru(1) of type Character
         krpl(1)   TYPE c, " Krpl(1) of type Character
         kzku(1)   TYPE c, " Kzku(1) of type Character
       END OF d_flag_k3.

*====================================================================*
* G L O B A L  C O N S T A N T S
*====================================================================*
CONSTANTS: c_z1qtc_e1edk01_01 TYPE edilsegtyp VALUE 'Z1QTC_E1EDK01_01', " Segment type
           c_e1edp01          TYPE edilsegtyp VALUE 'E1EDP01',          " Segment type
           c_e1edk03          TYPE edilsegtyp VALUE 'E1EDK03',
           c_e1edp02          TYPE edilsegtyp VALUE 'E1EDP02',
           c_e1edk36          TYPE edilsegtyp VALUE 'E1EDK36',          " Segment type
           c_022              TYPE edi_iddat  VALUE '022',
*** BOC by SAYANDAS
           c_019              TYPE edi_iddat  VALUE '019',
           c_020              TYPE edi_iddat  VALUE '020',
*** EOC by SAYANDAS
           c_prd              TYPE edi_iddat  VALUE 'PRD',
           c_z1qtc_e1edp01_01 TYPE edilsegtyp VALUE 'Z1QTC_E1EDP01_01'. " Segment type
