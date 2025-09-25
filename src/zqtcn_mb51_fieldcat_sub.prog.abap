*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_MB51_FIELDCAT_SUB (Include Program)
* PROGRAM DESCRIPTION: Set Field catalog properties on newly added fields in MB51
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   10/02/2019
* WRICEF ID: E218
* TRANSPORT NUMBER(S): ED2K916332
* REFERENCE NO: ERPM-835 / ERP-7933
*----------------------------------------------------------------------*

   CONSTANTS : lc_pubyear  TYPE rvari_vnam VALUE 'ISMYEARNR',       " Publication Year
               lc_arrdate  TYPE rvari_vnam VALUE 'ISMANLFTAGI',     " Actual goods arrival date
               lc_mediapro TYPE rvari_vnam VALUE 'ISMREFMDPROD'.    " Media Product

   " Set Field catalog propeties for newly added fields
   LOOP AT fc_flat.
     CASE fc_flat-fieldname.
       WHEN lc_pubyear.                                      " Publication year
         fc_flat-seltext_l = 'Publication Year'.
         fc_flat-outputlen = '10'.
       WHEN lc_arrdate.                                      " Acctual goods Arrival date
         fc_flat-seltext_l = 'Actual goods arrival date'.
         fc_flat-datatype  = 'DATS'.
       WHEN lc_mediapro.
         fc_flat-seltext_l = 'Media Product'.                " Media Product
     ENDCASE.
     MODIFY fc_flat.
   ENDLOOP.
