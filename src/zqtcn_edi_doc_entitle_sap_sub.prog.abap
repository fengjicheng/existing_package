
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBAK_VBAP
*&---------------------------------------------------------------------*
*   PERFORM to get Address and Material related information
*----------------------------------------------------------------------*

FORM f_get_vbak_vbap .

*** Local Structure Declaration
  TYPES: BEGIN OF lty_idct,
           sign   TYPE char1,        " Sign of type CHAR1
           option TYPE char2,        " Option of type CHAR2
           low    TYPE ismidentcode, " Identification Code
           high   TYPE ismidentcode, " Identification Code
         END OF lty_idct.            " local structure for identcode

  TYPES: BEGIN OF lty_prtrl,
           sign   TYPE char1, " Sign of type CHAR1
           option TYPE char2, " Option of type CHAR2
           low    TYPE parvw, " Partner Function
           high   TYPE parvw, " Partner Function
         END OF lty_prtrl.    " local structure for PARVW

  TYPES: BEGIN OF lty_media,
           sign   TYPE char1,         " Sign of type CHAR1
           option TYPE char2,         " Option of type CHAR2
           low    TYPE ismmediatype,  " Media Type
           high   TYPE ismmediatype,  " Media Type
         END OF lty_media,
         BEGIN OF lty_cmgst,
           sign   TYPE char1,         " Sign of type CHAR1
           option TYPE char2,         " Option of type CHAR2
           low    TYPE cmgst,         " Overall status of credit checks
           high   TYPE cmgst,         " Overall status of credit checks
         END OF lty_cmgst,
         BEGIN OF lty_idcode,
           sign   TYPE char1,         " Sign of type CHAR1
           option TYPE char2,         " Option of type CHAR2
           low    TYPE ismidcodetype, " Type of Identification Code
           high   TYPE ismidcodetype, " Type of Identification Code
         END OF lty_idcode,
         BEGIN OF lty_mtart,
           sign   TYPE char1,         " Sign of type CHAR1
           option TYPE char2,         " Option of type CHAR2
           low    TYPE mtart,         " Material Type
           high   TYPE mtart,         " Material Type
         END OF lty_mtart.

  TYPES: BEGIN OF lty_adr6,
           adrnr     TYPE adrnr,      " Address
           smtp_addr TYPE ad_smtpadr, " E-Mail Address
         END OF lty_adr6.
  TYPES: BEGIN OF lty_adrinfo,
           vbeln      TYPE vbeln, " Sales and Distribution Document Number
           posnr      TYPE posnr, " Item number of the SD document
           parvw      TYPE parvw, " Partner Function
           kunnr      TYPE kunnr, " Customer Number
           adrnr      TYPE adrnr, " Address
***BOC BY SAYANDAS on 17th May 2017 for ERP-2130
           title      TYPE ad_title, " Form-of-Address Key
***EOC BY SAYANDAS on 17th May 2017 for ERP-2130
           name1      TYPE ad_name1,  " Name 1
           name2      TYPE ad_name2,  " Name 2
           city1      TYPE ad_city1,  " City
           post_code1 TYPE ad_pstcd1, " City postal code
           street     TYPE ad_street, " Street
           country    TYPE land1,     " Country Key
           region     TYPE regio,     " Region (State, Province, County)
           landx50    TYPE landx50,   " Country Name (Max. 50 Characters)
         END OF lty_adrinfo,          " local structure for address information
***BOC BY BANDLAPAL on 17th May 2017 for ERP-2130
         BEGIN OF lty_title_desc,
           langu      TYPE spras,
           title      TYPE ad_title,
           title_medi TYPE ad_titletx,
         END OF lty_title_desc.
***EOC BY BANDLAPAL on 17th May 2017 for ERP-2130

  DATA:
*** Local variable declaration
    lv_jcode       TYPE char5, " Jcode of type CHAR5
    lv_jtemp       TYPE char4, " Jtemp of type CHAR4
    lv_jcode1      TYPE char5, " Jcode1 of type CHAR5
    lv_spras       TYPE spras, " Language Key
*** Local structure declaration
    lst_idct       TYPE lty_idct,
    lst_adr6       TYPE lty_adr6,
    lst_prtrl      TYPE lty_prtrl,
    lst_final      TYPE ty_final,
    lst_adrinfo    TYPE lty_adrinfo,
    lst_adrinfo1   TYPE lty_adrinfo,
