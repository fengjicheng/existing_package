class ZCL_LAUNCH_UI5 definition
  public
  final
  create public .

public section.

  methods JIRA_APP_LAUNCH .
  methods CLAIM_APP_LAUNCH .
  methods FUTURE_RENEWAL_APP_LAUNCH
    importing
      value(IM_KUNNR) type KUNNR optional .
  methods BLOCKEDDORDERS_APP_LAUNCH .
  methods PDF_APP_LAUNCH .
  methods ZIRM_PRICE_REPORTS_APP_LANUCH .
  methods ZIRM_CHANGE_LOG_APP_LAUNCH .
  methods BLOCK_ORDERS_APP_LAUNCH .
  methods CREDIT_BLOCK_APP_LAUNCH .
  methods RECKON_DASHBOARD_APP_LAUNCH .
  methods ZQTC_ORD_MGMT .
  methods CREDIT_BLOCK_APP_2 .
  methods RECON_DASHBOARD_APP_LAUNCH .
  methods DELIVERY_BLOCK_APP_LAUNCH .
  methods INCOMPLETION_APP_LAUNCH .
protected section.
private section.
ENDCLASS.



CLASS ZCL_LAUNCH_UI5 IMPLEMENTATION.


  method BLOCKEDDORDERS_APP_LAUNCH.
   DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.

    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'.
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-ui-appcache'.
    l_parameter-value = 'false'.
    INSERT l_parameter INTO TABLE l_parameters.
    l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/zblockedorders/index.html'  parameters = l_parameters  always_https = abap_false  ).

** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
*      CONCATENATE '”' l_url '”' INTO l_url.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.

  endmethod.


  METHOD block_orders_app_launch.

    DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.
    DATA : li_bp  TYPE STANDARD TABLE OF ZQTC_BLOCK_ORDER,
           lst_bp TYPE ZQTC_BLOCK_ORDER.
    CONSTANTS: lc_devid TYPE zdevid VALUE 'E266',
               lc_bp    TYPE rvari_vnam VALUE 'BP'.

*    CLEAR : li_bp,lst_bp.
*    SELECT * FROM ZQTC_BLOCK_ORDER INTO TABLE li_bp
*                                WHERE bname = sy-uname.
*    IF sy-subrc EQ 0.
*      SORT li_bp BY erdat DESCENDING ertim DESCENDING.
*      READ TABLE li_bp INTO lst_bp INDEX 1.
*    ENDIF.
    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'(003).
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.

*    l_parameter-name = 'sap-data-bp'(009).
*    IF lst_bp-bp IS NOT INITIAL.
*      l_parameter-value = lst_bp-bp.
*    ELSE.
*      SELECT SINGLE *
*           FROM zcaconstant
*           INTO @DATA(lst_const)
*           WHERE devid = @lc_devid
*             AND activate = @abap_true
*             AND param1   = @lc_bp.
*
*      l_parameter-value = lst_const-low.
*    ENDIF.
*    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-ui-appcache'(004).
    l_parameter-value = 'false'(005).
    INSERT l_parameter INTO TABLE l_parameters.


** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

