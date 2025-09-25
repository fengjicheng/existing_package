class ZCL_ZQTC_RECON_DASHBOA_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_RECON_DASHBOA_DPC
  create public .

public section.
protected section.

  methods DEVIDSET_GET_ENTITYSET
    redefinition .
  methods DEVSTATSET_GET_ENTITYSET
    redefinition .
  methods IDOCDETAILSSET_GET_ENTITYSET
    redefinition .
  methods IDOCSTATSET_GET_ENTITYSET
    redefinition .
  methods DAYSSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_RECON_DASHBOA_DPC_EXT IMPLEMENTATION.


  METHOD daysset_get_entityset.
    CONSTANTS: lc_devid TYPE zdevid VALUE 'R142',
               lc_days  TYPE rvari_vnam VALUE 'DAYS',
               lc_time  TYPE rvari_vnam VALUE 'TIME'.
    DATA : lst_entity LIKE LINE OF et_entityset.
    SELECT
         low,
         param1
         FROM zcaconstant
         INTO TABLE @DATA(li_constant)
         WHERE devid  = @lc_devid
         AND activate = @abap_true.

    LOOP AT li_constant INTO DATA(lst_constnat).
      CASE lst_constnat-param1.
        WHEN lc_days.
          lst_entity-low = lst_constnat-low.
        WHEN lc_time.
          lst_entity-salv_de_selopt_low = lst_constnat-low.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
    APPEND lst_entity TO et_entityset.
    CLEAR lst_entity.
  ENDMETHOD.


  METHOD devidset_get_entityset.
*----------------------------------------------------------------------*
* PROGRAM NAME:DEVIDSET_GET_ENTITYSET(Method)
* PROGRAM DESCRIPTION:Get DevId details
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
    SELECT devid,
           description FROM zqtc_idoc_devid INTO TABLE @et_entityset.
  ENDMETHOD.


  METHOD devstatset_get_entityset.
*----------------------------------------------------------------------*
* PROGRAM NAME:DEVSTATSET_GET_ENTITYSET(Method)
* PROGRAM DESCRIPTION:Get Devstat details
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
    DATA : lv_stdate TYPE erdat,
           lv_endate TYPE erdat,
           lt_date   TYPE date_t_range,
           ls_date   TYPE date_range,
           lv_tabix  TYPE sytabix,
           lv_devid  TYPE zdevid,
           lir_devid TYPE ztqtc_recon_devid_t,
           lsr_devid TYPE zstqtc_recon_devid_s.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Stdate'.
            IF <ls_filter_opt>-low IS NOT INITIAL AND <ls_filter_opt>-low NE 'null'.
              lv_stdate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Endate'.
            IF <ls_filter_opt>-low IS NOT INITIAL AND <ls_filter_opt>-low NE 'null'.
              lv_endate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Devid'.
            IF <ls_filter_opt>-low IS NOT INITIAL AND <ls_filter_opt>-low NE 'null'.
              lsr_devid-low = <ls_filter_opt>-low.
              lsr_devid-option = 'EQ'.
              lsr_devid-sign = 'I'.
              APPEND lsr_devid TO lir_devid.
              CLEAR lsr_devid.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
*Fetch Required data from CDS
    DATA(lo_recon) =  NEW ZCL_RECON_IDOC_GET_DATA_R142( lir_devid ).
    IF lv_stdate IS NOT INITIAL AND lv_endate IS NOT INITIAL.
      lo_recon->get_devid_stat(
        EXPORTING
          im_from_date  =     lv_stdate
          im_to_date    =     lv_endate
        IMPORTING
          ex_devid_stat =     DATA(li_devid_stat)
      ).

      et_entityset = CORRESPONDING #( li_devid_stat ).
    ENDIF.
  ENDMETHOD.


  METHOD idocdetailsset_get_entityset.
*----------------------------------------------------------------------*
* PROGRAM NAME:IDOCDETAILSSET_GET_ENTITYSET(Method)
* PROGRAM DESCRIPTION:Get Idoc details
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
    DATA : lv_stdate  TYPE erdat,
           lv_endate  TYPE erdat,
           lt_date    TYPE date_t_range,
           ls_date    TYPE date_range,
           lv_tabix   TYPE sytabix,
           lv_devid   TYPE zdevid,
           lst_entity TYPE zcl_zqtc_recon_dashboa_mpc=>ts_idocdetails,
           lv_host    TYPE string,
           lv_port    TYPE string,
           lir_devid  TYPE ztqtc_recon_devid_t,
           lsr_devid  TYPE zstqtc_recon_devid_s.
    CONSTANTS:lc_we02  TYPE string VALUE
       '/sap/bc/gui/sap/its/webgui?~Transaction=WE02%20CREDAT-LOW=;DOCNUM-LOW='.

    cl_http_server=>if_http_server~get_location(
     IMPORTING host = lv_host
           port = lv_port ).
    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Stdate'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_stdate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Endate'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_endate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Devid'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lsr_devid-low = <ls_filter_opt>-low.
              lsr_devid-option = 'EQ'.
              lsr_devid-sign = 'I'.
              APPEND lsr_devid TO lir_devid.
              CLEAR lsr_devid.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
