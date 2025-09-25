*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTCN_RBDSEDEB_F4_ENHANCE_02                   *
* PROGRAM DESCRIPTION:  Include for RBDSEDEB for Enhancing the F4 help *
* DEVELOPER:            Cheenangshuk Das                               *
* CREATION DATE:        12/09/2016                                     *
* OBJECT ID:            I0202                                          *
* TRANSPORT NUMBER(S):  ED2K903293                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907215
* REFERENCE NO: ERP-3054/CR593
* DEVELOPER: Writtick Roy (WROY)
* DATE:  07/11/2017
* DESCRIPTION: Additional Fields from BP: General data
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911463
* REFERENCE NO: ERP-7078, ERP-6095, ERP-7136
* DEVELOPER: Siva Guda
* DATE:  03/20/2018
* 1) Get the Data from custom table ZQTC_EXT_IDENT with reference to Partner
* 2) Populate the segment data with External ID from custom table
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO  : ED1K910143
* REFERENCE NO : PRB0043860
* DEVELOPER    : Venkata Durga Rao P
* DATE         : 05/15/2019
* DESCRIPTION  : Mandatory segment Z1QTC_BU_GENERAL filling for old
*                customer from KNA1
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  ERPM-24270
* DEVELOPER:MIMMADISET (Murali)
* DATE:  07/24/2020
* DESCRIPTION:Populate the Valid from date and valid to date in telephone
* Segment.
*----------------------------------------------------------------------*
*====================================================================*
* Local Structures
*====================================================================*
TYPES: BEGIN OF lty_kna1,
         kunnr TYPE kunnr, " Customer Number
         adrnr TYPE adrnr, " Address
       END OF lty_kna1.
TYPES: BEGIN OF lty_but000,
         type       TYPE bu_type,      " Business partner category
         found_dat  TYPE bu_found_dat, " Date organization founded
         chdat      TYPE bu_chdat,     " Date when object was last changed
         chtim      TYPE bu_chtim,     " Time at which object was last changed
*        Begin of ADD:ERP-3054/CR593:WROY:11-JUL-2017: ED2K907215
         crdat      TYPE bu_crdat,     " Date on which the object was created
         crtim      TYPE bu_crtim,     " Time at which the object was created
         name_last  TYPE bu_namep_l,   " Last name of business partner (person)
         name_first TYPE bu_namep_f,   " First name of business partner (person)
*        End   of ADD:ERP-3054/CR593:WROY:11-JUL-2017: ED2K907215
       END OF lty_but000.
TYPES: BEGIN OF lty_but050,
         relnr         TYPE bu_relnr,   " BP Relationship Number
         partner1      TYPE bu_partner, " Business Partner Number
         partner2      TYPE bu_partner, " Business Partner Number
         date_to       TYPE bu_datto,   " Validity Date (Valid To)
         date_from     TYPE bu_datfrom, " Validity Date (Valid From)
         reltyp        TYPE bu_reltyp,  " Business Partner Relationship Category
         partner2_type TYPE bu_type,    " Business partner category
       END OF lty_but050.
*====================================================================*
* Local Internal Table
*====================================================================*
DATA: li_but050            TYPE STANDARD TABLE OF lty_but050 INITIAL SIZE 0, " BP relationships/role definitions: General data
      li_adr2              TYPE STANDARD TABLE OF adr2   INITIAL SIZE 0,     " Telephone Numbers (Business Address Services)
      li_adr3              TYPE STANDARD TABLE OF adr3   INITIAL SIZE 0,     " Fax Numbers (Business Address Services)
      li_adr4              TYPE STANDARD TABLE OF adr4   INITIAL SIZE 0,     " Fax Numbers (Business Address Services)
      li_adr5              TYPE STANDARD TABLE OF adr5   INITIAL SIZE 0,     " Fax Numbers (Business Address Services)
      li_adr6              TYPE STANDARD TABLE OF adr6   INITIAL SIZE 0,     " E-Mail Addresses (Business Address Services)
      li_adrt              TYPE STANDARD TABLE OF adrt   INITIAL SIZE 0,     " Communication Data Text (Business Address Services)
