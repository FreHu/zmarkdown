CLASS zcl_markdown_docu_tabl DEFINITION PUBLIC
  INHERITING FROM zcl_markdown_data.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING name     TYPE string
                document TYPE REF TO zif_zmd_document.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_markdown_docu_tabl IMPLEMENTATION.

  METHOD constructor.

    super->constructor( document ).

*    CALL FUNCTION 'DDIF_TABL_GET'
*      EXPORTING
*        name          = lv_name
*        langu         = sy-langu
*      IMPORTING
*        dd02v_wa      = ls_dd02v
*        dd09l_wa      = ls_dd09l
*      TABLES
*        dd03p_tab     = lt_dd03p
*        dd05m_tab     = lt_dd05m
*        dd08v_tab     = lt_dd08v
*        dd12v_tab     = lt_dd12v
*        dd17v_tab     = lt_dd17v
*        dd35v_tab     = lt_dd35v
*        dd36m_tab     = lt_dd36m
*      EXCEPTIONS
*        illegal_input = 1
*        OTHERS        = 2.
  ENDMETHOD.




ENDCLASS.
