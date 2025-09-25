*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MODIFY_SALES_AREA_02 (Include Program)
* PROGRAM DESCRIPTION: Populate Sales Area from IDOC instead of getting
*                      the values from the Reference Document (Quote)
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 28-June-2018
* OBJECT ID: I0341 (ERP-6801)
* TRANSPORT NUMBER(S): ED2K912446
*----------------------------------------------------------------------*
DATA:
  lst_sales_area_i0341 TYPE erp_sales_area,      "Sales Area Structure in ERP
  lv_mem_name_i0341    TYPE char30.              "Memory ID Name

* Prepare the Memory ID Name
CONCATENATE rv45a-docnum
            '_SALES_AREA'
       INTO lv_mem_name_i0341.
* Get the Sales Area from IDOC
* The Memory ID is getting populated in Include ZQTCN_INSUB_BDC_I0341 (EXIT_SAPLVEDA_002)
IMPORT lst_sales_area_i0341 FROM MEMORY ID lv_mem_name_i0341.
IF lst_sales_area_i0341 IS NOT INITIAL.
  vbak-vkorg = lst_sales_area_i0341-vkorg.
  vbak-vtweg = lst_sales_area_i0341-vtweg.
  vbak-spart = lst_sales_area_i0341-spart.
* Organizational Unit: Sales Area(s)
  PERFORM tvta_select(sapmv45a) USING vbak-vkorg
                                      vbak-vtweg
                                      vbak-spart.
ENDIF.
