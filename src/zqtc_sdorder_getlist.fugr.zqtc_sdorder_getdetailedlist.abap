*----------------------------------------------------------------------*
* FUNCTION MODULE NAME:ZQTC_SDORDER_GETDETAILEDLIST (Get Subscription Order data)
* PROGRAM DESCRIPTION:Function Module for Sales Order Data
* DEVELOPER: Siva Guda ( SGUDA)
* CREATION DATE:   02/05/2016
* OBJECT ID: E096
* TRANSPORT NUMBER(S): ED2K910734
*----------------------------------------------------------------------*
FUNCTION ZQTC_SDORDER_GETDETAILEDLIST.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_SO_VIEW) LIKE  ZQTC_SO_VIEW STRUCTURE  ZQTC_SO_VIEW
*"       DEFAULT 'X'
*"     VALUE(IM_KEY_REF) TYPE  XFELD DEFAULT 'X'
*"  TABLES
*"      T_SALES_DOCUMENTS STRUCTURE  ZQTC_SO_RANGE
*"      T_ORDER_HEADERS_OUT STRUCTURE  BAPISDHD OPTIONAL
*"      T_ORDER_ITEMS_OUT STRUCTURE  BAPISDIT OPTIONAL
*"      T_ORDER_PARTNERS_OUT STRUCTURE  BAPISDPART OPTIONAL
*"      T_ORDER_CONTRACTS_OUT STRUCTURE  BAPISDCNTR OPTIONAL
*"      T_ORDER_BUSINESS_OUT STRUCTURE  BAPISDBUSI OPTIONAL
*"      T_ORDER_TEXTHEADERS_OUT STRUCTURE  BAPISDTEHD OPTIONAL
*"      T_ORDER_TEXTLINES_OUT STRUCTURE  BAPITEXTLI OPTIONAL
*"      T_ORDER_FLOWS_OUT STRUCTURE  BAPISDFLOW OPTIONAL
*"      T_NAST STRUCTURE  NAST OPTIONAL
*"----------------------------------------------------------------------
*- Checking the entries
  IF T_SALES_DOCUMENTS[] IS NOT INITIAL.
    REFRESH:LI_VBAK,LT_KEYTAB,LI_SALES,T_ORDER_HEADERS_OUT,T_ORDER_ITEMS_OUT,
            T_ORDER_BUSINESS_OUT,T_ORDER_PARTNERS_OUT,T_ORDER_CONTRACTS_OUT,
            T_ORDER_TEXTHEADERS_OUT,T_ORDER_TEXTLINES_OUT,T_ORDER_FLOWS_OUT.
    LT_KEYTAB[] = T_SALES_DOCUMENTS[].
    IF IM_KEY_REF = LC_X.
*- Remove if duplicate entries
      IF LT_KEYTAB[] IS NOT INITIAL.
*- Get Subscription Order Header data
        SELECT * FROM VBAK
                 INTO TABLE @LI_VBAK
*               FOR ALL ENTRIES IN @LT_KEYTAB
                 WHERE VBELN IN @LT_KEYTAB.
        IF LI_VBAK[] IS NOT INITIAL.
*- Get Subscription Order Item Data
          REFRESH:LI_VBAP.
          SELECT * FROM VBAP
                   INTO CORRESPONDING FIELDS OF TABLE @LI_VBAP
                   FOR ALL ENTRIES IN @LI_VBAK
                   WHERE VBELN = @LI_VBAK-VBELN.
          IF IM_SO_VIEW-PARTNER IS NOT INITIAL.
*- Get Subscription Order Partner Data
            REFRESH:LI_VBPA.
            SELECT * FROM VBPA
                     INTO CORRESPONDING FIELDS OF TABLE @LI_VBPA
                     FOR ALL ENTRIES IN @LI_VBAK
                     WHERE VBELN = @LI_VBAK-VBELN.
          ENDIF.
          IF IM_SO_VIEW-CONTRACT IS NOT INITIAL.
