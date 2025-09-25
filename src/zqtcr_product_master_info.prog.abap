*&---------------------------------------------------------------------*
*& Report  ZQTC_JOURNAL_DISPATCH_INFO
*&---------------------------------------------------------------------*
* REVISION NO   : ED2K927560,ED2K927573
* REFERENCE NO  : OTCM-59493
* DEVELOPER     : Vamsi Mamillapalli (VMAMILLAPA)
* DATE          : 06/09/2022
* DESCRIPTION   : Export Product Master Information to Application server
*                 in excel format
*&---------------------------------------------------------------------*
REPORT zqtcr_product_master_info.
DATA:v_ersda            TYPE mara-ersda,
     v_matnr            TYPE mara-matnr,
     v_ernam            TYPE mara-ernam,
     v_mtart            TYPE mara-mtart,
     v_extwg            TYPE mara-extwg,
     v_mstae            TYPE mara-mstae,
     v_ismrefmdprod     TYPE mara-ismrefmdprod,
     v_ismpubldate      TYPE mara-ismpubldate,
     v_ismcopynr        TYPE mara-ismcopynr,
     v_isminitshipdate  TYPE mara-isminitshipdate,
     v_vkorg            TYPE mvke-vkorg,
     v_werks            TYPE marc-werks,
     v_ismarrivaldateac TYPE marc-ismarrivaldateac,
     v_spras            TYPE makt-spras.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS : p_file TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_ersda FOR v_ersda,
                s_matnr FOR v_matnr,
                s_ernam FOR v_ernam,
                s_mtart FOR v_mtart,
                s_extwg FOR v_extwg,
                s_mstae FOR v_mstae,
                s_ismre FOR v_ismrefmdprod,
                s_ismp  FOR v_ismpubldate,
                s_ismcop FOR v_ismcopynr,
                s_ismin  FOR v_isminitshipdate,
                s_vkorg  FOR v_vkorg,
                s_werks  FOR v_werks,
                s_ismarr FOR v_ismarrivaldateac,
                s_spras  FOR v_spras DEFAULT sy-langu.
PARAMETERS      cb_alv AS CHECKBOX.
PARAMETERS: p_layout TYPE slis_vari.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.
  PERFORM f_select_layout.

FORM f_select_layout.
  DATA: ls_layout_key  TYPE salv_s_layout_key,
        ls_layout_info TYPE salv_s_layout_info.
  ls_layout_key-report = sy-repid.
  ls_layout_info = cl_salv_layout_service=>f4_layouts( ls_layout_key ).
  p_layout = ls_layout_info-layout.
ENDFORM.

TYPES:BEGIN OF ty_mara,
        bstmi TYPE char20,
        losgr TYPE char20,
      END OF ty_mara.

START-OF-SELECTION.
  SELECT mara~matnr,
         ersda,
         ernam,
         mtart,
         mbrsh,
         matkl,
         bismt,
         spart,
         extwg,
         mstae,
         mstav,
         mstdv,
         ismhierarchlevl,
         ismtitlelevel,
         ismtitle,
         ismsubtitle1,
         ismsubtitle2,
         ismsubtitle3,
         ismrefmdprod,
         ismpubltype,
         ismmediatype,
         ismconttype,
         ismpubldate,
         ismnrinyear,
         ismcopynr,
         ismyearnr,
         ismissuetypest,
         mara~isminitshipdate,
         vkorg,
         vtweg,
         bonus,
         mtpos,
         dwerk,
         kondm,
         ktgrm,
         mvgr1,
         mvgr2,
         mvgr3,
         mvgr4,
         mvgr5,
         prat1,
         maktx,
         werks,
         ekgrp,
         dismm,
         dispo,
         perkz,
         disls,
         beskz,
         sobsl,
         bstmi,
         ladgr,
         prctr,
         losgr,
         disgr,
         ismarrivaldateac
  FROM
  mara JOIN makt
  ON mara~matnr = makt~matnr
    JOIN mvke
  ON mara~matnr = mvke~matnr
    JOIN marc
  ON mara~matnr = marc~matnr
  INTO TABLE @DATA(i_matrl)
  WHERE mara~matnr IN @s_matnr AND
       ersda IN  @s_ersda AND
        ernam IN @s_ernam AND
        mtart IN @s_mtart AND
        extwg IN @s_extwg AND
        mstae IN @s_mstae AND
        ismrefmdprod IN @s_ismre AND
        ismpubldate IN @s_ismp AND
        ismcopynr IN @s_ismcop AND
        mara~isminitshipdate IN @s_ismp AND
        vkorg IN @s_vkorg AND
        werks IN @s_werks AND
        ismarrivaldateac IN  @s_ismarr AND
  spras IN @s_spras.