*** Local internal table declaration
    li_adr6        TYPE STANDARD TABLE OF lty_adr6,
    lit_idct       TYPE STANDARD TABLE OF lty_idct,
    li_adrnum      TYPE STANDARD TABLE OF lty_adrinfo,
    li_adrinfo     TYPE STANDARD TABLE OF lty_adrinfo,
***BOC BY BANDLAPAL on 17th May 2017 for ERP-2130
    li_adrinfo_tit TYPE STANDARD TABLE OF lty_adrinfo,
    lst_title_desc TYPE lty_title_desc,
    li_title_desc  TYPE STANDARD TABLE OF lty_title_desc,
***EOC BY BANDLAPAL on 17th May 2017 for ERP-2130
*    li_matinfo   TYPE STANDARD TABLE OF lty_matinfo, "Commented by MODUTTA on 02/02/2017 for CR334
    lit_prtrl      TYPE STANDARD TABLE OF lty_prtrl,
    li_media       TYPE STANDARD TABLE OF lty_media,
    lst_media      TYPE lty_media,
    li_cmgst       TYPE STANDARD TABLE OF lty_cmgst,
    lst_cmgst      TYPE lty_cmgst,
    li_idcode      TYPE TABLE OF lty_idcode, ",ismidcodetype,
    lst_idcode     TYPE lty_idcode,
    li_mtart       TYPE STANDARD TABLE OF lty_mtart,
    lst_mtart      TYPE lty_mtart.



*** Local Constant Declaration
  CONSTANTS:  lc_star       TYPE char1 VALUE '*',               " Star of type CHAR1
              lc_i          TYPE char1 VALUE 'I',               " I of type CHAR1
              lc_cp         TYPE char2 VALUE 'CP',              " Cp of type CHAR2
              lc_eq         TYPE char2 VALUE 'EQ',              " Eq of type CHAR2
              lc_ne         TYPE char2 VALUE 'NE',              " Ne of type CHAR2
              lc_ag         TYPE parvw VALUE 'AG',              " Partner Function
              lc_we         TYPE parvw VALUE 'WE',              " Partner Function
              lc_sub        TYPE auart VALUE 'ZSUB',            " Sales Document Type
              lc_cop        TYPE auart VALUE 'ZCOP',            " Sales Document Type
              lc_grc        TYPE auart VALUE 'ZGRC',            " Sales Document Type
              lc_trl        TYPE auart VALUE 'ZTRL',            " Sales Document Type
              lc_rew        TYPE auart VALUE 'ZREW',            " Sales Document Type
              lc_y          TYPE auart VALUE 'Y',               " Sales Document Type
              lc_r          TYPE auart VALUE 'R',               " Sales Document Type
              lc_subr       TYPE zsubtyp VALUE 'R',             " Subscription Type
              lc_subc       TYPE zsubtyp VALUE 'C',             " Subscription Type
              lc_cmgst      TYPE char05 VALUE 'CMGST',          " Cmgst of type CHAR05
              lc_idcode     TYPE rvari_vnam VALUE 'IDCODETYPE', " ABAP: Name of Variant Variable
              lc_mtart      TYPE rvari_vnam VALUE 'MTART',      " ABAP: Name of Variant Variable
              lc_media_type TYPE rvari_vnam VALUE 'MEDIA_TYPE',
              lc_devid      TYPE zdevid VALUE 'I0296'.          " Development ID

