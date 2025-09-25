@AbapCatalog.sqlViewName: 'ZSD_REL_ORDERS'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Release Orders'
@OData.publish: true 
define view ZCDS_REL_ORDERS as select from vbak
inner join vbap on vbak.vbeln = vbap.vbeln
inner join kna1 on vbak.kunnr = kna1.kunnr
left outer join ekkn on vbap.vbeln = ekkn.vbeln and vbap.posnr = ekkn.vbelp
left outer join eban on ekkn.ebeln = eban.ebeln and ekkn.ebelp = eban.ebelp
  {
      vbak.auart,
      vbak.vbeln,
      vbak.augru, 
      vbak.erdat,
      vbap.posnr,
      vbap.matnr,
      vbap.vgbel,
      vbap.vgpos,
      vbak.kunnr,
      kna1.name1,
      vbak.knkli,
      kna1.name2,
      ekkn.ebeln,
      ekkn.ebelp,
      ekkn.kostl,
      eban.bedat,
      eban.banfn,
      eban.bnfpo
      }
