*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_TAX_CTRL_UPD_R238_TOP
*&---------------------------------------------------------------------*
*--------------------------------TABLES--------------------------------*
TABLES : but000,
         cdhdr.
*-------------------------------CONSTANTS------------------------------*
CONSTANTS : c_e         TYPE c VALUE 'E', " Error Message type
            c_u         TYPE c VALUE 'U', " Change Indicator (U for Update)
            c_x         TYPE c VALUE 'X', " Flag
            c_i         TYPE c VALUE 'I', " Informative
            c_obj_cls   TYPE cdobjectcl VALUE 'DEBI',  " Object Class
            c_tax_field TYPE fieldname  VALUE 'TAXKD'. " Tax classification field
*---------------------------------TYPES--------------------------------*
TYPES : BEGIN OF ty_cdhdr,            " Header Logs
          objectclas TYPE cdobjectcl, " Object class
          objectid   TYPE cdobjectv,  " Object value
          changenr   TYPE cdchangenr, " Document change number
          username   TYPE cdusername, " User name of the person responsible in change document
          udate      TYPE cddatum,    " Creation date of the change document
          utime      TYPE cduzeit,    " Time changed
        END OF ty_cdhdr,
        BEGIN OF ty_cdpos,            " Item Logs
          objectclas TYPE cdobjectcl, " Object class
          objectid   TYPE cdobjectv,  " Object value
          changenr   TYPE cdchangenr, " Document change number
          tabname	   TYPE tabname,    " Table Name
          tabkey     TYPE cdtabkey,   " Changed table record key
          fname	     TYPE fieldname,  " Field Name
          chngind	   TYPE cdchngind,  " Change Type (U, I, S, D)
          value_new	 TYPE cdfldvaln,  " New contents of changed field
          value_old	 TYPE cdfldvalo,  " Old contents of changed field
        END OF ty_cdpos,
        BEGIN OF ty_final,            " Final
          bp_id        TYPE bu_partner, " Business Partner Number
          cust_nam     TYPE bu_nameor1, " Name 1 of organization
          addr1        TYPE ad_street,  " Street
          addr2        TYPE ad_strspp1, " Street 2
          city         TYPE ad_city1,   " City
          post_code    TYPE ad_pstcd1,  " City postal code
          country      TYPE land1,      " Country Key
          tx_cntry     TYPE land1,      " Output Tax Country
          tx_cntry_nam TYPE landx,      " Country Name
          tx_cat       TYPE kschl,      " Condition Type
          tx_cat_nam   TYPE vtxtk,      " Name
          old_tx_val   TYPE cdfldvalo,  " Old contents of changed field
          old_tx_desc  TYPE vtext,      " Description
          cur_tx_val   TYPE cdfldvaln,  " New contents of changed field
          cur_tx_desc  TYPE vtext,      " Description
          username     TYPE cdusername, " User name
          udate	       TYPE cddatum,    " Date of Change
          utime	       TYPE cduzeit,    " Time of Change
        END OF ty_final.
* ---------------------------INTERNAL TABLES---------------------------*
DATA : st_adr6 TYPE adr6,                   " E-mail address
       t_cdhdr TYPE TABLE OF ty_cdhdr,      " Header log internal table
       t_cdpos TYPE TABLE OF ty_cdpos,      " Item log internal table
       t_final TYPE TABLE OF ty_final,      " Final internal table
       o_alv   TYPE REF TO cl_salv_table,   " ALV reference
       o_cols  TYPE REF TO cl_salv_columns. " All Column Objects
