*&---------------------------------------------------------------------*
*&  Include           ZDUMMI_TOP
*&---------------------------------------------------------------------*
  TYPES : BEGIN OF ty_t685a,
            kappl TYPE kappl,         " Application
            kschl TYPE kschl,         " Condition type
            krech TYPE krech,         " Calculation type for condition
            kzbzg TYPE kzbzg,         " Scale basis indicator
            stfkz TYPE stfkz,         " Scale Type
          END OF ty_t685a,

          BEGIN OF ty_fields,
            fld_name TYPE char20,     " Name of type CHAR20
            index    TYPE syst_tabix, " ABAP System Field: Loop Index
            convexit TYPE convexit,   " Conversion Routine
          END OF ty_fields,

          BEGIN OF ty_status,
            fin_message_alv TYPE fin_message_alv, " Message
            vvis_lights     TYPE  vvis_lights,    "Field: Rate unit (currency or percentage)
          END OF ty_status.

*&---------------------------------------------------------------------*
*&  Work Declaration
*&---------------------------------------------------------------------*
  DATA : st_t685a TYPE ty_t685a,
         st_edidc TYPE edidc. " Control record (IDoc)

*&---------------------------------------------------------------------*
*&   Internal Table Declaration
*&---------------------------------------------------------------------*
  DATA : i_fields TYPE STANDARD TABLE OF ty_fields INITIAL SIZE 0,
         i_fcat   TYPE STANDARD TABLE OF lvc_s_fcat INITIAL SIZE 0. " ALV control: Field catalog

*&---------------------------------------------------------------------*
*&   Object Declaration
*&---------------------------------------------------------------------*
  DATA: obj_alv      TYPE REF TO cl_gui_alv_grid,     " ALV List Viewer
        obj_stdesc_d TYPE REF TO cl_abap_structdescr. " Runtime Type Services                            " Runtime Type Services

*&---------------------------------------------------------------------*
*&   Field Symbol Declaration
*&---------------------------------------------------------------------*
  FIELD-SYMBOLS:<st_cond_rc> TYPE any,
                <i_cond_rcs> TYPE STANDARD TABLE.

*&---------------------------------------------------------------------*
*&  C O N S T A N T S
*&---------------------------------------------------------------------*
  CONSTANTS: c_field       TYPE dynfnam   VALUE 'P_FILE',          "Field name
             c_rucomm      TYPE syucomm   VALUE 'RUCOMM',          "Function Code
             c_onli        TYPE syucomm   VALUE 'ONLI',            "Function Code
             c_separator   TYPE char1     VALUE ',',               "Separator of type Character
             c_kvewe_a     TYPE kvewe     VALUE 'A',               "Usage of the condition table
             c_alv_light_3 TYPE char1     VALUE '3',               "3 of type CHAR1
             c_alv_light_1 TYPE char1     VALUE '1',               "1 of type CHAR1
             c_msgid       TYPE symsgid   VALUE 'ZQTC_R2',         "Message Class
             c_msg_type_i  TYPE symsgty   VALUE 'I',               "Message Type
             c_msg_type_e  TYPE symsgty   VALUE 'E',               "Message Type
             c_fld_mandt   TYPE fieldname VALUE 'MANDT',           "Field: Client
             c_fld_kappl   TYPE fieldname VALUE 'KAPPL',           "Field: Application
             c_fld_kfrst   TYPE fieldname VALUE 'KFRST',           "Field: Release status
             c_fld_datbi   TYPE fieldname VALUE 'DATBI',           "Field: Validity end date of the condition record
             c_fld_datab   TYPE fieldname VALUE 'DATAB',           "Field: Validity start date of the condition record
* Begin of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023
*                 c_fld_knumaag TYPE fieldname VALUE 'KNUMA_AG',        "Field: Sales deal
             c_fld_kosrt   TYPE fieldname VALUE 'KOSRT',           "Field: Search Term
* END   of CHANGE:CR#512:WROY:11-MAY-2017:ED2K906023
             c_fld_kstbm   TYPE fieldname VALUE 'KSTBM',           "Field: Condition scale quantity
             c_fld_kbetr   TYPE fieldname VALUE 'KBETR',           "Field: Rate (condition amount or percentage)
             c_fld_konwa   TYPE fieldname VALUE 'KONWA',           "Field: Rate unit (currency or percentage)
             c_fld_kpein   TYPE fieldname VALUE 'KPEIN',           "Field: Condition pricing unit
             c_fld_kmein   TYPE fieldname VALUE 'KMEIN',           "Field: Condition unit
             c_fld_indictr TYPE fieldname VALUE 'VVIS_LIGHTS',     "Field: Rate unit (currency or percentage)
             c_fld_idoc    TYPE fieldname VALUE 'DOCNUM',          "Field: Rate unit (currency or percentage)
             c_fld_msg     TYPE fieldname VALUE 'FIN_MESSAGE_ALV', "Field: Rate unit (currency or percentage)
             c_fld_stfkz   TYPE fieldname VALUE 'STFKZ',           "Field: Sale Type "++ VDPATABALL Adding new filed 08/21/2020
             c_fld_konms   TYPE fieldname VALUE 'KONMS'.           "Field: Sale Unit "++ VDPATABALL Adding new filed 08/21/2020
