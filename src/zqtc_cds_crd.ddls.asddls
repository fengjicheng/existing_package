@AbapCatalog.sqlViewName: 'zqtc_crd_det'
@AbapCatalog.compiler.CompareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for Credit Report'
define view Zqtc_Cds_Crd as select from  vbrk 
as vk 
inner join vbrp as vp 
on ( vk.vbeln = vp.vbeln )
inner join mara as mr
on ( vp.matnr = mr.matnr )
inner join konv as kn 
on (kn.knumv = vk.knumv  
and kn.kposn = vp.posnr  )
inner join vbap as va
on ( va.vbeln = vp.aubel
and va.posnr = vp.aupos  )
left outer join jptidcdassign as jp
on ( jp.matnr = vp.matnr
// PBOSE: SR_: 8-Dec-2016
//and jp.idcodetype = 'ISBN' )
and jp.xmainidcode = 'X' )
// PBOSE: SR_: 8-Dec-2016 
{
 vk.vbeln,
 vk.fkart,
 vk.waerk,
 vk.vkorg,
 vk.vtweg,
 vk.fkdat,
 vk.erdat,
 vk.kunrg,
 vk.kunag,
 vp.fkimg,
 vp.netwr,
 vp.posnr, 
 vp.augru_auft,
 va.vgbel as va_vgbel,
 mr.ismtitle,
// kn.kposn,
// kn.krech,
  case kn.koaid
 when 'B' then kn.kbetr
 else 0
  end as list_price,
 case kn.koaid
// when 'D 'then kn.kbetr
//  when 'A'then kn.kbetr
when 'A'then kn.kwert
 else 0
  end as disc_percent,
 case kn.koaid
 when 'D' then kn.kwert
 else 0
  end as sales_tax,
 jp.identcode   
}
where (vk.vbtyp = 'O' 
 or vk.vbtyp = '6')
and kn.kinak = ''
