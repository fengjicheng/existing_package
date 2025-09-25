@AbapCatalog.sqlViewName: 'ZQTC_CDS_E267'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS view for E267 Release Orders'
define view ZQTC_CDS_E267_SQL as select from vbap 
  join vbak as vbak
    on    vbap.vbeln = vbak.vbeln
  inner join  vbfa as a
    on a.vbeln = vbap.vbeln    
    and vbtyp_v = 'G'
   inner join vbfa as b
   on a.vbelv = b.vbelv
   and b.vbtyp_n = 'C'
   inner join vbak as v
     on v.vbeln = b.vbeln
     and v.auart = 'ZOAR'
    
 {       vbak.vbeln,
         vbap.posnr,
         vbak.auart,

         a.vbelv as Contract_id,
         a.posnv as Contract_Item,
         b.vbeln as Release_Order,
         b.posnn as Rel_Ord_Item,  
         v.auart as Rel_ord_typ,  
         vbak.erdat,
         vbak.ernam,         
         vbak.vbtyp,             
         vbak.vkorg,
         vbak.vtweg,
         vbak.spart,
         vbak.vkgrp,
         vbak.vkbur,
         vbap.aedat,
         vbap.pstyv,
         vbap.abgru,
         vbap.netpr,
         vbap.waerk,
         vbap.meins,
         vbap.zmeng,
         vbak.lifsk,
         vbak.faksk,
         vbak.augru       
}
        where vbak.augru <> ''
        and vbap.pstyv = 'ZWOC'