*Eismarrivaldateac,NDSELECT.
  IF sy-subrc IS INITIAL.
    DATA: v_message TYPE char30.

    IF cb_alv IS INITIAL.
*  FIELD-SYMBOLS <hex_container> TYPE x.
*  OPEN DATASET p_file FOR OUTPUT IN BINARY MODE.
*      OPEN DATASET p_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT MESSAGE v_message.
*      IF sy-subrc NE 0.
*        MESSAGE v_message TYPE 'E'.
*        EXIT.
*
*      ELSE.
*        LOOP AT i_matrl INTO DATA(lst_matrl).
*
**      ASSIGN lst_matrl-mara TO <hex_container> CASTING.
**      TRANSFER <hex_container> TO p_file NO END OF LINE.
**      UNASSIGN <hex_container>.
**
**      ASSIGN lst_matrl-makt TO <hex_container> CASTING.
**      TRANSFER <hex_container> TO p_file." NO END OF LINE.
**      UNASSIGN <hex_container>.
**      TRANSFER lst_matrl-mara TO p_file.
*          DATA:lv_string TYPE string,
*               lv_output TYPE string,
*               lst_mara  TYPE ty_mara.
*          MOVE-CORRESPONDING lst_matrl TO lst_mara.
*          CONCATENATE lst_matrl-matnr
*                      lst_matrl-ersda
*                      lst_matrl-ernam
*                      lst_matrl-mtart
*                      lst_matrl-mbrsh
*                      lst_matrl-matkl
*                      lst_matrl-bismt
*                      lst_matrl-spart
*                      lst_matrl-extwg
*                      lst_matrl-mstae
*                      lst_matrl-mstav
*                      lst_matrl-mstdv
*                      lst_matrl-ismhierarchlevl
*                      lst_matrl-ismtitlelevel
*                      lst_matrl-ismtitle
*                      lst_matrl-ismsubtitle1
*                      lst_matrl-ismsubtitle2
*                      lst_matrl-ismsubtitle3
*                      lst_matrl-ismrefmdprod
*                      lst_matrl-ismpubltype
*                      lst_matrl-ismmediatype
*                      lst_matrl-ismconttype
*                      lst_matrl-ismpubldate
*                      lst_matrl-ismnrinyear
*                      lst_matrl-ismcopynr
*                      lst_matrl-ismyearnr
*                      lst_matrl-ismissuetypest
*                      lst_matrl-isminitshipdate
*
*                      lst_matrl-vkorg
*                      lst_matrl-vtweg
*                      lst_matrl-bonus
*                      lst_matrl-mtpos
*                      lst_matrl-dwerk
*                      lst_matrl-kondm
*                      lst_matrl-ktgrm
*                      lst_matrl-mvgr1
*                      lst_matrl-mvgr2
*                      lst_matrl-mvgr3
*                      lst_matrl-mvgr4
*                      lst_matrl-mvgr5
*                      lst_matrl-prat1
*
*                      lst_matrl-maktx
*
*                      lst_matrl-werks
*                      lst_matrl-ekgrp
*                      lst_matrl-dismm
*                      lst_matrl-dispo
*                      lst_matrl-perkz
*                      lst_matrl-disls
*                      lst_matrl-beskz
*                      lst_matrl-sobsl
*                      lst_mara-bstmi
*                      lst_matrl-ladgr
*                      lst_matrl-prctr
*                      lst_mara-losgr
*                      lst_matrl-disgr
*                      lst_matrl-ismarrivaldateac
*          INTO lv_output SEPARATED BY ','.
*          TRANSFER lv_output TO p_file." NO END OF LINE.
*        ENDLOOP.
      PERFORM f_upload_exl.
*      ENDIF.
*      CLOSE DATASET p_file.

      IF sy-subrc NE 0.
        MESSAGE 'Error closing the File' TYPE 'E'.
        EXIT.

      ELSEIF sy-subrc IS INITIAL.
        WRITE : 'File saved in the location' , p_file.
      ENDIF.
    ELSE.
* Display ALV.
      DATA: r_salv TYPE REF TO cl_salv_table.
      cl_salv_table=>factory( IMPORTING r_salv_table = r_salv CHANGING t_table = i_matrl ).


*   get layout object
      DATA(lo_layout) = r_salv->get_layout( ).
      DATA:ls_key TYPE salv_s_layout_key.
      ls_key-report = sy-repid.
      lo_layout->set_key( ls_key ).
      lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
*   set initial Layout


      lo_layout->set_initial_layout( p_layout ).

      DATA(r_functions) = r_salv->get_functions( ).

      r_functions->set_all( abap_true ).


      DATA(lo_columns) = r_salv->get_columns( ).

      lo_columns->set_optimize( ).
      PERFORM f_change_column_name.

      r_salv->display( ).



    ENDIF.
  ENDIF.
