@AbapCatalog.sqlViewName: 'ZQTC_INV_PAYMENT'
@ClientDependent: true
@AbapCatalog.compiler.CompareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Invoice Payment Status'

define view ZQTC_CDS_Invoice_Payment as select from but050 as a
inner join tbz9a as b on a.client = b.client and a.reltyp = b.reltyp
inner join kna1 as c on a.client = c.mandt and a.partner2 = c.kunnr
inner join kna1 as d on a.client = d.mandt and a.partner1 = d.kunnr
  {
   key a.partner1,
   key a.partner2,
    a.reltyp,
    c.name1,
    REPLACE(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT( c.name1, '|-| |-|'), c.ort01),'|-| |-|'),c.sortl),'|-| |-|'),c.stras),'|-|', '') as fullname,
    d.name1 as member_name
}
where --a.partner1 = '1000017071' and 
a.partner2 = '1000015549'
