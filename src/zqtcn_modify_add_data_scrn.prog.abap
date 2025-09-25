*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MODIFY_ADD_DATA_SCRN
*&---------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_MODIFY_ADD_DATA_SCRN
* PROGRAM DESCRIPTION : Disable deal type in item level additional data B
*                       tab based on PO type
* DEVELOPER           : Vamsi Mamillapalli(VMAMILLAPA)
* CREATION DATE       : 09/26/2023
* OBJECT ID           : E060
* TRANSPORT NUMBER(S) :
*----------------------------------------------------------------------*
CONSTANTS:lc_devid_e060 TYPE zdevid     VALUE 'E060',
          lc_trtyp      TYPE rvari_vnam VALUE 'TRTYP',
          lc_bsark      TYPE rvari_vnam VALUE 'BSARK'.

IF vbak-bsark IS NOT INITIAL.
  zca_utilities=>get_constants( EXPORTING im_devid = lc_devid_e060
                                IMPORTING et_constants = DATA(li_const_e060) ).

  IF line_exists( li_const_e060[ param1 = lc_bsark low = vbak-bsark ] ) AND
     line_exists( li_const_e060[ param1 = lc_trtyp low = t180-trtyp ] ).
    LOOP AT SCREEN.
      IF screen-name = 'VBAP-ZZDEALTYP'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP. " LOOP AT SCREEN
  ENDIF.
ENDIF.
