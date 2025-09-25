*&---------------------------------------------------------------------*
*&  Include  ZQTCN_WOA_INSUB_ORD_I0378
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_WOA_INSUB_ORD_I0378
* PROGRAM DESCRIPTION: Populate Sales Area data
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 25-DEC-2019
* OBJECT ID: I0378 (ERPM-197)
* TRANSPORT NUMBER(S): ED2K917150
*----------------------------------------------------------------------*
**********************************************************************
*                         TYPE DECLARATION                           *
**********************************************************************
* Type Declaration of Constant table
TYPES: BEGIN OF lty_vbak_i0378,
         vbeln TYPE vbeln_va, " Sales Document
         vkorg TYPE vkorg,    " Sales Organization
         vtweg TYPE vtweg,    " Distribution Channel
         spart TYPE spart,    " Division
         kunnr TYPE kunnr,    " Sold-to party
       END OF lty_vbak_i0378,

*      Type Declaration of Constant table
       BEGIN OF lty_const_i0378,
         devid  TYPE zdevid,              " Development ID
         param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
       END OF lty_const_i0378.

* Type declaration of VBAK
TYPES: BEGIN OF lty_xvbak2_i0378.
         INCLUDE STRUCTURE vbak.       " Sales Document: Header Data
         TYPES:  bstkd     TYPE bstkd, " Customer purchase order number
         kursk     TYPE kursk,         " Exchange Rate for Price Determination
         zterm     TYPE dzterm,        " Terms of Payment Key
         incov     TYPE incov,         " Incoterms Version
         inco1     TYPE inco1,         " Incoterms (Part 1)
         inco2     TYPE inco2,         " Incoterms (Part 2)
         inco2_l   TYPE inco2_l,       " Incoterms Location 1
         inco3_l   TYPE inco3_l,       " Incoterms Location 2
         prsdt     TYPE prsdt,         " Date for pricing and exchange rate
         angbt     TYPE vbeln_va,      " Sales Document
         contk     TYPE vbeln_va,      " Sales Document
         kzazu     TYPE kzazu_d,       " Order Combination Indicator
         fkdat     TYPE fkdat,         " Billing date for billing index and printout
         fbuda     TYPE fbuda,         " Date on which services rendered
         empst     TYPE empst,         " Receiving point
         valdt     TYPE valdt,         " Fixed value date
         kdkg1     TYPE kdkg1,         " Customer condition group 1
         kdkg2     TYPE kdkg2,         " Customer condition group 2
         kdkg3     TYPE kdkg3,         " Customer condition group 3
         kdkg4     TYPE kdkg4,         " Customer condition group 4
         kdkg5     TYPE kdkg5,         " Customer condition group 5
         delco     TYPE delco,         " Agreed delivery time
         abtnr     TYPE abtnr,         " Department number
         dwerk     TYPE dwerk_ext,     " Delivering Plant (Own or External)
         angbt_ref TYPE bstkd,         " Customer purchase order number
         contk_ref TYPE bstkd,         " Customer purchase order number
         currdec   TYPE currdec,       " Number of decimal places
         bstkd_e   TYPE bstkd_e,       " Ship-to Party's Purchase Order Number
         bstdk_e   TYPE bstdk_e,       " Ship-to party's PO date
       END OF lty_xvbak2_i0378,
       BEGIN OF lty_dxvbadr,
         posnr        TYPE posnr_va,
         parvw        TYPE parvw,
         kunnr        TYPE kunde_d,
         ablad        TYPE ablad,
         knref        TYPE knref,
         adrnr        TYPE adrnr,
         anred        TYPE anred_vp,
         name1        TYPE name1_gp,
         name2        TYPE name2_gp,
         name3        TYPE name3_gp,
         name4        TYPE name4_gp,
         stras        TYPE stras_gp,
         land1        TYPE land1_gp,
         pstlz        TYPE pstlz,
         pstl2        TYPE pstl2,
         pfort        TYPE pfort_gp,
         ort01        TYPE ort01_gp,
         ort02        TYPE ort02_gp,
         regio        TYPE regio,
         cityc        TYPE cityc,
         counc        TYPE counc,
         pfach        TYPE pfach,
         telf1        TYPE telf1,
         telf2        TYPE telf2,
         telbx        TYPE telbx,
         telfx        TYPE telfx,
         teltx        TYPE teltx,
         telx1        TYPE telx1,
         spras        TYPE spras,
         lzone        TYPE lzone,
         hausn        TYPE hsnmr,
         parge        TYPE parge,
         name_list    TYPE name_list,
         txjcd        TYPE txjcd,
         adrnp        TYPE ad_persnum,
         address_type TYPE ad_adrtype,
         duefl        TYPE duefl_bas,
         stock        TYPE stock,
         strs2        TYPE stras_gp,
         strasna      TYPE stras_na,
         email_addr   TYPE ad_smtpadr,
         mobnum       TYPE ad_mbnmbr1,
       END OF lty_dxvbadr,
       ltt_dxvbadr TYPE STANDARD TABLE OF lty_dxvbadr.


