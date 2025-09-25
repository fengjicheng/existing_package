*&---------------------------------------------------------------------*
*& Include ZQTCN_TEM_MAINTAIN_E255_TOP                       Module Pool      ZQTCC_TEMPLATE_MAINTAIN_E255
*&
*&---------------------------------------------------------------------*
PROGRAM zqtcc_template_maintain_e255.

TYPES : BEGIN OF ty_control_data,                              " Data declaration for get template details
          program_name    TYPE zca_templates-program_name,
          template_name   TYPE zca_templates-template_name,
          version         TYPE zca_templates-version,
          active          TYPE zca_templates-active,
          upload_location TYPE zca_templates-upload_location,
          erdat           TYPE zca_templates-erdat,
          ernam           TYPE zca_templates-ernam,
          erzet           TYPE zca_templates-erzet,
          aedat           TYPE zca_templates-aedat,
          aenam           TYPE zca_templates-aenam,
          cputm           TYPE zca_templates-cputm,
          wricef_id       TYPE zca_templates-wricef_id,
          comments        TYPE zca_templates-comments,
        END OF ty_control_data.

DATA : st_control_data            TYPE ty_control_data,
       st_control_data_dupliacate TYPE ty_control_data,
       v_dataupdated              TYPE char1.
