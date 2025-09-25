@AbapCatalog.sqlViewName: 'zqtc_inv_det'
@AbapCatalog.compiler.CompareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for Invoice'
define view Zqtc_Cds_Inv as select from vbrk 
as vk  
inner join vbrp as vp 
on ( vk.vbeln = vp.vbeln )
// PBOSE: SR_: 8-Dec-2016
inner join vbak as va
on (vp.aubel = va.vbeln)
inner join mara as mr
on ( vp.matnr = mr.matnr )
inner join tjpmedtpt as text
on (mr.ismmediatype = text.ismmediatype
and text.spras = 'E')
inner join konv as kn 
on ( vk.knumv = kn.knumv 
and vp.posnr = kn.kposn
and   kn.kinak    = '' )
left outer join lips as lips
on (lips.vbeln = vp.vgbel
and lips.posnr = vp.vgpos )
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
// PBOSE: SR_305: 8-Dec-2016 
// vk.bstnk_vf,
// PBOSE: SR_305: 8-Dec-2016 
 vp.netwr,
 vp.posnr,
// PBOSE: SR_305: 8-Dec-2016  
 vp.fkimg,
// PBOSE: SR_305: 8-Dec-2016  
 va.bstnk,   
// mr.ismmediatype,
 text.bezeichnung,
// kn.kposn, 
// kn.krech,
// mr.medium,
// PBOSE: SR_305: 8-Dec-2016
 mr.ismartist,
 mr.ismtitle,
 mr.ismpubldate,
lips.lfimg,
jp.identcode,  

 case kn.koaid
 when 'A' then kn.kwert
//  when 'A' then kn.kbetr
  else 0
  end as disc_percent,
  
 case kn.koaid
 when 'D' then kn.kwert
  else 0
   end as sales_tax, 
case kn.koaid
 when 'B' then kn.kbetr
 else 0
   end as list_price
}
where (vk.vbtyp    = 'P'
 or    vk.vbtyp    = 'M'
 or    vk.vbtyp    = '5')
// and   kn.kinak    = '')
    
