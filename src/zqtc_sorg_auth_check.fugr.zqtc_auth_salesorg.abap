FUNCTION zqtc_auth_salesorg.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_UNAME) TYPE  SYUNAME
*"  TABLES
*"      ET_VKORG TYPE  SD_VKORG_RANGES
*"----------------------------------------------------------------------
  DATA:lst_vkorg  TYPE sdsls_vkorg_range.
  IF im_uname IS NOT INITIAL.
* Get all Sales Organizations from TVKO
    SELECT vkorg ,bukrs FROM tvko INTO TABLE @DATA(li_tvko).
    IF sy-subrc EQ 0.
      LOOP AT li_tvko INTO DATA(lst_tvko).
* Check Authorization for each Sales Org for user
        AUTHORITY-CHECK OBJECT 'V_VBAK_VKO' FOR USER im_uname
                   ID 'VKORG' FIELD lst_tvko-vkorg
                   ID 'ACTVT' FIELD '01'
                   ID 'ACTVT' FIELD '02' .

        IF  syst-subrc = 0 .
* If authoruzed, use for data fetching
          lst_vkorg-low = lst_tvko-vkorg.
          lst_vkorg-sign = 'I'.
          lst_vkorg-option = 'EQ'.
          APPEND lst_vkorg TO et_vkorg.
          CLEAR:lst_vkorg.
        ENDIF.
        CLEAR:lst_tvko.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFUNCTION.
