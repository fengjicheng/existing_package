class ZCA_UTILITIES definition
  public
  final
  create public .

public section.

  types ITY_ZCACONSTANT type ZTCA_CACONSTANTS .

  class-data I_ZCACONSTANT type ITY_ZCACONSTANT .

  class-methods GET_CONSTANTS
    importing
      value(IM_DEVID) type ZDEVID
      value(IM_PARAM1) type RVARI_VNAM optional
      value(IM_PARAM2) type RVARI_VNAM optional
      value(IM_ACTIVATE) type ZCONSTACTIVE default 'X'
    exporting
      value(ET_CONSTANTS) type ZTCA_CACONSTANTS .
  class-methods GET_INTEG_CONSTANTS
    importing
      !IM_DEVID type ZDEVID
      !IM_PARAM1 type RVARI_VNAM optional
      !IM_PARAM2 type RVARI_VNAM optional
      !IM_ACTIVATE type ZCONSTACTIVE optional
    exporting
      !ET_CONSTANTS type ZTCA_INTEG_MAPPING .
protected section.
private section.
ENDCLASS.



CLASS ZCA_UTILITIES IMPLEMENTATION.


  METHOD get_constants.
    DATA:lr_param1 TYPE RANGE OF rvari_vnam,
         lr_param2 TYPE RANGE OF rvari_vnam.

    CONSTANTS:lc_i  TYPE char1 VALUE 'I',
              lc_eq TYPE char2 VALUE 'EQ'.

    IF im_param1 IS NOT INITIAL.
      lr_param1 = VALUE #( ( sign = lc_i option = lc_eq low = im_param1 high = space ) ).
    ENDIF.
    IF im_param2 IS NOT INITIAL.
      lr_param2 = VALUE #( ( sign = lc_i option = lc_eq low = im_param2 high = space ) ).
    ENDIF.

    SELECT *
      FROM zcaconstant
      INTO TABLE i_zcaconstant
      WHERE devid    =  im_devid
        AND param1   IN lr_param1
        AND param2   IN lr_param2
        AND activate =  im_activate.
    IF sy-subrc = 0.
      et_constants[] = i_zcaconstant[].
    ENDIF.


  ENDMETHOD.


  METHOD get_integ_constants.
*-----------------------------------------------------------------------*
* METHOD              : GET_INTEG_CONSTANTS                             *
* METHOD DESCRIPTION  : Method to return Interface Constants from       *
*                       ZCAINTEG_MAPPING table                          *
* DEVELOPER           : VMAMILLAPA (Vamsi Mamillapalli)                 *
* CREATION DATE       : 2022-03-30                                      *
* OBJECT ID           : I0502.1/EAM-3116                                *
* TRANSPORT NUMBER(S) : ED2K925808                                      *
*-----------------------------------------------------------------------*
* Local Constants Declaration
    CONSTANTS:lc_devid  TYPE fieldname VALUE 'DEVID',   " Dev id
              lc_param1 TYPE fieldname VALUE 'PARAM1',  " Param1
              lc_param2 TYPE fieldname VALUE 'PARAM2',  " Param2
              lc_active TYPE fieldname VALUE 'ACTIVATE', " ACtive Flag
              lc_eq     TYPE char2     VALUE 'EQ'.      " Operator

* Local Variables declaration
    DATA:li_cond  TYPE hrtb_cond,
         lst_cond TYPE hrcond,
         li_where TYPE j_3r_it_where.

    li_cond = VALUE #( ( field = lc_devid opera = lc_eq low = im_devid ) ). " Dev id
    IF im_param1 IS NOT INITIAL.
      lst_cond = VALUE #( field = lc_param1 opera = lc_eq low = im_param1 )." Param1
      APPEND lst_cond TO li_cond.
      CLEAR lst_cond.
    ENDIF.
    IF im_param2 IS NOT INITIAL.
      lst_cond = VALUE #( field = lc_param2 opera = lc_eq low = im_param2 )." Param2
      APPEND lst_cond TO li_cond.
      CLEAR lst_cond.
    ENDIF.
    IF im_activate IS NOT INITIAL.
      lst_cond = VALUE #( field = lc_active opera = lc_eq low = im_activate )." ACtive Flag
      APPEND lst_cond TO li_cond.
      CLEAR lst_cond.
    ENDIF.
    CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
      EXPORTING
        dbtable         = space " can be empty
      TABLES
        condtab         = li_cond
        where_clause    = li_where
      EXCEPTIONS
        empty_condtab   = 01
        no_db_field     = 02
        unknown_db      = 03
        wrong_condition = 04.
    IF sy-subrc IS INITIAL.
      SELECT param1,      " Param1
             param2,      " Param2
             srno,        " Serial Num
             legacy_value," Legacy value
             sap_value,   " SAP Value
             description  " Description
      FROM zcainteg_mapping " Integration constants
      INTO TABLE @et_constants
      WHERE (li_where).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
