@AbapCatalog.sqlViewName: 'zqtc_sum_inv'
@AbapCatalog.compiler.CompareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Sumation for invoice details'
define view Zqtc_Inv_Sum as select from zqtc_inv_det 
as inv
{
 inv.vbeln,
 inv.fkart,
 inv.waerk,
 inv.vkorg,
 inv.vtweg,
 inv.fkdat,
 inv.erdat,
 inv.kunrg,
 inv.kunag,
 inv.netwr,
 inv.posnr,
// PBOSE: SR_: 8-Dec-2016  
 inv.fkimg, 
 inv.bstnk,
// inv.ismmediatype,
 inv.bezeichnung,
// inv.kposn,
// inv.krech,
// PBOSE: SR_: 8-Dec-2016  
 inv.ismartist,
 inv.ismtitle,
 inv.ismpubldate,
 inv.lfimg,
 inv.identcode,  
 //inv.disc_percent,
 sum(inv.disc_percent) as disc_sum,
 sum(inv.sales_tax) as sales_tax,
 sum(inv.list_price) as list_sum 

}
group by inv.vbeln,
         inv.posnr,
         inv.vbeln,
 inv.fkart,
 inv.waerk,
 inv.vkorg,
 inv.vtweg,
 inv.fkdat,
 inv.erdat,
 inv.kunrg,
 inv.kunag,
 inv.netwr,
 inv.posnr,
// PBOSE: SR_: 8-Dec-2016   
 inv.fkimg,
 inv.bstnk,
 //inv.ismmediatype,
 inv.bezeichnung,
 // inv.kposn,
 //inv.krech,
// PBOSE: SR_: 8-Dec-2016   
 inv.ismartist,
 inv.ismtitle,
 inv.ismpubldate,
 inv.lfimg,
 inv.identcode
 //inv.disc_percent
 //inv.sales_tax
