@AbapCatalog.sqlViewName: 'ZIRM_PRICE_a937'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'A937 Price Condition'
define view ZCDS_Changelog_a937 as select from a937 as a 
inner join /vgm/gpr0007se as b on b.knumh = a.knumh
inner join mara as d on d.matnr = a.matnr
{
   a.kschl,
   a.matnr,
   a.kdgrp,
   a.knumh,
   a.datab,
   a.datbi,
   d.extwg   
}