*====================================================================*
* Local Work-Area
*====================================================================*
      lst_adr2             TYPE adr2,             " Telephone Numbers (Business Address Services)
      lst_adr3             TYPE adr3,             " Fax Numbers (Business Address Services)
      lst_adr4             TYPE adr4,             " Fax Numbers (Business Address Services)
      lst_adr5             TYPE adr5,             " Fax Numbers (Business Address Services)
      lst_adr6             TYPE adr6,             " E-Mail Addresses (Business Address Services)
      lst_adrt             TYPE adrt,             " Communication Data Text (Business Address Services)
      lst_kna1m            TYPE e1kna1m,          " Master customer master basic data (KNA1)
      lst_e1kna11          TYPE e1kna11,          " Customer Master: Additional General Fields  (KNA1)
      lst_z1qtc_bu_general TYPE z1qtc_bu_general, " Custom Segment for BP: General data
      lst_z1qtc_bu_rel     TYPE z1qtc_bu_rel,     " Custom Segment for BU Partner  -BUT050 table
      lst_z1qtc_bu_ident   TYPE z1qtc_bu_ident,   " Custom Segment for BU Partner  -BUT0ID table
      lst_but000           TYPE lty_but000,       " BP: General Data
      lst_but050           TYPE lty_but050,       " BP: General Data
      lst_but0id           TYPE but0id,           " BP: ID Numbers
      lst_adrc             TYPE adrc,             " Addresses (Business Address Services)
      lst_z1qtc_e1adrmas   TYPE z1qtc_e1adrmas,   " Header segment
      lst_z1qtc_e1bpad1vl  TYPE z1qtc_e1bpad1vl,  " Address distribution BAPI structure
      lst_z1qtc_e1bpad1vl1 TYPE z1qtc_e1bpad1vl1, " Address type 1 distribution BAPI structure
      lst_z1qtc_e1bpadtel  TYPE z1qtc_e1bpadtel,  " BAPI Structure for Telephone Numbers (Bus. Address Services)
      lst_z1qtc_e1bpadfax  TYPE z1qtc_e1bpadfax,  " BAPI Structure for Fax Numbers (Business Address Services)
      lst_z1qtc_e1bpadttx  TYPE z1qtc_e1bpadttx,  " BAPI Structure for Teletex Numbers (Bus. Address Services)
      lst_z1qtc_e1bpadtlx  TYPE z1qtc_e1bpadtlx,  " BAPI Structure for Telex Numbers (Business Address Services)
      lst_z1qtc_e1bpadsmtp TYPE z1qtc_e1bpadsmtp, " BAPI Structure for E-Mail Addresses (Bus. Address Services)
      lst_z1qtc_e1bpcomrem TYPE z1qtc_e1bpcomrem, " BAPI Structure for E-Mail Addresses (Bus. Address Services)
      lst_kna1             TYPE lty_kna1,         " General Data in Customer Master
      lv_objid             TYPE char70,          " Objid of type CHAR70
      "Begin of add:ERPM-24270:mimmadiset:
      lir_vkorg_range      TYPE fip_t_vkorg_range, "Sales org range table
      li_constants_i0202   TYPE zcat_constants.    "Constant Values
"End of add:ERPM-24270:mimmadiset:
*====================================================================*
* Local Constants
*====================================================================*
CONSTANTS: lc_e1kna1m           TYPE edilsegtyp VALUE 'E1KNA1M',           " Segment type
           lc_e1kna11           TYPE edilsegtyp VALUE 'E1KNA11',           " Segment type
           lc_z1qtc_bu_general  TYPE edilsegtyp VALUE 'Z1QTC_BU_GENERAL',  " Segment type
           lc_z1qtc_bu_rel      TYPE edilsegtyp VALUE 'Z1QTC_BU_REL',      " Segment type
           lc_z1qtc_bu_ident    TYPE edilsegtyp VALUE 'Z1QTC_BU_IDENT',    " Segment type
           lc_zrtre_debmas07_03 TYPE edi_cimtyp VALUE 'ZRTRE_DEBMAS07_03', " Extension
           lc_debmas            TYPE edi_mestyp VALUE 'DEBMAS',            " Message Type
           lc_debmas_outb       TYPE edi_mestyp VALUE 'ZQTC_DEBMAS_OUTB',  " Message Type
           lc_hlevel_2          TYPE edi_hlevel VALUE '02',                " Hierarchy level
           lc_hlevel_3          TYPE edi_hlevel VALUE '03',                " Hierarchy level
           lc_comrem            TYPE edilsegtyp VALUE 'Z1QTC_E1BPCOMREM',  " Segment type
           lc_adsmtp            TYPE edilsegtyp VALUE 'Z1QTC_E1BPADSMTP',  " Segment type
           lc_adtlx             TYPE edilsegtyp VALUE 'Z1QTC_E1BPADTLX',   " Segment type
           lc_adttx             TYPE edilsegtyp VALUE 'Z1QTC_E1BPADTTX',   " Segment type
           lc_adfax             TYPE edilsegtyp VALUE 'Z1QTC_E1BPADFAX',   " Segment type
           lc_adtel             TYPE edilsegtyp VALUE 'Z1QTC_E1BPADTEL',   " Segment type
           lc_ad1vl1            TYPE edilsegtyp VALUE 'Z1QTC_E1BPAD1VL1',  " Segment type
           lc_ad1vl             TYPE edilsegtyp VALUE 'Z1QTC_E1BPAD1VL',   " Segment type
           lc_adrmas            TYPE edilsegtyp VALUE 'Z1QTC_E1ADRMAS',    " Segment type
           lc_objtyp            TYPE ad_ownertp VALUE 'ADRESSE',           " Address owner object type
*        Begin of ADD:ERP-7078, ERP-6095, ERP-7136:Siva Guda:20-March-2018: ED2K911463
           lv_zsfci             TYPE but0id-type VALUE 'ZSFCI',
           lv_zcaaid            TYPE but0id-type VALUE 'ZCAAID',
*        End of ADD:ERP-7078, ERP-6095, ERP-7136:Siva Guda:20-March-2018: ED2K911463
           lc_bp                TYPE char2      VALUE 'BP',               " Bp of type CHAR2
** Begin of add:ERPM-24270:mimmadiset:
           lc_devid_i0202       TYPE zdevid     VALUE 'I0202',   "Development ID
           lc_vkorg             TYPE rvari_vnam VALUE 'VKORG'.   "Salesorg
** End of add:ERPM-24270:mimmadiset:


*make sure you are processing correct message type
CHECK message_type EQ lc_debmas_outb "'ZQTC_DEBMAS_OUTB'
OR    message_type EQ lc_debmas.     "'DEBMAS'.

