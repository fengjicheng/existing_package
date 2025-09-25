class ZCL_RECON_IDOC_GET_DATA_R142 definition
  public
  final
  create public .

public section.

  data GI_DEVID type ZTQTC_IDOC_DEVID .
  data GI_IDOC_STATUS type ZTQTC_DEV_IDOCSTAT .
  constants C_E type CHAR1 value 'E' ##NO_TEXT.
  constants C_A type CHAR1 value 'A' ##NO_TEXT.
  constants C_S type CHAR1 value 'S' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      value(IM_DEVID) type ZTQTC_RECON_DEVID_T optional .
  methods GET_IDOC_DETAILS
    importing
      value(IM_FROM_DATE) type EDI_CCRDAT optional
      value(IM_TO_DATE) type EDI_CCRDAT optional
    exporting
      value(EX_IDOC_DETAILS) type ZTQTC_RECON_IDOC_DETAILS .
  methods GET_IDOC_STAT
    importing
      value(IM_FROM_DATE) type EDI_CCRDAT
      value(IM_TO_DATE) type EDI_CCRDAT
    exporting
      value(EX_IDOC_STAT) type ZTQTC_RECON_IDOC_STAT_T .
  methods GET_DEVID_STAT
    importing
      value(IM_FROM_DATE) type EDI_CCRDAT
      value(IM_TO_DATE) type EDI_CCRDAT
    exporting
      value(EX_DEVID_STAT) type ZTQTC_RECON_DEVID_STAT_T .
protected section.
private section.
ENDCLASS.



CLASS ZCL_RECON_IDOC_GET_DATA_R142 IMPLEMENTATION.


  METHOD constructor.
*----------------------------------------------------------------------*
* PROGRAM NAME:Constructor Method
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
*--*Get devId details
    SELECT mestyp,
           mescod,
           mesfct,
           counter,
           devid,
           description,
           source,
           middleware,
           target FROM zqtc_idoc_devid INTO TABLE @DATA(li_devid)
                                     WHERE devid IN @im_devid.
    IF sy-subrc EQ 0.
      me->gi_devid = CORRESPONDING #( li_devid ).
*--*Get IDOC error status details
      SELECT devid,
             idoc_status,
             msg_type FROM zqtc_dev_idocsta INTO TABLE @DATA(li_idoc_stat) ORDER BY devid,idoc_status.
      IF sy-subrc EQ 0.
        me->gi_idoc_status = CORRESPONDING #( li_idoc_stat ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD GET_DEVID_STAT.
*----------------------------------------------------------------------*
* PROGRAM NAME:GET_DEVID_STAT(Method)
* PROGRAM DESCRIPTION:Get IDOC statistics  at devid details
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
    DATA : lst_devid_stat TYPE zstqtc_recon_devid_stat.
    CALL METHOD me->get_idoc_stat
      EXPORTING
        im_from_date = im_from_date
        im_to_date   = im_to_date
      IMPORTING
        ex_idoc_stat = DATA(li_idoc_stat).
    SORT li_idoc_stat BY devid.
    LOOP AT li_idoc_stat INTO DATA(lst_idoc_stat).
      lst_devid_stat-devid = lst_idoc_stat-devid.
      lst_devid_stat-description = lst_idoc_stat-description.
      lst_devid_stat-success = lst_devid_stat-success + lst_idoc_stat-success.
      lst_devid_stat-error = lst_devid_stat-error + lst_idoc_stat-error.
      lst_devid_stat-total = lst_devid_stat-success + lst_devid_stat-error.
      AT END OF devid.
        APPEND lst_devid_stat TO ex_devid_stat.
        CLEAR lst_devid_stat.
      ENDAT.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_idoc_details.
*----------------------------------------------------------------------*
* PROGRAM NAME:GET_IDOC_DETAILS(Method)
* PROGRAM DESCRIPTION:Get IDOC details
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
    DATA : lir_status TYPE RANGE OF edistattyp,
           lsr_status LIKE LINE OF lir_status.
    IF me->gi_devid IS NOT INITIAL.
      READ TABLE gi_devid INTO DATA(lst_devid) INDEX 1.
      IF sy-subrc EQ 0.
