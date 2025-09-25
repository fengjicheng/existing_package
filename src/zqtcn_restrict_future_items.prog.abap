***-------------------------------------------------------------------*
*** PROGRAM NAME: RV50B901
*** PROGRAM DESCRIPTION: Routine for the check of conditions
*** DEVELOPER:Sarada Mukherjee
*** CREATION DATE:2017-01-30
*** OBJECT ID:E150
*** TRANSPORT NUMBER(S):ED2K904220
***-------------------------------------------------------------------*
**
*** REVISION HISTORY--------------------------------------------------*
*** REVISION NO: ED2K911455
*** REFERENCE NO: ERP-7187
*** DEVELOPER: Writtick Roy (WROY)
*** DATE:  2018-03-19
*** DESCRIPTION: Check if the Date field is populated
***-------------------------------------------------------------------*
*&--------------------------------------------------------------------*
*&  Include           ZQTCN_RESTRICT_FUTURE_ITEMS
*&--------------------------------------------------------------------*

* Local Type declaration
TYPES: BEGIN OF ty_mara,
         matnr            TYPE matnr,          "Material Number
         mtart            TYPE mtart,          "Material Type
         ismpubldate      TYPE ismpubldate,    "Publication Date
         isminitshipdate  TYPE ismerstverdat,  "Initial Shipping Date
         ismarrivaldateac TYPE ismanlftagi,    "Actual Goods Arrival Date
       END OF ty_mara,

       BEGIN OF lty_constant,
         devid  TYPE zdevid,              " Development ID
         param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         srno   TYPE tvarv_numb,          " ABAP: Current selection number
         sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
       END OF lty_constant,
* Local range type declaration
       ltt_journ_r  TYPE RANGE OF mtart,
       ltt_njourn_r TYPE RANGE OF mtart.
* Local data declaration
DATA: lst_mara     TYPE ty_mara,
      li_constant  TYPE STANDARD TABLE OF lty_constant INITIAL SIZE 0,
      lir_journ    TYPE ltt_journ_r,
      lir_njourn   TYPE ltt_njourn_r,
      lst_constant TYPE lty_constant,
      lst_journ    TYPE LINE OF ltt_journ_r,
      lst_njourn   TYPE LINE OF ltt_njourn_r.
* Local Constant declaration
CONSTANTS: lc_devid         TYPE zdevid     VALUE 'E150',
           lc_param1        TYPE rvari_vnam VALUE 'MTART',
           lc_paran2_journ  TYPE rvari_vnam VALUE 'JOURNAL',
           lc_paran2_njourn TYPE rvari_vnam VALUE 'NON-JOURNAL'.

CLEAR: lst_mara, li_constant[], lir_journ[], lir_njourn[].

* Selecting material data
SELECT SINGLE m~matnr                   "Material Number
              m~mtart                   "Material Type
              m~ismpubldate             "Publication Date
              m~isminitshipdate         "Initial Shipping Date
              c~ismarrivaldateac        "Actual Goods Arrival Date
  FROM mara AS m INNER JOIN
       marc AS c
    ON c~matnr EQ m~matnr
  INTO lst_mara
  WHERE m~matnr = cvbap-matnr
    AND c~werks = cvbap-werks.

IF sy-subrc = 0.
* Get the constant values from ZCACONSTANT Table
  SELECT devid                " Development ID
         param1               " ABAP: Name of Variant Variable
         param2               " ABAP: Name of Variant Variable
         srno                 " ABAP: Current selection number
         sign                 " ABAP: ID: I/E (include/exclude values)
         opti                 " ABAP: Selection option (EQ/BT/CP/...)
         low                  " Lower Value of Selection Condition
         high                 " Upper Value of Selection Condition
    FROM zcaconstant          " Wiley Application Constant Table
    INTO TABLE li_constant
    WHERE devid = lc_devid
    AND   param1 = lc_param1
    AND activate = abap_true. "Only active record

  IF sy-subrc IS INITIAL.
    LOOP AT li_constant INTO lst_constant.
* Populating range table for journal data
      IF lst_constant-param2 = lc_paran2_journ.
        lst_journ-sign    = lst_constant-sign.
        lst_journ-option  = lst_constant-opti.
        lst_journ-low     = lst_constant-low.
        lst_journ-high    = lst_constant-high.

        APPEND lst_journ TO lir_journ.
        CLEAR lst_journ.
      ENDIF.
* Populating range table for non journal data
      IF lst_constant-param2 = lc_paran2_njourn.
        lst_njourn-sign    = lst_constant-sign.
        lst_njourn-option  = lst_constant-opti.
        lst_njourn-low     = lst_constant-low.
        lst_njourn-high    = lst_constant-high.

        APPEND lst_njourn TO lir_njourn.
        CLEAR lst_njourn.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDIF.

* Delivery Item creation condition for Journals
IF lir_journ IS NOT INITIAL.
  IF lst_mara-mtart IN lir_journ.
* Checking Actual Goods Arrival date
*   Begin of DEL:ERP-7187:19-Mar-2018:ED2K911455
*   IF lst_mara-ismarrivaldateac GT sy-datum.
*   End   of DEL:ERP-7187:19-Mar-2018:ED2K911455
*   Begin of ADD:ERP-7187:19-Mar-2018:ED2K911455
    IF lst_mara-ismarrivaldateac IS INITIAL OR
       lst_mara-ismarrivaldateac EQ space   OR
       lst_mara-ismarrivaldateac GT sy-datum.
*   End   of ADD:ERP-7187:19-Mar-2018:ED2K911455
      bp_subrc = 4.
*     Begin of ADD:ERP-7187:19-Mar-2018:ED2K911455
*     Message: Media Issue &1 is not yet published!
      PERFORM message_handling(sapmv50a) USING cvbap-posnr
                                         '245'
                                         'E'
                                         'ZQTC_R2'
                                         cvbap-matnr
                                         space
                                         space
                                         space.
*     End   of ADD:ERP-7187:19-Mar-2018:ED2K911455
    ENDIF.
  ENDIF.
ENDIF.

* Delivery Item creation condition for Non Journals
IF lir_njourn IS NOT INITIAL.
  IF lst_mara-mtart IN lir_njourn.
* Checking Actual Goods Arrival date
*   Begin of DEL:ERP-7187:19-Mar-2018:ED2K911455
*   IF lst_mara-ismarrivaldateac GT sy-datum.
*   End   of DEL:ERP-7187:19-Mar-2018:ED2K911455
*   Begin of ADD:ERP-7187:19-Mar-2018:ED2K911455
    IF lst_mara-ismarrivaldateac IS INITIAL OR
       lst_mara-ismarrivaldateac EQ space   OR
       lst_mara-ismarrivaldateac GT sy-datum.
*   End   of ADD:ERP-7187:19-Mar-2018:ED2K911455
      bp_subrc = 4.
*     Begin of ADD:ERP-7187:19-Mar-2018:ED2K911455
*     Message: Media Issue &1 is not yet published!
      PERFORM message_handling(sapmv50a) USING cvbap-posnr
                                         '245'
                                         'E'
                                         'ZQTC_R2'
                                         cvbap-matnr
                                         space
                                         space
                                         space.
*     End   of ADD:ERP-7187:19-Mar-2018:ED2K911455
    ENDIF.
  ENDIF.
ENDIF.
