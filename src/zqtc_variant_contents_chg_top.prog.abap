*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_VARIANT_CONTENTS_CHG_TOP(Include Program)
* PROGRAM DESCRIPTION: Variant's read and change
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   04/02/2018
* OBJECT ID: ?
* TRANSPORT NUMBER(S): ED2K911732
*----------------------------------------------------------------------*
**********************************************************************
*                         TYPE DECLARATION                           *
**********************************************************************
TYPE-POOLS: slis.
*- Type Declaration for range table
TYPES : BEGIN OF ty_range,
          sign   TYPE tvarv_sign,                       "ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv_opti,                       "ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE tvarv_val,                        "ABAP/4: Selection value (LOW or HIGH value, external format)
          high   TYPE tvarv_val,                        "ABAP/4: Selection value (LOW or HIGH value, external format)
        END OF ty_range,
        BEGIN OF ty_final_alv,
          report        TYPE vari_reprt,                "ABAP: Program Name in Variant Key
          variant       TYPE variant,                   "ABAP: Name of variant (without program
          old_pack_size TYPE edippcksiz,                "Size of IDoc packets to be sent (unit: IDoc)
          new_pack_size TYPE edippcksiz,                "Size of IDoc packets to be sent (unit: IDoc)
          icon          TYPE c,                         "Icon
          message       TYPE char100,                   "Status Message
        END OF ty_final_alv.
**********************************************************************
*                         DATA DECLARATION                           *
**********************************************************************
DATA :
*-      Internal Tables
  lt_rsparams        TYPE TABLE OF rsparams,            "ABAP: General Structure for PARAMETERS and SELECT-OPTIONS
  lt_docnum          TYPE TABLE OF ty_range,            "IDOC Number
  lt_status          TYPE TABLE OF ty_range,            "IDOC Status
  lt_mescod          TYPE TABLE OF ty_range,            "Logical Message Variant
  lt_mesfct          TYPE TABLE OF ty_range,            "Message function
  lt_sndprt          TYPE TABLE OF ty_range,            "Sender partner type
  lt_sndprn          TYPE TABLE OF ty_range,            "Sender partner no.
  lt_sndpfc          TYPE TABLE OF ty_range,            "Sender partn.funct.
  lt_credat          TYPE TABLE OF ty_range,            "Created on
  lt_cretim          TYPE TABLE OF ty_range,            "Created at
  lt_mestyp          TYPE TABLE OF ty_range,            "Message Type
  lt_idoc_control_r  TYPE TABLE OF edidc,               "Control record (IDoc)
  lt_final_alv       TYPE TABLE OF ty_final_alv,        "ALV repoort
  lt_fieldcat        TYPE slis_t_fieldcat_alv,          "Fieldcat log
*-      Work Areas
  lst_varid          TYPE varid,                        "Variable ID
  lst_rsparams       TYPE rsparams,                     "ABAP: General Structure for PARAMETERS and SELECT-OPTIONS
  lst_docnum         TYPE ty_range,                     "IDOC Number
  lst_status         TYPE ty_range,                     "IDOC Status
  lst_mescod         TYPE ty_range,                     "Logical Message Variant
  lst_mesfct         TYPE ty_range,                     "Message function
  lst_sndprt         TYPE ty_range,                     "Sender partner type
  lst_sndprn         TYPE ty_range,                     "Sender partner no.
  lst_sndpfc         TYPE ty_range,                     "Sender partn.funct.
  lst_credat         TYPE ty_range,                     "Created on
  lst_cretim         TYPE ty_range,                     "Created at
  lst_mestyp         TYPE ty_range,                     "Message Type
  lst_idoc_control_r TYPE edidc,                        "Control record (IDoc)
  lv_idoc_count      TYPE i,                            "IDOC Count
  lv_get_packet_n    TYPE edippcksiz,                   "New Packet Size
  lv_get_packet_o    TYPE edippcksiz,                   "Old Packet Size
  lst_final_alv      TYPE ty_final_alv,                 "ALV report
  lst_fieldcat       TYPE slis_fieldcat_alv,            "Fieldcatlog
  lv_layout          TYPE slis_layout_alv,              "Layout
  lv_message         TYPE char100,                      "Messages
  lv_repid           TYPE sy-repid.                     "Report ID
*====================================================================*
*   Constants
*====================================================================*
CONSTANTS:  c_1        TYPE c          VALUE '1',       "Red Traffic Light
            c_3        TYPE c          VALUE '3',       "Green Traffic Light
            c_credat   TYPE rsscr_name VALUE 'CREDAT',  "Created on
            c_cretim   TYPE rsscr_name VALUE 'CRETIM',  "Created at
            c_docnum   TYPE rsscr_name VALUE 'DOCNUM',  "IDOC Number
            c_mescod   TYPE rsscr_name VALUE 'MESCOD',  "Logical Message Variant
            c_mesfct   TYPE rsscr_name VALUE 'MESFCT',  "Message function
            c_mestyp   TYPE rsscr_name VALUE 'MESTYP',  "Message Type
            c_status   TYPE rsscr_name VALUE 'STATUS',  "IDOC Status
            c_sndpfc   TYPE rsscr_name VALUE 'SNDPFC',  "Sender partn.funct.
            c_sndprn   TYPE rsscr_name VALUE 'SNDPRN',  "Sender partner no.
            c_sndprt   TYPE rsscr_name VALUE 'SNDPRT',  "Sender partner type
            c_p_pcksiz TYPE rsscr_name VALUE 'P_PCKSIZ'. "Pack. Size
