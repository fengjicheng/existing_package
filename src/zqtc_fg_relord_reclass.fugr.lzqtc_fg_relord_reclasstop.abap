FUNCTION-POOL zqtc_fg_relord_reclass.       "MESSAGE-ID ..

DATA: i_customizing TYPE TABLE OF zcaconstant.


DATA: v_postcat TYPE farr_post_category,
      v_trtyp   TYPE rmvct,
      v_gjahr   TYPE gjahr,
      v_poper   TYPE poper,
      v_msg     TYPE string.


CONSTANTS : c_ricefid_e228_1 TYPE zdevid         VALUE 'E228.1',
            c_prm_gjahr      TYPE rvari_vnam     VALUE 'GJAHR',
            c_prm_poper      TYPE rvari_vnam     VALUE 'POPER'.