FORM f_change_column_name.
  " cambia el nombre a una columna...
  DATA not_found TYPE REF TO cx_salv_not_found.
  TRY.
      DATA(lo_column) = lo_columns->get_column( 'ISMCOPYNR' ).
      lo_column->set_short_text( 'Volume' ).
      lo_column->set_medium_text( 'Volume' ).
      lo_column->set_long_text( 'Volume' ).

      lo_column = lo_columns->get_column( 'ISMINITSHIPDATE' ).
      lo_column->set_short_text( 'RevPubDate' ).
      lo_column->set_medium_text( 'Rev Pub Date' ).
      lo_column->set_long_text( 'Revised Publication date' ).

    CATCH cx_salv_not_found INTO not_found.
      " error handling
  ENDTRY.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_EXL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_upload_exl .
*
  DATA:
*  lv_infilename    TYPE localfile,
*        li_exceldata     TYPE TABLE OF alsmex_tabline,
*        lv_row           TYPE string,
*        lv_dir_file      TYPE string,
    lv_date          TYPE string,
*        lv_month(2)      TYPE c,
*        lv_day(2)        TYPE c,
*        lv_year(4)       TYPE c,
    lv_max_line_c(6) TYPE c,
    lv_dir_file      TYPE string,
    lv_row           TYPE string.
*        lt_records       TYPE solix_tab,
*        lv_headerxstring TYPE xstring,
*        lv_filelength    TYPE i.
  DATA : BEGIN OF itab1 OCCURS 0,
           values(1000) TYPE c,
         END OF itab1.
*  FIELD-SYMBOLS : <gt_data> TYPE STANDARD TABLE .
**  BREAK-POINT.
*  lv_infilename = p_infile.

*  DATA(lv_lines) = lines( li_exceldata ).
*  DATA(lv_max_line) = li_exceldata[ lv_lines ]-row + 1.
  DATA(lv_max_line) = lines( i_matrl ) + 1.
  lv_max_line_c = lv_max_line.
  SHIFT lv_max_line_c LEFT DELETING LEADING space.

  APPEND '<?xml version="1.0"?>' TO itab1.
  APPEND '<?mso-application progid="Excel.Sheet"?>' TO itab1.
  APPEND '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' TO itab1.
  APPEND 'xmlns:o="urn:schemas-microsoft-com:office:office"' TO itab1.
  APPEND 'xmlns:x="urn:schemas-microsoft-com:office:excel"' TO itab1.
  APPEND 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' TO itab1.
  APPEND 'xmlns:html="http://www.w3.org/TR/REC-html40">' TO itab1.
  APPEND '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' TO itab1.
  APPEND '<Author>SAP WebAS</Author>' TO itab1.
