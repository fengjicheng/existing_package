@AbapCatalog.sqlViewName: 'ZQTC_RECON_EDIDS'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOTREQUIRED
@EndUserText.label: 'Get unique status records per IDOC'
define view ZCDS_RECON_EDIDS as select from edids{
    
key docnum, --idoc num   
  --  logdat,
  --  logtim,
    max(countr) as counter

} group by docnum
