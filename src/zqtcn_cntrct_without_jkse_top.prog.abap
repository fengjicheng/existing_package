*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_CNTRCT_WITHOUT_JKSE_TOP (Include Program)
* PROGRAM DESCRIPTION: Global data declaration
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   02/13/2020
* WRICEF ID:       R102
* TRANSPORT NUMBER(S): ED2K917550
*&---------------------------------------------------------------------*

TYPE-POOLS: slis.

TABLES : zcds_jkse_cwsch.

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

TYPES : BEGIN OF ty_jkse,
          document_number     TYPE zcds_jkse_cwsch-document_number,     " Document Number
          item                TYPE zcds_jkse_cwsch-item,                " Item
          contract_type       TYPE zcds_jkse_cwsch-contract_type,       " Contract type
          document_date       TYPE zcds_jkse_cwsch-document_date,       " Document date
          sales_org           TYPE zcds_jkse_cwsch-sales_org,           " Sales Org
          customer_number     TYPE zcds_jkse_cwsch-customer_number,     " Customer Number
          customer_name       TYPE zcds_jkse_cwsch-customer_name,       " Customer Name
          billing_document    TYPE zcds_jkse_cwsch-billing_document,    " Billing document
          material            TYPE zcds_jkse_cwsch-material,            " Material
          item_category       TYPE zcds_jkse_cwsch-item_category,       " Item Category
          qty                 TYPE zcds_jkse_cwsch-qty,                 " Quantity
          net_value           TYPE zcds_jkse_cwsch-net_value,           " Net value
          taxes               TYPE zcds_jkse_cwsch-taxes,               " Taxes
          contract_start_date TYPE zcds_jkse_cwsch-contract_start_date, " Contract start date
          contract_end_date   TYPE zcds_jkse_cwsch-contract_end_date,   " Contract end date
          arrival_date        TYPE zcds_jkse_cwsch-arrival_date,        " Arrival date
          status              TYPE zcds_jkse_cwsch-status,              " Status
        END OF ty_jkse.

TYPES : BEGIN OF ty_auart,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE auart,         " Sales Document Type
          high TYPE auart,         " Sales Document Type
        END OF ty_auart.

DATA : i_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0.    " ITAB Declaration for constant table

DATA : i_jkse TYPE STANDARD TABLE OF ty_jkse INITIAL SIZE 0.            " ITAB Decaration for CDS view fetch data

DATA: i_fieldcat_jkse  TYPE STANDARD TABLE OF slis_fieldcat_alv,        " ALV and Fieldcat declaration for JKSE output
      st_fieldcat_jkse TYPE slis_fieldcat_alv,
      v_layout         TYPE slis_layout_alv,
      i_events         TYPE slis_t_event,
      i_sort           TYPE slis_t_sortinfo_alv.

CONSTANTS : c_devid    TYPE zdevid   VALUE 'R102',           " WRICEF ID
            c_standard TYPE char1    VALUE 'A'.              " save standard variant or user specific variant
