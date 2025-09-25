report Z_VA42
       no standard page heading line-size 255.

include bdcrecx1.

start-of-selection.

perform open_group.

perform bdc_dynpro      using 'SAPMV45A' '0101'.
perform bdc_field       using 'BDC_CURSOR'
                              'VBAK-AUART'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'VBAK-AUART'
                              'ZSUB'.
perform bdc_field       using 'VBAK-VKORG'
                              '1001'.
perform bdc_field       using 'VBAK-VTWEG'
                              '00'.
perform bdc_field       using 'VBAK-SPART'
                              '00'.
perform bdc_field       using 'VBAK-VKBUR'
                              '0050'.
perform bdc_dynpro      using 'SAPMV45A' '4001'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'VBKD-BSTKD'
                              'ccccccccccccccc'.
perform bdc_field       using 'VBKD-BSTDK'
                              '03/16/2021'.
perform bdc_field       using 'KUAGV-KUNNR'
                              '1002449849'.
perform bdc_field       using 'KUWEV-KUNNR'
                              '1002449849'.
perform bdc_field       using 'VEDA-VBEGDAT'
                              '03/16/2021'.
perform bdc_field       using 'VEDA-VBEGREG'
                              '01'.
perform bdc_field       using 'VEDA-VENDDAT'
                              '03/15/2022'.
perform bdc_field       using 'VEDA-VENDREG'
                              '08'.
perform bdc_field       using 'BDC_CURSOR'
                              'RV45A-MABNR(01)'.
perform bdc_field       using 'RV45A-MABNR(01)'
                              'CIUZP'.
perform bdc_field       using 'VBAP-ZMENG(01)'
                              '                1'.
perform bdc_dynpro      using 'SAPMV45A' '4001'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ITEM'.
perform bdc_field       using 'VBKD-BSTKD'
                              'ccccccccccccccc'.
perform bdc_field       using 'VBKD-BSTDK'
                              '03/16/2021'.
perform bdc_field       using 'KUAGV-KUNNR'
                              '1002449849'.
perform bdc_field       using 'KUWEV-KUNNR'
                              '1002449849'.
perform bdc_field       using 'VBKD-PRSDT'
                              '03/16/2021'.
perform bdc_field       using 'VBAK-VSBED'
                              '01'.
perform bdc_field       using 'VEDA-VBEGDAT'
                              '03/16/2021'.
perform bdc_field       using 'VEDA-VBEGREG'
                              '01'.
perform bdc_field       using 'VEDA-VENDDAT'
                              '03/15/2022'.
perform bdc_field       using 'VEDA-VENDREG'
                              '08'.
perform bdc_field       using 'BDC_CURSOR'
                              'RV45A-MABNR(01)'.
perform bdc_dynpro      using 'SAPMV45A' '4003'.
perform bdc_field       using 'BDC_OKCODE'
                              '=T\16'.
perform bdc_field       using 'BDC_CURSOR'
                              'VBAP-ZMENG'.
perform bdc_field       using 'VBAP-ZMENG'
                              '                  1'.
perform bdc_field       using 'VBAP-ZIEME'
                              'EA'.
perform bdc_field       using 'VBAP-UMZIN'
                              '     1'.
perform bdc_field       using 'VBAP-UMZIZ'
                              '     1'.
perform bdc_field       using 'VBKD-PRSDT'
                              '03/16/2021'.
perform bdc_dynpro      using 'SAPMV45A' '4003'.
perform bdc_field       using 'BDC_OKCODE'
                              '/EBACK'.
perform bdc_field       using 'BDC_CURSOR'
                              'VBAP-ZZRGCODE'.
perform bdc_field       using 'VBAP-ZZRGCODE'
                              'VBGFRTYH'.
perform bdc_dynpro      using 'SAPMV45A' '4001'.
perform bdc_field       using 'BDC_OKCODE'
                              'BACK'.
perform bdc_field       using 'VBKD-BSTKD'
                              'ccccccccccccccc'.
perform bdc_field       using 'VBKD-BSTDK'
                              '03/16/2021'.
perform bdc_field       using 'KUAGV-KUNNR'
                              '1002449849'.
perform bdc_field       using 'KUWEV-KUNNR'
                              '1002449849'.
