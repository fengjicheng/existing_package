FUNCTION-POOL zqtc_print_vend            MESSAGE-ID sv.

* INCLUDE LZQTC_PRINT_VENDD...               " Local class definition
INCLUDE lsvimdat                                . "general data decl.
INCLUDE lzqtc_print_vendt00                     . "view rel. data dcl.

DATA:
  i_print_vend TYPE STANDARD TABLE OF zqtc_print_vend INITIAL SIZE 0,
  i_constants  TYPE zcat_constants.

CONSTANTS:
  c_devid_0231 TYPE zdevid VALUE 'I0231', "Development ID: I0231
  c_sep_undscr TYPE char1 VALUE '_', "Separator: Underscore
  c_sep_slash  TYPE char1 VALUE '/', "Separator: Slash
  c_msgty_err  TYPE symsgty VALUE 'E', "Message Type: (E)rror
  c_supplement TYPE char1 VALUE 'S', "(S)upplement
  c_fl_ext_pdf TYPE char4 VALUE '.pdf'. "File Extension: PDF
