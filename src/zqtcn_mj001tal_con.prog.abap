*----------------------------------------------------------------------*
*   INCLUDE MJ001TAL_CON                                               *
*----------------------------------------------------------------------*
type-pools: jydb,
            jfakt.

*---------------------------------------------------------------------*
*     Allgemeine Konstanten

*---------------------------------------------------------------------*

* Konstanten für Ankreuzfelder
include mj_xfeld.


* Konstanten für Meldungstypen
include mj_symsgty.

* Konstanten für Exklusives oder Shared - Sperren
include mj_enqmode.

constants :
     con_update_task    type jydb_update_type value jydb_update_task,
     con_update_dialog  type jydb_update_type value jydb_update_dialog.

constants: con_nr_intern    type jgtgpnr-gpnr value 'INTERN'.
