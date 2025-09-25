*&---------------------------------------------------------------------*
*& Report  Z_EDITORLOCK_UNLOCKED
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT Z_EDITORLOCK_UNLOCKED.
* Table Declaration
TABLES: TRDIR. "System table TRDIR

Parameter:  P_PROG    LIKE TRDIR-NAME,
            P_EDITOR  LIKE TRDIR-EDTX.

* Select the entered Program
SELECT SINGLE * FROM TRDIR WHERE NAME = P_PROG.

* Set/Remove the lock
TRDIR-EDTX = P_EDITOR.
MODIFY TRDIR.
IF SY-SUBRC EQ 0.
   WRITE: / 'Editor Lock update Successful ', TRDIR-NAME.
   IF TRDIR-EDTX = 'X'.
      WRITE: ' Lock'.
   ELSE.
      WRITE: ' UnLock'.
   ENDIF.
ELSE.
   WRITE: / 'Editor Lock update Unsuccessful ', TRDIR-NAME.
ENDIF.
