*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_POPULATE_ALEAUD_FIELDS
*               (User-Exit: Called from EXIT_SAPLBD11_001)
* PROGRAM DESCRIPTION: Populate Additional Fields for ALEAUD IDOC
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 10/02/2017
* OBJECT ID: I0229
* TRANSPORT NUMBER(S): ED2K907528
*----------------------------------------------------------------------*
DATA:
  li_idoc_numbers TYPE idoc_tt.                                      "IDOC Numbers

DATA:
  lst_seg_e1prtob TYPE e1prtob.                                      "Segment Data: E1PRTOB

CONSTANTS:
  lc_seg_e1prtob  TYPE edi_segnam VALUE 'E1PRTOB',                   "Segment Name: E1PRTOB
  lc_pipe_separtr TYPE char1      VALUE '|'.                         "Pipe Separator

LOOP AT idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data>).
  CASE <lst_idoc_data>-segnam.
    WHEN lc_seg_e1prtob.                                             "Segment Name: E1PRTOB
      lst_seg_e1prtob = <lst_idoc_data>-sdata.                       "Segment Data: E1PRTOB
      APPEND lst_seg_e1prtob-docnum TO li_idoc_numbers.              "IDOC Number
      CLEAR: lst_seg_e1prtob.
    WHEN OTHERS.
*     Nothing to do
  ENDCASE.
ENDLOOP.
IF li_idoc_numbers[] IS NOT INITIAL.
  SORT li_idoc_numbers BY table_line.
  DELETE ADJACENT DUPLICATES FROM li_idoc_numbers
                COMPARING table_line.
* Fetch Control record (IDoc)
  SELECT docnum,                                                     "IDoc number
         sndlad,                                                     "Logical address of sender
         arckey                                                      "EDI archive key
    FROM edidc
    INTO TABLE @DATA(li_idoc_cntrl_recs)
     FOR ALL ENTRIES IN @li_idoc_numbers
   WHERE docnum EQ @li_idoc_numbers-table_line.
  IF sy-subrc EQ 0.
    SORT li_idoc_cntrl_recs BY docnum.
  ENDIF.

  LOOP AT idoc_data ASSIGNING <lst_idoc_data>.
    CASE <lst_idoc_data>-segnam.
      WHEN lc_seg_e1prtob.                                           "Segment Name: E1PRTOB
        lst_seg_e1prtob = <lst_idoc_data>-sdata.
        READ TABLE li_idoc_cntrl_recs ASSIGNING FIELD-SYMBOL(<lst_idoc_cntrl_rec>)
             WITH KEY docnum = lst_seg_e1prtob-docnum                "IDOC Number
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          CLEAR: lst_seg_e1prtob-objkey.
          IF <lst_idoc_cntrl_rec>-sndlad IS NOT INITIAL.
            lst_seg_e1prtob-objkey = <lst_idoc_cntrl_rec>-sndlad.    "Logical address of sender
          ELSE.
            CONCATENATE space                                        "Place Holder-1
                        space                                        "Place Holder-2
                        space                                        "Place Holder-3
                        <lst_idoc_cntrl_rec>-arckey                  "EDI archive key
                   INTO lst_seg_e1prtob-objkey
              SEPARATED BY lc_pipe_separtr.
          ENDIF.
          <lst_idoc_data>-sdata = lst_seg_e1prtob.
        ENDIF.
        CLEAR: lst_seg_e1prtob.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF.
