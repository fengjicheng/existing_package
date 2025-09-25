*----------------------------------------------------------------------*
*   INCLUDE LJVPHCON                                                   *
*----------------------------------------------------------------------*
constants: con_jvph_maintain_type    type tcode value 'JVPH0',
           con_jvph_display_type     type tcode value 'JVPH1',
           con_jvph_maintain_model   type tcode value 'JVPH2',
           con_jvph_display_model    type tcode value 'JVPH3',
           con_jvph_maintain_date    type tcode value 'JVPH4',
           con_jvph_display_date     type tcode value 'JVPH5',
           con_jvph_maintain_quan    type tcode value 'JKSD05',
           con_jvph_display_quan     type tcode value 'JKSD06',
           con_jvph_editor           type tcode value 'JVPH8',
           con_jvph_generate         type tcode value 'JKSDORDER01'.

constants: con_jvph_parm_phasemdl    type memoryid value 'JVPH',
           con_jvph_parm_phasenbr    type memoryid value 'JVPHN'.

constants: con_jvph_auth_object      type xuobject  value 'J_JVPHM',
           con_jvph_auth_fieldname   type fieldname value 'J_JVPHM'.

constants: con_jvph_balobj           type balobj_d value 'JERROR'.

constants: con_phasemdl_initial      type jvphasemdl value is initial,
           con_phasenbr_initial      type jvphasenbr value is initial.

constants: con_geounit_contract       type geoein value '*CONTRACT'.
constants: con_exit_ism_phasemdl_prom type exit_def value 'ISM_PHASEMDL_PROM'.