*- Get Subscription Order Contract Data
            REFRESH:LI_VEDA.
            SELECT * FROM VEDA
                     INTO CORRESPONDING FIELDS OF TABLE @LI_VEDA
                     FOR ALL ENTRIES IN @LI_VBAK
                     WHERE VBELN = @LI_VBAK-VBELN.
          ENDIF.
          IF IM_SO_VIEW-BUSINESS IS NOT INITIAL.
*- Get Subscription Order business Data
            REFRESH:LI_VBKD.
            SELECT * FROM VBKD
                      INTO CORRESPONDING FIELDS OF TABLE @LI_VBKD
                      FOR ALL ENTRIES IN @LI_VBAK
                      WHERE VBELN = @LI_VBAK-VBELN.
          ENDIF.
*- Get Subscription Order header and item text Data
          IF IM_SO_VIEW-TEXTHEAD IS NOT INITIAL.
            REFRESH:LI_THEAD,LI_STX_LINES.
            PERFORM GET_TEXTHEAD TABLES LI_THEAD
                                      LT_KEYTAB .
            PERFORM  GET_TEXTLINES  TABLES LI_THEAD
                                           LI_STX_LINES.
          ENDIF.
          IF IM_SO_VIEW-SDFLOW IS NOT INITIAL.
*- *- Get Subscription Order document flow Data
            REFRESH:LI_VBFA.
            SELECT * FROM VBFA
                     INTO CORRESPONDING FIELDS OF TABLE @LI_VBFA
                     FOR ALL ENTRIES IN @LI_VBAK
                     WHERE VBELV = @LI_VBAK-VBELN.
          ENDIF.
*- Convert to BAPI Structure
          CALL FUNCTION 'MAP_INT_TO_EXT_STRUCTURE'
            EXPORTING
              I_OPERATION = LC_DOWNLOAD_TYPE
            TABLES
              FXVBAK      = LI_VBAK
              FXVBAP      = LI_VBAP
              FXVBKD      = LI_VBKD
              FXVBPA      = LI_VBPA
              FXVEDA      = LI_VEDA
              FXTHEAD     = LI_THEAD
              FXTLINE     = LI_STX_LINES
              FXVBFA      = LI_VBFA
              FXBAPIVBAK  = T_ORDER_HEADERS_OUT
              FXBAPIVBAP  = T_ORDER_ITEMS_OUT
              FXBAPIVBKD  = T_ORDER_BUSINESS_OUT
              FXBAPIVBPA  = T_ORDER_PARTNERS_OUT
              FXBAPIVEDA  = T_ORDER_CONTRACTS_OUT
              FXBAPITHEAD = T_ORDER_TEXTHEADERS_OUT
              FXBAPITLINE = T_ORDER_TEXTLINES_OUT
              FXBAPIVBFA  = T_ORDER_FLOWS_OUT.
        ENDIF.
      ENDIF.
    ELSE.
      REFRESH: LI_VBAK,LI_SALES,T_ORDER_HEADERS_OUT,T_ORDER_ITEMS_OUT,
               T_ORDER_BUSINESS_OUT,T_ORDER_PARTNERS_OUT,T_ORDER_CONTRACTS_OUT,
               T_ORDER_TEXTHEADERS_OUT,T_ORDER_TEXTLINES_OUT,T_ORDER_FLOWS_OUT.
*- Get Subscription Order Header data
      SELECT * FROM VBAK
               INTO TABLE @LI_VBAK
