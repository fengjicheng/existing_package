*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DETERMINE_PSTYV_FOR_GRC
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DETERMINE_PSTYV_FOR_GRC
*               From "ISM_SE_ORDERCREATION~CHANGE_DATA_BEFORE_RFC"
* PROGRAM DESCRIPTION: Determine the item Cat. for renewal order which is
* created. Check if ZGRC order has release order already created.
* DEVELOPER: Sunil Kairamkonda ( SKKAIRAMKO )
* CREATION DATE: 02/12/2019
* OBJECT ID: E142
* TRANSPORT NUMBER(S): ED2K914447
*----------------------------------------------------------------------*
CONSTANTS:
     lc_pstyv_zdup    TYPE pstyv    VALUE 'ZDUP',
     lc_stufe_01      TYPE char02   VALUE '01',
     lc_stufe_00      TYPE char02   VALUE '00',
     lc_contract      TYPE char01   VALUE 'G',
     lc_auart_grc     TYPE auart    VALUE 'ZGRC',
     lc_auart_rew     TYPE auart    VALUE 'ZREW'.

DATA: li_order_tab TYPE rjkseordergendata_tab,
      lv_bom_flag  TYPE c.
*--------------------------------------------------------------------*


  li_order_tab[] = order_tab[].
  SORT li_order_tab BY vbeln.
  DELETE ADJACENT DUPLICATES FROM li_order_tab
                  COMPARING vbeln.

*--Check if the order is renewal order (ZREW)
IF li_order_tab IS NOT INITIAL.
SELECT vbeln,
       auart
  FROM vbak
  INTO TABLE @DATA(li_vbak)
  FOR ALL ENTRIES IN @li_order_tab
  WHERE vbeln EQ @li_order_tab-vbeln AND
        auart EQ @lc_auart_rew.  "ZREW
 IF sy-subrc EQ 0.

*--Get the Main Subscription(ZSUB) order from ZREW
SELECT
       vbelv,   "main sub
       posnv,
       vbeln,   "Renewal order
       posnn,
       stufe
  FROM vbfa
  INTO TABLE @DATA(li_vbfa_main)
   FOR ALL ENTRIES IN @li_order_tab
  WHERE vbeln    EQ @li_order_tab-vbeln    AND
        posnn    EQ @li_order_tab-posnr    AND
        vbtyp_n  EQ @lc_contract AND   "'G'
        stufe    EQ @lc_stufe_01.      "'01'

IF sy-subrc <> 0.
*--Get the higher level item for the order item

  TRY .
    DATA(lst_order_tab) = li_order_tab[ 1 ].
  CATCH cx_sy_itab_line_not_found.

  ENDTRY.

  SELECT SINGLE
         vbeln,
         posnr,
         uepos
    FROM vbap
    INTO @DATA(lst_vbap)
    WHERE vbeln EQ @lst_order_tab-vbeln
     AND  posnr EQ @lst_order_tab-posnr.

  IF sy-subrc EQ 0 AND lst_vbap-uepos IS NOT INITIAL.

      lv_bom_flag = abap_true. "update Bom Flag


   SELECT
       vbelv,   "main sub
       posnv,
       vbeln,   "Renewal order
       posnn,
       stufe
  FROM vbfa
  INTO TABLE @li_vbfa_main
  WHERE vbeln    EQ @lst_vbap-vbeln    AND
        posnn    EQ @lst_vbap-uepos    AND
        vbtyp_n  EQ @lc_contract AND   "'G'
        stufe    EQ @lc_stufe_01.      "'01'


    ENDIF.

ENDIF.



  IF sy-subrc EQ 0.