* Fetch data from ZCACONSTANT table
  SELECT  param1,    " ABAP: Name of Variant Variable
          low,       " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE @DATA(li_constant)
    WHERE devid = @lc_devid.
  IF sy-subrc EQ 0.
    SORT li_constant BY param1.
    LOOP AT li_constant INTO DATA(lst_constant).
      CASE lst_constant-param1.
        WHEN lc_mtart.
          lst_mtart-sign    = lc_i.
          lst_mtart-option  = lc_eq.
          lst_mtart-low     = lst_constant-low.
          APPEND lst_mtart TO li_mtart.
          CLEAR lst_mtart.
        WHEN lc_idcode.
          lst_idcode-sign   = lc_i.
          lst_idcode-option = lc_eq.
          lst_idcode-low = lst_constant-low.
          APPEND lst_idcode TO li_idcode.
          CLEAR lst_idcode.
        WHEN lc_media_type.
          lst_media-sign = lc_i.
          lst_media-option = lc_eq.
          lst_media-low = lst_constant-low.
          APPEND lst_media TO li_media.
          CLEAR lst_media.
        WHEN lc_cmgst.
          lst_cmgst-sign   = lc_i.
          lst_cmgst-option = lc_ne.
          lst_cmgst-low = lst_constant-low.
          APPEND lst_cmgst TO li_cmgst.
        WHEN OTHERS.
          "No Action
      ENDCASE.
    ENDLOOP. " LOOP AT li_constant INTO DATA(lst_constant)
  ENDIF. " IF sy-subrc EQ 0

  LOOP AT s_jcode.
    IF s_jcode-low IS NOT INITIAL.
      lv_jtemp = s_jcode-low.

      SHIFT lv_jtemp RIGHT DELETING TRAILING space.
      TRANSLATE lv_jtemp USING ' 0'. " adding 0's in left

      s_jcode-low = lv_jtemp.

      CONCATENATE s_jcode-low lc_star INTO lv_jcode.
    ENDIF. " IF s_jcode-low IS NOT INITIAL

    IF s_jcode-high IS NOT INITIAL.

      CLEAR lv_jtemp.
      lv_jtemp = s_jcode-high.

      SHIFT lv_jtemp RIGHT DELETING TRAILING space.
      TRANSLATE lv_jtemp USING ' 0'. " adding 0's in left

      s_jcode-high = lv_jtemp.

      CONCATENATE s_jcode-high lc_star INTO lv_jcode1.

    ENDIF. " IF s_jcode-high IS NOT INITIAL

    lst_idct-sign = lc_i.
    lst_idct-option = lc_cp.
    lst_idct-low = lv_jcode.
    lst_idct-high = lv_jcode1.
    APPEND lst_idct TO lit_idct.
    CLEAR lst_idct.
  ENDLOOP. " LOOP AT s_jcode


**************Commented by MODUTTA on 02/02/2017 for CR334
*  SELECT a~matnr
*       a~identcode
*       b~auart
*       b~vbeln
*       b~posnr
*       c~gbsta
*       d~audat
*       e~zzsubtyp
*      INTO TABLE li_matinfo
*      FROM jptidcdassign AS a
*      INNER JOIN mara AS f ON a~matnr  = f~matnr
*      INNER JOIN vapma AS b ON a~matnr = b~matnr
*      INNER JOIN vbup AS c ON b~vbeln = c~vbeln
*                           AND b~posnr = c~posnr
*      INNER JOIN vbak AS d ON b~vbeln = d~vbeln
*      INNER JOIN vbap AS e ON b~vbeln = e~vbeln
*                           AND b~posnr = e~posnr
*      WHERE a~identcode IN lit_idct
*      AND a~idcodetype = lc_jrnl
*      AND b~auart IN s_auart
*      AND c~gbsta IN lit_vgbsta
*      AND f~ismmediatype = lc_di.
**************End of comment by MODUTTA on 02/02/2017 for CR334
***BOC by MODUTTA on 02/02/2017 for CR334
  SELECT a~matnr,
         a~identcode,
         b~auart,
         b~vbeln,
         b~posnr,
         c~gbsta,
         d~audat,
         e~zzsubtyp,
         i~venddat " Contract end date
        INTO TABLE @DATA(li_matinfo)
        FROM jptidcdassign AS a
        INNER JOIN vapma AS b ON a~matnr = b~matnr
        INNER JOIN vbup AS c  ON b~vbeln = c~vbeln
                             AND b~posnr = c~posnr
        INNER JOIN vbak AS d ON b~vbeln = d~vbeln
        INNER JOIN vbap AS e ON b~vbeln = e~vbeln
                             AND b~posnr = e~posnr
        INNER JOIN mara AS f ON e~matnr  = f~matnr
        INNER JOIN vbuk AS g ON c~vbeln = g~vbeln
        INNER JOIN veda AS i ON e~vbeln = i~vbeln
*                             AND e~posnr = i~vposn
        WHERE a~identcode IN @lit_idct
        AND a~idcodetype IN @li_idcode
        AND b~auart IN @s_auart
        AND d~lifsk EQ @space
        AND e~abgru EQ @space
        AND f~ismmediatype IN @li_media
        AND f~mtart IN @li_mtart
        AND g~cmgst IN @li_cmgst
        AND i~venddat GE @sy-datum.
