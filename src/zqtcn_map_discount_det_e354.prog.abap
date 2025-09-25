*&---------------------------------------------------------------------*
* REVISION NO: ED2K926099 , ED2K927140
* PROGRAM NAME: ZQTCN_MAP_DISCOUNT_DET_E354
* REFRENCE NO  : ASOTC-266
* DEVELOPER    :    Ramesh N (RNARAYANAS)
* DATE : 03/25/2022
* OBJECT ID: E354
* DESCRIPTION: Map the caller data values to populate the KOMK & KOMP
*              pricing communication structures
*----------------------------------------------------------------------*

DATA : lst_item LIKE LINE OF it_item,              " Work area delartion for import table parameter
       lst_head TYPE if_piq_prepare=>ty_gs_head.

FIELD-SYMBOLS : <lfs_va1>         TYPE any,
                <lfs_komp_ass>    TYPE any,
                <lfs_caller_data> TYPE any.

* BOC by Ramesh on 05/03/2022 for ASOTC-226(ASOTC-700 defect) with ED2K927140  *
CONSTANTS: lc_pltyp TYPE dd03l-fieldname VALUE 'PLTYP',
           lc_waers TYPE dd03l-fieldname VALUE 'WAERS_BILL'.
* EOC by Ramesh on 05/03/2022 for ASOTC-226(ASOTC-700 defect) with ED2K927140  *

IF ct_komp_head_fields[] IS NOT INITIAL AND ct_komp[] IS NOT INITIAL .

  LOOP AT it_headitem INTO DATA(lst_hditm).                                      " Read header caller data
    READ TABLE ct_komp_head_fields ASSIGNING FIELD-SYMBOL(<lfs_str>) INDEX 1.    " read the first recod of header details
    IF <lfs_str> IS ASSIGNED.
      <lfs_str>-use_multival_attr = abap_true.
      UNASSIGN <lfs_str>.
    ENDIF.

    READ TABLE it_item INTO lst_item WITH KEY kposn = lst_hditm-kposn.            " Read the line item data and get the index
    IF sy-subrc = 0.
      DATA(lv_tabix) = sy-tabix.
    ENDIF.
    LOOP AT it_item INTO lst_item WHERE  kposn = lst_hditm-kposn.
      IF lst_item-kposn <> lst_hditm-kposn.
        EXIT.
      ENDIF.
      ASSIGN  lst_item-caller_data->* TO <lfs_caller_data>.                       " Based on index assign the caller data value to fieldsymbol for further processing
      CLEAR lst_item.
      EXIT.
    ENDLOOP.
  ENDLOOP.
  IF <lfs_caller_data> IS ASSIGNED AND <lfs_caller_data> IS NOT INITIAL.

    DATA(lo_strdesc)    = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( p_data = <lfs_caller_data> ) ).
    DATA(li_components) = lo_strdesc->get_components( ).    " Get the field name & value

    LOOP AT li_components INTO DATA(lst_components).        " Loop the caller data value to map the value to KOMP for the entered caller data
      READ TABLE ct_komp ASSIGNING FIELD-SYMBOL(<lfs_komp>) INDEX 1.
      IF <lfs_komp> IS ASSIGNED.
        ASSIGN COMPONENT lst_components-name OF STRUCTURE <lfs_caller_data> TO <lfs_va1>.
        ASSIGN COMPONENT lst_components-name OF STRUCTURE <lfs_komp>        TO <lfs_komp_ass>.
        IF <lfs_va1> IS ASSIGNED AND <lfs_komp_ass> IS ASSIGNED.
          <lfs_komp_ass> = <lfs_va1>.       " Assign caller data values to KOMP structure
          UNASSIGN : <lfs_komp_ass> , <lfs_va1>.
        ENDIF.
      ENDIF.
    ENDLOOP.

    CONDENSE : <lfs_komp>-zzaspromo , <lfs_komp>-zzassocpromo , <lfs_komp>-zzins_disc_p1 ,        " Remove all the blank spaces
               <lfs_komp>-zzins_disc_p2 ,<lfs_komp>-zzins_disc_v1 ,<lfs_komp>-zzins_disc_v2 NO-GAPS.
    UNASSIGN <lfs_komp>.
  ENDIF.
ENDIF.

* BOC by Ramesh on 05/03/2022 for ASOTC-226(ASOTC-700 defect) with ED2K927140  *
"Fill the header Price list and Currency
IF it_head[] IS NOT INITIAL AND ct_komk[] IS NOT INITIAL.

  "Check for exitsing caller data is assigned or not
  IF <lfs_caller_data> IS ASSIGNED.
    UNASSIGN <lfs_caller_data>.
  ENDIF.

  LOOP AT it_head INTO lst_head.
    ASSIGN  lst_head-caller_data->* TO <lfs_caller_data>.                       " Based on index assign the caller data value to fieldsymbol for further processing
    CLEAR lst_head.
    EXIT.
  ENDLOOP.

  IF <lfs_caller_data>  IS ASSIGNED AND <lfs_caller_data> IS NOT INITIAL.
    READ TABLE ct_komk ASSIGNING FIELD-SYMBOL(<lfs_komk>) INDEX 1.
    IF sy-subrc = 0.

      "Assign Price List value from caller data to KOMK structure
      ASSIGN COMPONENT lc_pltyp OF STRUCTURE  <lfs_caller_data> TO <lfs_va1>.
      IF sy-subrc = 0 AND <lfs_va1> IS NOT INITIAL AND <lfs_va1> IS ASSIGNED.
        <lfs_komk>-pltyp = <lfs_va1>.
        UNASSIGN <lfs_va1>.
      ENDIF.

      "Assign Currency from Caller data of Bill to Party  to KOMK structure
      ASSIGN COMPONENT lc_waers OF STRUCTURE  <lfs_caller_data> TO <lfs_va1>.
      IF sy-subrc = 0 AND <lfs_va1> IS NOT INITIAL AND <lfs_va1> IS ASSIGNED.
        <lfs_komk>-hwaer = <lfs_va1>.
        <lfs_komk>-waerk = <lfs_va1>.
        UNASSIGN <lfs_va1>.
      ENDIF.
      UNASSIGN <lfs_komk>.

    ENDIF.
  ENDIF.
ENDIF.

* EOC by Ramesh on 05/03/2022 for ASOTC-226(ASOTC-700 defect) with ED2K927140  *
