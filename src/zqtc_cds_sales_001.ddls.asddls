@AbapCatalog.sqlViewName: 'zqtc_sales_001'
@ClientDependent: true
@AbapCatalog.compiler.CompareFilter: true
@EndUserText.label: 'ABAP CDS Views on VBAK VBAP and VEDA'
define view Zqtc_Cds_Sales_001 
as select from vbap as b
inner join vbak as a on b.vbeln = a.vbeln
left outer join veda as c on b.vbeln = c.vbeln and b.posnr = c.vposn 
left outer join veda as d on b.vbeln = d.vbeln and d.vposn = '000000'
{
a.vbeln,
a.auart,
a.waerk,
a.vkorg,
a.vkbur,
a.kunnr,
a.erdat,
a.lifsk,
a.faksk,
b.posnr,
b.matnr,
b.arktx,
b.netwr,
b.zzsubtyp,
b.zmeng,
b.zieme,
b.mvgr1,
b.mvgr2,
b.mvgr3,
b.mvgr4,
b.mvgr5,
case when c.vposn is null then d.vposn else c.vposn end as vposn,
case when c.vbegdat is null then d.vbegdat else c.vbegdat end as vbegdat,
case when c.venddat is null then d.venddat else c.venddat end as venddat,
a.bukrs_vf,
b.vgbel,
a.zzlicgrp,
b.mwsbp,
b.werks,
a.vtweg,
a.spart,
case when c.vkuegru is null then d.vkuegru else c.vkuegru end as vkuegru,
b.uepos,
a.vsnmr_v,
a.bsark,
a.augru
--
}