* l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/ZBLOCK_ORDERS/index.html'
** parameters = l_parameters
*                                                                                  always_https = abap_false  ).

    DATA(lv_sysid) = sy-sysid.
    TRANSLATE lv_sysid TO LOWER CASE.
    CONCATENATE 'https://' lv_sysid 'app01.wiley.com:44300' INTO l_url.

    DATA l_parameter_string TYPE string.

    CONCATENATE l_url '/sap/bc/ui5_ui5/sap/ZBLOCK_ORDERS/index.html' INTO l_url.
    l_parameter_string = cl_http_utility=>fields_to_string( l_parameters ).
    IF l_parameter_string IS NOT INITIAL.
      CONCATENATE l_url '?' l_parameter_string INTO l_url.
    ENDIF.

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
*         application = 'MicrosoftEdge.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.

  ENDMETHOD.


  METHOD claim_app_launch.
    DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.
    DATA : li_bp  TYPE STANDARD TABLE OF zqtc_claims_bp,
           lst_bp TYPE zqtc_claims_bp.
    CONSTANTS: lc_devid TYPE zdevid VALUE 'E252',
               lc_bp    TYPE rvari_vnam VALUE 'BP'.

    CLEAR : li_bp,lst_bp.
    SELECT * FROM zqtc_claims_bp INTO TABLE li_bp
                                WHERE created_user = sy-uname.
    IF sy-subrc EQ 0.
      SORT li_bp BY creted_date DESCENDING time DESCENDING.
      READ TABLE li_bp INTO lst_bp INDEX 1.
    ENDIF.
    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'(003).
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-data-bp'(009).
    IF lst_bp-bp IS NOT INITIAL.
      l_parameter-value = lst_bp-bp.
    ELSE.
      SELECT SINGLE *
           FROM zcaconstant
           INTO @DATA(lst_const)
           WHERE devid = @lc_devid
             AND activate = @abap_true
             AND param1   = @lc_bp.

      l_parameter-value = lst_const-low.
    ENDIF.
    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-ui-appcache'(004).
    l_parameter-value = 'false'(005).
    INSERT l_parameter INTO TABLE l_parameters.

*    CONCATENATE 'https://sap-'(006) sy-sysid '.wiley.com'(007) INTO l_url.
    DATA(lv_sysid) = sy-sysid.
    TRANSLATE lv_sysid TO LOWER CASE.
    CONCATENATE 'https://' lv_sysid 'app01.wiley.com:44300' INTO l_url.

    DATA l_parameter_string TYPE string.

    CONCATENATE l_url '/sap/bc/ui5_ui5/sap/zqtc_claims/index.html'(008) INTO l_url.
    l_parameter_string = cl_http_utility=>fields_to_string( l_parameters ).
    IF l_parameter_string IS NOT INITIAL.
      CONCATENATE l_url '?' l_parameter_string INTO l_url.
    ENDIF.

*        l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/zqtc_claims/index.html'
*         parameters = l_parameters  always_https = abap_false  ).

** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
*         application = 'MicrosoftEdge.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.

  ENDMETHOD.


  method CREDIT_BLOCK_APP_2.
    DATA l_url          TYPE string..
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.


    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'(003).
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.


    l_parameter-name = 'sap-ui-appcache'(004).
    l_parameter-value = 'false'(005).
    INSERT l_parameter INTO TABLE l_parameters.


** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

* l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/ZBLOCK_ORDERS/index.html'
** parameters = l_parameters
*                                                                                  always_https = abap_false  ).

    DATA(lv_sysid) = sy-sysid.
    TRANSLATE lv_sysid TO LOWER CASE.
    CONCATENATE 'https://' lv_sysid 'app01.wiley.com:44300' INTO l_url.

    DATA l_parameter_string TYPE string.

    CONCATENATE l_url '/sap/bc/ui5_ui5/sap/ZCREDIT_BLOCK_N/index.html' INTO l_url.
    l_parameter_string = cl_http_utility=>fields_to_string( l_parameters ).
    IF l_parameter_string IS NOT INITIAL.
      CONCATENATE l_url '?' l_parameter_string INTO l_url.
    ENDIF.

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
*         application = 'MicrosoftEdge.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.
  endmethod.


  METHOD credit_block_app_launch.

    DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.


    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'(003).
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.


    l_parameter-name = 'sap-ui-appcache'(004).
    l_parameter-value = 'false'(005).
    INSERT l_parameter INTO TABLE l_parameters.


** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

