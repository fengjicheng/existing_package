*---------------------------------------------------------------------*
* PROGRAM NAME:        RV45B904 (Include)
*                      [Sales Orders Copy routine ]
* PROGRAM DESCRIPTION: Create new copy routine 904 for billing document
*                      validation, when we are the creating credit memo orders
* DEVELOPER:           VDPATABALL
* CREATION DATE:       03/21/2022
* OBJECT ID:           E355/OTCM-46700
* TRANSPORT NUMBER(S): ED2K926190
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*---------------------------------------------------------------------*
DATA:lv_fksto   TYPE fksto. "Billing document is cancelled
CONSTANTS:lc_e TYPE char1 VALUE 'E'. "error

*---get the cancellaton status from VBRK table
CLEAR:lv_fksto.
SELECT SINGLE fksto "Billing document is cancelled
  FROM vbrk
  INTO lv_fksto
  WHERE vbeln = vbrk-vbeln.
*if FKSTO value is inital then populating error and stop the process.
IF lv_fksto IS NOT INITIAL.
  CONCATENATE 'Referenced Document'
               vbrk-vbeln
               'is Cancelled'
               INTO DATA(lv_msg_error) SEPARATED BY space.
  MESSAGE lv_msg_error TYPE lc_e.
ENDIF.
