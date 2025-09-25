@AbapCatalog.sqlViewName: 'ZQTC_RECON_IDOC'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOTREQUIRED
@EndUserText.label: 'IDOC Status Details for Reckon Dashboard App'
define view ZCDS_RECON_IDOC as select from  ZCDS_RECON_EDIDS as stat
            inner join edids as stat2 on stat.docnum = stat2.docnum                                    
                                      and stat.counter = stat2.countr
        inner join edidc as cntrl on stat2.docnum = cntrl.docnum     
{ 
       
    key stat.docnum, --idoc num   
    stat2.logdat, -- Date of status information
    stat2.logtim, -- Time of status information
    stat.counter, -- IDoc status counter
    stat2.status, -- Status of IDoc
    stat2.statxt, -- Status of IDoc
    stat2.stamid, -- Status message ID
    stat2.statyp, -- Type of system error message (A, W, E, S, I)
    stat2.stamno, -- Status message number
    stat2.stapa1, -- Parameter 1
    stat2.stapa2, -- Parameter 2
    stat2.stapa3, -- Parameter 3
    stat2.stapa4, -- Parameter 4
    cntrl.sndprn, -- Partner Number of Sender
    cntrl.rcvprn, -- Partner Number of Receiver
    cntrl.mescod, -- Logical Message Variant
    cntrl.mesfct,  -- Logical message function
    cntrl.credat, -- IDoc Created On
    cntrl.cretim,  -- IDoc Created at
    cntrl.mestyp  -- Message Type
    
   --        
}   

       
     