***EOC by MODUTTA on 02/02/2017 for CR334
  IF sy-subrc IS NOT INITIAL AND li_matinfo IS INITIAL.
    MESSAGE i015(zqtc_r2). " No Data found to display!
    PERFORM f_mail_send.
  ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL AND li_matinfo IS INITIAL
*****BOC by MODUTTA on 02/06/2017 for CR334
    SORT li_matinfo BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_matinfo COMPARING vbeln posnr.
    IF li_matinfo IS NOT INITIAL.
      SELECT
         vbeln,            " Sales order
         posnr,            " Item Number
         valid_from,       " Valid From
         valid_to          " valid To
        FROM jkseinterrupt " IS-M: Suspensions
        INTO TABLE @DATA(li_jkse_info)
        FOR ALL ENTRIES IN @li_matinfo
        WHERE vbeln = @li_matinfo-vbeln
          AND posnr = @li_matinfo-posnr
          AND reasoncode <> @space
          AND valid_from < @sy-datum
          AND valid_to > @sy-datum.
      IF sy-subrc EQ 0.
        SORT li_jkse_info BY vbeln posnr.
        DATA(lv_flag) = abap_true.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_matinfo IS NOT INITIAL
*****EOC by MODUTTA on 02/06/2017 for CR334
  ENDIF. " IF sy-subrc IS NOT INITIAL AND li_matinfo IS INITIAL

  lst_prtrl-sign = lc_i.
  lst_prtrl-option = lc_eq.
  lst_prtrl-low = lc_ag.
  APPEND lst_prtrl TO lit_prtrl.
  CLEAR lst_prtrl.

  lst_prtrl-sign = lc_i.
  lst_prtrl-option = lc_eq.
  lst_prtrl-low = lc_we.
  APPEND lst_prtrl TO lit_prtrl.
  CLEAR lst_prtrl.

  IF li_matinfo IS NOT INITIAL.

*** Calling FM to convert sy-langu value
    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_INPUT'
      EXPORTING
        input            = sy-langu
      IMPORTING
        output           = lv_spras
      EXCEPTIONS
        unknown_language = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF. " IF sy-subrc <> 0

**** Select Data from VBPA ADRC
**** ADR6 T005T   table

    SELECT a~vbeln      " Sales and Distribution Document Number
           a~posnr      " Item number of the SD document
           a~parvw      " Partner Function
           a~kunnr      " Customer Number
           a~adrnr      " Address
***BOC BY SAYANDAS on 17th May 2017 for ERP-2130
           b~title
***EOC BY SAYANDAS on 17th May 2017 for ERP-2130
           b~name1      " Name 1
           b~name2      " Name 2
           b~city1      " City
           b~post_code1 " City postal code
           b~street     " Street
           b~country    " Country Key
           b~region     " Region (State, Province, County)
           d~landx50    " Country Name (Max. 50 Characters)
      INTO TABLE li_adrinfo
      FROM vbpa AS a
      INNER JOIN adrc AS b ON a~adrnr = b~addrnumber
      INNER JOIN t005t AS d ON b~country = d~land1
      FOR ALL ENTRIES IN li_matinfo
      WHERE a~vbeln = li_matinfo-vbeln
      AND a~parvw IN lit_prtrl
      AND d~spras = lv_spras.

    IF sy-subrc = 0.
      SORT li_adrinfo BY vbeln posnr parvw. " sorting ADRINFO table
      DELETE ADJACENT DUPLICATES FROM li_adrinfo COMPARING vbeln posnr parvw.
      " Deleting duplicate entries
      li_adrnum[] = li_adrinfo[].
      SORT li_adrnum BY adrnr.
      DELETE ADJACENT DUPLICATES FROM li_adrnum COMPARING adrnr.
      IF li_adrnum IS NOT INITIAL.
        SELECT addrnumber smtp_addr
          INTO TABLE li_adr6
          FROM adr6 " E-Mail Addresses (Business Address Services)
          FOR ALL ENTRIES IN li_adrnum
          WHERE addrnumber = li_adrnum-adrnr.
        IF sy-subrc EQ 0.
          SORT li_adr6 BY adrnr.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF li_adrnum IS NOT INITIAL