*  <LastAuthor>Dimantha, Thilina</LastAuthor>
*  <Revision>1</Revision>
*  <Created>2022-02-15T16:22:49Z</Created>
*  <LastSaved>2022-06-02T07:03:37Z</LastSaved>
*  <Version>16.00</Version>
  APPEND '</DocumentProperties>' TO itab1.
  APPEND '<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">' TO itab1.
  APPEND '<AllowPNG/>' TO itab1.
  APPEND '</OfficeDocumentSettings>' TO itab1.
  APPEND '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' TO itab1.
  APPEND '<WindowHeight>7880</WindowHeight>' TO itab1.
  APPEND '<WindowWidth>15380</WindowWidth>' TO itab1.
  APPEND '<WindowTopX>32767</WindowTopX>' TO itab1.
  APPEND '<WindowTopY>32767</WindowTopY>' TO itab1.
  APPEND '<ActiveSheet>1</ActiveSheet>' TO itab1.
  APPEND '<ProtectStructure>False</ProtectStructure>' TO itab1.
  APPEND '<ProtectWindows>False</ProtectWindows>' TO itab1.
  APPEND '</ExcelWorkbook>' TO itab1.
  APPEND '<Styles>' TO itab1.
  APPEND '<Style ss:ID="Default" ss:Name="Normal">' TO itab1.
  APPEND '<Alignment ss:Vertical="Bottom"/>' TO itab1.
  APPEND '<Borders/>' TO itab1.
  APPEND '<Font ss:FontName="Arial"/>' TO itab1.
  APPEND '<Interior/>' TO itab1.
  APPEND '<NumberFormat/>' TO itab1.
  APPEND '<Protection/>' TO itab1.
  APPEND '</Style>' TO itab1.
  APPEND '<Style ss:ID="s15">' TO itab1.
  APPEND '<Alignment ss:Vertical="Top"/>' TO itab1.
  APPEND '</Style>' TO itab1.
  APPEND '<Style ss:ID="s16">' TO itab1.
  APPEND '<Alignment ss:Vertical="Top"/>' TO itab1.
  APPEND '<Borders>' TO itab1.
  APPEND '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' TO itab1.
  APPEND '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' TO itab1.
  APPEND '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' TO itab1.
  APPEND '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' TO itab1.
  APPEND '</Borders>' TO itab1.
  APPEND '<Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>' TO itab1.
  APPEND '</Style>' TO itab1.
  APPEND '<Style ss:ID="s17">' TO itab1.
  APPEND '<Alignment ss:Horizontal="Right" ss:Vertical="Top"/>' TO itab1.
  APPEND '<NumberFormat ss:Format="Short Date"/>' TO itab1.
  APPEND '</Style>' TO itab1.
  APPEND '<Style ss:ID="s18">' TO itab1.
  APPEND '<Alignment ss:Vertical="Top"/>' TO itab1.
  APPEND '<Font ss:FontName="Arial" x:Family="Swiss" ss:Size="18" ss:Bold="1"/>' TO itab1.
  APPEND '</Style>' TO itab1.
  APPEND '<Style ss:ID="s10">' TO itab1.
  APPEND '<Alignment ss:Vertical="Center"/>' TO itab1.
  APPEND '<Font ss:FontName="Arial" x:Family="Swiss" ss:Size="10" ss:Bold="0"/>' TO itab1.
  APPEND '</Style>' TO itab1.
  APPEND '<Style ss:ID="s63">' TO itab1.
  APPEND '<Alignment ss:Vertical="Top"/>' TO itab1.
  APPEND '</Style>' TO itab1.
  APPEND '<Style ss:ID="s64">' TO itab1.
  APPEND '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' TO itab1.
  APPEND '</Style>' TO itab1.
  APPEND '<Style ss:ID="s70">' TO itab1.
  APPEND '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' TO itab1.
  APPEND 'ss:Bold="1"/>' TO itab1.
  APPEND '</Style>' TO itab1.
  APPEND '</Styles>' TO itab1.
  APPEND '<Worksheet ss:Name="How to use this resource">' TO itab1.