*               FOR ALL ENTRIES IN @LT_KEYTAB
               WHERE VBELN IN @LT_KEYTAB.

      LOOP AT LI_VBAK INTO LST_VBAK.
        LST_SALES-VBELN = LST_VBAK-VBELN.
        APPEND LST_SALES TO LI_SALES.
        CLEAR: LST_SALES,LST_VBAK.
      ENDLOOP.
      SORT LI_SALES BY VBELN.
      DELETE ADJACENT DUPLICATES FROM LI_SALES.
      IF IM_SO_VIEW-HEADER IS NOT INITIAL.
        LV_BAPI_VIEW-HEADER = LC_X.
      ENDIF.
      IF IM_SO_VIEW-ITEM IS NOT INITIAL.
        LV_BAPI_VIEW-ITEM = LC_X.
      ENDIF.
      IF IM_SO_VIEW-PARTNER IS NOT INITIAL.
        LV_BAPI_VIEW-PARTNER = LC_X.
      ENDIF.
      IF IM_SO_VIEW-BUSINESS IS NOT INITIAL.
        LV_BAPI_VIEW-BUSINESS = LC_X.
      ENDIF.
      IF IM_SO_VIEW-CONTRACT IS NOT INITIAL.
        LV_BAPI_VIEW-CONTRACT = LC_X.
      ENDIF.
      IF IM_SO_VIEW-TEXTHEAD IS NOT INITIAL.
        LV_BAPI_VIEW-TEXT = LC_X.
      ENDIF.
      IF IM_SO_VIEW-SDFLOW IS NOT INITIAL.
        LV_BAPI_VIEW-FLOW = LC_X.
      ENDIF.
*& Call function module to fecth order details
      CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
        EXPORTING
          I_BAPI_VIEW           = LV_BAPI_VIEW
*         I_MEMORY_READ         =
*         I_WITH_HEADER_CONDITIONS       = ' '
        TABLES
          SALES_DOCUMENTS       = LI_SALES
          ORDER_HEADERS_OUT     = T_ORDER_HEADERS_OUT
          ORDER_ITEMS_OUT       = T_ORDER_ITEMS_OUT
*         ORDER_SCHEDULES_OUT   =
          ORDER_BUSINESS_OUT    = T_ORDER_BUSINESS_OUT
          ORDER_PARTNERS_OUT    = T_ORDER_PARTNERS_OUT
*         ORDER_ADDRESS_OUT     =
*         ORDER_STATUSHEADERS_OUT        =
*         ORDER_STATUSITEMS_OUT =
*         ORDER_CONDITIONS_OUT  =
*         ORDER_COND_HEAD       =
*         ORDER_COND_ITEM       =
*         ORDER_COND_QTY_SCALE  =
*         ORDER_COND_VAL_SCALE  =
          ORDER_CONTRACTS_OUT   = T_ORDER_CONTRACTS_OUT
          ORDER_TEXTHEADERS_OUT = T_ORDER_TEXTHEADERS_OUT
          ORDER_TEXTLINES_OUT   = T_ORDER_TEXTLINES_OUT
          ORDER_FLOWS_OUT       = T_ORDER_FLOWS_OUT
*         ORDER_CFGS_CUREFS_OUT =
*         ORDER_CFGS_CUCFGS_OUT =
*         ORDER_CFGS_CUINS_OUT  =
*         ORDER_CFGS_CUPRTS_OUT =
*         ORDER_CFGS_CUVALS_OUT =
*         ORDER_CFGS_CUBLBS_OUT =
*         ORDER_CFGS_CUVKS_OUT  =
*         ORDER_BILLINGPLANS_OUT         =
*         ORDER_BILLINGDATES_OUT         =
*         ORDER_CREDITCARDS_OUT =
*         EXTENSIONOUT          =
        .

*      CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
*        EXPORTING
*          I_BAPI_VIEW           = IM_BAPI_VIEW
*        TABLES
*          SALES_DOCUMENTS       = LI_SALES
*          ORDER_HEADERS_OUT     = FP_I_HEADER
*          ORDER_ITEMS_OUT       = FP_I_ITEM
*          ORDER_BUSINESS_OUT    = FP_I_BUSINESS
*          ORDER_PARTNERS_OUT    = FP_I_PARTNER
*          ORDER_CONTRACTS_OUT   = FP_I_CONTRACT
*          ORDER_TEXTHEADERS_OUT = FP_I_TEXTHEADERS
*          ORDER_TEXTLINES_OUT   = FP_I_TEXTLINES
*          ORDER_FLOWS_OUT       = FP_I_DOCFLOW.
    ENDIF.
  ENDIF.


ENDFUNCTION.
