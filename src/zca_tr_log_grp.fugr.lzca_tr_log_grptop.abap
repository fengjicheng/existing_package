FUNCTION-POOL zca_tr_log_grp.               "MESSAGE-ID ..

* INCLUDE LZCA_TR_LOG_GRPD...                " Local class definition


*-----------------Declaration-----------------------------------------
TYPES:BEGIN OF ty_final,
        as4user  TYPE tr_as4user,
        trkorr   TYPE  trkorr,
        date     TYPE  char10,
        trtype   TYPE  char10,
        as4text  TYPE  as4text,
        ed1      TYPE  icon_d,
        ed1date  TYPE  char10,
        ed1time  TYPE  char10,
        ed2      TYPE  icon_d,
        ed2date  TYPE  char10,
        ed2time  TYPE  char10,
        eq1      TYPE  icon_d,
        eq1date  TYPE  char10,
        eq1time  TYPE  char10,
        eq2      TYPE  icon_d,
        eq2date  TYPE  char10,
        eq2time  TYPE  char10,
        ep1      TYPE  icon_d,
        ep1date  TYPE  char10,
        ep1time  TYPE  char10,
        eq3      TYPE  icon_d,
        eq3date  TYPE  char10,
        eq3time  TYPE  char10,
        es1      TYPE  icon_d,
        es1date  TYPE  char10,
        es1time  TYPE  char10,
        trstatus TYPE  trstatus,
      END OF ty_final.

DATA: i_final       TYPE STANDARD TABLE OF ty_final.


CONSTANTS:c_ed1         TYPE trtarsys   VALUE 'ED1',
          c_ed2         TYPE trtarsys   VALUE 'ED2',
          c_eq1         TYPE trtarsys   VALUE 'EQ1',
          c_eq2         TYPE trtarsys   VALUE 'EQ2',
          c_eq3         TYPE trtarsys   VALUE 'EQ3',
          c_ep1         TYPE trtarsys   VALUE 'EP1',
          c_es1         TYPE trtarsys   VALUE 'ES1',
          c_zero        TYPE strw_int4  VALUE '0',
          c_four        TYPE strw_int4  VALUE '4',
          c_green       TYPE icon_d     VALUE '@08@',   " Green Symbol for Successful to Import
          c_red         TYPE icon_d     VALUE '@0A@',   " Red Symbol for Fail to import
          c_yellow      TYPE icon_d     VALUE '@09@',   " Yellow Symbol for open to import
          c_e           TYPE char1      VALUE 'E',
          c_inf         TYPE char1      VALUE 'I',
          c_export      TYPE trbatfunc  VALUE 'E', "E	Create Versions After Export
          c_version     TYPE trbatfunc  VALUE 'V', "V  Version Management: Set I Flags at Import
          c_genrat      TYPE trbatfunc  VALUE 'G', "G  Generation of ABAPs and Screens
          c_y           TYPE trbatfunc  VALUE 'Y', "Y	Conversion Program Call for Matchcode Generation
          c_o           TYPE trbatfunc  VALUE 'O', "O	Conversion Program Call in Background (SE14 TBATG)
          c_a           TYPE trbatfunc  VALUE 'A', "A	Activation of ABAP Dictionary objects
          c_x           TYPE trbatfunc  VALUE 'X', "X	Export Application-Defined Objects
          c_d           TYPE trbatfunc  VALUE 'D', "D Import Application-Defined Objects
          c_r           TYPE trbatfunc  VALUE 'R', "R	Perform Actions after Activation
          c_b           TYPE trbatfunc  VALUE 'B', "B	Activation with TACOB
          c_n           TYPE trbatfunc  VALUE 'N', "N	Conversion with TBATG (Upgrade or Transport)
          c_q           TYPE trbatfunc  VALUE 'Q', "Q	Perform Actions Before Activation
          c_u           TYPE trbatfunc  VALUE 'U', "U	Evaluation of Conversion Logs
          c_s           TYPE trbatfunc  VALUE 'S', "S	Distributor (Compare Program for Inactive Nametabs)
          c_j           TYPE trbatfunc  VALUE 'J', "J	Activation of Dictionary Obj. with Inact. Nametab w/o Conv.
          c_m           TYPE trbatfunc  VALUE 'M', "M	Activation of ENQU/D, MCOB/ID/OF/OD
          c_f           TYPE trbatfunc  VALUE 'F', "F	Create Versions After Import
          c_w           TYPE trbatfunc  VALUE 'W', "W	Create Backup Versions before Import
          c_p           TYPE trbatfunc  VALUE 'P', "P	Activation of Nametab Entries
          c_ext_t       TYPE trbatfunc  VALUE 'T', "T	External Deployment Objects
          c_t           TYPE trbatfunc  VALUE 't', "t	Check Deploy Status
          c_c           TYPE trbatfunc  VALUE 'C', "C	HANA deployment for HOTA, HOTO, and HOTP objects
          c_7           TYPE trbatfunc  VALUE '7', "7	Execute method (follow-up actions)
          c_i           TYPE trbatfunc  VALUE 'I', "Set I Flags at Import
          c_custom      TYPE trfunction VALUE 'W', "Customization Request
          c_workbench   TYPE trfunction VALUE 'K', "Workbench  Request
          c_exclamation TYPE trfunction VALUE '!',
          c_graterthan  TYPE trfunction VALUE '>',
          c_lessthan    TYPE trfunction VALUE '<',
          c_ed1rfc      TYPE char15 VALUE 'ED1CLNT130T'.
