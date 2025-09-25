*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_BUR_EXP_TOKEN_TOP
* PROGRAM DESCRIPTION : Global Data Declarations
* DEVELOPER           : Yraulji
* CREATION DATE       : 11/08/2017
* OBJECT ID           : I0234
* TRANSPORT NUMBER(S) : ED2K909379.
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
          zieme TYPE vbap-zieme,      " Quantity UoM
          idocn TYPE edi_docnum,      " IDoc number
        END OF ty_itab,

        BEGIN OF ty_vbfa,
          vbelv   TYPE  vbfa-vbelv,   " Preceding sales and distribution document
          posnv   TYPE  vbfa-posnv,   " Preceding item of an SD document
          vbtyp_n TYPE  vbfa-vbtyp_n, " Document category of subsequent document
          rfmng   TYPE  vbfa-rfmng,   " Referenced quantity in base unit of measure
        END OF ty_vbfa.

*  workarea declaration
DATA: st_itab         TYPE ty_itab,
      st_vbfa         TYPE ty_vbfa,

* Idoc Related Workarea Declaration.
      v_docnum        TYPE edi_docnum, " IDoc number
      st_edidc        TYPE edidc,      " Data Control Record (IDOC)
      st_seg_k01      TYPE e1edk01,    " Doc: Document header general data
      st_seg_k02      TYPE e1edk02,    " Document header reference data
      st_seg_p01      TYPE e1edp01,    " Document Item General Data
      st_seg_p03      TYPE e1edp03,    " Document Item Date Segment
      st_seg_p05      TYPE e1edp05,    " Document Item Conditions
      st_seg_p19      TYPE e1edp19,    " Document Item Object Identification

* Internal Table Declaration.
      i_itab          TYPE TABLE OF ty_itab, "Output table.

* Alv Related Declaration.
      r_alv_table     TYPE REF TO cl_salv_table,         " Basis Class for Simple Tables
      r_alv_columns   TYPE REF TO cl_salv_columns_table, " Columns in Simple, Two-Dimensional Tables
      r_single_column TYPE REF TO cl_salv_column.        " Individual Column Object

*  Constant Declaration.
CONSTANTS :

* IDOC Related Constant Declaration.

  c_qualf_043  TYPE edi_qualfr VALUE '043',     "IDOC qualifier reference document
  c_iddat_acd  TYPE edi_iddat  VALUE 'ACD',     "Qualifier for IDOC date segment
  c_seg_k01    TYPE edilsegtyp VALUE 'E1EDK01', "Segment type: E1EDK01
  c_seg_k02    TYPE edilsegtyp VALUE 'E1EDK02', "Segment type: E1EDK02
  c_seg_p01    TYPE edilsegtyp VALUE 'E1EDP01', "Segment type: E1EDP01
  c_seg_p03    TYPE edilsegtyp VALUE 'E1EDP03', "Segment type: E1EDP03
  c_seg_p05    TYPE edilsegtyp VALUE 'E1EDP05', "Segment type: E1EDP05
  c_seg_p19    TYPE edilsegtyp VALUE 'E1EDP19', "Segment type: E1EDP19

* Sales Document Type ( ZSUB, ZREW, ZCOP, ZTRL, ZDTK )

  c_auart_zsub TYPE auart           VALUE 'ZSUB', "Sales Document Type: ZSUB
  c_auart_zrew TYPE auart           VALUE 'ZREW', "Sales Document Type: ZREW
  c_auart_zcop TYPE auart           VALUE 'ZCOP', "Sales Document Type: ZCOP
  c_auart_ztrl TYPE auart           VALUE 'ZTRL', "Sales Document Type: ZTRL
  c_pstyv_zdtk TYPE pstyv           VALUE 'ZDTK', "Sales document item category: ZDTK

* IDOC Status Number (50, 64, 53)

  c_status_50  TYPE edi_status      VALUE '50', " Idoc Status
  c_status_64  TYPE edi_status      VALUE '64', " Idoc Status

* Selection Range Option Declaration.

  c_sign_incld TYPE ddsign          VALUE 'I',  "Sign: (I)nclude
  c_opti_equal TYPE ddoption        VALUE 'EQ', "Option: (EQ)ual
  c_opti_betwn TYPE ddoption        VALUE 'BT', "Option: (B)e(T)ween
  c_msgty_i    TYPE msgty           VALUE 'I'.  " Information message.
