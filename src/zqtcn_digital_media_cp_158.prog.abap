*----------------------------------------------------------------------*
* PROGRAM NAME:         FILTER_BDCPV_BEFORE_WRITE                      *
* PROGRAM DESCRIPTION:  BADi to determine whether the material type is *
*                       ZJID and if there is any change in the actual  *
*                       goods arrival date. If not then we will        *
*                       clear the change pointer entry to restrict from*
*                       BDCP2 entry.                                   *
* DEVELOPER:            MMUKHERJEE                                     *
* CREATION DATE:        18/04/2017                                     *
* OBJECT ID:            I158                                           *
* TRANSPORT NUMBER(S):  ED2K905426,ED2K905437(C)                       *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
    CONSTANTS:
      lc_fieldname_date TYPE fieldname  VALUE 'ISMARRIVALDATEAC', " Field Name
      lc_fieldname_key  TYPE fieldname  VALUE 'KEY',              " Field Name
      lc_param_mtart    TYPE rvari_vnam VALUE 'MTART',            " ABAP: Name of Variant Variable
      lc_initial_date   TYPE cdfldvalo  VALUE '00000000',         " Initial Date
      lc_devid          TYPE zdevid     VALUE 'E158'.             " Development ID

    DATA:
      lst_marc_key      TYPE bdimarckey.

    DATA:
      li_marc_keys      TYPE bdimarckey_tab,
      lir_material_type TYPE fip_t_mtart_range.



    SELECT devid,                   " Development ID
           param1,                  " ABAP: Name of Variant Variable
           param2,                  " ABAP: Name of Variant Variable
           srno,                    " ABAP: Current selection number
           sign,                    " ABAP: ID: I/E (include/exclude values)
           opti,                    " ABAP: Selection option (EQ/BT/CP/...)
           low,                     " Lower Value of Selection Condition
           high                     " Upper Value of Selection Condition
      FROM zcaconstant              " Wiley Application Constant Table
      INTO TABLE @DATA(li_constant)
     WHERE devid    EQ @lc_devid    "'E158'
       AND activate EQ @abap_true.
    IF sy-subrc EQ 0.
      LOOP AT li_constant  ASSIGNING FIELD-SYMBOL(<lst_constant>).
        CASE <lst_constant>-param1.
          WHEN lc_param_mtart. "'MTART'.
            APPEND INITIAL LINE TO lir_material_type ASSIGNING FIELD-SYMBOL(<lst_mat_type>).
            <lst_mat_type>-sign   = <lst_constant>-sign.
            <lst_mat_type>-option = <lst_constant>-opti.
            <lst_mat_type>-low    = <lst_constant>-low.
            <lst_mat_type>-high   = <lst_constant>-high.

        ENDCASE.
      ENDLOOP. " LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<fs_constant>)
    ENDIF. " IF sy-subrc EQ 0

    LOOP AT change_pointers ASSIGNING FIELD-SYMBOL(<lst_change_pointer>).
      lst_marc_key = <lst_change_pointer>-tabkey.
      APPEND lst_marc_key TO li_marc_keys.
      CLEAR: lst_marc_key.
    ENDLOOP.

    IF li_marc_keys IS NOT INITIAL.
*     Fetch General and Plant Data for Material
      SELECT a~matnr,                    " Material Number
             a~mtart,                    " Material Type
             c~werks,                    " Plant
             c~ismarrivaldateac          " Goods Arrival Date
        FROM mara AS a INNER JOIN        " General Material Data
             marc AS c                   " Plant Data for Material
          ON c~matnr EQ a~matnr
        INTO TABLE @DATA(li_mara_marc)
         FOR ALL ENTRIES IN @li_marc_keys
       WHERE a~matnr EQ @li_marc_keys-matnr
         AND c~werks EQ @li_marc_keys-werks
         AND a~mtart IN @lir_material_type. " 'ZJID'.
      IF sy-subrc EQ 0.
        SORT li_mara_marc BY matnr werks.
      ENDIF.

      LOOP AT change_pointers ASSIGNING <lst_change_pointer>.
        lst_marc_key = <lst_change_pointer>-tabkey.
        CASE <lst_change_pointer>-fldname.
          WHEN lc_fieldname_key.
            READ TABLE li_mara_marc INTO DATA(lst_mara_marc)
                 WITH KEY matnr = lst_marc_key-matnr
                          werks = lst_marc_key-werks
                 BINARY SEARCH.
            IF sy-subrc NE 0 OR
               lst_mara_marc-ismarrivaldateac IS INITIAL.
              CLEAR: <lst_change_pointer>-mestype.
            ENDIF.

          WHEN lc_fieldname_date.
            READ TABLE li_mara_marc INTO lst_mara_marc
                 WITH KEY matnr = lst_marc_key-matnr
                          werks = lst_marc_key-werks
                 BINARY SEARCH.
            IF sy-subrc EQ 0.
              READ TABLE change_document_positions INTO DATA(lst_cdpos)
                   WITH KEY objectclas = change_document_header-objectclas
                            objectid   = change_document_header-objectid
                            fname      = lc_fieldname_date . "'ISMARRIVALDATEAC'.
*             Binary Search is not required as number of entries will be very less
*             Change Pointer should be triggered only for the First Time Change
*             (Blank value to a Non-blank value)
              IF sy-subrc EQ 0 AND
                 lst_cdpos-value_old NE lc_initial_date.
                IF lst_cdpos-value_old IS NOT INITIAL.
                  CLEAR: <lst_change_pointer>-mestype.
                ENDIF.
              ENDIF.
            ELSE.
              CLEAR: <lst_change_pointer>-mestype.
            ENDIF.
        ENDCASE.
        CLEAR: lst_mara_marc,
               lst_cdpos.
      ENDLOOP.
      DELETE change_pointers WHERE mestype IS INITIAL.
    ENDIF.
