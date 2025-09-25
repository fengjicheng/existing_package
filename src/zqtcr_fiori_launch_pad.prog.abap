*&---------------------------------------------------------------------*
*& Report  /UI2/START_URL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zqtcr_fiori_launch_pad.

TYPE-POOLS abap.

DATA lv_accessibility_mode TYPE c.
DATA lv_langu              TYPE c LENGTH 2.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-002 NO INTERVALS.
PARAMETERS flp TYPE c NO-DISPLAY. "RADIOBUTTON GROUP appl  USER-COMMAND app_changed DEFAULT 'X' no-display.
PARAMETERS flpd TYPE c NO-DISPLAY. "RADIOBUTTON GROUP appl NO-DISPLAY .
SELECTION-SCREEN END OF BLOCK b1.
" adaptation layers
SELECTION-SCREEN BEGIN OF BLOCK layer WITH FRAME TITLE text-001 NO INTERVALS.
PARAMETERS conf TYPE c NO-DISPLAY. "RADIOBUTTON GROUP layr MODIF ID ly DEFAULT 'X'.
*PARAMETERS cust TYPE c RADIOBUTTON GROUP layr MODIF ID ly.
SELECTION-SCREEN END OF BLOCK layer.

AT SELECTION-SCREEN OUTPUT.

START-OF-SELECTION.
  conf = abap_true.
  IF sy-tcode = 'ZFLP'.
    flp = abap_true.
  ELSEIF  sy-tcode = 'ZFLPD'.
    flpd = abap_true.
  ELSE.
    flp = abap_true.
  ENDIF.
**********************************************************************
* create (pattern) entries in table HTTPURLLOC for the below urls


