FUNCTION zudm_fetch_strategy_versions.
*"Created as part of OSS Note 1277798 - Problem related to client copy
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      T_STR_VERS STRUCTURE  UDM_STRATEGY_V
*"----------------------------------------------------------------------

  SELECT * FROM udm_strategy_v CLIENT SPECIFIED INTO TABLE t_str_vers.

ENDFUNCTION.