***BOC BY BANDLAPAL on 17th May 2017 for ERP-2130
* To retrieve the title description for the ship to
      li_adrinfo_tit[] = li_adrinfo[].
      DELETE li_adrinfo_tit WHERE parvw NE lc_we.
      SORT li_adrinfo_tit BY vbeln adrnr parvw.
      DELETE ADJACENT DUPLICATES FROM li_adrinfo_tit COMPARING vbeln adrnr parvw.
      IF li_adrinfo_tit[] IS NOT INITIAL.
        SELECT langu
               title
               title_medi
            INTO TABLE li_title_desc
           FROM tsad3t
          FOR ALL ENTRIES IN li_adrinfo_tit
          WHERE langu EQ lv_spras
            AND title  EQ li_adrinfo_tit-title.
        IF sy-subrc EQ 0.
          SORT li_title_desc BY title.
        ENDIF.
      ENDIF.
***EOC BY BANDLAPAL on 17th May 2017 for ERP-2130

    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF li_matinfo IS NOT INITIAL
*** Loop to prepare final internal table
*****************************************************************
  LOOP AT li_matinfo INTO DATA(lst_matinfo).
    IF lst_matinfo-venddat LT sy-datum.
      CONTINUE.
    ENDIF. " IF lst_matinfo-venddat LT sy-datum
    IF lv_flag IS NOT INITIAL.
      READ TABLE li_jkse_info WITH KEY vbeln = lst_matinfo-vbeln
                                       posnr = lst_matinfo-posnr
                                       BINARY SEARCH
                                       TRANSPORTING NO FIELDS.

      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lv_flag IS NOT INITIAL

    READ TABLE li_adrinfo INTO lst_adrinfo WITH KEY vbeln = lst_matinfo-vbeln
                                                    posnr = lst_matinfo-posnr
                                                    parvw = lc_we.

    " reading internal table to fetch ship-to information
    IF sy-subrc EQ 0.
      CLEAR lst_adr6.
      READ TABLE li_adr6 INTO lst_adr6 WITH KEY adrnr = lst_adrinfo-adrnr.
      IF sy-subrc EQ 0.
        lst_final-smtp_addr = lst_adr6-smtp_addr.
      ENDIF. " IF sy-subrc EQ 0
***BOC BY SAYANDAS on 17th May 2017 for ERP-2130
*      lst_final-name1 = lst_adrinfo-name1.
      READ TABLE li_title_desc INTO lst_title_desc WITH KEY title = lst_adrinfo-title.
      IF sy-subrc EQ 0.
        CONCATENATE lst_title_desc-title_medi lst_adrinfo-name1 lst_adrinfo-name2
               INTO lst_final-name1 SEPARATED BY space.
      ELSE.
        CONCATENATE lst_adrinfo-name1 lst_adrinfo-name2 INTO lst_final-name1
                   SEPARATED BY space.
      ENDIF.

***EOC BY SAYANDAS on 17th May 2017 for ERP-2130
      lst_final-street = lst_adrinfo-street.
      lst_final-city1 =  lst_adrinfo-city1.
      lst_final-landx50 = lst_adrinfo-landx50.
      IF lst_adrinfo-region IS INITIAL.
        lst_final-reg_post_code = lst_adrinfo-post_code1.
      ELSEIF lst_adrinfo-post_code1 IS INITIAL.
        lst_final-reg_post_code = lst_adrinfo-region.
      ELSE. " ELSE -> IF lst_adrinfo-region IS INITIAL
        CONCATENATE lst_adrinfo-region lst_adrinfo-post_code1 INTO
                    lst_final-reg_post_code.
      ENDIF. " IF lst_adrinfo-region IS INITIAL
      CONDENSE lst_final-reg_post_code.

    ELSE. " ELSE -> IF sy-subrc EQ 0
      CLEAR lst_adrinfo.
      READ TABLE li_adrinfo INTO lst_adrinfo WITH KEY vbeln = lst_matinfo-vbeln
                                                      parvw = lc_we.
      IF sy-subrc EQ 0.
        CLEAR lst_adr6.
        READ TABLE li_adr6 INTO lst_adr6 WITH KEY adrnr = lst_adrinfo-adrnr.
        IF sy-subrc EQ 0.
          lst_final-smtp_addr = lst_adr6-smtp_addr.
        ENDIF. " IF sy-subrc EQ 0
