@AbapCatalog.sqlViewName: 'ZSD_ORDRS'
@AbapCatalog.compiler.CompareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Orders Table'
@OData.publish: true
    
 define view ZSDORDS as select from vbak 
  join vbap 
    on vbak.vbeln = vbap.vbeln
    inner join vbup
    on vbup.vbeln = vbap.vbeln
     and vbup.posnr = vbap.posnr
     inner join vbuk
     on vbuk.vbeln = vbap.vbeln
    {  vbak.vbeln, vbap.posnr,vbap.matnr,
        vbap.charg,vbap.arktx,vbap.pstyv,vbap.uepos,
 vbak.auart,
vbak.erdat,
vbak.ernam,
vbak.vbtyp,
vbak.lifsk,
vbak.faksk,
vbak.vkorg,
vbak.vtweg,
vbak.spart,
vbak.vkgrp,
vbak.vkbur,vbap.abgru,
vbap.zmeng,vbap.zieme,vbap.meins,vbap.netwr,vbap.waerk,vbap.kwmeng,vbap.faksp,
vbap.prodh,
vbup.lfsta,
vbup.fksaa,vbup.fksta,vbup.fssta,vbup.lssta,vbup.absta,vbup.gbsta,
vbuk.uvall as huvall, vbup.uvall as iuvall,vbuk.cmgst, vbuk.spstg,
'         ' as Blocktype ,
'             ' as ordtyp ,vbak.netwr as Knetwr,vbak.bsark,
vbak.kunnr, '          '  as stdate
}
where  vbak.lifsk <> '' or vbap.faksp <> ''  or vbuk.cmgst <> '' or vbuk.spstg <> ''

  
