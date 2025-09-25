FUNCTION zqtc_update_zinvrec_flidoc_gr.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_T_MSEG) TYPE  TY_MSEG
*"----------------------------------------------------------------------
  TYPES: BEGIN OF lty_mseg_zqtc,
           matnr  TYPE matnr,
           zdate  TYPE ztdate,
           zseqno TYPE pkr_seq,
           werks  TYPE dwerk_ext,
         END OF lty_mseg_zqtc.
  TYPES: BEGIN OF lty_objkey,
           objkey TYPE swo_typeid,
         END OF lty_objkey,
         BEGIN OF lty_srrelroles,
           objkey TYPE swo_typeid,
           roleid TYPE roleid,
         END OF lty_srrelroles,
         BEGIN OF lty_xblnr,
           xblnr TYPE xblnr,
         END OF lty_xblnr,
         BEGIN OF lty_idocrel,
           role_a TYPE roleid,
           role_b TYPE roleid,
         END OF lty_idocrel.

  DATA: lst_mseg_zqtc    TYPE lty_mseg_zqtc,
        li_mseg_zqtc     TYPE TABLE OF lty_mseg_zqtc,
        lst_objkey       TYPE lty_objkey,
        li_objkey        TYPE TABLE OF lty_objkey,
        li_xblnr         TYPE TABLE OF lty_xblnr,
        lst_xblnr        TYPE lty_xblnr,
        li_srrelroles    TYPE TABLE OF lty_srrelroles,
        li_idocrel       TYPE TABLE OF lty_idocrel,
        li_idoc_dtls     TYPE TABLE OF lty_srrelroles,
        lst_idoc_dtls    TYPE lty_srrelroles,
        lst_invrec_fdate TYPE zqtc_inven_recon,
        li_invrec_fdate  TYPE TABLE OF zqtc_inven_recon.

  FIELD-SYMBOLS:
    <fs_zqtc_inv_data>     TYPE zqtc_inven_recon.

