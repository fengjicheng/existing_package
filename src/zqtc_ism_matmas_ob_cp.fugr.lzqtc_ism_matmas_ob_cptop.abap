*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K917822
* REFERENCE NO:  ERPM-1974
* DEVELOPER:     Gopalakrishna K(GKAMMILI)
* DATE:          03/20/2016
* DESCRIPTION:   Adding Subtitle1 field in Change pointers
*----------------------------------------------------------------------*
FUNCTION-POOL zqtc_ism_matmas_ob_cp.        "MESSAGE-ID ..

* INCLUDE LZQTC_ISM_MATMAS_OB_CPD...         " Local class definition

DATA:
  i_cpident_mat TYPE ztqtc_cpident_mat,
  i_chgptrs     TYPE bdcp_tab.

CONSTANTS:
  c_mtyp_matmas TYPE edi_mestyp  VALUE 'ISM_MATMAS',
  c_s_e1maram   TYPE edilsegtyp  VALUE 'E1MARAM',
  c_s_e1maraism TYPE edilsegtyp  VALUE 'E1MARAISM',
  c_s_e1marcm   TYPE edilsegtyp  VALUE 'E1MARCM',
  c_s_e1marcism TYPE edilsegtyp  VALUE 'E1MARCISM',
  c_table_mara  TYPE tabname     VALUE 'MARA',
  c_table_marc  TYPE tabname     VALUE 'MARC',
  c_field_matnr TYPE fieldname   VALUE 'MATNR',
  c_field_mtart TYPE fieldname   VALUE 'MTART',
  c_field_werks TYPE fieldname   VALUE 'WERKS',
*--BOC:ERPM-1974: GKAMMILI ED2K917822
  c_field_subtitle TYPE fieldname VALUE 'ISMSUBTITLE1'.
*--EOC:ERPM-1974: GKAMMILI ED2K917822