*  APPEND '<Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="19" x:FullColumns="1"' TO itab1.
*  APPEND 'x:FullRows="1" ss:StyleID="s15" ss:DefaultRowHeight="12.5">' TO itab1.
*  APPEND '<Row ss:Height="23">' TO itab1.
*  APPEND '<Cell ss:StyleID="s18"><Data ss:Type="String">How to use the Wiley Journals Print Dispatch Report</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> Use this self-service report to check on the status of forthcoming journal print issues. Note that </Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> this information covers first print runs of new journal issues. It does not include print on </Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> demand (POD) for online-only journals titles.</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"></Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> To use the tool, go to the tab labeled Dispatch Report. Filter based on the publication name</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> ("Material Description"), volume ("Volume"), and issue number ("Issue No.").</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"></Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> The column named "AtGArrDt" shows Actual Goods Arrival Date, which indicates whether the</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> issue has been received by our distribution team. If this column is blank it means the issue has</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> not yet been dispatched. In this case, it would be too early to file a claim for the print issue.</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"></Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> If there is a date in "AtGArrDt," the issue has been printed and is being shipped. Please allow</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> approximately 3-6 weeks for delivery.</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"></Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> If you have any questions or concerns about this document, please contact agency-</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> agency-partnerships@wiley.com.</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"></Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '<Row ss:Height="12">' TO itab1.
*  APPEND '<Cell ss:StyleID="s10"><Data ss:Type="String"> This file updates monthly. The report was last updated 26 April 2022.</Data></Cell>' TO itab1.
*  APPEND '</Row>' TO itab1.
*  APPEND '</Table>' TO itab1.
  APPEND '<Table ss:ExpandedColumnCount="10" ss:ExpandedRowCount="20" x:FullColumns="1"' TO itab1.
  APPEND 'x:FullRows="1" ss:DefaultRowHeight="14.5">' TO itab1.
  APPEND '<Row ss:Height="23">' TO itab1.
  APPEND '<Cell ss:StyleID="s18"><Data ss:Type="String">How to use the Wiley Journals Print Dispatch Report</Data></Cell>' TO itab1.
  APPEND '<Cell ss:StyleID="s63"/>' TO itab1.
  APPEND '<Cell ss:StyleID="s63"/>' TO itab1.
  APPEND '<Cell ss:StyleID="s63"/>' TO itab1.
  APPEND '<Cell ss:StyleID="s63"/>' TO itab1.
  APPEND '<Cell ss:StyleID="s63"/>' TO itab1.
  APPEND '<Cell ss:StyleID="s63"/>' TO itab1.
  APPEND '<Cell ss:StyleID="s63"/>' TO itab1.
  APPEND '<Cell ss:StyleID="s63"/>' TO itab1.
  APPEND '<Cell ss:StyleID="s63"/>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s64"/>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><Data ss:Type="String">Use this self-service report to check on the status of forthcoming journal print issues. Note that </Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><Data ss:Type="String">this information covers first print runs of new journal issues. It does not include print on </Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><Data ss:Type="String">demand (POD) for online-only journals titles.</Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s64"/>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><ss:Data ss:Type="String"' TO itab1.
  APPEND 'xmlns="http://www.w3.org/TR/REC-html40"><Font html:Color="#000000">To use the tool, go to the tab labeled </Font><B><Font' TO itab1.
  APPEND 'html:Color="#000000">Dispatch Report</Font></B><Font html:Color="#000000">. Filter based on the publication name </Font></ss:Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><ss:Data ss:Type="String"' TO itab1.
  APPEND 'xmlns="http://www.w3.org/TR/REC-html40"><Font html:Color="#000000">(&quot;</Font><B><Font' TO itab1.
  APPEND 'html:Color="#000000">Material Description</Font></B><Font' TO itab1.
  APPEND 'html:Color="#000000">&quot;), volume (&quot;</Font><B><Font' TO itab1.
  APPEND 'html:Color="#000000">Volume</Font></B><Font html:Color="#000000">&quot;), and issue number (&quot;</Font><B><Font' TO itab1.
  APPEND 'html:Color="#000000">Issue No.</Font></B><Font html:Color="#000000">&quot;).</Font></ss:Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row ss:Index="10">' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><ss:Data ss:Type="String"' TO itab1.
  APPEND 'xmlns="http://www.w3.org/TR/REC-html40"><Font html:Color="#000000">The column named &quot;</Font><B><Font' TO itab1.
  APPEND 'html:Color="#000000">AtGArrDt</Font></B><Font html:Color="#000000">&quot; shows Actual Goods Arrival Date, which indicates whether the </Font></ss:Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><Data ss:Type="String">issue has been received by our distribution team. If this column is blank it means the issue has </Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><Data ss:Type="String">not yet been dispatched. In this case, it would be too early to file a claim for the print issue.</Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row ss:Index="14">' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><ss:Data ss:Type="String"' TO itab1.
  APPEND 'xmlns="http://www.w3.org/TR/REC-html40"><Font html:Color="#000000">If there is a date in &quot;</Font><B><Font' TO itab1.
  APPEND 'html:Color="#000000">AtGArrDt</Font></B><Font html:Color="#000000">,&quot; the issue has been printed and is being shipped. Please allow </Font></ss:Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><Data ss:Type="String">approximately 3-6 weeks for delivery.</Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row ss:Index="17">' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><ss:Data ss:Type="String"' TO itab1.
  APPEND 'xmlns="http://www.w3.org/TR/REC-html40"><Font html:Color="#000000">If you have any questions or concerns about this document, please contact </Font><B><Font' TO itab1.
  APPEND 'html:Color="#000000">agency-</Font></B></ss:Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s70"><Data ss:Type="String">partnerships@wiley.com.</Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '<Row ss:Index="20">' TO itab1.
  APPEND '<Cell ss:StyleID="s64"><ss:Data ss:Type="String"' TO itab1.
  APPEND 'xmlns="http://www.w3.org/TR/REC-html40"><Font html:Color="#000000">This file updates monthly. The report was last updated </Font><B><Font' TO itab1.
  APPEND 'html:Color="#000000">26 April 2022.</Font></B></ss:Data></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.
  APPEND '</Table>' TO itab1.

  APPEND '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' TO itab1.
  APPEND '<PageSetup>' TO itab1.
  APPEND '<Header x:Margin="0.3"/>' TO itab1.
  APPEND '<Footer x:Margin="0.3"/>' TO itab1.
  APPEND '<PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>' TO itab1.
  APPEND '</PageSetup>' TO itab1.
  APPEND '<Print>' TO itab1.
  APPEND '<ValidPrinterInfo/>' TO itab1.
  APPEND '<HorizontalResolution>1200</HorizontalResolution>' TO itab1.
  APPEND '<VerticalResolution>1200</VerticalResolution>' TO itab1.
  APPEND '</Print>' TO itab1.
  APPEND '<Panes>' TO itab1.
  APPEND '<Pane>' TO itab1.
  APPEND '<Number>3</Number>' TO itab1.
  APPEND '<ActiveCol>9</ActiveCol>' TO itab1.
  APPEND '</Pane>' TO itab1.
  APPEND '</Panes>' TO itab1.
  APPEND '<ProtectObjects>False</ProtectObjects>' TO itab1.
  APPEND '<ProtectScenarios>False</ProtectScenarios>' TO itab1.
  APPEND '</WorksheetOptions>' TO itab1.
  APPEND '</Worksheet>' TO itab1.
  APPEND '<Worksheet ss:Name="Dispatch Report">' TO itab1.
  APPEND '<Names>' TO itab1.
  APPEND '<NamedRange ss:Name="_FilterDatabase"' TO itab1.
  APPEND 'ss:RefersTo="=' TO itab1.
  APPEND 'Dispatch Report' TO itab1.
  CLEAR: lv_row.
  CONCATENATE '!R1C1:R' lv_max_line_c 'C9" ss:Hidden="1"/>' INTO lv_row.
  APPEND lv_row TO itab1.
  APPEND '</Names>' TO itab1.
  CLEAR: lv_row.
  CONCATENATE '<Table ss:ExpandedColumnCount="9" ss:ExpandedRowCount="' lv_max_line_c '" x:FullColumns="1"' INTO lv_row.
  APPEND lv_row TO itab1.
  APPEND 'x:FullRows="1" ss:StyleID="s15" ss:DefaultRowHeight="12.5">' TO itab1.
  APPEND '<Column ss:StyleID="s15" ss:Width="99"/>' TO itab1.
  APPEND '<Column ss:StyleID="s15" ss:Width="231"/>' TO itab1.
  APPEND '<Column ss:StyleID="s15" ss:Width="38.5"/>' TO itab1.
  APPEND '<Column ss:StyleID="s15" ss:Width="71.5"/>' TO itab1.
  APPEND '<Column ss:StyleID="s15" ss:Width="60.5"/>' TO itab1.
  APPEND '<Column ss:StyleID="s15" ss:Width="44" ss:Span="1"/>' TO itab1.
  APPEND '<Column ss:Index="8" ss:StyleID="s15" ss:Width="71.5"/>' TO itab1.
  APPEND '<Column ss:StyleID="s15" ss:Width="77"/>' TO itab1.
  APPEND '<Row>' TO itab1.
  APPEND '<Cell ss:StyleID="s16"><Data ss:Type="String">MATNR Number</Data><NamedCell' TO itab1.
  APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
  APPEND '<Cell ss:StyleID="s16"><Data ss:Type="String">Material Description</Data><NamedCell' TO itab1.
  APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
  APPEND '<Cell ss:StyleID="s16"><Data ss:Type="String">Plant</Data><NamedCell' TO itab1.
  APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
  APPEND '<Cell ss:StyleID="s16"><Data ss:Type="String">PublDate</Data><NamedCell' TO itab1.
  APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
  APPEND '<Cell ss:StyleID="s16"><Data ss:Type="String">Issue No.</Data><NamedCell' TO itab1.
  APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
  APPEND '<Cell ss:StyleID="s16"><Data ss:Type="String">Volume</Data><NamedCell' TO itab1.
  APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
  APPEND '<Cell ss:StyleID="s16"><Data ss:Type="String">Vol Yr</Data><NamedCell' TO itab1.
  APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
  APPEND '<Cell ss:StyleID="s16"><Data ss:Type="String">AtGArrDt</Data><NamedCell' TO itab1.
  APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
  APPEND '<Cell ss:StyleID="s16"><Data ss:Type="String">Rev Pub date</Data><NamedCell' TO itab1.
  APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
  APPEND '</Row>' TO itab1.

  LOOP AT i_matrl ASSIGNING FIELD-SYMBOL(<lfs_exceldata>).
    APPEND '<Row ss:Hidden="1">' TO itab1.

    CLEAR lv_row.
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
      EXPORTING
        input  = <lfs_exceldata>-matnr
      IMPORTING
        output = <lfs_exceldata>-matnr.

    CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-matnr '</Data><NamedCell' INTO lv_row.
    APPEND lv_row TO itab1.
    APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.

    CLEAR lv_row.
    CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-maktx '</Data><NamedCell' INTO lv_row.
    APPEND lv_row TO itab1.
    APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.

    CLEAR lv_row.
    CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-werks '</Data><NamedCell' INTO lv_row.
    APPEND lv_row TO itab1.
    APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.

    CLEAR: lv_row,lv_date.
    IF <lfs_exceldata>-ismpubldate IS NOT INITIAL.
      CONCATENATE <lfs_exceldata>-ismpubldate+0(4) <lfs_exceldata>-ismpubldate+4(2) <lfs_exceldata>-ismpubldate+6 INTO lv_date SEPARATED BY '-'.
      CONCATENATE '<Cell ss:StyleID="s17"><Data ss:Type="DateTime">' lv_date 'T00:00:00.000' '</Data><NamedCell' INTO lv_row.
      APPEND lv_row TO itab1.
      APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
    ELSE.
      APPEND   '<Cell ss:StyleID="s17"/>' TO itab1.
    ENDIF.

