@AbapCatalog.sqlViewName: 'ZQTC_RECON_STAT'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Recon Dashboard Statistics'
define view ZCDS_RECON_STAT with parameters p_from_date : EDI_CCRDAT , 
                                            p_to_date : EDI_CCRDAT 
     as select from ZCDS_RECON_IDOC {
     key mestyp, -- Idoc Message type
         mescod, -- Idoc Message code
         mesfct, -- Idoc Message Function
         status, -- Idoc Status
        -- statyp,         
         count( * ) as records_count    
         
} where  credat between $parameters.p_from_date and $parameters.p_to_date 
     
  group by mestyp, mescod, mesfct, status
  --statyp
