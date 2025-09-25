"Name: \PR:SDPIQPRICELIST\EX:ES_PIQ_SDPRICELIST_EXT6\EI
ENHANCEMENT 0 ZQTC_SDPRICELST_EXT6.

DATA:lv_str TYPE string.
* Add Member Partner to Selection Screen Input structure

IF s_partnr IS NOT INITIAL.
  CLEAR gs_additional_selcrit.
  gs_additional_selcrit-table = 'KOMK'.
  gs_additional_selcrit-field = 'ZZPARTNER2'.

  LOOP AT s_partnr ASSIGNING <gs_select_option>.
    MOVE-CORRESPONDING <gs_select_option> TO gs_range_string.
    INSERT gs_range_string INTO TABLE gs_additional_selcrit-rgtab.
  ENDLOOP.
  INSERT gs_additional_selcrit INTO TABLE gs_selcrit-additional_selcrit.

ENDIF.

* Add RELTYP Membership category to Selection Screen Input structure
IF s_reltyp IS NOT INITIAL  .

  CLEAR gs_additional_selcrit.
  gs_additional_selcrit-table = 'KOMK'.
  gs_additional_selcrit-field = 'ZZRELTYP'.

  LOOP AT s_reltyp ASSIGNING <gs_select_option>.
    MOVE-CORRESPONDING <gs_select_option> TO gs_range_string.
    INSERT gs_range_string INTO TABLE gs_additional_selcrit-rgtab.
  ENDLOOP.
  INSERT gs_additional_selcrit INTO TABLE gs_selcrit-additional_selcrit.
ENDIF.



* Add SD1 Membership category to Selection Screen Input structure
IF s_member IS NOT INITIAL AND s_partnr[] IS NOT INITIAL .
  SELECT partner1,partner2,reltyp
    FROM but050
    INTO TABLE @DATA(li_sd1)
    WHERE partner1 IN @s_kunnr
      AND partner2 IN @s_partnr
      AND reltyp IN @s_member
      AND date_from LE @sy-datum
      AND date_to GE @sy-datum.
  IF li_sd1 IS INITIAL .
    CLEAR:lv_str.
    lv_str = '  '.
    CONCATENATE 'Rel. Category : ' s_member-low lv_str ' not maintained' INTO lv_str.
    MESSAGE lv_str TYPE 'S' DISPLAY LIKE  'E'.
    LEAVE  LIST-PROCESSING.
  ELSE.

    IF s_member+3(1) = '*' AND s_kunnr[] IS INITIAL.
      SORT li_sd1 BY partner1.
      DELETE ADJACENT DUPLICATES FROM li_sd1 COMPARING partner1.
      LOOP AT li_sd1 INTO DATA(lst_sd1).

        s_kunnr-sign = 'I'.
        s_kunnr-option = 'EQ'.
        s_kunnr-low = lst_sd1-partner1.
        APPEND s_kunnr.
        INSERT s_kunnr INTO TABLE gs_selcrit-kunnr.
      ENDLOOP.
    ENDIF.

    CLEAR gs_additional_selcrit.
    gs_additional_selcrit-table = 'KOMK'.
    gs_additional_selcrit-field = 'ZZRELTYP_SD1'.

    LOOP AT s_member ASSIGNING <gs_select_option>.
      MOVE-CORRESPONDING <gs_select_option> TO gs_range_string.
      INSERT gs_range_string INTO TABLE gs_additional_selcrit-rgtab.
    ENDLOOP.
    INSERT gs_additional_selcrit INTO TABLE gs_selcrit-additional_selcrit.
  ENDIF.
ENDIF.


* Add SD2 Membership category to Selection Screen Input structure
IF s_memsd2 IS NOT INITIAL AND s_partnr[] IS NOT INITIAL .
  SELECT partner1,partner2,reltyp
  FROM but050
  INTO TABLE @DATA(li_sd2)
  WHERE partner1 IN @s_kunnr
    AND partner2 IN @s_partnr
    AND reltyp IN @s_memsd2
    AND date_from LE @sy-datum
    AND date_to GE @sy-datum.
  IF li_sd2 IS INITIAL .
    CLEAR:lv_str.
    lv_str = ' '.
    CONCATENATE 'Rel. Category :  ' s_memsd2-low lv_str ' not maintained' INTO lv_str.
    MESSAGE lv_str TYPE 'S' DISPLAY LIKE  'E'.
    LEAVE  LIST-PROCESSING.
  ELSE.

    IF s_memsd2+3(1) = '*' AND s_kunnr[] IS INITIAL.
      SORT li_sd2 BY partner1.
      DELETE ADJACENT DUPLICATES FROM li_sd2 COMPARING partner1.

      LOOP AT li_sd2 INTO DATA(lst_sd2).

        s_kunnr-sign = 'I'.
        s_kunnr-option = 'EQ'.
        s_kunnr-low = lst_sd2-partner1.
        APPEND s_kunnr.
        INSERT s_kunnr INTO TABLE gs_selcrit-kunnr.
      ENDLOOP.
    ENDIF.

    CLEAR gs_additional_selcrit.
    gs_additional_selcrit-table = 'KOMK'.
    gs_additional_selcrit-field = 'ZZRELTYP_SD2'.

    LOOP AT s_memsd2 ASSIGNING <gs_select_option>.
      MOVE-CORRESPONDING <gs_select_option> TO gs_range_string.
      INSERT gs_range_string INTO TABLE gs_additional_selcrit-rgtab.
    ENDLOOP.
    INSERT gs_additional_selcrit INTO TABLE gs_selcrit-additional_selcrit.
  ENDIF.