* since customer number is not passed in this user exit, you need to go
* through the data records to find the customer number

LOOP AT idoc_data.
  CASE idoc_data-segnam.
    WHEN lc_e1kna1m. "'E1KNA1M'.
      MOVE idoc_data-sdata TO lst_kna1m.
    WHEN lc_e1kna11. "'E1KNA11'.
      MOVE idoc_data-sdata TO lst_e1kna11.
    WHEN  OTHERS.
*    No actions
  ENDCASE. " case idoc_data-segname.
ENDLOOP. " LOOP AT idoc_data

*--------------------------------------------------------------------*
* BUT000 - BP general Data
*--------------------------------------------------------------------*
READ TABLE idoc_data WITH KEY segnam = lc_z1qtc_bu_general. "'Z1QTC_BU_GENERAL'.
IF sy-subrc NE 0.
  CLEAR: lst_but000.
  SELECT SINGLE type      "Business partner category
                found_dat "Date organization founded
                chdat     "Date when object was last changed
                chtim     "Time at which object was last changed
*               Begin of ADD:ERP-3054/CR593:WROY:11-JUL-2017: ED2K907215
                crdat     "Date on which the object was created
                crtim     "Time at which the object was created
                name_last "Last name of business partner (person)
                name_first"First name of business partner (person)
*               End   of ADD:ERP-3054/CR593:WROY:11-JUL-2017: ED2K907215
    FROM but000           " BP: General Data
    INTO lst_but000
   WHERE partner  = lst_kna1m-kunnr.
  IF sy-subrc IS INITIAL.
    idoc_cimtype = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.

    MOVE-CORRESPONDING lst_but000 TO lst_z1qtc_bu_general.
    MOVE lc_z1qtc_bu_general  TO idoc_data-segnam. " administrative section
    MOVE lst_z1qtc_bu_general TO idoc_data-sdata. " data section
    APPEND idoc_data.
*---Begin of change VDPATABALL 15/05/2019 PRB0043860
  ELSE.
    SELECT SINGLE erdat,    "Date on which the object was created
                  name1,
                  name2
      FROM kna1          " Internal custmer
      INTO @DATA(lst_kna1_tmp)
      WHERE kunnr  = @lst_kna1m-kunnr.
    IF sy-subrc = 0.
      lst_z1qtc_bu_general-crdat      = lst_kna1_tmp-erdat.
      lst_z1qtc_bu_general-name_last  = lst_kna1_tmp-name1.
      lst_z1qtc_bu_general-name_first = lst_kna1_tmp-name2.
      MOVE lc_z1qtc_bu_general  TO idoc_data-segnam. " administrative section
      MOVE lst_z1qtc_bu_general TO idoc_data-sdata. " data section
      APPEND idoc_data.
    ENDIF.
*---End of change VDPATABALL 15/05/2019 PRB0043860
  ENDIF. " IF sy-subrc IS INITIAL
ENDIF. " IF sy-subrc NE 0

*--------------------------------------------------------------------*
* BUT050 - BP relationships/role definitions: General data
*--------------------------------------------------------------------*
READ TABLE idoc_data WITH KEY segnam = lc_z1qtc_bu_rel. "'Z1QTC_BU_REL'.
IF sy-subrc NE 0.
  SELECT r~relnr     " BP Relationship Number
         r~partner1  " Business Partner Number
         r~partner2  " Business Partner Number
         r~date_to   " Validity Date (Valid To)
         r~date_from " Validity Date (Valid From)
         r~reltyp    " Business Partner Relationship Category
         g~type      " Business partner category
    FROM but050 AS r " BP relationships/role definitions: General data
   INNER JOIN but000 AS g
      ON r~partner2 EQ g~partner
    INTO TABLE li_but050
   WHERE r~partner1  = lst_kna1m-kunnr.
  IF sy-subrc IS INITIAL.
    idoc_cimtype = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.

    CLEAR lst_z1qtc_bu_rel.

    LOOP AT li_but050 INTO lst_but050.
      MOVE-CORRESPONDING lst_but050 TO lst_z1qtc_bu_rel.
      MOVE lc_z1qtc_bu_rel  TO idoc_data-segnam. " administrative section
      MOVE lst_z1qtc_bu_rel TO idoc_data-sdata. " data section
      APPEND idoc_data.
    ENDLOOP. " LOOP AT li_but050 INTO lst_but050

  ENDIF. " IF sy-subrc IS INITIAL
ENDIF. " IF sy-subrc NE 0

*--------------------------------------------------------------------*
* BUT0ID - Identification Tab
*--------------------------------------------------------------------*
READ TABLE idoc_data WITH KEY segnam = lc_z1qtc_bu_ident. "'Z1QTC_BU_IDENT'.
IF sy-subrc NE 0.
  SELECT  partner, "ADD:ERP-7078, ERP-6095, ERP-7136:Siva Guda:20-March-2018: ED2K911463
          type,       " Identification Type
          idnumber    " Identification Number
          FROM but0id " BP: ID Numbers
          INTO TABLE @DATA(li_but0id_temp)
          WHERE partner  = @lst_kna1m-kunnr.
  IF sy-subrc IS INITIAL.