*'<Cell ss:StyleID="s18"><Data ss:Type="DateTime">2022-05-13T00:00:00.000</Data></Cell>'
    CLEAR lv_row.
    CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-ismnrinyear '</Data><NamedCell' INTO lv_row.
    APPEND lv_row TO itab1.
    APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.

    CLEAR lv_row.
    CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-ismcopynr '</Data><NamedCell' INTO lv_row.
    APPEND lv_row TO itab1.
    APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.

    CLEAR lv_row.
    CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-ismyearnr  '</Data><NamedCell' INTO lv_row.
    APPEND lv_row TO itab1.
    APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.

    CLEAR: lv_row,lv_date.
    IF <lfs_exceldata>-ismarrivaldateac IS NOT INITIAL.
      CONCATENATE <lfs_exceldata>-ismarrivaldateac+0(4) <lfs_exceldata>-ismarrivaldateac+4(2) <lfs_exceldata>-ismarrivaldateac+6 INTO lv_date SEPARATED BY '-'.
      CONCATENATE '<Cell ss:StyleID="s17"><Data ss:Type="DateTime">' lv_date 'T00:00:00.000' '</Data><NamedCell' INTO lv_row.
      APPEND lv_row TO itab1.
      APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
    ELSE.
      APPEND   '<Cell ss:StyleID="s17"/>' TO itab1.
    ENDIF.