* (e.g. /sap/bc/ui2/* and /sap/bc/ui5_ui5/*).
* these entries have to point to the reverse proxy (e.g. SAP WebDispatcher).
* if the entries are missing the local host name will be used.
**********************************************************************

* create start url
  CASE abap_true.
    WHEN flp.
      DATA(lo_start_url) = NEW /ui2/cl_start_url( iv_icf_node_path = /ui2/if_start_url=>co_flp ).
    WHEN flpd.
      lo_start_url = NEW /ui2/cl_start_url( iv_icf_node_path = /ui2/if_start_url=>co_flpd ).
    WHEN OTHERS.
      /ui2/cx_runtime=>raise_not_implemented( method = '' ).
  ENDCASE.

* case FLPD - add url parameter 'scope'
  IF flpd EQ abap_true.
    CASE abap_true.
      WHEN conf.
        lo_start_url->add_url_param( 'scope=CONF' ).
*      WHEN cust.
*        lo_start_url->add_url_param( 'scope=CUST' ).
      WHEN OTHERS.
        /ui2/cx_runtime=>raise_not_implemented( method = '' ).
    ENDCASE.
  ENDIF.

* add sap params "sy-mandt", "sap-language", "sap-language"
  lo_start_url->add_sap_params( ).

*  break vdpataball.
* start in browser
*  lo_start_url->start_browser( ).
  DATA gv_url TYPE string .
* single sign-on
  CONSTANTS lc_icf_url TYPE string VALUE '/sap/public/myssocntl'. "#EC SYNTCHAR
  DATA lv_sso_active   TYPE abap_bool.
  CALL METHOD cl_icf_tree=>if_icf_tree~service_from_url
    EXPORTING
      url                   = lc_icf_url
      hostnumber            = 0
      authority_check       = abap_false
    IMPORTING
      icfactive             = lv_sso_active
    EXCEPTIONS
      wrong_application     = 1
      no_application        = 2
      not_allow_application = 3
      wrong_url             = 4
      no_authority          = 4
      OTHERS                = 5.
  IF sy-subrc NE 0.
    lv_sso_active = abap_false.
  ENDIF.

  DATA: lv_urlc TYPE c LENGTH 1024,
        lv_url  TYPE string.

  DATA(lv_sysid) = sy-sysid.
  TRANSLATE lv_sysid TO LOWER CASE.
*  CONCATENATE 'https://' lv_sysid 'app01.wiley.com:44300' INTO lv_url.
  CONCATENATE 'http://' lv_sysid 'app01.wiley.com:8000' INTO lv_url.

*escape URL
  IF flpd = abap_true.
    CONCATENATE lv_url '/sap/bc/ui5_ui5/sap/arsrvc_upb_admn/main.html?scope=CONF&sap-client=120&sap-language=EN' INTO lv_url.
    lv_urlc = lv_url."'http://ed2app01.wiley.com:8000/sap/bc/ui5_ui5/sap/arsrvc_upb_admn/main.html?scope=CONF&sap-client=120&sap-language=EN'.
  ELSEIF flp = abap_true.
    CONCATENATE lv_url '/sap/bc/ui2/flp?sap-client=130&sap-language=EN' INTO lv_url.
    lv_urlc = lv_url." 'http://ed2app01.wiley.com:8000/sap/bc/ui2/flp?sap-client=130&sap-language=EN'.
  ENDIF.

  gv_url = lv_urlc.
* start browser with single sign-on
  IF lv_sso_active = abap_true.
    DATA lv_container TYPE REF TO cl_gui_container.         "#EC NEEDED
    DATA lv_viewer    TYPE REF TO cl_gui_html_viewer.

    CREATE OBJECT lv_viewer
      EXPORTING
        parent             = lv_container
      EXCEPTIONS
        cntl_error         = 1
        cntl_install_error = 2
        dp_install_error   = 3
        dp_error           = 4
        OTHERS             = 5.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              DISPLAY LIKE 'E'.
    ENDIF.

    CALL METHOD lv_viewer->enable_sapsso
      EXPORTING
        enabled    = abap_true
      EXCEPTIONS
        cntl_error = 1
        OTHERS     = 2.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              DISPLAY LIKE 'E'.
    ENDIF.

************************************************************************
    DATA l_html_viewer  TYPE REF TO cl_gui_html_viewer.

    CALL METHOD cl_gui_frontend_services=>execute
      EXPORTING
*       application = 'chrome.exe'
        application = 'MicrosoftEdge.exe'
        parameter   = gv_url "lv_urlc
      EXCEPTIONS
        OTHERS      = 1.
    IF sy-subrc = 0.
      CALL METHOD cl_gui_cfw=>flush
        EXCEPTIONS
          cntl_system_error = 1
          cntl_error        = 2
          OTHERS            = 3.
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
                DISPLAY LIKE 'E'.
      ENDIF.
      RETURN.
    ENDIF.

    TRY.
        DATA l_empty_co TYPE REF TO cl_gui_container.

        CREATE OBJECT l_html_viewer
          EXPORTING
            parent = l_empty_co.

        CALL METHOD l_html_viewer->('DETACH_URL_IN_BROWSER')
          EXPORTING
            url = lv_urlc.
        "l_char_url.
        CALL METHOD cl_gui_cfw=>flush
          EXCEPTIONS
            cntl_system_error = 1
            cntl_error        = 2
            OTHERS            = 3.
        IF sy-subrc NE 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
                  DISPLAY LIKE 'E'.
        ENDIF.

      CATCH cx_root.
        CALL FUNCTION 'CALL_BROWSE'
          EXPORTING
            url                    = lv_urlc
            new_window             = abap_true
          EXCEPTIONS
            frontend_not_supported = 1
            frontend_error         = 2
            prog_not_found         = 3
            no_batch               = 4
            unspecified_error      = 5.
        IF sy-subrc NE 0.
          MESSAGE e001(00) WITH 'cannot start browser'.
        ENDIF.
    ENDTRY.
*****************************************************************

*    CALL METHOD lv_viewer->detach_url_in_browser
*      EXPORTING
*        url        = lv_urlc
*      EXCEPTIONS
*        cntl_error = 1
*        OTHERS     = 2.
*    IF sy-subrc NE 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
*              DISPLAY LIKE 'E'.
*    ENDIF.
  ELSE.
    CALL FUNCTION 'CALL_BROWSE'
      EXPORTING
        url                    = lv_urlc "l_char_url
      EXCEPTIONS
        frontend_not_supported = 1
        frontend_error         = 2
        prog_not_found         = 3
        no_batch               = 4
        unspecified_error      = 5.
    IF sy-subrc NE 0.
      MESSAGE e001(00) WITH 'cannot start browser'.
    ENDIF.

  ENDIF.