*   Begin of ADD:ERP-7078, ERP-6095, ERP-7136:Siva Guda:20-March-2018: ED2K911463
* Fetch identification data from custom table
    SELECT  partner,
            type,       " Identification Type
            idnumber,    " Identification Number
            ext_idnumber    " SFDC ID no
            FROM zqtc_ext_ident " BP: ID Numbers
            INTO TABLE @DATA(li_zqtc_ext_ident_temp)
            WHERE partner  = @lst_kna1m-kunnr.
*   End of ADD:ERP-7078, ERP-6095, ERP-7136:Siva Guda:20-March-2018: ED2K911463
    idoc_cimtype = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.

    CLEAR lst_z1qtc_bu_ident.

    LOOP AT li_but0id_temp INTO DATA(lst_but0id_temp).
      lst_z1qtc_bu_ident-type      = lst_but0id_temp-type.
      lst_z1qtc_bu_ident-idnumber  = lst_but0id_temp-idnumber.
*        Begin of ADD:ERP-7078, ERP-6095, ERP-7136:Siva Guda:20-March-2018: ED2K911463
* Update  segement with external identification data from custom table
      READ TABLE li_zqtc_ext_ident_temp INTO DATA(lst_zqtc_ext_ident_temp) WITH KEY partner = lst_but0id_temp-partner
                                                                                    type    = lst_but0id_temp-type
                                                                                    idnumber = lst_but0id_temp-idnumber.
      IF sy-subrc = 0.
        IF lst_zqtc_ext_ident_temp-type = lv_zsfci OR lst_zqtc_ext_ident_temp-type = lv_zcaaid.
          lst_z1qtc_bu_ident-ext_id_number  = lst_zqtc_ext_ident_temp-ext_idnumber.
        ENDIF.
      ENDIF.
*        End of ADD:ERP-7078, ERP-6095, ERP-7136:Siva Guda:20-March-2018: ED2K911463
      MOVE lc_z1qtc_bu_ident  TO idoc_data-segnam. " administrative section
      MOVE lst_z1qtc_bu_ident TO idoc_data-sdata. " data section
      APPEND idoc_data.
*        Begin of ADD:ERP-7078, ERP-6095, ERP-7136:Siva Guda:20-March-2018: ED2K911463
      CLEAR: lst_z1qtc_bu_ident,lst_zqtc_ext_ident_temp,lst_but0id_temp.
*        End of ADD:ERP-7078, ERP-6095, ERP-7136:Siva Guda:20-March-2018: ED2K911463
    ENDLOOP. " LOOP AT li_but0id_temp INTO DATA(lst_but0id_temp)

  ENDIF. " IF sy-subrc IS INITIAL
ENDIF. " IF sy-subrc NE 0

*--------------------------------------------------------------------*
* ADRC - Address Tab
*--------------------------------------------------------------------*
READ TABLE idoc_data WITH KEY segnam = lc_adrmas.
IF sy-subrc NE 0.
  SELECT SINGLE kunnr     " Customer Number
                adrnr     " Address
                FROM kna1 " General Data in Customer Master
                INTO lst_kna1
                WHERE kunnr EQ lst_kna1m-kunnr.
  IF sy-subrc IS INITIAL.
    SELECT SINGLE  *
           FROM adrc " Addresses (Business Address Services)
         INTO  lst_adrc
         WHERE addrnumber = lst_kna1-adrnr.
    IF sy-subrc IS INITIAL.
      idoc_cimtype = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.
      idoc_data-segnam = lc_adrmas. " administrative section
      lst_z1qtc_e1adrmas-obj_type = lc_objtyp.
      CLEAR lv_objid.

      CONCATENATE lc_bp "BP
                  space " ' '
                  space " ' '
                  lst_kna1-adrnr
                  INTO
                  lv_objid
                  RESPECTING BLANKS.

      lst_z1qtc_e1adrmas-obj_id   = lv_objid.
      MOVE lst_z1qtc_e1adrmas TO idoc_data-sdata. " data section
      APPEND idoc_data.