*    CLEAR lv_row.
**    CONCATENATE '<Cell><Data ss:Type="DateTime">' <lfs_exceldata>-isminitshipdate '</Data><NamedCell' INTO lv_row.
*     CONCATENATE '<Cell ss:StyleID="s17"><Data ss:Type="DateTime">'  '2022-05-13T00:00:00.000' '</Data><NamedCell' INTO lv_row.
*    APPEND lv_row TO itab1.
*    APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
    CLEAR: lv_row,lv_date.
    IF <lfs_exceldata>-isminitshipdate IS NOT INITIAL.
      CONCATENATE <lfs_exceldata>-isminitshipdate+0(4) <lfs_exceldata>-isminitshipdate+4(2) <lfs_exceldata>-isminitshipdate+6 INTO lv_date SEPARATED BY '-'.
      CONCATENATE '<Cell ss:StyleID="s17"><Data ss:Type="DateTime">' lv_date 'T00:00:00.000' '</Data><NamedCell' INTO lv_row.
      APPEND lv_row TO itab1.
      APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
    ELSE.
      APPEND   '<Cell ss:StyleID="s17"/>' TO itab1.
    ENDIF.

    APPEND '</Row>' TO itab1.
  ENDLOOP.
*  LOOP AT li_exceldata ASSIGNING FIELD-SYMBOL(<lfs_exceldata>).
*    AT NEW row.
*      APPEND '<Row ss:Hidden="1">' TO itab1.
*    ENDAT.
*    CASE <lfs_exceldata>-col.
*      WHEN 1.
*        CLEAR lv_row.
*        CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-value '</Data><NamedCell' INTO lv_row.
*        APPEND lv_row TO itab1.
*        APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
*      WHEN 2.
*        CLEAR lv_row.
*        CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-value '</Data><NamedCell' INTO lv_row.
*        APPEND lv_row TO itab1.
*        APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
*      WHEN 3.
*        CLEAR lv_row.
*        CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-value '</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>' INTO lv_row.
*        APPEND lv_row TO itab1.
*      WHEN 4.
*        CLEAR: lv_row, lv_date, lv_month, lv_day, lv_year.
*        SPLIT <lfs_exceldata>-value AT '/' INTO lv_month lv_day lv_year.
*        IF strlen( lv_month ) = 1.
*          CONCATENATE '0' lv_month INTO lv_month.
*        ENDIF.
*        IF strlen( lv_day ) = 1.
*          CONCATENATE '0' lv_day INTO lv_day.
*        ENDIF.
*        CONCATENATE lv_year lv_month lv_day INTO lv_date SEPARATED BY '-'.
*        CONCATENATE '<Cell ss:StyleID="s17"><Data ss:Type="DateTime">' lv_date 'T00:00:00.000</Data><NamedCell' INTO lv_row.
*        APPEND lv_row TO itab1.
*        APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
*      WHEN 5.
*        CLEAR lv_row.
*        CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-value '</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>'
*        INTO lv_row.
*        APPEND lv_row TO itab1.
*      WHEN 6.
*        CLEAR lv_row.
*        CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-value '</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>'
*        INTO lv_row.
*        APPEND lv_row TO itab1.
*      WHEN 7.
*        CLEAR lv_row.
*        CONCATENATE '<Cell><Data ss:Type="String">' <lfs_exceldata>-value '</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>'
*        INTO lv_row.
*        APPEND lv_row TO itab1.
*      WHEN 8.
*        CLEAR: lv_row, lv_date, lv_month, lv_day, lv_year.
*        SPLIT <lfs_exceldata>-value AT '/' INTO lv_month lv_day lv_year.
*        IF strlen( lv_month ) = 1.
*          CONCATENATE '0' lv_month INTO lv_month.
*        ENDIF.
*        IF strlen( lv_day ) = 1.
*          CONCATENATE '0' lv_day INTO lv_day.
*        ENDIF.
*        CONCATENATE lv_year lv_month lv_day INTO lv_date SEPARATED BY '-'..
*        CONCATENATE '<Cell ss:StyleID="s17"><Data ss:Type="DateTime">' lv_date 'T00:00:00.000</Data><NamedCell' INTO lv_row.
*        APPEND lv_row TO itab1.
*        APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
*      WHEN 9.
*        CLEAR: lv_row, lv_date, lv_month, lv_day, lv_year.
*        SPLIT <lfs_exceldata>-value AT '/' INTO lv_month lv_day lv_year.
*        IF strlen( lv_month ) = 1.
*          CONCATENATE '0' lv_month INTO lv_month.
*        ENDIF.
*        IF strlen( lv_day ) = 1.
*          CONCATENATE '0' lv_day INTO lv_day.
*        ENDIF.
*        CONCATENATE lv_year lv_month lv_day INTO lv_date SEPARATED BY '-'.
*        CONCATENATE '<Cell ss:StyleID="s17"><Data ss:Type="DateTime">' lv_date 'T00:00:00.000</Data><NamedCell' INTO lv_row.
*        APPEND lv_row TO itab1.
*        APPEND 'ss:Name="_FilterDatabase"/></Cell>' TO itab1.
*    ENDCASE.
*    AT END OF row.
*      APPEND '</Row>' TO itab1.
*    ENDAT.
*  ENDLOOP.

  APPEND '</Table>' TO itab1.
  APPEND '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' TO itab1.
  APPEND '<Selected/>' TO itab1.
  APPEND '<FilterOn/>' TO itab1.
  APPEND '<Panes>' TO itab1.
  APPEND '<Pane>' TO itab1.
  APPEND '<Number>3</Number>' TO itab1.
  APPEND '<ActiveRow>16</ActiveRow>' TO itab1.
  APPEND '<ActiveCol>1</ActiveCol>' TO itab1.
  APPEND '</Pane>' TO itab1.
  APPEND '</Panes>' TO itab1.
  APPEND '<ProtectObjects>False</ProtectObjects>' TO itab1.
  APPEND '<ProtectScenarios>False</ProtectScenarios>' TO itab1.
  APPEND '</WorksheetOptions>' TO itab1.
  CLEAR: lv_row.
  CONCATENATE '<AutoFilter x:Range="R1C1:R' lv_max_line_c 'C9"' INTO lv_row.
  APPEND lv_row TO itab1.
  APPEND 'xmlns="urn:schemas-microsoft-com:office:excel">' TO itab1.
*  APPEND '<AutoFilterColumn x:Index="7" x:Type="Custom">' TO itab1.
*  APPEND '<AutoFilterCondition x:Operator="Equals" x:Value="2016"/>' TO itab1.
*  APPEND '</AutoFilterColumn>' TO itab1.
  APPEND '</AutoFilter>' TO itab1.
  APPEND '</Worksheet>' TO itab1.
  APPEND '</Workbook>' TO itab1.

  CONCATENATE sy-sysid
                    '_'
                    text-003
                    '-'
                    sy-datum
                    sy-uzeit
                    sy-zonlo
                    '_'
                    '.XLS'
               INTO lv_dir_file.

  CONCATENATE '/usr/sap/tmp/' lv_dir_file INTO lv_dir_file.
  OPEN DATASET lv_dir_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc EQ 0.
    LOOP AT itab1 ASSIGNING FIELD-SYMBOL(<lfs_xl>).
      TRANSFER <lfs_xl>-values TO lv_dir_file.
    ENDLOOP.
  ENDIF.
  CLOSE DATASET lv_dir_file.
  p_file = lv_dir_file.

ENDFORM.