*--*Fetch required data from CDS
    DATA(lo_recon) =  NEW zcl_recon_idoc_get_data_r142( lir_devid ).

    IF lv_stdate IS NOT INITIAL AND lv_endate IS NOT INITIAL.
      lo_recon->get_idoc_details(
        EXPORTING
          im_from_date    =     lv_stdate
          im_to_date      =     lv_endate
        IMPORTING
          ex_idoc_details =     DATA(li_details)
      ).
*--*Build detail messages
      SORT lo_recon->gi_devid BY mestyp mescod mesfct.
      LOOP AT li_details INTO DATA(lst_details).

        IF lst_details-statyp IS INITIAL.
          lst_details-statyp = 'E'.
        ENDIF.

        MESSAGE ID lst_details-stamid    "Status message ID
            TYPE lst_details-statyp      "Type of system error message (A, W, E, S, I)
          NUMBER lst_details-stamno      "Status message number
            WITH lst_details-stapa1      "Parameter 1
                 lst_details-stapa2      "Parameter 2
                 lst_details-stapa3      "Parameter 3
                 lst_details-stapa4      "Parameter 4
            INTO lst_entity-bapi_msg. "Message text
        IF lst_details-status = '68'.
          lst_entity-bapi_msg = text-001. "Idoc is deactivated and cannot be processed further
        ENDIF.
        MOVE-CORRESPONDING lst_details TO lst_entity.
        IF lst_entity-logdat IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_entity-logdat
            IMPORTING
              output = lst_entity-logdat.
        ENDIF.
        IF lst_entity-credat IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
            EXPORTING
              input  = lst_entity-credat
            IMPORTING
              output = lst_entity-credat.
        ENDIF.
        READ TABLE lo_recon->gi_devid INTO DATA(lst_devid) WITH KEY mestyp = lst_details-mestyp
                                                                    mescod = lst_details-mescod
                                                                    mesfct = lst_details-mesfct
                                                                    BINARY SEARCH.
        IF sy-subrc EQ 0.
          lst_entity-devid = lst_devid-devid.
          lst_entity-description = lst_devid-description.
        ENDIF.
        CONCATENATE 'http://' lv_host ':'
                      lv_port lc_we02
                      lst_details-docnum
                      INTO lst_entity-link.
        APPEND lst_entity TO et_entityset.
        CLEAR : lst_entity.
      ENDLOOP.
      SORT et_entityset BY docnum DESCENDING.
    ENDIF.
  ENDMETHOD.


  METHOD idocstatset_get_entityset.
*----------------------------------------------------------------------*
* PROGRAM NAME:IDOCSTATSET_GET_ENTITYSET(Method)
* PROGRAM DESCRIPTION:Get IDOC statistics details
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
    DATA : lv_stdate TYPE erdat,
           lv_endate TYPE erdat,
           lt_date   TYPE date_t_range,
           ls_date   TYPE date_range,
           lv_tabix  TYPE sytabix,
           lir_devid TYPE ztqtc_recon_devid_t,
           lsr_devid TYPE zstqtc_recon_devid_s.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Stdate'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_stdate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Endate'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_endate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Devid'.
            IF <ls_filter_opt>-low IS NOT INITIAL AND <ls_filter_opt>-low NE 'null'.
              lsr_devid-low = <ls_filter_opt>-low.
              lsr_devid-option = 'EQ'.
              lsr_devid-sign = 'I'.
              APPEND lsr_devid TO lir_devid.
              CLEAR lsr_devid.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    DATA(lo_recon) =  NEW zcl_recon_idoc_get_data_r142( lir_devid ).
*--*Get statistcs at idoc level from CDS
    IF lv_stdate IS NOT INITIAL AND lv_endate IS NOT INITIAL.
      lo_recon->get_idoc_stat(
        EXPORTING
          im_from_date =     lv_stdate
          im_to_date   =     lv_endate
        IMPORTING
          ex_idoc_stat =    DATA(li_idoc_stat)
      ).
      et_entityset = CORRESPONDING #( li_idoc_stat ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