* l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/ZBLOCK_ORDERS/index.html'
** parameters = l_parameters
*                                                                                  always_https = abap_false  ).

    DATA(lv_sysid) = sy-sysid.
    TRANSLATE lv_sysid TO LOWER CASE.
    CONCATENATE 'https://' lv_sysid 'app01.wiley.com:44300' INTO l_url.

    DATA l_parameter_string TYPE string.

    CONCATENATE l_url '/sap/bc/ui5_ui5/sap/ZCREDITBLOCK/index.html' INTO l_url.
    l_parameter_string = cl_http_utility=>fields_to_string( l_parameters ).
    IF l_parameter_string IS NOT INITIAL.
      CONCATENATE l_url '?' l_parameter_string INTO l_url.
    ENDIF.

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
*         application = 'MicrosoftEdge.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.

  ENDMETHOD.


  METHOD delivery_block_app_launch.
    DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.
    DATA : li_bp  TYPE STANDARD TABLE OF zqtc_block_order,
           lst_bp TYPE zqtc_block_order.
    CONSTANTS: lc_devid TYPE zdevid VALUE 'E266',
               lc_bp    TYPE rvari_vnam VALUE 'BP'.

*    CLEAR : li_bp,lst_bp.
*    SELECT * FROM ZQTC_BLOCK_ORDER INTO TABLE li_bp
*                                WHERE bname = sy-uname.
*    IF sy-subrc EQ 0.
*      SORT li_bp BY erdat DESCENDING ertim DESCENDING.
*      READ TABLE li_bp INTO lst_bp INDEX 1.
*    ENDIF.
    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'(003).
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-del'.
    l_parameter-value = abap_true.

    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-ui-appcache'(004).
    l_parameter-value = 'false'(005).
    INSERT l_parameter INTO TABLE l_parameters.


    DATA(lv_sysid) = sy-sysid.
    TRANSLATE lv_sysid TO LOWER CASE.
    CONCATENATE 'https://' lv_sysid 'app01.wiley.com:44300' INTO l_url.

    DATA l_parameter_string TYPE string.

    CONCATENATE l_url '/sap/bc/ui5_ui5/sap/ZBLOCK_ORDERS/index.html' INTO l_url.
    l_parameter_string = cl_http_utility=>fields_to_string( l_parameters ).
    IF l_parameter_string IS NOT INITIAL.
      CONCATENATE l_url '?' l_parameter_string INTO l_url.
    ENDIF.

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.

  ENDMETHOD.


  METHOD future_renewal_app_launch.

    DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.

    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'(003).
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.
*--*Additional Parameter BP
    l_parameter-name = 'sap-data-bp'(009).
    l_parameter-value = im_kunnr.
    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-ui-appcache'(004).
    l_parameter-value = 'false'(005).
    INSERT l_parameter INTO TABLE l_parameters.

**    l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/zqtc_frnwal/index.html'
**    parameters = l_parameters  always_https = abap_false  ).

**    CONCATENATE 'https://sap-'(006) sy-sysid '.wiley.com'(007) INTO l_url.
    DATA(lv_sysid) = sy-sysid.
    TRANSLATE lv_sysid TO LOWER CASE.
    CONCATENATE 'https://' lv_sysid 'app01.wiley.com:44300' INTO l_url.


    DATA l_parameter_string TYPE string.

    CONCATENATE l_url '/sap/bc/ui5_ui5/sap/zqtc_frnwal/index.html'(010) INTO l_url.
    l_parameter_string = cl_http_utility=>fields_to_string( l_parameters ).
    IF l_parameter_string IS NOT INITIAL.
      CONCATENATE l_url '?' l_parameter_string INTO l_url.
    ENDIF.
** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
*      CONCATENATE '”' l_url '”' INTO l_url.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.

  ENDMETHOD.


  method INCOMPLETION_APP_LAUNCH.
  DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.
    DATA : li_bp  TYPE STANDARD TABLE OF zqtc_block_order,
           lst_bp TYPE zqtc_block_order.
    CONSTANTS: lc_devid TYPE zdevid VALUE 'R144',
               lc_bp    TYPE rvari_vnam VALUE 'BP'.

    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'(003).
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-del'.
    l_parameter-value = abap_true.

    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-ui-appcache'(004).
    l_parameter-value = 'false'(005).
    INSERT l_parameter INTO TABLE l_parameters.


    DATA(lv_sysid) = sy-sysid.
    TRANSLATE lv_sysid TO LOWER CASE.
    CONCATENATE 'https://' lv_sysid 'app01.wiley.com:44300' INTO l_url.

    DATA l_parameter_string TYPE string.

    CONCATENATE l_url '/sap/bc/ui5_ui5/sap/zqtc_increpr144/index.html' INTO l_url.
    l_parameter_string = cl_http_utility=>fields_to_string( l_parameters ).
    IF l_parameter_string IS NOT INITIAL.
      CONCATENATE l_url '?' l_parameter_string INTO l_url.
    ENDIF.

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.

  endmethod.


  METHOD JIRA_APP_LAUNCH.
    DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.

    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'.
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-ui-appcache'.
    l_parameter-value = 'false'.
    INSERT l_parameter INTO TABLE l_parameters.
    l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/zjira/index.html'  parameters = l_parameters  always_https = abap_false  ).

** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
*      CONCATENATE '”' l_url '”' INTO l_url.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.

  ENDMETHOD.


  METHOD pdf_app_launch.

    DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.

    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'(003).
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-ui-appcache'(004).
    l_parameter-value = 'false'(005).
    INSERT l_parameter INTO TABLE l_parameters.
**    l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/zqtc_frnwal/index.html'  parameters = l_parameters  always_https = abap_false  ).
    CONCATENATE 'https://sap-'(006) sy-sysid '.wiley.com'(007) INTO l_url.
    DATA l_parameter_string TYPE string.

    CONCATENATE l_url '/sap/bc/ui5_ui5/sap/zpdf_poc/index.html'(011) INTO l_url.
*    l_parameter_string = cl_http_utility=>fields_to_string( l_parameters ).
*    IF l_parameter_string IS NOT INITIAL.
*      CONCATENATE l_url '?' l_parameter_string INTO l_url.
*    ENDIF.
** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
*      CONCATENATE '”' l_url '”' INTO l_url.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.
  ENDMETHOD.


  method RECKON_DASHBOARD_APP_LAUNCH.


    DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.


    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'(003).
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.


    l_parameter-name = 'sap-ui-appcache'(004).
    l_parameter-value = 'false'(005).
    INSERT l_parameter INTO TABLE l_parameters.


** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

* l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/ZBLOCK_ORDERS/index.html'
** parameters = l_parameters
*                                                                                  always_https = abap_false  ).

    DATA(lv_sysid) = sy-sysid.
    TRANSLATE lv_sysid TO LOWER CASE.
    CONCATENATE 'https://' lv_sysid 'app01.wiley.com:44300' INTO l_url.

    DATA l_parameter_string TYPE string.

    CONCATENATE l_url '/sap/bc/ui5_ui5/sap/zrecon_dash/index.html' INTO l_url.
    l_parameter_string = cl_http_utility=>fields_to_string( l_parameters ).
    IF l_parameter_string IS NOT INITIAL.
      CONCATENATE l_url '?' l_parameter_string INTO l_url.
    ENDIF.

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
*         application = 'MicrosoftEdge.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.


  endmethod.


  METHOD recon_dashboard_app_launch.
*----------------------------------------------------------------------*
* PROGRAM NAME:RECON_DASHBOARD_APP_LAUNCH(Method)
* PROGRAM DESCRIPTION:Trigger recon dashboard app Tcode-ZRECON_DASHBOARD
* DEVELOPER: Prabhu(PTUFARAM )
* CREATION DATE:   2021-09-09
* OBJECT ID:OTCM-49142/R142
* TRANSPORT NUMBER(S)  ED2K924408
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*
    DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.


    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'(003).
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.


    l_parameter-name = 'sap-ui-appcache'(004).
    l_parameter-value = 'false'(005).
    INSERT l_parameter INTO TABLE l_parameters.


** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

