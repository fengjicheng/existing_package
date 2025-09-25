@AbapCatalog.sqlViewName: 'zqtc_sales_002'
@ClientDependent: true
@AbapCatalog.compiler.CompareFilter: true
@EndUserText.label: 'ABAP CDS View on VBKD table'
define view Zqtc_Cds_Sales_002 as
select from vbkd {
vbeln,
posnr,
konda,
bstkd,
bsark,
ihrez,
kdkg1,
kdkg2,
kdkg3,
kdkg4,
kdkg5,
kdgrp,
pltyp,
ihrez_e    
}