*--------------------------------------------------------------------*
      idoc_cimtype = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.
      idoc_data-segnam = lc_ad1vl  . " administrative section
      idoc_data-hlevel = lc_hlevel_2.
      MOVE-CORRESPONDING lst_adrc TO lst_z1qtc_e1bpad1vl.
      lst_z1qtc_e1bpad1vl-addr_vers   = lst_adrc-nation.
      lst_z1qtc_e1bpad1vl-from_date   = lst_adrc-date_from.
      lst_z1qtc_e1bpad1vl-to_date     = lst_adrc-date_to.
      lst_z1qtc_e1bpad1vl-title       = lst_adrc-title.
      lst_z1qtc_e1bpad1vl-name        = lst_adrc-name1.
      lst_z1qtc_e1bpad1vl-name_2      = lst_adrc-name2.
      lst_z1qtc_e1bpad1vl-name_3      = lst_adrc-name3.
      lst_z1qtc_e1bpad1vl-name_4      = lst_adrc-name4.
      lst_z1qtc_e1bpad1vl-conv_name   = lst_adrc-name_text.
      lst_z1qtc_e1bpad1vl-c_o_name    = lst_adrc-name_co.
      lst_z1qtc_e1bpad1vl-city        = lst_adrc-city1.
      lst_z1qtc_e1bpad1vl-district    = lst_adrc-city2.
      lst_z1qtc_e1bpad1vl-city_no     = lst_adrc-city_code.
      lst_z1qtc_e1bpad1vl-distrct_no  = lst_adrc-cityp_code.
      lst_z1qtc_e1bpad1vl-chckstatus  = lst_adrc-chckstatus.
      lst_z1qtc_e1bpad1vl-regiogroup  = lst_adrc-regiogroup.
      lst_z1qtc_e1bpad1vl-postl_cod1  = lst_adrc-post_code1.
      lst_z1qtc_e1bpad1vl-postl_cod2  = lst_adrc-post_code2.
      lst_z1qtc_e1bpad1vl-postl_cod3  = lst_adrc-post_code3.
      lst_z1qtc_e1bpad1vl-pcode1_ext  = lst_adrc-pcode1_ext.
      lst_z1qtc_e1bpad1vl-pcode2_ext  = lst_adrc-pcode2_ext.
      lst_z1qtc_e1bpad1vl-pcode3_ext  = lst_adrc-pcode3_ext.
      lst_z1qtc_e1bpad1vl-po_box      = lst_adrc-po_box.
      lst_z1qtc_e1bpad1vl-po_w_o_no   = lst_adrc-dont_use_p.
      lst_z1qtc_e1bpad1vl-po_box_cit  = lst_adrc-po_box_loc.
      lst_z1qtc_e1bpad1vl-pboxcit_no  = lst_adrc-po_box_num.
      lst_z1qtc_e1bpad1vl-po_box_reg  = lst_adrc-po_box_reg.
      lst_z1qtc_e1bpad1vl-pobox_ctry  = lst_adrc-po_box_cty.
      lst_z1qtc_e1bpad1vl-po_ctryiso  = lst_adrc-po_box_cty.
      lst_z1qtc_e1bpad1vl-transpzone  = lst_adrc-transpzone.
      lst_z1qtc_e1bpad1vl-street      = lst_adrc-street.
      lst_z1qtc_e1bpad1vl-street_no   = lst_adrc-streetcode.
      lst_z1qtc_e1bpad1vl-str_abbr    = lst_adrc-streetabbr.
      lst_z1qtc_e1bpad1vl-house_no    = lst_adrc-house_num1.
      lst_z1qtc_e1bpad1vl-house_no2   = lst_adrc-house_num2.
      lst_z1qtc_e1bpad1vl-house_no3   = lst_adrc-house_num3.
      lst_z1qtc_e1bpad1vl-str_suppl1  = lst_adrc-str_suppl1.
      lst_z1qtc_e1bpad1vl-str_suppl2  = lst_adrc-str_suppl2.
      lst_z1qtc_e1bpad1vl-str_suppl3  = lst_adrc-str_suppl3.
      lst_z1qtc_e1bpad1vl-location    = lst_adrc-location.
      lst_z1qtc_e1bpad1vl-building    = lst_adrc-building.
      lst_z1qtc_e1bpad1vl-floor       = lst_adrc-floor.
      lst_z1qtc_e1bpad1vl-room_no     = lst_adrc-roomnumber.
      lst_z1qtc_e1bpad1vl-country     = lst_adrc-country.
      lst_z1qtc_e1bpad1vl-countryiso  = lst_adrc-country.
      lst_z1qtc_e1bpad1vl-langu       = lst_adrc-langu.
      lst_z1qtc_e1bpad1vl-langu_iso   = lst_adrc-langu.
      lst_z1qtc_e1bpad1vl-region      = lst_adrc-region.
      lst_z1qtc_e1bpad1vl-sort1       = lst_adrc-sort1.
      lst_z1qtc_e1bpad1vl-sort2       = lst_adrc-sort2.
      lst_z1qtc_e1bpad1vl-extens_1    = lst_adrc-extension1.
      lst_z1qtc_e1bpad1vl-extens_2    = lst_adrc-extension2.
      lst_z1qtc_e1bpad1vl-time_zone   = lst_adrc-time_zone.
      lst_z1qtc_e1bpad1vl-taxjurcode  = lst_adrc-taxjurcode.
      idoc_data-sdata                 = lst_z1qtc_e1bpad1vl.

      APPEND idoc_data.
*--------------------------------------------------------------------*
      idoc_cimtype = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.
      idoc_data-segnam = lc_ad1vl1.
      idoc_data-hlevel = lc_hlevel_3.
      MOVE-CORRESPONDING lst_adrc TO lst_z1qtc_e1bpad1vl1.
      lst_z1qtc_e1bpad1vl1-address_id   = lst_adrc-address_id.
      lst_z1qtc_e1bpad1vl1-langu_cr     = lst_adrc-langu_crea.
      lst_z1qtc_e1bpad1vl1-langucriso   = lst_adrc-langu_crea.
      lst_z1qtc_e1bpad1vl1-comm_type    = lst_adrc-deflt_comm.
      lst_z1qtc_e1bpad1vl1-addr_group   = lst_adrc-addr_group.
      lst_z1qtc_e1bpad1vl1-home_city    = lst_adrc-home_city.
      lst_z1qtc_e1bpad1vl1-homecityno   = lst_adrc-cityh_code.
      lst_z1qtc_e1bpad1vl1-dont_use_s   = lst_adrc-dont_use_s.
      lst_z1qtc_e1bpad1vl1-dont_use_p   = lst_adrc-dont_use_p.
      lst_z1qtc_e1bpad1vl1-po_box_lobby      = lst_adrc-po_box_lobby.
      lst_z1qtc_e1bpad1vl1-deli_serv_type    = lst_adrc-deli_serv_type.
      lst_z1qtc_e1bpad1vl1-deli_serv_number  = lst_adrc-deli_serv_number.
      lst_z1qtc_e1bpad1vl1-county_code       = lst_adrc-county_code.
      lst_z1qtc_e1bpad1vl1-county            = lst_adrc-county.
      lst_z1qtc_e1bpad1vl1-township_code     = lst_adrc-township_code.
      lst_z1qtc_e1bpad1vl1-township          = lst_adrc-township.

      idoc_data-sdata = lst_z1qtc_e1bpad1vl1. " data section
      APPEND idoc_data.