*  IF im_t_mseg[] IS NOT INITIAL.
*    LOOP AT im_t_mseg INTO DATA(lst_mseg).
*      lst_mseg_zqtc-matnr = lst_mseg-matnr.
*      lst_mseg_zqtc-zdate = lst_mseg-ablad+0(8).
*      lst_mseg_zqtc-zseqno = lst_mseg-ablad+9(10).
*      lst_mseg_zqtc-werks = lst_mseg-werks.
*      APPEND lst_mseg_zqtc TO li_mseg_zqtc.
*      CLEAR lst_mseg_zqtc.
*    ENDLOOP.
*
*    IF li_mseg_zqtc[] IS NOT INITIAL.
*      SELECT * INTO TABLE @DATA(li_zqtc_inv_data)
*             FROM zqtc_inven_recon
*        FOR ALL ENTRIES IN @li_mseg_zqtc
*        WHERE  matnr   EQ @li_mseg_zqtc-matnr
*          AND  zdate   EQ @li_mseg_zqtc-zdate
*          AND  zseqno  EQ @li_mseg_zqtc-zseqno
*          AND  werks   EQ @li_mseg_zqtc-werks.
**          AND  ( mblnr   EQ @space OR
**                 zgi_docnum EQ @space )
**          AND  xblnr   NE @space.
*      IF sy-subrc EQ 0.
*        li_invrec_fdate[] = li_zqtc_inv_data[].
** To take the first GR date for the material and plant.
*        SORT li_invrec_fdate BY matnr werks zfgrdat.
*        DELETE ADJACENT DUPLICATES FROM li_invrec_fdate COMPARING matnr werks zfgrdat.
*
*        DELETE li_zqtc_inv_data WHERE  mblnr NE space.
**                                  AND zdate   NE li_mseg_zqtc-zdate
**                                  AND  zseqno  NE li_mseg_zqtc-zseqno.
**                                      zgi_docnum EQ space )
**                                AND  xblnr NE space.
*      ENDIF.
*    ENDIF.
*    CLEAR: lst_invrec_fdate,
*           lst_mseg_zqtc.
*
**    LOOP AT li_zqtc_inv_data INTO lst_invrec_fdate.
**      READ TABLE li_mseg_zqtc INTO lst_mseg_zqtc WITH KEY
**    ENDLOOP.
*    LOOP AT li_zqtc_inv_data ASSIGNING <fs_zqtc_inv_data>.
*      READ TABLE im_t_mseg INTO lst_mseg WITH KEY matnr = <fs_zqtc_inv_data>-matnr
*                                                  werks = <fs_zqtc_inv_data>-werks.
*      IF sy-subrc EQ 0.
*        <fs_zqtc_inv_data>-mblnr = lst_mseg-mblnr.
*        <fs_zqtc_inv_data>-zlgrdat = <fs_zqtc_inv_data>-zdate.
*        <fs_zqtc_inv_data>-ebeln = lst_mseg-ebeln.
*      ENDIF.
*      READ TABLE li_invrec_fdate INTO lst_invrec_fdate WITH KEY
*                                 matnr = <fs_zqtc_inv_data>-matnr
*                                 werks = <fs_zqtc_inv_data>-werks.
*      IF sy-subrc EQ 0.
*        IF lst_invrec_fdate IS INITIAL.
*          <fs_zqtc_inv_data>-zfgrdat = <fs_zqtc_inv_data>-zdate.
*        ELSE.
*          <fs_zqtc_inv_data>-zfgrdat = lst_invrec_fdate-zfgrdat.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
*    UPDATE zqtc_inven_recon FROM TABLE li_zqtc_inv_data.
*  ENDIF.
**  ENDIF.

  LOOP AT im_t_mseg INTO DATA(lst_mseg).
    CONCATENATE lst_mseg-mblnr lst_mseg-mjahr INTO lst_objkey-objkey.
    APPEND lst_objkey TO li_objkey.
  ENDLOOP.

  SORT li_objkey BY objkey.
  DELETE ADJACENT DUPLICATES FROM li_objkey COMPARING objkey.

  IF li_objkey IS NOT INITIAL.
    SELECT objkey roleid INTO TABLE li_srrelroles
           FROM srrelroles
       FOR ALL ENTRIES IN li_objkey
       WHERE objkey = li_objkey-objkey.
    IF sy-subrc EQ 0.
      SORT li_srrelroles BY objkey roleid.
      DELETE ADJACENT DUPLICATES FROM li_srrelroles COMPARING roleid.
      IF li_srrelroles[] IS NOT INITIAL.
        SELECT role_a role_b INTO TABLE li_idocrel
              FROM idocrel
          FOR ALL ENTRIES IN li_srrelroles
          WHERE role_b EQ li_srrelroles-roleid.
        IF sy-subrc EQ 0.
          SELECT objkey roleid INTO TABLE li_idoc_dtls
           FROM srrelroles
           FOR ALL ENTRIES IN li_idocrel
           WHERE roleid = li_idocrel-role_a.
          IF sy-subrc EQ 0.
            SORT li_idoc_dtls BY objkey.
            DELETE ADJACENT DUPLICATES FROM li_idoc_dtls COMPARING objkey.
            LOOP AT li_idoc_dtls INTO lst_idoc_dtls.
              lst_xblnr-xblnr = lst_idoc_dtls-objkey+0(16).
              APPEND lst_xblnr TO li_xblnr.
            ENDLOOP.
            IF li_xblnr IS NOT INITIAL.
              SELECT * INTO TABLE @DATA(li_zqtc_inv_data)
                     FROM zqtc_inven_recon
                FOR ALL ENTRIES IN @li_xblnr
                WHERE  xblnr  EQ @li_xblnr-xblnr.
            ENDIF.
            LOOP AT li_zqtc_inv_data ASSIGNING <fs_zqtc_inv_data>.
              READ TABLE im_t_mseg INTO lst_mseg WITH KEY matnr = <fs_zqtc_inv_data>-matnr
                                                          werks = <fs_zqtc_inv_data>-werks.
              IF sy-subrc EQ 0.
                <fs_zqtc_inv_data>-mblnr = lst_mseg-mblnr.
                <fs_zqtc_inv_data>-zlgrdat = <fs_zqtc_inv_data>-zdate.
                <fs_zqtc_inv_data>-ebeln = lst_mseg-ebeln.
              ENDIF.
              IF lst_invrec_fdate IS INITIAL.
                <fs_zqtc_inv_data>-zfgrdat = <fs_zqtc_inv_data>-zdate.
              ENDIF.
            ENDLOOP.
            IF li_zqtc_inv_data IS NOT INITIAL.
              UPDATE zqtc_inven_recon FROM TABLE li_zqtc_inv_data.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFUNCTION.
