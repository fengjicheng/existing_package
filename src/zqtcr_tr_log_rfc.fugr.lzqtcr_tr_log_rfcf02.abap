*----------------------------------------------------------------------*
***INCLUDE LZQTCR_TR_LOG_RFCF02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_OBSEL  text
*      -->P_S_TRKORR  text
*      -->P_S_DES  text
*      -->P_S_USER  text
*      -->P_S_DATE  text
*      -->P_S_INC  text
FORM get_data_1 TABLES  gt_obsel STRUCTURE e071
                      s_trkorr STRUCTURE rsdsselopt
                      s_des    STRUCTURE rsdsselopt
                      s_user   STRUCTURE rsdsselopt
                      s_date   STRUCTURE rsdsselopt
                      s_inc    STRUCTURE rsdsselopt.
  SELECT a~trkorr,
         a~trfunction,
         a~trstatus,
         a~tarsystem,
         a~korrdev,
         a~as4user,
         a~as4date,
         a~as4time,
         a~strkorr,
         b~as4pos,
         b~pgmid,
         b~object,
         b~obj_name,
         b~objfunc,
         c~langu,
         c~as4text,
*         d~attribute,
*         d~reference,
         e~zrequest,
         e~zmessage,
         e~log_num,
         e~zdate,
         e~ztime,
         e~zuname,
         e~dependency_tr,
         e~dependency_cr,
         e~cr_check,
         e~incident_check,
         e~incident_no,
         e~retrofit_check
         INTO TABLE @it_join
         FROM e070 AS a LEFT OUTER JOIN e071 AS b ON a~trkorr = b~trkorr
         LEFT OUTER JOIN e07t AS c ON a~trkorr = c~trkorr
*         LEFT OUTER JOIN e070a AS d ON a~trkorr = d~trkorr
         LEFT OUTER JOIN zca_tr_log AS e ON a~trkorr = e~zrequest
         FOR ALL ENTRIES IN @gt_obsel
         WHERE
             a~trkorr IN @s_trkorr
         AND a~as4user IN @s_user
         AND a~as4date IN @s_date
         AND c~langu = @sy-langu
         AND c~as4text IN @s_des
*         AND d~attribute = @c_att
         AND e~incident_no IN @s_inc
         AND b~pgmid      = @gt_obsel-pgmid
         AND b~object     = @gt_obsel-object
         AND b~obj_name   = @gt_obsel-obj_name.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_OBSEL  text
*      -->P_S_TRKORR  text
*      -->P_S_DES  text
*      -->P_S_USER  text
*      -->P_S_DATE  text
*      -->P_S_INC  text
*----------------------------------------------------------------------*
FORM get_data_2 TABLES  gt_obsel STRUCTURE e071
                      s_trkorr STRUCTURE rsdsselopt
                      s_des    STRUCTURE rsdsselopt
                      s_user   STRUCTURE rsdsselopt
                      s_date   STRUCTURE rsdsselopt
                      s_inc    STRUCTURE rsdsselopt.
  SELECT a~trkorr,
         a~trfunction,
         a~trstatus,
         a~tarsystem,
         a~korrdev,
         a~as4user,
         a~as4date,
         a~as4time,
         a~strkorr,
         b~as4pos,
         b~pgmid,
         b~object,
         b~obj_name,
         b~objfunc,
         c~langu,
         c~as4text,
*         d~attribute,
*         d~reference,
         e~zrequest,
         e~zmessage,
         e~log_num,
         e~zdate,
         e~ztime,
         e~zuname,
         e~dependency_tr,
         e~dependency_cr,
         e~cr_check,
         e~incident_check,
         e~incident_no,
         e~retrofit_check
         INTO TABLE @it_join
         FROM e070 AS a INNER JOIN e071 AS b ON a~trkorr = b~trkorr
         INNER JOIN e07t AS c ON a~trkorr = c~trkorr
*         LEFT OUTER JOIN e070a AS d ON a~trkorr = d~trkorr
         LEFT OUTER JOIN zca_tr_log AS e ON a~trkorr = e~zrequest
         WHERE
*             a~trkorr IN @s_trkorr
             ( a~trkorr IN @s_trkorr OR a~strkorr IN @s_trkorr )
         AND a~as4user IN @s_user
         AND a~as4date IN @s_date
         AND c~langu = @sy-langu
         AND c~as4text IN @s_des
*         AND ( d~attribute = @c_att or
         AND e~incident_no IN @s_inc.
ENDFORM.
