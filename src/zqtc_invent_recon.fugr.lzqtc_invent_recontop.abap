FUNCTION-POOL zqtc_invent_recon. "MESSAGE-ID ..

* Type Declaration
TYPES: ty_medtype TYPE RANGE OF ismmediatype, " Media Type
       ty_matofc  TYPE RANGE OF labor,        " Laboratory/design office
       ty_matcon  TYPE RANGE OF dispo.        " MRP Controller (Materials Planner)
TYPES:    BEGIN OF ty_mara,
            matnr TYPE matnr,                                " Material Number
          END OF ty_mara,

          BEGIN OF ty_ekpo,
            ebeln TYPE ebeln,                                " Purchasing Document Number
            ebelp TYPE ebelp,                                " Item Number of Purchasing Document
            menge TYPE bstmg,                                " Purchase Order Quantity
            meins TYPE bstme,                                " Purchase Order Unit of Measure
            netwr TYPE bwert,                                " Net Order Value in PO Currency
            matnr TYPE matnr,                                " Material Number
            emlif TYPE emlif,                                " Vendor to be supplied/who is to receive delivery
            waers TYPE waers,                                " Currency Key
            loekz TYPE eloek,                                " Deletion Indicator in Purchasing Document

          END OF ty_ekpo,

          BEGIN OF ty_ekbe_gr,
            ebeln TYPE  ebeln,                               " Purchasing Document Number
            ebelp TYPE  ebelp,                               " Item Number of Purchasing Document
            zekkn TYPE  dzekkn,                              " Sequential Number of Account Assignment
            vgabe TYPE  vgabe,                               " Transaction/event type, purchase order history
            gjahr TYPE  mjahr,                               " Material Document Year
            belnr TYPE  mblnr,                               " Number of Material Document
            buzei TYPE  mblpo,                               " Item in Material Document
            bwart TYPE   bwart,                              " Movement Type (Inventory Management)
            menge TYPE  menge_d,                             " Quantity
          END OF ty_ekbe_gr,

          BEGIN OF ty_ekbe_in,
            ebeln TYPE  ebeln,                               " Purchasing Document Number
            ebelp TYPE  ebelp,                               " Item Number of Purchasing Document
            zekkn TYPE  dzekkn,                              " Sequential Number of Account Assignment
            vgabe TYPE  vgabe,                               " Transaction/event type, purchase order history
            gjahr TYPE  mjahr,                               " Material Document Year
            belnr TYPE  mblnr,                               " Number of Material Document
            buzei TYPE  mblpo,                               " Item in Material Document
            bwart TYPE   bwart,                              " Movement Type (Inventory Management)
            menge TYPE  menge_d,                             " Quantity
          END OF ty_ekbe_in,
          BEGIN OF ty_final,
            matnr    TYPE matnr,                             " Material Number
            ebeln    TYPE ebeln,                             " Purchasing Document Number
            ebelp    TYPE ebelp,                             " Item Number of Purchasing Document
            menge    TYPE bstmg,                             " Purchase Order Quantity
            meins    TYPE bstme,                             " Purchase Order Unit of Measure
            netwr    TYPE bwert,                             " Net Order Value in PO Currency
            menge_gr TYPE bstmg,                             " Purchase Order Quantity
          END OF ty_final,
          tt_mara    TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,
          tt_ekpo    TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0,
          tt_ekbe_gr TYPE STANDARD TABLE OF ty_ekbe_gr INITIAL SIZE 0,
          tt_ekbe_in TYPE STANDARD TABLE OF ty_ekbe_in INITIAL SIZE 0,
          tt_custom  TYPE STANDARD TABLE OF zqtc_inven_recon " Table for Inventory Reconciliation Data
           INITIAL SIZE 0.

* Global Internal Table Declaration
DATA :     i_matnr     TYPE fip_t_matnr_range,
           i_medprd    TYPE fip_t_matnr_range,
           i_medtype   TYPE ty_medtype,
           i_mattype   TYPE fip_t_mtart_range,
           i_matofc    TYPE ty_matofc,
           i_vend      TYPE fip_t_lifnr_range,
           i_cust      TYPE fip_t_kunnr_range,
           i_mvntype   TYPE fip_t_bwart_range,
           i_mara      TYPE tt_mara,
           i_ekpo      TYPE tt_ekpo,
           i_ekbe_gr   TYPE tt_ekbe_gr,
           i_ekbe_in   TYPE tt_ekbe_in,
           i_custom    TYPE tt_custom, " ZQTC_INVEN_RECO.
           i_final     TYPE STANDARD TABLE OF ty_final INITIAL SIZE 0,
           lst_mara    TYPE ty_mara,
           lst_ekpo    TYPE ty_ekpo,
           lst_ekbe_gr TYPE ty_ekbe_gr,
           lst_ekbe_in TYPE ty_ekbe_in,
           lst_final   TYPE ty_final.
* Global Varible Declaration
DATA : v_pub_year TYPE ismjahrgang. " Media issue year number


* INCLUDE LZQTC_INVENT_RECOND...             " Local class definition
