*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ISM_MATMAS_SEGMENTS_02
*&---------------------------------------------------------------------*
*     True Delta - Segments related to MARC table
      PERFORM f_delta_segment_marc IN PROGRAM saplzqtc_ism_matmas_ob_cp IF FOUND
        USING mara
              marc
     CHANGING idoc_cimtype
              t_idoc_data[].
