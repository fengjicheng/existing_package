*&-----------------------------------------------------------------------*
*&  Include           ZQTCN_MAT_CONV_PIV_TO_SAP
*&-----------------------------------------------------------------------*
* PROGRAM DESCRIPTION : Convert Legacy Material (IB13) to SAP Material   *
*                       Pass default values for E1KONP,E1KOMG fields     *
*                       Condition type mapping from PIV to SAP           *
* DEVELOPER           : VMAMILLAPA (Vamsi Mamillapalli)                  *
* CREATION DATE       : 2022-02-17                                       *
* OBJECT ID           : I0502.1/EAM-3116                                 *
* TRANSPORT NUMBER(S) : ED2K926349                                       *
*------------------------------------------------------------------------*
*========================================================================*
*                         VARIABLE DECLARATIONS                          *
*========================================================================*
DATA:
  lv_sap_mat        TYPE matnr,                         "SAP Material Number
  lst_data_e1komg1  TYPE e1komg,                        "KOMG Idoc data
  lst_data_e1konp   TYPE e1konp,                        "KOMG Idoc data
  lst_z1qtc_komg_02 TYPE z1qtc_komg_02,                 "Z1QTC_KOMG_02 Idoc data
  lv_access_prg     TYPE progname,                      "Access Program Name
  lst_komg1         TYPE komg.                          "Allowed Fields for Condition Structures
*========================================================================*
*                         CONSTANT DECLARATIONS                          *
*========================================================================*
CONSTANTS:
  lc_devid         TYPE zdevid     VALUE 'I0502.1',       "Development ID
  lc_publ_typ_tab  TYPE rvari_vnam VALUE 'PUBL_TYP_TABLE', "Publication Type table name
  lc_vkorg         TYPE rvari_vnam VALUE 'VKORG',         "Sales Org
  lc_vtweg         TYPE rvari_vnam VALUE 'VTWEG',         "Distribution channel
  lc_seg_e1komg    TYPE edilsegtyp VALUE 'E1KOMG',        "Segment type: E1KOMG
  lc_seg_e1konp    TYPE edilsegtyp VALUE 'E1KONP',        "Segment type: E1KONP
  lc_z1qtc_komg_02 TYPE edilsegtyp VALUE 'Z1QTC_KOMG_02', "Segment type: Z1QTC_KOMG_02
  lc_msgid         TYPE SYST_MSGID VALUE 'ZQTC_R2',       "Message class
  lc_s             TYPE SYST_MSGTY VALUE 'S'.             " Message type
*========================================================================*
*                            PROCESSING LOGIC                            *
*========================================================================*
CLEAR:lst_data_e1komg1.
LOOP AT idoc_contrl ASSIGNING FIELD-SYMBOL(<lst_idoc_contrl1>).
  LOOP AT idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data1>)
    WHERE docnum EQ <lst_idoc_contrl1>-docnum.
    CASE <lst_idoc_data1>-segnam.                        "Segment type
      WHEN lc_seg_e1komg.
        lst_data_e1komg1 = <lst_idoc_data1>-sdata.        "Filter segment with separated condition key

        IF lst_data_e1komg1-matnr IS NOT INITIAL.
          DATA(lv_leg_mat) = lst_data_e1komg1-matnr.      "Identification Code (Legacy Material)
          CLEAR:lv_sap_mat.
          SELECT SINGLE matnr " Material Number
            INTO lv_sap_mat
            FROM mara " Material Master
            WHERE bismt = lv_leg_mat. " Old Material number
          IF sy-subrc IS INITIAL.
            lst_data_e1komg1-matnr = lv_sap_mat.    "SAP Material Number
*            Get Constants from ZCAINTEG_MAPPING
            zca_utilities=>get_integ_constants( EXPORTING im_devid = lc_devid
                                                IMPORTING et_constants = DATA(li_const_502) ).
            IF line_exists( li_const_502[ param1 = lc_vkorg ] ) AND line_exists( li_const_502[ param1 = lc_vtweg ] ).
              DATA(lv_vkorg_502) = CONV vkorg( li_const_502[ param1 = lc_vkorg ]-sap_value ).
              DATA(lv_vtweg_502) = CONV vtweg( li_const_502[ param1 = lc_vtweg ]-sap_value ).
              SELECT SINGLE mvgr4 "Material group 4
                FROM mvke "Sales Data for Material
                INTO @DATA(lv_mvgr4)
                WHERE matnr = @lv_sap_mat
                AND vkorg = @lv_vkorg_502
                AND vtweg = @lv_vtweg_502.
              IF sy-subrc IS INITIAL.
                SELECT kbetr
                  INTO @DATA(lv_tax)
                  FROM zqtc_taxcal
                  UP TO 1 ROWS
                  WHERE vkorg = @lv_vkorg_502
                  AND vtweg = @lv_vtweg_502
                  AND mvgr4 = @lv_mvgr4
                  AND datab LE @sy-datum
                  AND datbi GE @sy-datum.
                ENDSELECT.
                IF sy-subrc IS INITIAL.

                ENDIF.
              ENDIF.
            ENDIF.