***BOC BY SAYANDAS on 17th May 2017 for ERP-2130
*        lst_final-name1 = lst_adrinfo-name1.
      READ TABLE li_title_desc INTO lst_title_desc WITH KEY title = lst_adrinfo-title.
      IF sy-subrc EQ 0.
        CONCATENATE lst_title_desc-title_medi lst_adrinfo-name1 lst_adrinfo-name2
               INTO lst_final-name1 SEPARATED BY space.
      ELSE.
        CONCATENATE lst_adrinfo-name1 lst_adrinfo-name2 INTO lst_final-name1
                   SEPARATED BY space.
      ENDIF.
***EOC BY SAYANDAS on 17th May 2017 for ERP-2130
        lst_final-street = lst_adrinfo-street.
        lst_final-city1 =  lst_adrinfo-city1.
        lst_final-landx50 = lst_adrinfo-landx50.
        IF lst_adrinfo-region IS INITIAL.
          lst_final-reg_post_code = lst_adrinfo-post_code1.
        ELSEIF lst_adrinfo-post_code1 IS INITIAL.
          lst_final-reg_post_code = lst_adrinfo-region.
        ELSE. " ELSE -> IF lst_adrinfo-region IS INITIAL
          CONCATENATE lst_adrinfo-region lst_adrinfo-post_code1 INTO
                      lst_final-reg_post_code.
        ENDIF. " IF lst_adrinfo-region IS INITIAL
        CONDENSE lst_final-reg_post_code.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0

    READ TABLE li_adrinfo INTO lst_adrinfo1 WITH KEY vbeln = lst_matinfo-vbeln
                                                     posnr = lst_matinfo-posnr
                                                     parvw = lc_ag.

    IF sy-subrc EQ 0.
      IF lst_adrinfo1-kunnr NE lst_adrinfo-kunnr. " if partner is different then only store
        " these informations
        lst_final-name3 = lst_adrinfo1-name1.
        lst_final-name2 = lst_adrinfo1-name2.
      ENDIF. " IF lst_adrinfo1-kunnr NE lst_adrinfo-kunnr
    ELSE. " ELSE -> IF sy-subrc EQ 0
      READ TABLE li_adrinfo INTO lst_adrinfo1 WITH KEY vbeln = lst_matinfo-vbeln
                                                     parvw = lc_ag.

      IF lst_adrinfo1-kunnr NE lst_adrinfo-kunnr. " if partner is different then only store
        " these informations
        lst_final-name3 = lst_adrinfo1-name1.
        lst_final-name2 = lst_adrinfo1-name2.
      ENDIF. " IF lst_adrinfo1-kunnr NE lst_adrinfo-kunnr
    ENDIF. " IF sy-subrc EQ 0

*** Reading LI_MATINFO internal table to fecth material related information
*      lst_final-identcode = lst_matinfo-identcode. Commented by MODUTTA on 02/02/2016 for CR334
    lst_final-identcode = lst_matinfo-identcode+0(4). "Added by MODUTTA on 02/02/2016 for CR334
    SHIFT lst_final-identcode LEFT DELETING LEADING c_lead_zero.
    lst_final-vbeln    = lst_matinfo-vbeln.
    lst_final-audat    = lst_matinfo-audat.
*  if auart is zsub/zcop/zgrc/ztrl then store Y otherwise R
    IF lst_matinfo-auart = lc_sub OR lst_matinfo-auart = lc_cop
    OR lst_matinfo-auart = lc_grc OR lst_matinfo-auart = lc_trl.
      lst_final-auart = lc_y.
    ELSEIF lst_matinfo-auart = lc_rew.
      lst_final-auart = lc_r.
    ENDIF. " IF lst_matinfo-auart = lc_sub OR lst_matinfo-auart = lc_cop

*  if subtype is blank then store R otherwise C
    IF  lst_matinfo-zzsubtyp IS INITIAL.
      lst_final-zzsubtyp = lc_subr.
    ELSE. " ELSE -> IF lst_matinfo-zzsubtyp IS INITIAL
      lst_final-zzsubtyp = lc_subc.
    ENDIF. " IF lst_matinfo-zzsubtyp IS INITIAL
    APPEND lst_final TO i_final. " appending in final internal table.

    CLEAR: lst_adrinfo,lst_matinfo,lst_final, lst_adr6.
  ENDLOOP. " LOOP AT li_matinfo INTO DATA(lst_matinfo)

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREPARE_CSV
*&---------------------------------------------------------------------*
*   This perform is used to convert internal table to .CSV file
*----------------------------------------------------------------------*

