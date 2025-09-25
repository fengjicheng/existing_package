@AbapCatalog.sqlViewName: 'ZIRM_PRICE_a911'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'A911 Price Condition'
define view ZCDS_Changelog_a911 as select from a911 as a 
inner join /vgm/gpr0002se as b on b.knumh = a.knumh
inner join mara as d on d.matnr = a.matnr
 {
   a.kschl,
   a.matnr,
   a.kdgrp,
   a.knumh,
   a.datab,
   a.datbi,
   d.extwg,
   b.zzprice_type,
   a.pltyp
   
}