*          Get Publication type
*            Check If publication type is needed for the Condition table
            IF line_exists( li_const_502[ param1 = lc_publ_typ_tab sap_value = lst_data_e1komg1-kotabnr ] )
               AND line_exists( idoc_data[ segnam = lc_z1qtc_komg_02 ] ).
              lst_z1qtc_komg_02 = idoc_data[ segnam = lc_z1qtc_komg_02 ]-sdata.
              DATA(lv_ismpubltype) =  lst_z1qtc_komg_02-ismpubltype.
              IF lv_ismpubltype IS INITIAL.
*                  Message: Please provide publication type
                MESSAGE e264(zqtc_r2) INTO DATA(lv_msg_txt2).
                DATA(lv_err) = abap_true.
              ENDIF.
            ENDIF.
*            Build Variable key
*          * Get the Access Program Name
            PERFORM set_access_program(sapmv130)
              USING lst_data_e1komg1-kvewe
                    lst_data_e1komg1-kotabnr
                    lv_access_prg.
            IF lv_access_prg IS NOT INITIAL.
*    *   Map fields from Communication structure to Variable Key
              MOVE-CORRESPONDING lst_data_e1komg1 TO lst_komg1.
              lst_komg1-zzismpubltype = lv_ismpubltype. " Publication Type
              lst_komg1-bsark = lst_data_e1komg1-bsart. " PO Type
              PERFORM fill_vakey_from_komg IN PROGRAM (lv_access_prg)
                USING lst_data_e1komg1-vakey_long
                      lst_komg1.
              IF strlen( lst_data_e1komg1-vakey_long ) LE 50.
                lst_data_e1komg1-vakey = lst_data_e1komg1-vakey_long.
              ENDIF.
            ENDIF.

            <lst_idoc_data1>-sdata = lst_data_e1komg1.    "Modify the Idoc segment E1KOMG

          ELSE.
**           Message: Invalid material number
            MESSAGE e167(ftr_tex1) WITH lv_leg_mat INTO DATA(lv_msg_txt1).
            lv_err = abap_true.
          ENDIF.
        ENDIF.

        IF lv_err IS NOT INITIAL.
*         Fehlerfall:  WF-Result setzen
          return_variables-doc_number = <lst_idoc_contrl1>-docnum.
          return_variables-wf_param = c_wf_par_error_idocs.
          APPEND return_variables.
          workflow_result = c_wf_result_error.
*         IN CASE OF ERROR NO SERIALIZATION CHECK
          REFRESH serialization_info.
*        Fill error info in IDOC status
          APPEND INITIAL LINE TO idoc_status ASSIGNING FIELD-SYMBOL(<lst_idoc_status1>).
          <lst_idoc_status1>-docnum = <lst_idoc_contrl1>-docnum.
          <lst_idoc_status1>-msgid  = sy-msgid.
          <lst_idoc_status1>-msgty  = sy-msgty.
          <lst_idoc_status1>-msgno  = sy-msgno.
          <lst_idoc_status1>-msgv1  = sy-msgv1.
          <lst_idoc_status1>-msgv2  = sy-msgv2.
          <lst_idoc_status1>-msgv3  = sy-msgv3.
          <lst_idoc_status1>-msgv4  = sy-msgv4.
          <lst_idoc_status1>-repid  = sy-repid.
          <lst_idoc_status1>-uname  = sy-uname.
          <lst_idoc_status1>-status = c_idoc_status_error.
          UNASSIGN: <lst_idoc_status1>.
        ENDIF.
      WHEN lc_seg_e1konp.
        lst_data_e1konp = <lst_idoc_data1>-sdata.
        IF lv_tax IS NOT INITIAL.
          DATA(lv_taxamount) =  CONV kbetr( ( lv_tax * lst_data_e1konp-kbetr ) / ( lv_tax + 100 ) ).
          lst_data_e1konp-kbetr = ( CONV kbetr( lst_data_e1konp-kbetr ) ) - lv_taxamount.
          <lst_idoc_data1>-sdata =  lst_data_e1konp.
*        Fill status info in IDOC status
          APPEND INITIAL LINE TO idoc_status ASSIGNING <lst_idoc_status1>.
          <lst_idoc_status1>-docnum = <lst_idoc_contrl1>-docnum.
          <lst_idoc_status1>-msgid  = lc_msgid.
          <lst_idoc_status1>-msgty  = lc_s.
          <lst_idoc_status1>-msgno  = 265.
          <lst_idoc_status1>-msgv1  = lv_tax.
          <lst_idoc_status1>-repid  = sy-repid.
          <lst_idoc_status1>-uname  = sy-uname.
          <lst_idoc_status1>-status = c_idoc_status_ok.
          UNASSIGN: <lst_idoc_status1>.
        ENDIF.
    ENDCASE.
  ENDLOOP.
ENDLOOP.

* No further processing in case of Error
READ TABLE idoc_status TRANSPORTING NO FIELDS
     WITH KEY status = c_idoc_status_error.
IF sy-subrc EQ 0.
  RETURN.
ENDIF.