FORM f_prepare_csv .
*** Local Constant Declaration
  CONSTANTS: lc_tab    TYPE c VALUE cl_abap_char_utilities=>horizontal_tab, " Tab of type Character
             lc_semico TYPE char1 VALUE ';'.                                " Semico of type CHAR1
**** Local field symbol declaration
  FIELD-SYMBOLS: <lfs_final_csv> TYPE LINE OF truxs_t_text_data.
*** Local structure and internal table declaration
  DATA: lst_final_csv TYPE LINE OF truxs_t_text_data,
        li_final_csv  TYPE truxs_t_text_data.

* Calling FM to Convert the file to CSV format
  CALL FUNCTION 'SAP_CONVERT_TO_CSV_FORMAT'
    EXPORTING
      i_field_seperator    = lc_semico
    TABLES
      i_tab_sap_data       = i_final
    CHANGING
      i_tab_converted_data = li_final_csv[] " CSV file
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ENDIF. " IF sy-subrc <> 0
  LOOP AT li_final_csv ASSIGNING <lfs_final_csv>.
    REPLACE ALL OCCURRENCES OF lc_semico IN <lfs_final_csv> WITH lc_tab.
  ENDLOOP. " LOOP AT li_final_csv ASSIGNING <lfs_final_csv>

* Header Data
  CONCATENATE text-001 text-002 text-003 text-004 text-005 text-006 text-007
              text-008 text-009 text-010 text-011 text-012 text-013
              INTO lst_final_csv SEPARATED BY lc_tab.

  INSERT lst_final_csv INTO  li_final_csv INDEX 1. " Inserting Header

  IF li_final_csv[] IS NOT INITIAL.
    i_final_csv[] = li_final_csv[].
  ENDIF. " IF li_final_csv[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILE_UPLOAD
*&---------------------------------------------------------------------*
* This perform is used to store .CSV file into application server file path
*----------------------------------------------------------------------*

FORM f_file_upload .
  DATA: lv_fname      TYPE aco_string, " String
*        lv_path       TYPE sxpgcolist-parameters, " Path of type CHAR100.
        lv_file       TYPE char50, " File of type CHAR50
        lv_length     TYPE i,      " Length of type Integers
        lv_fnm        TYPE char50, " Fnm of type CHAR50
        lst_final_csv TYPE LINE OF truxs_t_text_data.

  CONSTANTS: lc_slash     TYPE char1 VALUE '/',    " Slash of type CHAR1
             lc_extension TYPE char4 VALUE '.csv'. " Extension of type CHAR4

  CONCATENATE text-019 sy-datum sy-uzeit INTO lv_file.

*** checking if last character of file path is / or not
*** if not then then appending one /.
  lv_fnm = p_file.
  lv_length = strlen( lv_fnm ).
  lv_length = lv_length - 1.
  IF lv_fnm+lv_length(1) NE lc_slash.
    CONCATENATE lv_fnm lc_slash INTO lv_fnm.
  ENDIF. " IF lv_fnm+lv_length(1) NE lc_slash
*** Preparing file name
  CONCATENATE lv_fnm lv_file lc_extension INTO lv_fname.

  OPEN DATASET lv_fname FOR OUTPUT IN TEXT  MODE ENCODING UTF-8. " Output type
  " opening file
  IF sy-subrc NE 0. " if file not opened showing error message
    MESSAGE e045(zqtc_r2). " File cannot be opened.
    RETURN.
  ENDIF. " IF sy-subrc NE 0

  LOOP AT i_final_csv  INTO lst_final_csv.
    TRANSFER lst_final_csv TO lv_fname. " transfering data
  ENDLOOP. " LOOP AT i_final_csv INTO lst_final_csv

  CLOSE DATASET  lv_fname. " closing file

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAIL_SEND
*&---------------------------------------------------------------------*
*   This perform is used to send mail
*----------------------------------------------------------------------*

FORM f_mail_send.

***Local  types declaration
  TYPES: BEGIN OF lty_email,
           email TYPE ad_smtpadr, " E-Mail Address
         END OF lty_email.

