@AbapCatalog.sqlViewName: 'zqtc_e186_copy'
@AbapCatalog.compiler.CompareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'E186 CDS view with release orders ERPM-29655'
define view ZQTC_CDS_E186_001_COPY as 
select from vbap as a
left outer join vbak as b on a.vbeln = b.vbeln 
left outer join veda as ci on a.vbeln = ci.vbeln and a.posnr = ci.vposn --and ci.vkuegru = '' and (ci.vkuesch = 'Z001' or ci.vkuesch = 'Z002') 
--left outer join veda as ch on a.vbeln = ch.vbeln and a.posnr = '000000' --and ch.vkuegru = '' and (ch.vkuesch = 'Z001' or ch.vkuesch = 'Z002')
left outer join jkseflow as jf on jf.contract_vbeln = ci.vbeln and jf.contract_posnr = ci.vposn                                  
left outer join jksesched as jk on jk.nip = jf.nip and jk.vbeln = jf.contract_vbeln and
                                   jk.posnr = jf.contract_posnr                                 
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
b.spart, -- Added by ED2K921321 PTUFARAM R2P_QTC_SD_OTCM-29655-Automate Rejection RPT - Performance
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
vbegdat,
venddat,
vkuegru,
vkuesch,
veindat,
vwundat,
--case when ci.vbegdat is null then ch.vbegdat else ci.vbegdat end as vebgdat, -- Contract Start Date 
--case when ci.venddat is null then ch.venddat else ci.venddat end as venddat, -- Contract End Date
--case when ci.vkuegru is null then ch.vkuegru else ci.vkuegru end as vkuegru, -- Reason for rejection
--case when ci.vkuesch is null then ch.vkuesch else ci.vkuesch end as vkuesch,  -- Cancellation procedure
--case when ci.veindat is null then ch.veindat else ci.veindat end as veindat,
--case when ci.vwundat is null then ch.vwundat else ci.vwundat end as vwundat
jk.vbeln as jk_vbeln,
jk.posnr as jk_posnr,
jk.xorder_created,    
jk.nip,
jf.contract_vbeln,
jf.contract_posnr,
jf.issue,
jf.vbelnorder,
jf.posnrorder,
jf.check_failed,
jf.shipping_date
}
where 
a.abgru = '' and 
--(
(ci.vkuesch = 'Z001' or ci.vkuesch = 'Z002') 
--or 
--(ch.vkuesch = 'Z001' or ch.vkuesch = 'Z002'))
