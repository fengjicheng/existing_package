@AbapCatalog.sqlViewName: 'ZQTC_CDS_E505'
@ClientDependent: true
@AbapCatalog.compiler.CompareFilter: true
@EndUserText.label: 'ABAP CDS View for E505'
define view ZQTC_CDS_E505_001 as select from vbap as a
left outer join vbak as b on a.vbeln = b.vbeln 
left outer join vbep as c on a.vbeln = c.vbeln and 
                             b.vbeln = c.vbeln and
                             a.posnr = c.posnr
left outer join vbup as d on a.vbeln = d.vbeln and
                             a.posnr = d.posnr                             
{
    a.vbeln,
    a.posnr, 
    b.erdat,
    b.auart,
    b.vkorg,
    b.kunnr,
    a.matnr,
    a.abgru,
    c.wmeng,
    c.bmeng
     
}
where  a.abgru = ' ' and
       ( d.lfgsa = 'A' or d.lfgsa = 'B' )
