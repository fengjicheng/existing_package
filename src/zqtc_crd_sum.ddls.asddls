@AbapCatalog.sqlViewName: 'zqtc_sum_crd'
@AbapCatalog.compiler.CompareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Sumation for credit details'
define view Zqtc_Crd_Sum as select from zqtc_crd_det
as crd
 {
 crd.vbeln,
 crd.fkart,
 crd.waerk,
 crd.vkorg,
 crd.vtweg,
 crd.fkdat,
 crd.erdat,
 crd.kunrg,
 crd.kunag,
 crd.fkimg,
 crd.netwr,
 crd.posnr, 
 crd.augru_auft,
 crd.va_vgbel,
 crd.ismtitle,
// crd.kposn,
// crd.krech,
 sum(crd.list_price) as list_sum,
 sum(crd.disc_percent) as disc_sum,
// crd.disc_percent,
 sum(crd.sales_tax) as sales_tax,
 crd.identcode
}
group by
 crd.vbeln,
 crd.fkart,
 crd.waerk,
 crd.vkorg,
 crd.vtweg,
 crd.fkdat,
 crd.erdat,
 crd.kunrg,
 crd.kunag,
 crd.fkimg,
 crd.netwr,
 crd.posnr, 
 crd.augru_auft,
 crd.va_vgbel,
 crd.ismtitle,
// crd.kposn,
// crd.krech,
// crd.disc_percent,
 //crd.sales_tax,
 crd.identcode
