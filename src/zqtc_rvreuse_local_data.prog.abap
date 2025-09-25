***INCLUDE RVREUSE1 .

  DATA:   LS_SD_ALV TYPE SD_ALV.
  DATA:   LS_SD_ALV_SAVE TYPE SD_ALV.

  DATA:   LV_SUBRC LIKE SY-SUBRC,
          LV_PFKEY LIKE SY-PFKEY.

  DATA:   LT_EXCTAB TYPE SLIS_T_EXTAB WITH HEADER LINE.

* Customer Connection Project 200451 in 2018
  DATA:   BEGIN OF LS_SEL_DFLT,
            ALLEA,
            ALLEL,
            ALLEB,
            ALLEI,
            NO_FAKSK,
            PDSTK,
          END OF LS_SEL_DFLT.      "User Parameter