*--Get the Gracing document (ZGRC) From Main Sub
    SELECT a~vbelv, "main sub
           a~posnv,
           a~vbeln, "Grace order
           a~posnn,
           a~vbtyp_n,
           a~stufe,
           b~auart
       FROM vbfa AS a
       INNER JOIN vbak AS b ON ( b~vbeln EQ a~vbeln )
       INTO TABLE @DATA(li_vbfa_grace)
       FOR ALL ENTRIES IN @li_vbfa_main
       WHERE a~vbelv   EQ @li_vbfa_main-vbelv  AND
             a~posnv   EQ @li_vbfa_main-posnv  AND
             a~vbtyp_n EQ @lc_contract         AND    "'G'
             a~stufe   EQ @lc_stufe_00         AND    "'00'
             b~auart   EQ @lc_auart_grc.              "'ZGRC'.


    IF sy-subrc EQ 0.  "if found

*--If Grace order found check if release order created for Grace
    SELECT  vbeln,  "Grace order
            posnr,
            issue,
            xorder_created
      FROM jksesched
      INTO TABLE @DATA(li_jksesched)
      FOR ALL ENTRIES IN @li_vbfa_grace
      WHERE vbeln EQ @li_vbfa_grace-vbeln AND
*            posnr EQ @li_vbfa_grace-posnn AND
*            issue EQ @issue                AND
            xorder_created EQ @abap_true.

        IF sy-subrc EQ 0. "Order Created

*        do nothing

      ENDIF.
     ENDIF.
    ENDIF.
   ENDIF.



  LOOP AT order_tab ASSIGNING <lst_order>.

   IF lv_bom_flag IS INITIAL. "Non BOM Items

*--check if order is Renewal order or not
    IF line_exists( li_vbak[ vbeln = <lst_order>-vbeln ] ).

*--   Read main Subrcription from Renewal order
      TRY.
      DATA(lst_vbfa_main) = li_vbfa_main[  vbeln = <lst_order>-vbeln
                                           posnn = <lst_order>-posnr ].

*      Read Gracing document from main subrcription
       TRY.
       DATA(lst_vbfa_grace) = li_vbfa_grace[ vbelv = lst_vbfa_main-vbelv
                                             posnv = lst_vbfa_main-posnv ].

*--- check if for the Grace order has been created for the issue.

          LOOP AT <lst_order>-next_issues ASSIGNING <lst_next_issue>.


                IF line_exists( li_jksesched[ vbeln = lst_vbfa_grace-vbeln
                                              posnr = lst_vbfa_grace-posnn
                                              issue = <lst_next_issue>-issue
                                              xorder_created  = abap_true ] ).

                    <lst_next_issue>-pstyv = lc_pstyv_zdup.  "Modify item cat.


                    ELSE.

                    <lst_order>-xseparate_order = abap_true.  "Split the orders which are not ZDUP

                 ENDIF.


          ENDLOOP.

         CATCH cx_sy_itab_line_not_found.
        ENDTRY.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

   ENDIF.

 ELSE. "incase of BOM items

*--check if order is Renewal order or not
    IF line_exists( li_vbak[ vbeln = <lst_order>-vbeln ] ).

*--   Read main Subrcription from Renewal order ( Main Item )
      TRY.
      lst_vbfa_main = li_vbfa_main[  vbeln = lst_vbap-vbeln
                                           posnn = lst_vbap-uepos ].

*      Read Gracing document from main subrcription (Main Item)
       TRY.
       lst_vbfa_grace = li_vbfa_grace[ vbelv = lst_vbfa_main-vbelv
                                       posnv = lst_vbfa_main-posnv ].

*--- check if for the Grace order has been created for the issue , order item.

          LOOP AT <lst_order>-next_issues ASSIGNING <lst_next_issue>.


                IF line_exists( li_jksesched[ vbeln = lst_vbfa_grace-vbeln
                                              posnr = <lst_order>-posnr
                                              issue = <lst_next_issue>-issue
                                              xorder_created  = abap_true ] ).

                    <lst_next_issue>-pstyv = lc_pstyv_zdup.  "Modify item cat.
                    <lst_order>-xseparate_order = abap_true.  "Split the orders which are not ZDUP


                 ENDIF.


          ENDLOOP.

         CATCH cx_sy_itab_line_not_found.
        ENDTRY.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

   ENDIF.






ENDIF.

  ENDLOOP.
  ENDIF.
