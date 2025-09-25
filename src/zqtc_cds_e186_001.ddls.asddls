@AbapCatalog.sqlViewName: 'zqtc_cds_e186'
@ClientDependent: true
@AbapCatalog.compiler.CompareFilter: true
@EndUserText.label: 'ABAP CDS view for E186'
define view Zqtc_Cds_E186_001 as 
select from vbap as a  
left outer join vbak as b on a.vbeln = b.vbeln 
left outer join veda as ci on a.vbeln = ci.vbeln and a.posnr = ci.vposn --and ci.vkuegru = '' and (ci.vkuesch = 'Z001' or ci.vkuesch = 'Z002') 
left outer join veda as ch on b.vbeln = ch.vbeln and ch.vposn = '000000' --by TDIMANTHA adding header level selection --a.posnr = '000000' --and ch.vkuegru = '' and (ch.vkuesch = 'Z001' or ch.vkuesch = 'Z002') 
{
a.vbeln,
a.posnr,
a.uepos, -- Higher level item
a.abgru, -- Reason for rejection of quote / Sales order
a.matnr,
a.zmeng, -- Target Qty
a.pstyv, -- Item Category,
a.netwr, -- Net Value,
a.waerk, -- Currency
b.erdat,
b.ernam,
b.audat,
b.auart,
b.lifsk,
b.faksk,
b.vkorg,
b.vtweg,
b.vkgrp,
b.vkbur,
b.kvgr1,
b.kvgr2,
b.kvgr3,
b.kvgr4,
b.kvgr5,
b.kunnr,
a.mvgr1,
a.mvgr2,
a.mvgr3,
a.mvgr4,
a.mvgr5,
a.ismmediatype,
a.ismpubltype,
a.zzsubtyp,
--vbegdat, --by TDIMANTHA adding header level selection
--venddat,
--vkuegru,
--vkuesch,
--veindat,
--vwundat
case when ci.vbegdat is null then ch.vbegdat else ci.vbegdat end as vebgdat, -- Contract Start Date --by TDIMANTHA adding header level selection
case when ci.venddat is null then ch.venddat else ci.venddat end as venddat, -- Contract End Date
case when ci.vkuegru is null then ch.vkuegru else ci.vkuegru end as vkuegru, -- Reason for rejection
case when ci.vkuesch is null then ch.vkuesch else ci.vkuesch end as vkuesch,  -- Cancellation procedure
case when ci.veindat is null then ch.veindat else ci.veindat end as veindat,
case when ci.vwundat is null then ch.vwundat else ci.vwundat end as vwundat
}
where 
 a.abgru = '' and 
(
(ci.vkuesch = 'Z001' or ci.vkuesch = 'Z002')  
or 
(ch.vkuesch = 'Z001' or ch.vkuesch = 'Z002')) -- by TDIMANTHA adding header level selection