*--------------------------------------------------------------------*
** Begin of add:ERPM-24270:mimmadiset:
      IF lst_kna1m-kunnr IS NOT INITIAL.
        FREE:lir_vkorg_range.
        CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
          EXPORTING
            im_devid     = lc_devid_i0202  "Development ID
          IMPORTING
            ex_constants = li_constants_i0202. "Constant Values
        LOOP AT li_constants_i0202[] ASSIGNING FIELD-SYMBOL(<lfs_constant>).
          IF <lfs_constant>-param1 = lc_vkorg.
            APPEND INITIAL LINE TO lir_vkorg_range ASSIGNING FIELD-SYMBOL(<lst_vkorg_range>).
            <lst_vkorg_range>-sign     = <lfs_constant>-sign.
            <lst_vkorg_range>-option   = <lfs_constant>-opti.
            <lst_vkorg_range>-low      = <lfs_constant>-low.
          ENDIF.
        ENDLOOP.
        IF lir_vkorg_range IS NOT INITIAL.
          SELECT SINGLE kunnr, vkorg
          FROM knvp
          INTO @DATA(lst_knvp)
          WHERE kunnr EQ @lst_kna1m-kunnr AND
                vkorg IN @lir_vkorg_range.
          IF sy-subrc = 0.
            SELECT SINGLE partner," Business Partner Number
                addrnumber        " Address number
                FROM but020
                INTO @DATA(ls_but020)
                WHERE partner = @lst_kna1m-kunnr.  "#EC CI_NO_TRANSFORM
            IF sy-subrc = 0 AND ls_but020-addrnumber IS NOT INITIAL.
*** Read the valid from date and to data of telephone numbers and fax numbers
              SELECT *
                  FROM adr2 " Telephone Numbers (Business Address Services)
                  INTO TABLE @DATA(li_adr2_date)
                  WHERE addrnumber = @ls_but020-addrnumber
                  AND   valid_from NE @space.
              SELECT *
                  FROM adr3 " Fax Numbers (Business Address Services)
                  INTO TABLE @DATA(li_adr3_date)
                  WHERE addrnumber = @ls_but020-addrnumber
                  AND   valid_from NE @space.
            ENDIF." IF sy-subrc = 0 AND ls_but020-addrnumber IS NOT INITIAL.
          ENDIF.
        ENDIF." IF lst_knvp-vkorg IN lir_vkorg_range AND lir_vkorg_range IS NOT INITIAL.
      ENDIF."if lst_kna1m-kunnr is not INITIAL.
** End of add:ERPM-24270:mimmadiset:
      CLEAR li_adr2.
      SELECT *
            FROM adr2 " Telephone Numbers (Business Address Services)
            INTO TABLE li_adr2
            WHERE addrnumber = lst_kna1-adrnr.
      IF sy-subrc IS INITIAL.
        CLEAR lst_adr2.
        LOOP AT li_adr2 INTO lst_adr2.
          idoc_cimtype = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.
          idoc_data-segnam = lc_adtel  . " administrative section
          idoc_data-hlevel = lc_hlevel_2.
          lst_z1qtc_e1bpadtel-country     = lst_adr2-country.
          lst_z1qtc_e1bpadtel-countryiso  = lst_adr2-country.
          lst_z1qtc_e1bpadtel-std_no      = lst_adr2-flgdefault.
          lst_z1qtc_e1bpadtel-telephone   = lst_adr2-tel_number.
          lst_z1qtc_e1bpadtel-extension   = lst_adr2-tel_extens.
          lst_z1qtc_e1bpadtel-tel_no      = lst_adr2-telnr_long.
          lst_z1qtc_e1bpadtel-caller_no   = lst_adr2-telnr_call.
          lst_z1qtc_e1bpadtel-std_recip   = lst_adr2-dft_receiv.
          lst_z1qtc_e1bpadtel-r_3_user    = lst_adr2-r3_user.
          lst_z1qtc_e1bpadtel-home_flag   = lst_adr2-home_flag.
          lst_z1qtc_e1bpadtel-consnumber  = lst_adr2-consnumber.
          lst_z1qtc_e1bpadtel-flg_nouse   = lst_adr2-flg_nouse.
          lst_z1qtc_e1bpadtel-valid_from  = lst_adr2-valid_from.
          lst_z1qtc_e1bpadtel-valid_to    = lst_adr2-valid_to.
** Begin of add:ERPM-24270:mimmadiset:
          IF lst_adr2-valid_from IS INITIAL AND
             lst_adr2-valid_to IS INITIAL AND
             li_adr2_date IS NOT INITIAL.
            READ TABLE li_adr2_date INTO DATA(lst_adr2_date)
                     WITH KEY tel_number   = lst_adr2-tel_number.
            IF sy-subrc = 0.
              DELETE li_adr2_date INDEX sy-tabix.
              lst_z1qtc_e1bpadtel-valid_from  = lst_adr2_date-valid_from+0(8).
              lst_z1qtc_e1bpadtel-valid_to    = lst_adr2_date-valid_to+0(8).
              lst_z1qtc_e1bpadtel-consnumber  = lst_adr2_date-consnumber.
            ENDIF.
          ENDIF.
