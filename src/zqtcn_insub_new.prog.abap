*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INSUB_NEW
*&---------------------------------------------------------------------*
*  used Imp.BADI-method IF_EX_IDOC_DATA_MAPPER~PROCESS.
*----------------------------------------------------------------------*
* REVISION NO: ED2K926194 ---------------------------------------------*
* REFERENCE NO: OTCM-54171/2 (I0230)
* DEVELOPER: Polina Nageswara / Bharat kumar saki (bsaki) / Raj
* DATE: 18-April-2022
* DESCRIPTION: Item partner segment data removing if the header partner
*              segment data is same ship-to-party(WE) because
*              Contact names changing between times of invoice generation
*----------------------------------------------------------------------*

    "IDoc constants
    CONSTANTS :
      lc_we      TYPE parvw VALUE 'WE',
      lc_e1edka1 TYPE edidd-segnam VALUE 'E1EDKA1',
      lc_e1edpa1 TYPE edidd-segnam VALUE 'E1EDPA1',
      lc_parvw   TYPE fieldname VALUE 'PARVW',
      lc_partn   TYPE fieldname VALUE 'PARTN',
      lc_save_type VALUE 'V' ,lc_e VALUE 'E'.

    " Data Declarations for IDoc Segments
    DATA : lst_e1edka1 TYPE e1edka1,
           lst_e1edpa1 TYPE e1edpa1.

    LOOP AT data INTO DATA(lst_data) WHERE segnam = lc_e1edka1.
      lst_e1edka1 = lst_data-sdata.
      IF lst_e1edka1-parvw = lc_we .
        LOOP AT data ASSIGNING FIELD-SYMBOL(<lfs_data>) WHERE segnam = lc_e1edpa1 .
          lst_e1edpa1    = <lfs_data>-sdata.
          IF ( lst_e1edka1-parvw = lc_we AND lst_e1edpa1-parvw = lc_we ) AND
             ( lst_e1edpa1-partn = lst_e1edka1-partn ).
            mapping_tab = VALUE tab_ichang( ( segnum = <lfs_data>-segnum feldname = lc_parvw value = ' ' save_type = lc_save_type )
                                            ( segnum = <lfs_data>-segnum feldname = lc_partn value = ' ' save_type = lc_save_type )
                                          ).
            MOVE lc_e TO have_to_change .
          ENDIF.
        ENDLOOP.  " MAPPING_TAB for 'E1EDPA1'

        EXIT.

      ENDIF.  " lst_e1edka1
    ENDLOOP. "MAPPING_TAB for 'E1EDKA1'
