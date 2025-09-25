FUNCTION-POOL zqtcr_tr_log_rfc.             "MESSAGE-ID ..

* INCLUDE LZQTCR_TR_LOG_RFCD...              " Local class definition

CONSTANTS:c_custom      TYPE trfunction VALUE 'W', "Customization Request
          c_workbench   TYPE trfunction VALUE 'K', "Workbench  Request
          c_dev         TYPE trfunction VALUE 'S', "Workbench  Request
          c_repair      TYPE trfunction VALUE 'R', "Repair
          c_dev_crt     TYPE trfunction VALUE 'S', "Development/Correction
          c_cust_tsk    TYPE trfunction VALUE 'Q', "Customizing Task
          c_exclamation TYPE trfunction VALUE '!',
          c_graterthan  TYPE trfunction VALUE '>',
          c_lessthan    TYPE trfunction VALUE '<',
          c_ed1         TYPE trtarsys   VALUE 'ED1',
          c_ed2         TYPE trtarsys   VALUE 'ED2',
          c_eq1         TYPE trtarsys   VALUE 'EQ1',
          c_eq2         TYPE trtarsys   VALUE 'EQ2',
          c_eq3         TYPE trtarsys   VALUE 'EQ3',
          c_ep1         TYPE trtarsys   VALUE 'EP1',
          c_es1         TYPE trtarsys   VALUE 'ES1',
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
          c_zero        TYPE strw_int4  VALUE '0',
          c_inc         TYPE char3      VALUE 'INC',
          c_const       TYPE char1      VALUE '*',
          c_c1          TYPE char1      VALUE '_',
          c_c2          TYPE char1      VALUE ':',
          c_c3          TYPE char1      VALUE '#',
          c_c4          TYPE char1      VALUE '-',
          c_four        TYPE strw_int4  VALUE '4',
          c_green       TYPE icon_d     VALUE '@08@',   " Green Symbol for Successful to Import
          c_red         TYPE icon_d     VALUE '@0A@',   " Red Symbol for Fail to import
          c_yellow      TYPE icon_d     VALUE '@09@',   " Yellow Symbol for open to import
          c_e           TYPE char1      VALUE 'E',
          c_inf         TYPE char1      VALUE 'I',
          c_att         TYPE e070a-attribute VALUE 'SAP_CTS_PROJECT'.

DATA:gt_e070 TYPE TABLE OF e070,
     gs_e070 TYPE e070,
     gt_e071 TYPE TABLE OF e071,
     gs_e071 TYPE e071,
*     gt_ilog  TYPE TABLE OF /ibmaccel/ctslog,
     gs_ilog TYPE zca_tr_log.

TYPES: BEGIN OF ty_join,
         trkorr         TYPE e070-trkorr,
         trfunction     TYPE e070-trfunction,
         trstatus       TYPE e070-trstatus,
         tarsystem      TYPE e070-tarsystem,
         korrdev        TYPE e070-korrdev,
         as4user        TYPE e070-as4user,
         as4date        TYPE e070-as4date,
         as4time        TYPE e070-as4time,
         strkorr        TYPE e070-strkorr,
         as4pos         TYPE e071-as4pos,
         pgmid          TYPE e071-pgmid,
         object         TYPE e071-object,
         obj_name       TYPE e071-obj_name,
         objfunc        TYPE e071-objfunc,
         langu          TYPE e07t-langu,
         as4text        TYPE e07t-as4text,
*         attribute      TYPE e070a-attribute,
*         reference      TYPE e070a-reference,
         zrequest       TYPE zca_tr_log-zrequest,
         ZMESSAGE       TYPE zca_tr_log-ZMESSAGE,
         log_num        TYPE zca_tr_log-log_num,
         zdate          TYPE zca_tr_log-zdate,
         ztime          TYPE zca_tr_log-ztime,
         zuname         TYPE zca_tr_log-zuname,
         dependency_tr  TYPE zca_tr_log-dependency_tr,
         dependency_cr  TYPE zca_tr_log-dependency_cr,
         cr_check       TYPE zca_tr_log-cr_check,
         incident_check TYPE zca_tr_log-incident_check,
         incident_no    TYPE zca_tr_log-incident_no,
         retrofit_check TYPE zca_tr_log-retrofit_check,
       END OF ty_join.
DATA:it_join  TYPE TABLE OF ty_join,
     lst_join TYPE ty_join.