**********************************************************************
*                     CONSTANT DECLARATION                           *
**********************************************************************
CONSTANTS:
  lc_idoc_i0378          TYPE char30      VALUE '(SAPLVEDA)IDOC_DATA[]',
  lc_e1edk02_i0378       TYPE edilsegtyp  VALUE 'E1EDK02',          " Segment type
  lc_e1edka1_i0378       TYPE char7       VALUE 'E1EDKA1',          " Segment: E1EDKA1-Document Header Partner Information
  lc_e1edp01_i0378       TYPE edilsegtyp  VALUE 'E1EDP01',          " Segment type: E1EDP01
  lc_z1qtc_e1edp01_i0378 TYPE edilsegtyp  VALUE 'Z1QTC_E1EDP01_01', " Segment type: Z1QTC_E1EDP01_01
  lc_qualf_043_i0378     TYPE edi_qualfr  VALUE '043',              " IDOC qualifier: 043
  lc_we_i0378            TYPE parvw       VALUE 'WE',               " Ship-to
  lc_sno_0001            TYPE tvarv_numb  VALUE '0001',             " Serial Number: 0001
  lc_posnr_low           TYPE posnr_va    VALUE '000000',           " Item number
  lc_addr_char_p1        TYPE rvari_vnam  VALUE 'ADDR_CHAR',        " Param1: Address Identifier
  lc_region_p1           TYPE rvari_vnam  VALUE 'REGION',           " Param1: Region Identifier
  lc_devid_i0378         TYPE zdevid      VALUE 'I0378',            " Development Id
  lc_txtyp               TYPE trtyp       VALUE 'A'.                " Txtype: Display

**********************************************************************
*                     DATA DECLARATION                               *
**********************************************************************
STATICS: lv_vbeln_i0378     TYPE vbeln_va,           " Sales Document
         lv_addr_ident      TYPE char5,              " Addr Fields Identifier
         lv_region_ident    TYPE char1,              " Region Field Identifier
         li_constants_i0378 TYPE zcat_constants.     " Itab: Constant entries

* Work area declaration:
DATA: lst_vbak_i0378          TYPE lty_vbak_i0378,   " VBAK structure
      lst_e1edka1_i0378       TYPE e1edka1,          " IDoc: Document Header partner information
      lst_e1edk02_i0378       TYPE e1edk02,          " IDoc: Document header reference data
      lst_e1edp01_i0378       TYPE e1edp01,          " IDoc: Document Item
      lst_z1qtc_e1edp01_i0378 TYPE z1qtc_e1edp01_01, " IDOC Custom Segment fields at Item Level
      lst_xvbak_i0378         TYPE lty_xvbak2_i0378, " VBAK Structure
      lst_veda_hdr            TYPE vedavb,           " Contract Data
      lv_slsdoc_i0378         TYPE vbeln_va,         " Sales Document
      lv_posnr_i0378          TYPE posnr_va,         " Item number
      lv_parvw_i0378          TYPE parvw,            " Partner Function
      lv_matnr_i0378          TYPE matnr,            " Material Number
      lv_subtyp_i0378         TYPE zsubtyp,          " Subscription Type
      lv_inco1                TYPE inco1,            " Incoterms (Part 1)
      lv_inco2                TYPE inco2,            " Incoterms (Part 2)
      lv_data                 TYPE REF TO data.      " Reference variable

* Field Symbol
FIELD-SYMBOLS:
  <li_idoc_rec_i0378> TYPE edidd_tt,         " Table Type for EDIDD (IDoc Data Records)
  <li_dxvbadr>        TYPE ltt_dxvbadr.      " VBADR Structure


* Fetch Document Type from Constant entries
IF li_constants_i0378[] IS INITIAL.
  SELECT devid                               " Development ID
         param1                              " ABAP: Name of Variant Variable
         param2                              " ABAP: Name of Variant Variable
         srno                                " ABAP: Current selection number
         sign                                " ABAP: I/E (include/exclude values)
         opti                                " ABAP: Selection option (EQ/BT/CP/...)
         low                                 " Lower Value of Selection Condition
         high                                " Upper Value of Selection Condition
         FROM zcaconstant                    " Wiley Application Constant Table
         INTO TABLE li_constants_i0378
         WHERE devid = lc_devid_i0378 AND
               activate = abap_true.         " Only active records
  IF sy-subrc = 0 AND
     li_constants_i0378[] IS NOT INITIAL.
    LOOP AT li_constants_i0378 ASSIGNING FIELD-SYMBOL(<lst_constant_i0378>).
      CASE <lst_constant_i0378>-param1.
        WHEN lc_addr_char_p1.
          lv_addr_ident = <lst_constant_i0378>-low.

        WHEN lc_region_p1.
          lv_region_ident = <lst_constant_i0378>-low.

        WHEN OTHERS.
          " Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF. " IF sy-subrc = 0 AND
