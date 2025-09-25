*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ERPSLS_CUSTOMERS_TOP
*&---------------------------------------------------------------------*

TABLES: sdcustview.

TYPE-POOLS: slis.

DATA: i_customers    TYPE TABLE OF sdcustview,
      st_customers   TYPE sdcustview,
      i_fieldcat     TYPE slis_t_fieldcat_alv,
      st_fieldcat    LIKE LINE OF i_fieldcat,
      st_layout      TYPE slis_layout_alv,
      v_status       TYPE slis_formname VALUE 'SET_STATUS',
      v_user_command TYPE slis_formname VALUE 'USER_COMMAND',
      v_repid        LIKE sy-repid VALUE sy-repid.
