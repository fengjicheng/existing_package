*------------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_POPULATE_FTE_AS_SCALES                     *
* PROGRAM DESCRIPTION : Populate "Number of FTEs" as Scale Base Value    *
* DEVELOPER           : WROY (Writtick Roy)                              *
* CREATION DATE       : 06-DEC-2016                                      *
* OBJECT ID           : E075                                             *
* TRANSPORT NUMBER(S) : ED2K903315                                       *
*------------------------------------------------------------------------*
* REVISION HISTORY-------------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------------*
*========================================================================*
*                        WORK AREA DECLARATIONS                          *
*========================================================================*
DATA:
  lst_knvv TYPE knvv,                                 "Customer Master Sales Data
  lst_bgen TYPE but000.                               "BP: General data

CONSTANTS:
  lc_t_ind TYPE bu_type VALUE '1',                    "Business partner category: Person
  lc_t_org TYPE bu_type VALUE '2'.                    "Business partner category: Organization

*========================================================================*
*                           PROCESSING LOGIC                             *
*========================================================================*
* Fetch Customer Master Sales Data Details
CALL FUNCTION 'KNVV_SINGLE_READ'
  EXPORTING
    i_kunnr         = komk-kunwe                      "Ship-to Customer Number
    i_vkorg         = komk-vkorg                      "Sales Organization
    i_vtweg         = komk-vtweg                      "Distribution Channel
    i_spart         = komk-spart                      "Division
  IMPORTING
    o_knvv          = lst_knvv                        "Customer Master Sales Data
  EXCEPTIONS
    not_found       = 1
    parameter_error = 2
    kunnr_blocked   = 3
    OTHERS          = 4.
IF sy-subrc EQ 0.
  xkwert = lst_knvv-zzfte * 1000.                     "Scale base value of the condition
ENDIF.

IF lst_knvv-zzfte IS INITIAL.
* Fetch BP: General data Details
  CALL FUNCTION 'BUP_BUT000_SELECT_SINGLE'
    EXPORTING
      i_partner       = komk-kunwe                    "Ship-to Customer Number
      iv_req_mask     = space
    IMPORTING
      e_but000        = lst_bgen                      "BP: General data
    EXCEPTIONS
      not_found       = 1
      internal_error  = 2
      blocked_partner = 3
      OTHERS          = 4.
  IF sy-subrc EQ 0.
*   Check Business partner category
    CASE lst_bgen-type.
      WHEN lc_t_ind.                                  "Business partner category: Person
        lst_knvv-zzfte = '1'.
      WHEN lc_t_org.                                  "Business partner category: Organization
        lst_knvv-zzfte = '999999'.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
    xkwert = lst_knvv-zzfte * 1000.                   "Scale base value of the condition
  ENDIF.

ENDIF.