ENDIF. " IF li_constants_i0378[] IS INITIAL.

" Populate segments of the IDoc data
CASE segment-segnam.

  WHEN lc_e1edka1_i0378.
    " Get the IDoc data into local work area to process further
    lst_e1edka1_i0378 = segment-sdata.
    IF lst_e1edka1_i0378-parvw = lc_we_i0378.
      lv_parvw_i0378 = lst_e1edka1_i0378-parvw.
      " Get the Memory address of dxvbadr[]
      GET REFERENCE OF dxvbadr[] INTO lv_data.
      IF lv_data IS NOT INITIAL.
        ASSIGN lv_data->* TO <li_dxvbadr>.
        IF sy-subrc = 0 AND <li_dxvbadr> IS ASSIGNED.
          READ TABLE <li_dxvbadr> ASSIGNING FIELD-SYMBOL(<lst_dxvbadr>)
               WITH KEY parvw = lv_parvw_i0378.
          IF sy-subrc = 0 AND <lst_dxvbadr> IS ASSIGNED.
            " Name1, City, Country Key are the mandatory fields in
            " Address screen
            IF <lst_dxvbadr>-name2 IS INITIAL.          " Name 2
              <lst_dxvbadr>-name2 = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-name3 IS INITIAL.          " Name 3
              <lst_dxvbadr>-name3 = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-name4 IS INITIAL.          " Name 4
              <lst_dxvbadr>-name4 = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-stras IS INITIAL.          " Street and house number 1
              <lst_dxvbadr>-stras = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-strs2 IS INITIAL.          " Street and house number 2
              <lst_dxvbadr>-strs2 = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-pfach IS INITIAL.          " P.O Box
              <lst_dxvbadr>-pfach = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-pstlz IS INITIAL.          " Postal code
              <lst_dxvbadr>-pstlz = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-pstl2 IS INITIAL.          " P.O. Box postal code
              <lst_dxvbadr>-pstl2 = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-hausn IS INITIAL.          " House number
              <lst_dxvbadr>-hausn = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-regio IS INITIAL OR        " Region
               lst_e1edka1_i0378-regio = lv_region_ident.
              <lst_dxvbadr>-regio = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-telf1 IS INITIAL.          " 1st telephone number of contact person
              <lst_dxvbadr>-telf1 = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-telf2 IS INITIAL.          " 2nd telephone number of contact person
              <lst_dxvbadr>-telf2 = lv_addr_ident.
            ENDIF.
            IF <lst_dxvbadr>-telfx IS INITIAL.          " Fax number
              <lst_dxvbadr>-telfx = lv_addr_ident.
            ENDIF.

            UNASSIGN <lst_dxvbadr>.
          ENDIF. " IF sy-subrc = 0 AND <lst_dxvbadr> IS ASSIGNED.

          UNASSIGN <li_dxvbadr>.
        ENDIF. " IF sy-subrc = 0 AND <li_dxvbadr> IS ASSIGNED.

        CLEAR lv_data.
      ENDIF. " IF lv_data IS NOT INITIAL.
    ENDIF. " IF lst_e1edka1_i0378-parvw = lc_we_i0378.

    CLEAR: lst_e1edka1_i0378,
           lv_parvw_i0378.

  WHEN lc_e1edk02_i0378.
    " Get the IDoc data into local work area to process further
    lst_e1edk02_i0378 = segment-sdata.
    lst_xvbak_i0378 = dxvbak.

    IF lst_e1edk02_i0378-qualf = lc_qualf_043_i0378.
      IF lst_e1edk02_i0378-belnr IS INITIAL.
        " Message: Reference parent order should not be blank to create OA Relorder
        MESSAGE e350(zqtc_r2) RAISING user_error.
      ELSE.
        lv_vbeln_i0378 = lst_e1edk02_i0378-belnr.

        " Fetch sales related data from VBAK table
        SELECT SINGLE
               vbeln " Sales Document
               vkorg " Sales Organization
               vtweg " Distribution Channel
               spart " Division
               kunnr " Sold-to party
          FROM vbak  " Sales Document: Header Data
          INTO lst_vbak_i0378
          WHERE vbeln = lv_vbeln_i0378.
        IF sy-subrc = 0.
          SELECT SINGLE inco1 inco2 FROM knvv INTO ( lv_inco1, lv_inco2 )
                 WHERE kunnr = lst_vbak_i0378-kunnr AND
                       vkorg = lst_vbak_i0378-vkorg AND
                       vtweg = lst_vbak_i0378-vtweg AND
                       spart = lst_vbak_i0378-spart.
          IF sy-subrc = 0 AND lv_inco1 IS INITIAL.
            " Message: Incoterms missing for the Customer
            MESSAGE e354(zqtc_r2) WITH lst_vbak_i0378-kunnr RAISING user_error.
          ENDIF.
          " Populate Sales data in VBAK structure
          lst_xvbak_i0378-vkorg = lst_vbak_i0378-vkorg. " Sales Organisation
          lst_xvbak_i0378-vtweg = lst_vbak_i0378-vtweg. " Distribution Channel
          lst_xvbak_i0378-spart = lst_vbak_i0378-spart. " Division
          lst_xvbak_i0378-kunnr = lst_vbak_i0378-kunnr. " Sol-To-Party
          lst_xvbak_i0378-inco1 = lv_inco1.             " Incoterms (Part 1)
          lst_xvbak_i0378-inco2 = lv_inco2.             " Incoterms (Part 2)

          dxvbak = lst_xvbak_i0378.
        ELSE.
          " Message: Reference parent order & does not exist
          MESSAGE e351(zqtc_r2) WITH lv_vbeln_i0378 RAISING user_error.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF.
    ELSE.
      " Nothing to do
    ENDIF. " IF lst_e1edk02_i0378-belnr IS NOT INITIAL
    CLEAR: lst_e1edk02_i0378,
           lst_xvbak_i0378, lv_inco1, lv_inco2.

  WHEN lc_e1edp01_i0378.
    " Get the IDoc data into local work area to process further
    lst_e1edp01_i0378 = segment-sdata.

      " Get the IDOC data from ABAP Memory
      ASSIGN (lc_idoc_i0378) TO <li_idoc_rec_i0378>.
      IF sy-subrc = 0 AND <li_idoc_rec_i0378> IS ASSIGNED.
        " Read the child segment (Z1QTC_E1EDP01_01) of E1EDP01
        READ TABLE <li_idoc_rec_i0378> ASSIGNING FIELD-SYMBOL(<lst_idoc_rec_i0378>) WITH KEY
                                       segnam = lc_z1qtc_e1edp01_i0378
                                       psgnum = segment-segnum.     " psgnum --> parentsegment number
        IF sy-subrc = 0.
          lst_z1qtc_e1edp01_i0378 = <lst_idoc_rec_i0378>-sdata.
          lv_matnr_i0378 = lst_z1qtc_e1edp01_i0378-ihrez_e.  " ihrez_e --> Reference Material passed via IDOC seg
          " Get the line item of Parent Subscription order based on Material
          SELECT SINGLE vbeln posnr zzsubtyp FROM vbap INTO ( lv_slsdoc_i0378, lv_posnr_i0378, lv_subtyp_i0378 )
                 WHERE vbeln = lv_vbeln_i0378 AND
                       matnr = lv_matnr_i0378.
          IF sy-subrc <> 0.
            " Reference Parent contract doesn't have# <Material>
            MESSAGE e356(zqtc_r2) WITH lv_matnr_i0378 RAISING user_error.
          ELSEIF sy-subrc = 0.

          IF lst_z1qtc_e1edp01_i0378-zzsubtyp IS INITIAL.
                 "If subscription type isn't passed by E-core/TIBCO.. match it from parent contract
            lst_z1qtc_e1edp01_i0378-zzsubtyp = lv_subtyp_i0378.
          ENDIF.

            <lst_idoc_rec_i0378>-sdata = lst_z1qtc_e1edp01_i0378.
          ENDIF.
          UNASSIGN <lst_idoc_rec_i0378>.
        ENDIF.
        UNASSIGN <li_idoc_rec_i0378>.
      ENDIF.

    " Get Contract dates of Reference ZSUB
    CALL FUNCTION 'SD_VEDA_SELECT'
      EXPORTING
        i_document_number = lv_slsdoc_i0378  " Contract Document Number
        i_item_number     = lv_posnr_i0378   " Item Number
        i_trtyp           = lc_txtyp         " Transaction Type
      IMPORTING
        e_vedavb          = lst_veda_hdr.    " Contract Data

    IF lst_veda_hdr-venddat IS NOT INITIAL AND
       sy-datum > lst_veda_hdr-venddat AND contrl-mesfct NE 'EXP'.
      " Message: Reference Parent Line item contract end date is expired
      MESSAGE e352(zqtc_r2) RAISING user_error.
    ENDIF.

    CLEAR: lst_e1edp01_i0378,
           lst_z1qtc_e1edp01_i0378,
           lst_veda_hdr,
           lv_slsdoc_i0378,
           lv_posnr_i0378,
           lv_matnr_i0378,
           lv_subtyp_i0378.


  WHEN OTHERS.
    " Nothing to do


ENDCASE.