ENDIF.

* Add Multi Year Membership category to Selection Screen Input structure
IF s_memmys IS NOT INITIAL AND s_partnr[] IS NOT INITIAL .

  SELECT partner1,partner2,reltyp
    FROM but050
    INTO TABLE @DATA(li_mys)
    WHERE partner1 IN @s_kunnr
      AND partner2 IN @s_partnr
      AND reltyp IN @s_memmys
      AND date_from LE @sy-datum
      AND date_to GE @sy-datum.
  IF li_mys IS INITIAL .
    CLEAR:lv_str.
    lv_str = '  '.
    CONCATENATE 'Rel. Category :  ' s_memmys-low lv_str ' not maintained' INTO lv_str.
    MESSAGE lv_str TYPE 'S' DISPLAY LIKE  'E'.
    LEAVE  LIST-PROCESSING.
  ELSE.

    IF s_memmys+3(1) = '*' AND s_kunnr[] IS INITIAL.
      SORT li_mys BY partner1.
      DELETE ADJACENT DUPLICATES FROM li_mys COMPARING partner1.
      LOOP AT li_mys INTO DATA(lst_mys).

        s_kunnr-sign = 'I'.
        s_kunnr-option = 'EQ'.
        s_kunnr-low = lst_mys-partner1.
        APPEND s_kunnr.
        INSERT s_kunnr INTO TABLE gs_selcrit-kunnr.
      ENDLOOP.
    ENDIF.
    CLEAR gs_additional_selcrit.
    gs_additional_selcrit-table = 'KOMK'.
    gs_additional_selcrit-field = 'ZZRELTYP_MYS'.

    LOOP AT s_memmys ASSIGNING <gs_select_option>.
      MOVE-CORRESPONDING <gs_select_option> TO gs_range_string.
      INSERT gs_range_string INTO TABLE gs_additional_selcrit-rgtab.
    ENDLOOP.
    INSERT gs_additional_selcrit INTO TABLE gs_selcrit-additional_selcrit.
  ENDIF.
ENDIF.

* Add SD1 Membership category to Selection Screen Input structure
IF s_memlps IS NOT INITIAL AND s_partnr[] IS NOT INITIAL .
  SELECT partner1,partner2,reltyp
    FROM but050
    INTO TABLE @DATA(li_lps)
    WHERE partner1 IN @s_kunnr
      AND partner2 IN @s_partnr
      AND reltyp IN @s_memlps
      AND date_from LE @sy-datum
      AND date_to GE @sy-datum.
  IF li_lps IS INITIAL .
    CLEAR:lv_str.
    lv_str = '  '.
    CONCATENATE 'Rel. Category : ' s_memlps-low lv_str ' not maintained' INTO lv_str.
    MESSAGE lv_str TYPE 'S' DISPLAY LIKE  'E'.
    LEAVE  LIST-PROCESSING.
  ELSE.

    IF s_memlps+3(1) = '*' AND s_kunnr[] IS INITIAL.
      SORT li_lps BY partner1.
      DELETE ADJACENT DUPLICATES FROM li_lps COMPARING partner1.
      LOOP AT li_lps INTO DATA(lst_lps).

        s_kunnr-sign = 'I'.
        s_kunnr-option = 'EQ'.
        s_kunnr-low = lst_lps-partner1.
        APPEND s_kunnr.
        INSERT s_kunnr INTO TABLE gs_selcrit-kunnr.
      ENDLOOP.
    ENDIF.

    CLEAR gs_additional_selcrit.
    gs_additional_selcrit-table = 'KOMK'.
    gs_additional_selcrit-field = 'ZZRELTYP_LPS'.

    LOOP AT s_memlps ASSIGNING <gs_select_option>.
      MOVE-CORRESPONDING <gs_select_option> TO gs_range_string.
      INSERT gs_range_string INTO TABLE gs_additional_selcrit-rgtab.
    ENDLOOP.
    INSERT gs_additional_selcrit INTO TABLE gs_selcrit-additional_selcrit.
  ENDIF.
ENDIF.



* Add Price List to Selection Screen Input structure
IF s_prlist IS NOT INITIAL.
  CLEAR gs_additional_selcrit.
  gs_additional_selcrit-table = 'KNVV'.
  gs_additional_selcrit-field = 'PLTYP'.

  LOOP AT s_prlist ASSIGNING <gs_select_option>.
    MOVE-CORRESPONDING <gs_select_option> TO gs_range_string.
    INSERT gs_range_string INTO TABLE gs_additional_selcrit-rgtab.
  ENDLOOP.
  INSERT gs_additional_selcrit INTO TABLE gs_selcrit-additional_selcrit.

ENDIF.

* Add Value period category to Selection Screen Input structure
IF s_vlaufk IS NOT INITIAL.
  CLEAR gs_additional_selcrit.
  gs_additional_selcrit-table = 'KOMP'.
  gs_additional_selcrit-field = 'ZZVLAUFK'.

  LOOP AT s_vlaufk ASSIGNING <gs_select_option>.
    MOVE-CORRESPONDING <gs_select_option> TO gs_range_string.
    INSERT gs_range_string INTO TABLE gs_additional_selcrit-rgtab.
  ENDLOOP.
  INSERT gs_additional_selcrit INTO TABLE gs_selcrit-additional_selcrit.

ENDIF.
ENDENHANCEMENT.
