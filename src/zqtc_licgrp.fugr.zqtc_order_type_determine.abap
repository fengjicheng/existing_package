FUNCTION zqtc_order_type_determine.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_OBJECTID) TYPE  ZDEVID DEFAULT 'E106'
*"     VALUE(IM_AUART) TYPE  AUART
*"  EXPORTING
*"     VALUE(EX_ACTIVE_FLAG) TYPE  CHAR1
*"     VALUE(EX_LICGRP) TYPE  BU_ID_TYPE
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_ORDER_TYPE_DETERMINE
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move LICENSE
*                      GROUP into the sales header workaerea VBAK
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   09/02/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K904422
*----------------------------------------------------------------------*

  TYPES:
    BEGIN OF lty_constant,
      devid  TYPE zdevid,                                      " Development ID
      param1 TYPE rvari_vnam,                                  " ABAP: Name of Variant Variable
      param2 TYPE rvari_vnam,                                  " ABAP: Name of Variant Variable
      srno   TYPE tvarv_numb,                                  " ABAP: Current selection number
      sign   TYPE tvarv_sign,                                  " ABAP: ID: I/E (include/exclude values)
      opti   TYPE tvarv_opti,                                  " ABAP: Selection option (EQ/BT/CP/...)
      low    TYPE salv_de_selopt_low,                          " Lower Value of Selection Condition
    END OF lty_constant,
    BEGIN OF lty_auart,
      sign   TYPE tvarv_sign,                                  " Sign
      option TYPE tvarv_opti,                                  " Option
      low    TYPE auart,                                       " Doc type
      high   TYPE auart,                                       " Doc type
    END OF lty_auart,

    ltt_auart TYPE STANDARD TABLE OF lty_auart INITIAL SIZE 0. " Doc type

  DATA :
    li_constant TYPE STANDARD TABLE OF
                lty_constant INITIAL SIZE 0, " Constant tab
    lr_auart    TYPE ltt_auart,              " Doc type
    lst_auart   TYPE lty_auart.              " Doc type range table


* fetch constant table entry.
  SELECT devid        " Development ID
         param1       " ABAP: Name of Variant Variable
         param2       " ABAP: Name of Variant Variable
         srno         " ABAP: Current selection number
         sign         " ABAP: ID: I/E (include/exclude values)
         opti         " ABAP: Selection option (EQ/BT/CP/...)
         low          " Lower Value of Selection Condition
     FROM zcaconstant " Wiley Application Constant Table
     INTO TABLE li_constant
     WHERE devid    EQ im_objectid
       AND activate EQ abap_true.

  IF sy-subrc EQ 0.
    SORT li_constant BY devid param1 param2 low.
  ENDIF. " IF sy-subrc EQ 0

  LOOP AT li_constant INTO DATA(lst_constant).

    CASE lst_constant-param1.
* Range table population for different document type
      WHEN c_auart.
        lst_auart-sign = lst_constant-sign .
        lst_auart-option = lst_constant-opti.
        lst_auart-low = lst_constant-low.
        APPEND lst_auart TO lr_auart.
        CLEAR lst_auart.

* License group population
      WHEN c_type.
        ex_licgrp = lst_constant-low.

      WHEN OTHERS.


    ENDCASE.

    CLEAR : lst_constant.
  ENDLOOP. " LOOP AT li_constant INTO DATA(lst_constant)

* If current document type and document type maintain in constant
* table matches then populate flax as X
  IF im_auart IN lr_auart.

    ex_active_flag = abap_true.

  ENDIF. " IF im_auart IN lr_auart



ENDFUNCTION.
