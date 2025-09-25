@AbapCatalog.sqlViewName: 'ZIRM_MATERIAL'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'IRM Material Pricing Combination'
define view ZCDS_PRICE_LIST2 as select from mara as a
left outer join jptidcdassign as b on b.matnr = a.matnr
 {
  a.matnr,
  a.mtart,
  a.extwg,
  a.ismtitle,
  a.ismsubtitle3,
  a.ismmediatype,
  a.ismpubltype,
  b.idcodetype,
  b.identcode
    
}