** End of add:ERPM-24270:mimmadiset:
          idoc_data-sdata = lst_z1qtc_e1bpadtel. " data section
          APPEND idoc_data.
        ENDLOOP. " LOOP AT li_adr2 INTO lst_adr2
      ENDIF. " IF sy-subrc IS INITIAL
*--------------------------------------------------------------------*
      CLEAR li_adr3.
      SELECT *
          FROM adr3 " Fax Numbers (Business Address Services)
          INTO TABLE li_adr3
          WHERE addrnumber = lst_kna1-adrnr.
      IF sy-subrc IS INITIAL.
        CLEAR lst_adr3.
        LOOP AT li_adr3 INTO lst_adr3.
          idoc_cimtype     = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.
          idoc_data-segnam = lc_adfax. " administrative section
          idoc_data-hlevel = lc_hlevel_2.

          lst_z1qtc_e1bpadfax-country    = lst_adr3-country.
          lst_z1qtc_e1bpadfax-countryiso = lst_adr3-country.
          lst_z1qtc_e1bpadfax-std_no     = lst_adr3-flgdefault.
          lst_z1qtc_e1bpadfax-fax        = lst_adr3-fax_number.
          lst_z1qtc_e1bpadfax-extension  = lst_adr3-fax_extens.
          lst_z1qtc_e1bpadfax-fax_no     = lst_adr3-faxnr_long.
          lst_z1qtc_e1bpadfax-sender_no  = lst_adr3-faxnr_call.
          lst_z1qtc_e1bpadfax-fax_group  = lst_adr3-fax_group.
          lst_z1qtc_e1bpadfax-std_recip  = lst_adr3-dft_receiv.
          lst_z1qtc_e1bpadfax-r_3_user   = lst_adr3-r3_user.
          lst_z1qtc_e1bpadfax-home_flag  = lst_adr3-home_flag.
          lst_z1qtc_e1bpadfax-consnumber = lst_adr3-consnumber.
          lst_z1qtc_e1bpadfax-flg_nouse  = lst_adr3-flg_nouse.
          lst_z1qtc_e1bpadfax-valid_from = lst_adr3-valid_from.
          lst_z1qtc_e1bpadfax-valid_to   = lst_adr3-valid_to.
** Begin of add:ERPM-24270:mimmadiset:
          IF lst_adr3-valid_from IS INITIAL AND
             lst_adr3-valid_to IS INITIAL AND
             li_adr3_date IS NOT INITIAL.
            READ TABLE li_adr3_date INTO DATA(lst_adr3_date)
                     WITH KEY fax_number   = lst_adr3-fax_number.
            IF sy-subrc = 0.
              DELETE li_adr3_date INDEX sy-tabix.
              lst_z1qtc_e1bpadfax-valid_from = lst_adr3_date-valid_from+0(8).
              lst_z1qtc_e1bpadfax-valid_to   = lst_adr3_date-valid_to+0(8).
              lst_z1qtc_e1bpadfax-consnumber  = lst_adr3_date-consnumber.
            ENDIF.
          ENDIF.
** End of add:ERPM-24270:mimmadiset:
          idoc_data-sdata               = lst_z1qtc_e1bpadfax. " data section
          APPEND idoc_data.
        ENDLOOP. " LOOP AT li_adr3 INTO lst_adr3
      ENDIF. " IF sy-subrc IS INITIAL
*--------------------------------------------------------------------*
      CLEAR li_adr4.

      SELECT *
            FROM adr4 " Teletex Numbers (Business Address Services)
            INTO TABLE li_adr4
            WHERE addrnumber = lst_kna1-adrnr.
      IF sy-subrc IS INITIAL.
        CLEAR lst_adr4.
        LOOP AT li_adr4 INTO lst_adr4.
          idoc_cimtype     = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.
          idoc_data-segnam = lc_adttx  . " administrative section
          idoc_data-hlevel = lc_hlevel_2.

          lst_z1qtc_e1bpadttx-country     = lst_adrc-country.
          lst_z1qtc_e1bpadttx-countryiso  = lst_adrc-country.
          lst_z1qtc_e1bpadttx-std_no      = lst_adr4-flgdefault.
          lst_z1qtc_e1bpadttx-teletex     = lst_adr4-ttx_number.
          lst_z1qtc_e1bpadttx-std_recip   = lst_adr4-dft_receiv.
          lst_z1qtc_e1bpadttx-r_3_user    = lst_adr4-r3_user.
          lst_z1qtc_e1bpadttx-home_flag   = lst_adr4-home_flag.
          lst_z1qtc_e1bpadttx-consnumber  = lst_adr4-consnumber.
          lst_z1qtc_e1bpadttx-flg_nouse   = lst_adr4-flg_nouse.
          lst_z1qtc_e1bpadttx-valid_from  = lst_adr4-valid_from.
          lst_z1qtc_e1bpadttx-valid_to    = lst_adr4-valid_to.
          idoc_data-sdata = lst_z1qtc_e1bpadttx . " data section
          APPEND idoc_data.
        ENDLOOP. " LOOP AT li_adr4 INTO lst_adr4
      ENDIF. " IF sy-subrc IS INITIAL
