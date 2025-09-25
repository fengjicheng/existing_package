@AbapCatalog.sqlViewName: 'ZQSD_INDCOND'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Indirect Society Condition Records'
@OData.publish: true
define view ZSD_IND_COND as select from a985
left outer join a950
on  a950.zzpartner2_mys = a985.zzpartner2 
{
a985.kappl,
a985.kschl,
a985.kunag,
a985.pltyp,
a985.zzreltyp,
a985.zzpartner2  as BP985,
a985.matnr,
a985.kfrst,
a985.datbi,
a985.datab,
a985.kbstat,
a985.knumh,
a950.kdgrp,
a950.zzreltyp_mys as RELTY950,
a950.zzpartner2_mys as BP950,
a950.zzvlaufk,
a950.kfrst as kfrst950,
a950.datbi as datbi950,
a950.datab as datab950,
a950.kbstat as kbsta950,
a950.knumh as knumh950    
}