* l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/ZBLOCK_ORDERS/index.html'
** parameters = l_parameters
*                                                                                  always_https = abap_false  ).

    DATA(lv_sysid) = sy-sysid.
    TRANSLATE lv_sysid TO LOWER CASE.
    CONCATENATE 'https://' lv_sysid 'app01.wiley.com:44300' INTO l_url.

    DATA l_parameter_string TYPE string.

    CONCATENATE l_url '/sap/bc/ui5_ui5/sap/zqtc_recon/index.html' INTO l_url.
    l_parameter_string = cl_http_utility=>fields_to_string( l_parameters ).
    IF l_parameter_string IS NOT INITIAL.
      CONCATENATE l_url '?' l_parameter_string INTO l_url.
    ENDIF.

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
*         application = 'MicrosoftEdge.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.



  ENDMETHOD.


  method ZIRM_CHANGE_LOG_APP_LAUNCH.
    DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.

    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'.
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-ui-appcache'.
    l_parameter-value = 'false'.
    INSERT l_parameter INTO TABLE l_parameters.
    l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/ZIRM_CHANGELOG/index.html'  parameters = l_parameters  always_https = abap_false  ).

** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
*      CONCATENATE '”' l_url '”' INTO l_url.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.
  endmethod.


  METHOD zirm_price_reports_app_lanuch.
   DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.

    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'.
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-ui-appcache'.
    l_parameter-value = 'false'.
    INSERT l_parameter INTO TABLE l_parameters.
    l_url = /ui5/cl_theme_util=>get_server_url( path = '/sap/bc/ui5_ui5/sap/ZIRM_PRICE_REP/index.html'  parameters = l_parameters  always_https = abap_false  ).

** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
*      CONCATENATE '”' l_url '”' INTO l_url.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.

  ENDMETHOD.


  METHOD zqtc_ord_mgmt.

    DATA l_url          TYPE string.
    DATA l_char_url     TYPE char1024.
    DATA l_parameter    TYPE ihttpnvp.
    DATA l_parameters   TYPE tihttpnvp.
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.
    DATA : li_bp  TYPE STANDARD TABLE OF zqtc_block_order,
           lst_bp TYPE zqtc_block_order.
    CONSTANTS: lc_devid TYPE zdevid VALUE 'E266',
               lc_bp    TYPE rvari_vnam VALUE 'BP'.

    l_parameter-name = 'sap-client'(001).
    l_parameter-value = sy-mandt.
    INSERT l_parameter INTO TABLE l_parameters.
    DATA l_lang(2).

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_lang.

*Additional URL paramater for UI5 application (Language and APP Cache)
    l_parameter-name = 'sap-ui-language'(003).
    l_parameter-value = l_lang.
    INSERT l_parameter INTO TABLE l_parameters.

    l_parameter-name = 'sap-ui-appcache'(004).
    l_parameter-value = 'false'(005).
    INSERT l_parameter INTO TABLE l_parameters.


** – You can launch any WDA/BSP application. Below is the url to launch WDT_ALV Webdynpro ABAP Application


    DATA(lv_sysid) = sy-sysid.
    TRANSLATE lv_sysid TO LOWER CASE.
    CONCATENATE 'https://' lv_sysid 'app01.wiley.com:44300' INTO l_url.

    DATA l_parameter_string TYPE string.

    CONCATENATE l_url '/sap/bc/ui5_ui5/sap/ZQTC_ORD_MGMT/index.html' INTO l_url.
    l_parameter_string = cl_http_utility=>fields_to_string( l_parameters ).
    IF l_parameter_string IS NOT INITIAL.
      CONCATENATE l_url '?' l_parameter_string INTO l_url.
    ENDIF.

    l_char_url = l_url.

    DATA l_platform TYPE i.
    l_platform = cl_gui_frontend_services=>get_platform( ).
    IF l_platform <> cl_gui_frontend_services=>platform_macosx AND l_platform <> cl_gui_frontend_services=>platform_linux.
*      ” chrome should be used for the ui5 application on windows
*      ” therefore we first try to launch chrome.
*      ” if it fails we fall back to the default browser.

      REPLACE ALL OCCURRENCES OF '”' IN l_url WITH '%34'.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          application = 'chrome.exe'
*         application = 'MicrosoftEdge.exe'
          parameter   = l_url
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = l_char_url.
        cl_gui_cfw=>flush( ).
      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = l_char_url
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'(002).
        ENDIF.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
