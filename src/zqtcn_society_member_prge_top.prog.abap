*---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SOCIETY_MEMBER_PRGE_TOP (Include Program)
* PROGRAM DESCRIPTION: Global Data declaration
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   05/12/2020
* WRICEF ID:       R106
* TRANSPORT NUMBER(S):  ED2K918190/ ED2K918243
*---------------------------------------------------------------------*

TYPE-POOLS: slis.

TABLES : but050.

TYPES : BEGIN OF ty_constant,
          devid    TYPE zdevid,              "Development ID
          param1   TYPE rvari_vnam,          "Parameter1
          param2   TYPE rvari_vnam,          "Parameter2
          srno     TYPE tvarv_numb,          "Serial Number
          sign     TYPE tvarv_sign,          "Sign
          opti     TYPE tvarv_opti,          "Option
          low      TYPE salv_de_selopt_low,  "Low
          high     TYPE salv_de_selopt_high, "High
          activate TYPE zconstactive,        "Active/Inactive Indicator
        END OF ty_constant.

TYPES : BEGIN OF ty_parvw,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE parvw,         " Partner Function
          high TYPE parvw,         " Partner Function
        END OF ty_parvw.

TYPES : BEGIN OF ty_socbp,
          partner1  TYPE but050-partner1,       " Member BP
          partner2  TYPE but050-partner2,       " Society BP
          reltyp    TYPE but050-reltyp,         " Relationship Category
          date_to   TYPE but050-date_to,        " To Date
          date_from TYPE but050-date_from,      " From Date
          crusr     TYPE but050-crusr,          " Create user
          crdat     TYPE but050-crdat,          " Create date
          chusr     TYPE but050-chusr,          " Changed user
          chdat     TYPE but050-chdat,          " Changed date
          land1     TYPE kna1-land1,            " Society BP Country
          name1     TYPE kna1-name1,            " Society BP name1
          name2     TYPE kna1-name2,            " Society BP name2
          ort01     TYPE kna1-ort01,            " Society BP city
          pstlz     TYPE kna1-pstlz,            " Society BP postal code
          regio     TYPE kna1-regio,            " Society BP region
          stras     TYPE kna1-stras,            " Society BP House number
          name3     TYPE kna1-name3,            " Society BP name3
          name4     TYPE kna1-name4,            " Society BP name4
          bez50_2   TYPE tbz9a-bez50_2,         " Relationship category description
        END OF ty_socbp.

TYPES : BEGIN OF ty_membp,
          kunnr TYPE kna1-kunnr,                " Member Code
          land1 TYPE kna1-land1,                " Member BP Country
          name1 TYPE kna1-name1,                " Member BP name1
          name2 TYPE kna1-name2,                " Member BP name2
          ort01 TYPE kna1-ort01,                " Member BP city
          pstlz TYPE kna1-pstlz,                " Member BP postal code
          regio TYPE kna1-regio,                " Member BP region
          stras TYPE kna1-stras,                " Member BP house number
          name3 TYPE kna1-name3,                " Member BP name3
          name4 TYPE kna1-name4,                " Member BP name4
        END OF ty_membp.

TYPES : BEGIN OF ty_final,
          member    TYPE but050-partner1,       " Member BP
          mem_nam   TYPE char140,               " Member Name
          c_reltyp  TYPE but050-reltyp,         " Current/Most recent relationship type
          c_descrp  TYPE tbz9a-bez50_2,         " Relationship description
          c_dfrom   TYPE but050-date_from,      " Relationship start date
          c_dto     TYPE but050-date_to,        " Relationship end date
          c1_reltyp TYPE but050-reltyp,         " Previous relationship type
          c1_descrp TYPE tbz9a-bez50_2,         " Previous relationship description
          c1_dfrom  TYPE but050-date_from,      " Previous relationship start date
          c1_dto    TYPE but050-date_to,        " Previous relationship end date
          c2_reltyp TYPE but050-reltyp,         " Previous two relationship type
          c2_descrp TYPE tbz9a-bez50_2,         " Previous two relationship description
          c2_dfrom  TYPE but050-date_from,      " Previous two relationship start date
          c2_dto    TYPE but050-date_to,        " Previous two relationship end date
          society   TYPE but050-partner2,       " Society BP
          soc_name  TYPE char140,               " Society Name
          crusr     TYPE but050-crusr,          " Create user
          crdat     TYPE but050-crdat,          " Create date
          chusr     TYPE but050-chusr,          " Changed user
          chdat     TYPE but050-chdat,          " Changed date
          mem_stras TYPE kna1-stras,            " Member BP house number
          mem_ort01 TYPE kna1-ort01,            " Member BP city
          mem_pstlz TYPE kna1-pstlz,            " Member BP postal code
          mem_land1 TYPE kna1-land1,            " Member BP Country
          mem_regio TYPE kna1-regio,            " Member BP region
          soc_stras TYPE kna1-stras,            " Society BP house number
          soc_ort01 TYPE kna1-ort01,            " Society BP city
          soc_pstlz TYPE kna1-pstlz,            " Society BP postal code
          soc_land1 TYPE kna1-land1,            " Society BP country
          soc_regio TYPE kna1-regio,            " Society BP region
        END OF ty_final.

TYPES : BEGIN OF ty_view,
          kunnr TYPE vbpa-kunnr,                " Society BP code
          name1 TYPE kna1-name1,
          name2 TYPE kna1-name2,
          name3 TYPE kna1-name3,
          name4 TYPE kna1-name4,
        END OF ty_view.

DATA : ir_parvw TYPE RANGE OF vbpa-parvw.  " Partner Function

TYPES : tt_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,      " Table types declarations
        tt_socbp    TYPE STANDARD TABLE OF ty_socbp    INITIAL SIZE 0,
        tt_membp    TYPE STANDARD TABLE OF ty_membp    INITIAL SIZE 0.

DATA : i_constant TYPE tt_constant,                                         " Internal table declarations
       i_socbp    TYPE tt_socbp,
       i_membp    TYPE tt_membp,
       i_final    TYPE STANDARD TABLE OF ty_final INITIAL SIZE 0,
       i_view     TYPE STANDARD TABLE OF ty_view INITIAL SIZE 0.

DATA: i_fieldcat_r106  TYPE STANDARD TABLE OF slis_fieldcat_alv,        " ALV and Fieldcat declaration for JKSE output
      st_fieldcat_r106 TYPE slis_fieldcat_alv,
      v_layout         TYPE slis_layout_alv,
      i_events         TYPE slis_t_event,
      i_sort           TYPE slis_t_sortinfo_alv.

CONSTANTS : c_devid    TYPE zdevid   VALUE 'R106',           " WRICEF ID
            c_errtype  TYPE char1    VALUE 'E',              " Error messege
            c_standard TYPE char1    VALUE 'A'.              " Save standard variant or user specific variant