*--------------------------------------------------------------------*
      CLEAR li_adr5.
      SELECT *
        FROM adr5 " Telex Numbers (Business Address Services)
        INTO TABLE li_adr5
        WHERE addrnumber = lst_kna1-adrnr.
      IF sy-subrc IS INITIAL.
        CLEAR lst_adr5.
        LOOP AT li_adr5 INTO lst_adr5.
          idoc_cimtype = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.
          idoc_data-segnam = lc_adtlx. " administrative section
          idoc_data-hlevel = lc_hlevel_2.
          MOVE-CORRESPONDING lst_adr5 TO lst_z1qtc_e1bpadtlx.
          lst_z1qtc_e1bpadtlx-country     = lst_adrc-country.
          lst_z1qtc_e1bpadtlx-countryiso  = lst_adrc-country.
          lst_z1qtc_e1bpadtlx-std_no      = lst_adr5-flgdefault.
          lst_z1qtc_e1bpadtlx-telex_no    = lst_adr5-tlx_number.
          lst_z1qtc_e1bpadtlx-std_recip   = lst_adr5-flgdefault.
          lst_z1qtc_e1bpadtlx-r_3_user    = lst_adr5-r3_user.
          lst_z1qtc_e1bpadtlx-home_flag   = lst_adr5-home_flag.
          lst_z1qtc_e1bpadtlx-consnumber  = lst_adr5-consnumber.
          lst_z1qtc_e1bpadtlx-flg_nouse   = lst_adr5-flg_nouse.
          lst_z1qtc_e1bpadtlx-valid_from  = lst_adr5-valid_from.
          lst_z1qtc_e1bpadtlx-valid_to    = lst_adr5-valid_to.

          idoc_data-sdata = lst_z1qtc_e1bpadtlx.
          APPEND idoc_data.
        ENDLOOP. " LOOP AT li_adr5 INTO lst_adr5
      ENDIF. " IF sy-subrc IS INITIAL
*--------------------------------------------------------------------*
      CLEAR li_adr6.
      SELECT *
         FROM adr6 " E-Mail Addresses (Business Address Services)
        INTO TABLE li_adr6
         WHERE addrnumber = lst_kna1-adrnr.
      IF sy-subrc IS INITIAL.
        CLEAR lst_adr6.
        LOOP AT li_adr6 INTO lst_adr6.
          idoc_cimtype = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.
          MOVE lc_adsmtp TO idoc_data-segnam. " administrative section
          idoc_data-hlevel = lc_hlevel_2.

          lst_z1qtc_e1bpadsmtp-std_no      = lst_adr6-flgdefault.
          lst_z1qtc_e1bpadsmtp-e_mail      = lst_adr6-smtp_addr.
          lst_z1qtc_e1bpadsmtp-email_srch  = lst_adr6-smtp_srch.
          lst_z1qtc_e1bpadsmtp-std_recip   = lst_adr6-dft_receiv.
          lst_z1qtc_e1bpadsmtp-r_3_user    = lst_adr6-r3_user.
          lst_z1qtc_e1bpadsmtp-encode      = lst_adr6-encode.
          lst_z1qtc_e1bpadsmtp-tnef        = lst_adr6-tnef.
          lst_z1qtc_e1bpadsmtp-home_flag   = lst_adr6-home_flag.
          lst_z1qtc_e1bpadsmtp-consnumber  = lst_adr6-consnumber.
          lst_z1qtc_e1bpadsmtp-flg_nouse   = lst_adr6-flg_nouse.
          lst_z1qtc_e1bpadsmtp-valid_from  = lst_adr6-valid_from.
          lst_z1qtc_e1bpadsmtp-valid_to    = lst_adr6-valid_to.
          idoc_data-sdata = lst_z1qtc_e1bpadsmtp. " data section
          APPEND idoc_data.
        ENDLOOP. " LOOP AT li_adr6 INTO lst_adr6
      ENDIF. " IF sy-subrc IS INITIAL
*--------------------------------------------------------------------*
      CLEAR li_adrt.
      SELECT *
          FROM adrt " Communication Data Text (Business Address Services)
          INTO TABLE li_adrt
          WHERE addrnumber = lst_kna1-adrnr.
      IF sy-subrc IS INITIAL.
        CLEAR lst_adrt.
        LOOP AT li_adrt INTO lst_adrt.
          idoc_cimtype = lc_zrtre_debmas07_03. "'ZRTRE_DEBMAS07_03'.
          MOVE lc_comrem  TO idoc_data-segnam. " administrative section
          idoc_data-hlevel = lc_hlevel_2.

          lst_z1qtc_e1bpcomrem-comm_type   = lst_adrt-comm_type.
          lst_z1qtc_e1bpcomrem-langu       = lst_adrt-langu.
          lst_z1qtc_e1bpcomrem-langu_iso   = lst_adrt-langu.
          lst_z1qtc_e1bpcomrem-comm_notes  = lst_adrt-remark.
          lst_z1qtc_e1bpcomrem-consnumber  = lst_adrt-remark.

          idoc_data-sdata = lst_z1qtc_e1bpcomrem.
          APPEND idoc_data.

        ENDLOOP. " LOOP AT li_adrt INTO lst_adrt
      ENDIF. " IF sy-subrc IS INITIAL
*--------------------------------------------------------------------*
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL
ENDIF. " IF sy-subrc NE 0
