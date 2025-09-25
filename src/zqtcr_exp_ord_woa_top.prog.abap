*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_EXPIRE_ORD_WOA_E229
* PROGRAM DESCRIPTION : Idoc generation &  release order
* DEVELOPER           : NPOLINA
* CREATION DATE       : 23/Jan/2020
* OBJECT ID           : I0378
* TRANSPORT NUMBER(S) : ED2K917365.
*----------------------------------------------------------------------*

* Tables declaration
TABLES:
  vbak, "Sales Document: Header Data
  vbap, "Sales Document: Item Data
  veda. "Sales Document: Item Data

* Types Declaration
TYPES : BEGIN OF ty_itab,
          vbeln TYPE vbap-vbeln,      " Sales Document
          posnr TYPE vbap-posnr,      " Sales Document Item
          menge TYPE vbap-zmeng,      " Target quantity in sales units
          netwr TYPE netwr,
          zieme TYPE vbap-zieme,      " Quantity UoM
          idocn TYPE edi_docnum,      " IDoc number
        END OF ty_itab,

        BEGIN OF ty_vbfa,
          vbelv   TYPE  vbfa-vbelv,   " Preceding sales and distribution document
          matnr   TYPE  matnr,
          posnv   TYPE  vbfa-posnv,   " Preceding item of an SD document
          vbtyp_n TYPE  vbfa-vbtyp_n, " Document category of subsequent document
          rfmng   TYPE  vbfa-rfmng,   " Referenced quantity in base unit of measure
          netwr   TYPE  vbap-netwr,
        END OF ty_vbfa.

*  workarea declaration
DATA: st_itab         TYPE ty_itab,
      st_vbfa         TYPE ty_vbfa,

* Idoc Related Workarea Declaration.
      v_docnum        TYPE edi_docnum, " IDoc number
      st_edidc        TYPE edidc,      " Data Control Record (IDOC)
      st_seg_k01      TYPE e1edk01,    " Doc: Document header general data
      st_seg_k14      TYPE e1edk14,    " Doc: Document header general data
      st_seg_k02      TYPE e1edk02,    " Document header reference data
      st_seg_k03      TYPE e1edk03,    " Document header reference data
      st_seg_ka1      TYPE e1edka1,    " Document header reference data
      st_seg_p01      TYPE e1edp01,    " Document Item General Data
      st_seg_zp01     TYPE z1qtc_e1edp01_01,    " Document Item General Data
      st_seg_p03      TYPE e1edp03,    " Document Item Date Segment
      st_seg_p02      TYPE e1edp02,    " Document Item Date Segment
      st_seg_p05      TYPE e1edp05,    " Document Item Conditions
      st_seg_p19      TYPE e1edp19,    " Document Item Object Identification

* Internal Table Declaration.
      i_itab          TYPE TABLE OF ty_itab, "Output table.
      i_date          TYPE date_t_range,
      st_date         TYPE date_range,

* Alv Related Declaration.
      r_alv_table     TYPE REF TO cl_salv_table,         " Basis Class for Simple Tables
      r_alv_columns   TYPE REF TO cl_salv_columns_table, " Columns in Simple, Two-Dimensional Tables
      r_single_column TYPE REF TO cl_salv_column.        " Individual Column Object

*  Constant Declaration.
CONSTANTS :

* IDOC Related Constant Declaration.

  c_qualf_043  TYPE edi_qualfr VALUE '043',     "IDOC qualifier reference document
  c_qualf_013  TYPE edi_qualfr VALUE '013',     "IDOC qualifier reference document
  c_qualf_011  TYPE edi_qualfr VALUE '011',     "IDOC qualifier reference document
  c_qualf_002  TYPE edi_qualfr VALUE '002',     "IDOC qualifier reference document
  c_qualf_001  TYPE edi_qualfr VALUE '001',     "IDOC qualifier reference document
  c_qualf_022  TYPE edi_qualfr VALUE '022',     "IDOC qualifier reference document
  c_qualf_012  TYPE edi_qualfr VALUE '012',     "IDOC qualifier reference document
  c_qualf_008  TYPE edi_qualfr VALUE '008',     "IDOC qualifier reference document
  c_qualf_007  TYPE edi_qualfr VALUE '007',     "IDOC qualifier reference document
  c_qualf_006  TYPE edi_qualfr VALUE '006',     "IDOC qualifier reference document
  c_qualf_016  TYPE edi_qualfr VALUE '016',     "IDOC qualifier reference document
  c_iddat_acd  TYPE edi_iddat  VALUE 'ACD',     "Qualifier for IDOC date segment
  c_seg_k01    TYPE edilsegtyp VALUE 'E1EDK01', "Segment type: E1EDK01
  c_seg_k02    TYPE edilsegtyp VALUE 'E1EDK02', "Segment type: E1EDK02
  c_seg_ka1    TYPE edilsegtyp VALUE 'E1EDKA1', "Segment type: E1EDK02
  c_seg_k03    TYPE edilsegtyp VALUE 'E1EDK03', "Segment type: E1EDK03
  c_seg_k14    TYPE edilsegtyp VALUE 'E1EDK14', "Segment type: E1EDK02
  c_seg_p01    TYPE edilsegtyp VALUE 'E1EDP01', "Segment type: E1EDP01
  c_seg_zp01   TYPE edilsegtyp VALUE 'Z1QTC_E1EDP01_01', "Segment type: E1EDP01
  c_seg_p03    TYPE edilsegtyp VALUE 'E1EDP03', "Segment type: E1EDP03
  c_seg_p02    TYPE edilsegtyp VALUE 'E1EDP02', "Segment type: E1EDP03
  c_seg_p05    TYPE edilsegtyp VALUE 'E1EDP05', "Segment type: E1EDP05
  c_seg_p19    TYPE edilsegtyp VALUE 'E1EDP19', "Segment type: E1EDP19

* Sales Document Type ( ZSUB, ZREW, ZCOP, ZTRL, ZDTK )

  c_auart_zsub TYPE auart           VALUE 'ZSUB', "Sales Document Type: ZSUB
  c_auart_zrew TYPE auart           VALUE 'ZREW', "Sales Document Type: ZREW
  c_auart_zcop TYPE auart           VALUE 'ZCOP', "Sales Document Type: ZCOP
  c_auart_ztrl TYPE auart           VALUE 'ZTRL', "Sales Document Type: ZTRL
  c_pstyv_zwoa TYPE pstyv           VALUE 'ZWOA', "Sales document item category: ZWOA

* IDOC Status Number (50, 64, 53)

  c_status_50  TYPE edi_status      VALUE '50', " Idoc Status
  c_status_64  TYPE edi_status      VALUE '64', " Idoc Status

* Selection Range Option Declaration.

  c_sign_incld TYPE ddsign          VALUE 'I',  "Sign: (I)nclude
  c_opti_equal TYPE ddoption        VALUE 'EQ', "Option: (EQ)ual
  c_opti_betwn TYPE ddoption        VALUE 'BT', "Option: (B)e(T)ween
  c_msgty_i    TYPE msgty           VALUE 'I'.  " Information message.
