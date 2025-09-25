@AbapCatalog.sqlViewName: 'zsql_first_view'
@AbapCatalog.compiler.CompareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'First CDS View'
//define view ZLW_FIRST_CDS as select from vbrp 
//inner join vbrk on vbrp.vbeln = vbrk.vbeln
//{
//   vbrk.vbeln as vbeln,
 //   vbrk.knumv as knumv,
//    vbrp.posnr as posnr
//}
//group by vbrk.vbeln , vbrk.knumv, vbrp.posnr
define view ZLW_FIRST_CDS as select from vbrk as a
inner join vbrp as b on b.vbeln = a.vbeln
{
   a.vbeln as vbeln,
   a.knumv as knumv,
   b.posnr as posnr
}
where a.fkart = 'ZF2' 