*** Local Internal Table and Structure  declaration
  DATA: lit_email TYPE STANDARD TABLE OF lty_email,
        lst_email TYPE lty_email.

* Prepare mail object
  DATA : lo_send_request TYPE REF TO cl_bcs VALUE IS INITIAL. " Business Communication Service
  CLASS cl_bcs DEFINITION LOAD. " Business Communication Service
  DATA : lo_document TYPE REF TO cl_document_bcs VALUE IS INITIAL. " Wrapper Class for Office Documents
  " Document object
  DATA : li_text  TYPE bcsy_text,       " table for body
         lst_text LIKE LINE OF li_text. " work area for message body

  DATA : lo_sender TYPE REF TO if_sender_bcs VALUE IS INITIAL. " sender
  " recipient
  DATA : lo_recipient TYPE REF TO if_recipient_bcs VALUE IS INITIAL. " Interface of Recipient Object in BCS
  DATA : lv_subject TYPE char50. " Subject of type CHAR50

  DATA : lv_send(1) VALUE 'X'.
  DATA : lv_email TYPE ad_smtpadr, " E-Mail Address
         lv_temp  TYPE sy-datum,   " ABAP System Field: Current Date of Application Server
         lv_dt    TYPE char10.     " Dt of type CHAR10

  CONSTANTS : lc_txt TYPE so_obj_tp VALUE 'TXT', " Code for document class
              lc_x   TYPE char1 VALUE 'X'.       " X of type CHAR1



  TRY.
      lo_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
  ENDTRY.

  CONCATENATE text-015 sy-datum INTO lst_text-line SEPARATED BY space.
  APPEND lst_text TO li_text. " Preparing Body
  CLEAR lst_text.

  lv_temp = sy-datum.
  CONCATENATE  lv_temp+4(2) lv_temp+6(2) lv_temp+0(4) INTO lv_dt.

  CONCATENATE text-016 lv_dt
  INTO lv_subject SEPARATED BY space. " Preparing subject line
  TRY.
      lo_document = cl_document_bcs=>create_document( i_type = lc_txt
                                                      i_text = li_text
                                                      i_subject = lv_subject ).
    CATCH cx_document_bcs.
  ENDTRY.

* pass the document to send request
  TRY.
      lo_send_request->set_document( lo_document ).

    CATCH cx_send_req_bcs.

  ENDTRY.
  TRY.
      lo_sender = cl_sapuser_bcs=>create( sy-uname ).

    CATCH cx_address_bcs.

  ENDTRY.

  TRY.
      lo_send_request->set_sender( EXPORTING
                                     i_sender = lo_sender ).

    CATCH cx_send_req_bcs.

  ENDTRY.
** Set recipient

  lst_email-email = text-017.
  APPEND lst_email TO lit_email.
  CLEAR lst_email.

  lst_email-email = text-018.
  APPEND lst_email TO lit_email.
  CLEAR lst_email.

  LOOP AT lit_email INTO lst_email.
    lv_email = lst_email-email.

    TRY.
        lo_recipient = cl_cam_address_bcs=>create_internet_address( lv_email ).

      CATCH cx_address_bcs.

    ENDTRY.
    TRY .
        lo_send_request->add_recipient( EXPORTING
                                         i_recipient = lo_recipient
                                         i_express   = lc_x ).
      CATCH cx_send_req_bcs.

    ENDTRY.
    CLEAR: lv_email, lst_email.
  ENDLOOP. " LOOP AT lit_email INTO lst_email
  TRY .
      CALL METHOD lo_send_request->set_send_immediately
        EXPORTING
          i_send_immediately = lv_send.
    CATCH cx_send_req_bcs.
  ENDTRY.
  TRY .
      lo_send_request->send( EXPORTING
                               i_with_error_screen = lc_x ).
      COMMIT WORK. " COMMIT WORK is required
      MESSAGE s046(zqtc_r2). " Showing Message
    CATCH cx_send_req_bcs.
  ENDTRY.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SERVERFILE_F4
*&---------------------------------------------------------------------*
*       Search help for application server file path
*----------------------------------------------------------------------*
FORM f_serverfile_f4.
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    IMPORTING
      serverfile       = p_file
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc NE 0.
    MESSAGE e002(zqtc_r2). " File does not exist
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
