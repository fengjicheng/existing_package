FUNCTION-POOL zqtc_shipping_plan.           "MESSAGE-ID ..

* INCLUDE LZQTC_SHIPPING_PLAND...            " Local class definition

INCLUDE mjkse01top IF FOUND.

CONSTANTS:
  c_sign_incld TYPE ddsign          VALUE 'I',        "Sign: (I)nclude
  c_opti_equal TYPE ddoption        VALUE 'EQ'.       "Option: (EQ)ual
