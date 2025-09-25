*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ERPSLS_CUSTOMERS_SEL
*&---------------------------------------------------------------------*

"Customer Details
SELECTION-SCREEN BEGIN OF BLOCK kunnr WITH FRAME TITLE TEXT-s05.
SELECT-OPTIONS: skunnr    FOR sdcustview-kunnr,                               "Customer
                sktokd    FOR sdcustview-ktokd.                               "Customer Account Group
SELECTION-SCREEN END OF BLOCK kunnr.

"Customer Address
SELECTION-SCREEN BEGIN OF BLOCK addrdata WITH FRAME TITLE TEXT-s01.
SELECT-OPTIONS: sname     FOR sdcustview-name,                                "Name
                sname2    FOR sdcustview-name2,                               "Name Part2
                sstreet   FOR sdcustview-street,                              "Street
                sstrnum   FOR sdcustview-street_no,                           "House Nummber
                spcode    FOR sdcustview-pcode,                               "Postal Code
                scity     FOR sdcustview-city,                                "City
                scountry  FOR sdcustview-country,                             "Country
                semail    FOR sdcustview-smtp_addr,                           "Email
                ssortl    FOR sdcustview-sortl.                               "Search Term
SELECTION-SCREEN END OF BLOCK addrdata.

"Organization data
SELECTION-SCREEN BEGIN OF BLOCK orgdata WITH FRAME TITLE TEXT-s02.
SELECT-OPTIONS: svkorg    FOR sdcustview-vkorg MEMORY ID vko,                 "Sales Org
                svtweg    FOR sdcustview-vtweg MEMORY ID vtw,                 "Distribution Channel
                sspart    FOR sdcustview-spart MEMORY ID spa,                 "Division
                svkbur    FOR sdcustview-vkbur MEMORY ID vkb,                 "Sales Area
                svkgrp    FOR sdcustview-vkgrp MEMORY ID vkg,                 "Sales Group
                sbzirk    FOR sdcustview-bzirk MEMORY ID sbz.                 "Sales District
PARAMETERS: pwoorg AS CHECKBOX USER-COMMAND check1 DEFAULT ' '.               "Customer without SD data
SELECTION-SCREEN END OF BLOCK orgdata.

"Marketing data
SELECTION-SCREEN BEGIN OF BLOCK marketdata WITH FRAME TITLE TEXT-s07.
SELECT-OPTIONS: skukla    FOR sdcustview-kukla,                               "Customer Classification
                sbrsch    FOR sdcustview-brsch.                               "Industry Key
SELECTION-SCREEN END OF BLOCK marketdata.

"Sales Data
SELECTION-SCREEN BEGIN OF BLOCK salesdata WITH FRAME TITLE TEXT-s06.
SELECT-OPTIONS: skonda    FOR sdcustview-konda,                               "Price Group
                spltyp    FOR sdcustview-pltyp,                               "Price List type
                svsbed    FOR sdcustview-vsbed,                               "Shipping Point
                sinco1    FOR sdcustview-inco1,                               "Incoterms Part1
                sinco2    FOR sdcustview-inco2,                               "Incoterms Part2
                sincov2   FOR sdcustview-incov,                               "Incoterms Version
                sincov22  FOR sdcustview-inco2_l,                             "Incoterms Location1
                sincov23  FOR sdcustview-inco3_l,                             "Incoterms Location2
                szterm    FOR sdcustview-zterm.                               "Payment Terms
SELECTION-SCREEN END OF BLOCK salesdata.

"Central/SD block data
SELECTION-SCREEN BEGIN OF BLOCK blockdata WITH FRAME TITLE TEXT-s03.
SELECT-OPTIONS: saufsdz   FOR sdcustview-aufsdz,                              "Order Block (Central)
                saufsdv   FOR sdcustview-aufsdv,                              "Order Block (SD)
                slifsdz   FOR sdcustview-lifsdz,                              "Delivery Block (Central)
                slifsdv   FOR sdcustview-lifsdv,                              "Delivery Block(SD)
                sfaksdz   FOR sdcustview-faksdz,                              "Billing Block (Central)
                sfaksdv   FOR sdcustview-faksdv.                              "Billing Block (SD)
SELECTION-SCREEN END OF BLOCK blockdata.

"Delivery Data
SELECTION-SCREEN BEGIN OF BLOCK deldata WITH FRAME TITLE TEXT-s04.
PARAMETERS: ploevmz       LIKE sdcustview-loevmz,                             "Central Deletion Flag
            ploevmv       LIKE sdcustview-loevmv,                             "SD Deletion Flag
            pnodel        LIKE sdcustview-nodel,                              "Central Delivery Block
            pxdele        LIKE sdcustview-xdele.                              "Central Archiving Flag
SELECTION-SCREEN END OF BLOCK deldata.