*--*Get only error statuses
        LOOP AT gi_idoc_status INTO DATA(lst_idoc_status) WHERE devid = lst_devid-devid
                                                           AND msg_type = c_e.
          lsr_status-low = lst_idoc_status-idoc_status.
          lsr_status-option = 'EQ'.
          lsr_status-sign = 'I'.
          APPEND lsr_status TO lir_status.
          CLEAR lsr_status.
        ENDLOOP.
        SELECT docnum,
               logdat,
               logtim,
               sndprn,
               rcvprn,
               mestyp,
               mescod,
               mesfct,
               counter,
               status,
               statxt,
               stamid,
               statyp,
               stamno,
               stapa1,
               stapa2,
               stapa3,
               stapa4,
               credat,
               cretim
               FROM zqtc_recon_idoc INTO TABLE  @DATA(li_details)
                          WHERE  mestyp = @lst_devid-mestyp
                              AND mescod = @lst_devid-mescod
                               AND mesfct = @lst_devid-mesfct AND
                                 credat BETWEEN @im_from_date AND @im_to_date
                                 AND status IN @lir_status.
        "   AND ( statyp = @c_e OR statyp = ' ' OR statyp = @c_a ).
        IF sy-subrc EQ 0.
          ex_idoc_details = CORRESPONDING #( li_details ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_idoc_stat.
*----------------------------------------------------------------------*
* PROGRAM NAME:GET_IDOC_STAT(Method)
* PROGRAM DESCRIPTION:Get IDOC statistics
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
    DATA : lst_stat_final   TYPE zstqtc_recon_idoc_stat,
           lv_error_count   TYPE i,
           lv_success_count TYPE i.
*--*Get Idoc stat from CDS
    IF me->gi_devid IS NOT INITIAL.
      SELECT mestyp,
             mescod,
             mesfct,
             "statyp,
             status,
             records_count FROM zqtc_recon_stat( p_from_date = @im_from_date, p_to_date = @im_to_date )
                           INTO TABLE @DATA(li_stat)
                           FOR ALL ENTRIES IN @gi_devid
                               WHERE mestyp = @gi_devid-mestyp
                                  AND mescod = @gi_devid-mescod
                                  AND mesfct = @gi_devid-mesfct.
      IF sy-subrc EQ 0.
*--*Build final output
        SORT li_stat BY mestyp mescod mesfct.
        LOOP AT gi_devid INTO DATA(lst_dev).
          lst_stat_final-devid = lst_dev-devid.
          lst_stat_final-description = lst_dev-description.
          lst_stat_final-source = lst_dev-source.
          lst_stat_final-middleware = lst_dev-middleware.
          lst_stat_final-target = lst_dev-target.
          READ TABLE li_stat INTO DATA(lst_stat) WITH KEY mestyp = lst_dev-mestyp
                                                          mescod = lst_dev-mescod
                                                          mesfct = lst_dev-mesfct
                                                          BINARY SEARCH.
          IF sy-subrc EQ 0.
            DATA(lv_index) = sy-tabix.
            LOOP AT li_stat INTO lst_stat FROM lv_index.
              IF lst_stat-mestyp = lst_dev-mestyp AND lst_stat-mescod = lst_dev-mescod
                                                  AND lst_stat-mesfct = lst_dev-mesfct.
                READ TABLE gi_idoc_status INTO DATA(lst_idoc_status) WITH KEY devid = lst_dev-devid
                                                                              idoc_status = lst_stat-status
                                                                              BINARY SEARCH.
                IF sy-subrc EQ 0.
                  CASE lst_idoc_status-msg_type.
                    WHEN c_e.
                      ADD 1 TO lv_error_count.
                      lst_stat_final-error = lst_stat_final-error + lst_stat-records_count.
                    WHEN c_s.
                      ADD 1 TO lv_success_count.
                      lst_stat_final-success = lst_stat_final-success + lst_stat-records_count.
                    WHEN OTHERS.
                  ENDCASE.
                ENDIF.
              ELSE.
                EXIT.
              ENDIF.
            ENDLOOP.
            lst_stat_final-total = lst_stat_final-error + lst_stat_final-success.
          ENDIF.
*
          APPEND lst_stat_final TO ex_idoc_stat.
          CLEAR : lst_stat_final, lv_error_count, lv_success_count.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
