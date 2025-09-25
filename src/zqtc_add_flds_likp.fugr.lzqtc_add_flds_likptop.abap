*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_ADD_FLDS_LIKPTOP(Top Include)
* PROGRAM DESCRIPTION: Additional Fiels in LIKP (Delivery Header)
* DEVELOPER: Aratrika Banerjee(ARABANERJE)
* CREATION DATE:   10/12/2016
* OBJECT ID: E124
* TRANSPORT NUMBER(S): ED2K903037
*----------------------------------------------------------------------*
FUNCTION-POOL zqtc_add_flds_likp. "MESSAGE-ID ..

* INCLUDE LZQTC_ADD_FLDS_LIKPD...            " Local class definition


DATA : v_whs TYPE likp-zzwhs. " Consolidation/Packing list/Price on Packing List
