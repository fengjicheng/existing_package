*&---------------------------------------------------------------------*
*&  Include  ZQTCN_I0369_1_MATMAS_SEG_SALES
*&---------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_I0369_1_MATMAS_SEG_SALES
* PROGRAM DESCRIPTION: Generating Sales text segment always  in outbound Idoc
* (Irrespective of whatever is changed on Material master eg : Basic data) .
* DEVELOPER: Murali(mimmadiset)
* CREATION DATE:   02/22/2020
* OBJECT ID:       I0369.1(OTCM-42871)
* TRANSPORT NUMBER(S):ED2K922113
*----------------------------------------------------------------------*

IF stxhkey[] IS NOT INITIAL OR stxhkey[] IS INITIAL.
  CONSTANTS:lc_mvke        TYPE tdobject      VALUE 'MVKE',  "Object id
            lc_vkorg_i0369 TYPE rvari_vnam    VALUE 'VKORG',
            lc_vtweg_i0369 TYPE rvari_vnam    VALUE 'VTWEG',
            lc_msgfn       TYPE msgfn         VALUE '004',    "Change
            lc_devid_i0369 TYPE zdevid        VALUE 'I0369.1',
            lc_id          TYPE tdid          VALUE '0001'.  "Name
  READ TABLE stxhkey INTO DATA(ls_stx)
                         WITH KEY mandt = sy-mandt
                                 tdobject = lc_mvke
                                 tdid = lc_id.
  IF sy-subrc NE 0.  "if MVKE entry is not exist.
    DATA: lir_vkorg_range_i0369 TYPE fip_t_vkorg_range,
          lir_vtweg_range_i0369 TYPE fip_t_vtweg_range,
          li_constants          TYPE zcat_constants,    "Constant Values
          lt_mvke               TYPE STANDARD TABLE OF mvke.
*---Check the Constant table before going to the actual logiC.
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_devid_i0369  "Development ID
      IMPORTING
        ex_constants = li_constants. "Constant Values
*---Fill the respective entries which are maintain in zcaconstant.
    IF li_constants[] IS NOT INITIAL.
      FREE:lir_vkorg_range_i0369,lir_vtweg_range_i0369,lt_mvke.
      LOOP AT li_constants[] ASSIGNING FIELD-SYMBOL(<lfs_constant_i0369>).
*   **---Sale Org constant value
        IF <lfs_constant_i0369>-param1 = lc_vkorg_i0369.
          APPEND INITIAL LINE TO lir_vkorg_range_i0369 ASSIGNING FIELD-SYMBOL(<lst_vkorg_range>).
          <lst_vkorg_range>-sign     = <lfs_constant_i0369>-sign.
          <lst_vkorg_range>-option   = <lfs_constant_i0369>-opti.
          <lst_vkorg_range>-low      = <lfs_constant_i0369>-low.
        ELSEIF <lfs_constant_i0369>-param1 = lc_vtweg_i0369.
          APPEND INITIAL LINE TO lir_vtweg_range_i0369 ASSIGNING FIELD-SYMBOL(<lst_vtweg_range>).
          <lst_vtweg_range>-sign     = <lfs_constant_i0369>-sign.
          <lst_vtweg_range>-option   = <lfs_constant_i0369>-opti.
          <lst_vtweg_range>-low      = <lfs_constant_i0369>-low.
        ENDIF.
      ENDLOOP.
      IF lir_vkorg_range_i0369[] IS NOT INITIAL AND
         lir_vtweg_range_i0369[] IS NOT INITIAL.
        CALL FUNCTION 'MVKE_READ_WITH_MATNR'
          EXPORTING
            matnr         = marakey-matnr
          TABLES
            mvke_tab      = lt_mvke
          EXCEPTIONS
            error_message = 1
            OTHERS        = 2.
        IF sy-subrc EQ 0.
          LOOP AT lt_mvke INTO DATA(ls_mvke)
                            WHERE vkorg IN lir_vkorg_range_i0369 AND
                                  vtweg IN lir_vtweg_range_i0369.
            ls_stx-mandt = sy-mandt.
            ls_stx-tdobject = lc_mvke.
            ls_stx-tdname = ls_mvke-matnr && ls_mvke-vkorg && ls_mvke-vtweg.
            ls_stx-tdid = lc_id.
            ls_stx-tdspras = sy-langu.
            ls_stx-msgfn = lc_msgfn.
            APPEND ls_stx TO stxhkey.
            CLEAR ls_stx.
            EXIT.
          ENDLOOP.
        ENDIF."IF sy-subrc EQ 0.
      ENDIF."IF lir_vkorg_range_i0369[] IS NOT INITIAL AND
    ENDIF."IF li_constants[] IS NOT INITIAL.
  ENDIF."IF sy-subrc NE 0.
ENDIF."IF stxhkey[] IS NOT INITIAL OR stxhkey IS INITIAL.
