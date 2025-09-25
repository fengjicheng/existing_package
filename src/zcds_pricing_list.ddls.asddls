@AbapCatalog.sqlViewName: 'ZIRM_PRICING'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Vistex CDS table'
define view ZCDS_PRICING_LIST as select from konp as a

left outer join konm           as c on c.knumh = a.knumh 
left outer join /vgm/gpr0002se as d on d.knumh = a.knumh

left  outer join konh          as f on f.knumh = a.knumh

{
    a.knumh,
    a.kbetr as konp_kbetr,
    a.konwa,
   
    c.klfn1 as konm_klfn1,
    c.kbetr as konm_kbetr,   
    d.zzismmediatype,
    d.zzprice_type,
    d.zzprat1,
    d.zzreason_code_change,
    d.zzreason_code_cease,
    d.zzjrnl_prod_manager,
    d.zzismpubltype,
    d.zzismidentcode,
    d.zzjournalcode,
    d.zzjrnleditorcode,
    d.zzownership,
    d.zzowningsociety,
    d.zzbase_price_inc_per,
    d.zzonline_open_adj_per,
    d.zzcurr_year,
    d.zzprev_year,
    d.zzcurr_vs_prev_price,
    d.zzprev_price,
    d.zzreason_code_create,
    d.zzextwg,
    f.kosrt,
    f.datab
    
    
       
}