perform bdc_field       using 'VBKD-PRSDT'
                              '03/16/2021'.
perform bdc_field       using 'VBAK-VSBED'
                              '01'.
perform bdc_field       using 'VEDA-VBEGDAT'
                              '03/16/2021'.
perform bdc_field       using 'VEDA-VBEGREG'
                              '01'.
perform bdc_field       using 'VEDA-VENDDAT'
                              '03/15/2022'.
perform bdc_field       using 'VEDA-VENDREG'
                              '08'.
perform bdc_field       using 'BDC_CURSOR'
                              'RV45A-MABNR(02)'.
perform bdc_field       using 'RV45A-MABNR(02)'
                              'CIUZP'.
perform bdc_field       using 'VBAP-ZMENG(02)'
                              '                1'.
perform bdc_dynpro      using 'SAPMV45A' '4001'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ITEM'.
perform bdc_field       using 'VBKD-BSTKD'
                              'ccccccccccccccc'.
perform bdc_field       using 'VBKD-BSTDK'
                              '03/16/2021'.
perform bdc_field       using 'KUAGV-KUNNR'
                              '1002449849'.
perform bdc_field       using 'KUWEV-KUNNR'
                              '1002449849'.
perform bdc_field       using 'VBKD-PRSDT'
                              '03/16/2021'.
perform bdc_field       using 'VBAK-VSBED'
                              '01'.
perform bdc_field       using 'VEDA-VBEGDAT'
                              '03/16/2021'.
perform bdc_field       using 'VEDA-VBEGREG'
                              '01'.
perform bdc_field       using 'VEDA-VENDDAT'
                              '03/15/2022'.
perform bdc_field       using 'VEDA-VENDREG'
                              '08'.
perform bdc_field       using 'BDC_CURSOR'
                              'RV45A-MABNR(01)'.
perform bdc_dynpro      using 'SAPMV45A' '4003'.
perform bdc_field       using 'BDC_OKCODE'
                              '=T\01'.
perform bdc_field       using 'BDC_CURSOR'
                              'VBAP-ZZRGCODE'.
perform bdc_field       using 'VBAP-ZZRGCODE'
                              'GHFHFGHFF'.
perform bdc_dynpro      using 'SAPMV45A' '4003'.
perform bdc_field       using 'BDC_OKCODE'
                              '/EBACK'.
perform bdc_field       using 'BDC_CURSOR'
                              'VBAP-ZMENG'.
perform bdc_field       using 'VBAP-ZMENG'
                              '                  1'.
perform bdc_field       using 'VBAP-ZIEME'
                              'EA'.
perform bdc_field       using 'VBAP-UMZIN'
                              '     1'.
perform bdc_field       using 'VBAP-UMZIZ'
                              '     1'.
perform bdc_field       using 'VBKD-PRSDT'
                              '03/16/2021'.
perform bdc_dynpro      using 'SAPMV45A' '4001'.
perform bdc_field       using 'BDC_OKCODE'
                              '=SICH'.
perform bdc_field       using 'VBKD-BSTKD'
                              'ccccccccccccccc'.
perform bdc_field       using 'VBKD-BSTDK'
                              '03/16/2021'.
perform bdc_field       using 'KUAGV-KUNNR'
                              '1002449849'.
perform bdc_field       using 'KUWEV-KUNNR'
                              '1002449849'.
perform bdc_field       using 'VBKD-PRSDT'
                              '03/16/2021'.
perform bdc_field       using 'VBAK-VSBED'
                              '01'.
perform bdc_field       using 'VEDA-VBEGDAT'
                              '03/16/2021'.
perform bdc_field       using 'VEDA-VBEGREG'
                              '01'.
perform bdc_field       using 'VEDA-VENDDAT'
                              '03/15/2022'.
perform bdc_field       using 'VEDA-VENDREG'
                              '08'.
perform bdc_field       using 'BDC_CURSOR'
                              'RV45A-MABNR(02)'.
perform bdc_dynpro      using 'SAPLSPO2' '0101'.
perform bdc_field       using 'BDC_OKCODE'
                              '=OPT1'.
perform bdc_transaction using 'VA41'.

perform close_group.
