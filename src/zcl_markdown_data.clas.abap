CLASS zcl_markdown_data DEFINITION PUBLIC
  INHERITING FROM zcl_markdown.

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF initial_handling,
        omit    TYPE string VALUE `omit`,
        include TYPE string VALUE `include`,
      END OF initial_handling.

    METHODS structure
      IMPORTING data             TYPE data
                initial_elements TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(self)      TYPE REF TO zcl_markdown_data.

    METHODS data_table
      IMPORTING data             TYPE ANY TABLE
                auto_header_row     TYPE abap_bool DEFAULT abap_true
                initial_elements TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(self)      TYPE REF TO zcl_markdown_data.

    METHODS signature
      IMPORTING class       TYPE string
                method      TYPE string
      RETURNING VALUE(self) TYPE REF TO zcl_markdown_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_markdown_data IMPLEMENTATION.

  METHOD structure.
    DATA(descr) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( data ) ).
    DATA(table_data) = VALUE stringtab( ( `Component;Value` ) ).
    LOOP AT descr->components ASSIGNING FIELD-SYMBOL(<component>).
      ASSIGN COMPONENT <component>-name OF STRUCTURE data TO FIELD-SYMBOL(<value>).
      IF <value> IS NOT INITIAL.
        APPEND |{ <component>-name };{ <value> };| TO table_data.
      ELSE.
        CASE initial_elements.
          WHEN initial_handling-include.
            APPEND |{ <component>-name };;| TO table_data.
          WHEN OTHERS.
            CONTINUE.
        ENDCASE.
      ENDIF.
    ENDLOOP.

    table( table_data ).

    self = me.
  ENDMETHOD.

  METHOD signature.
    DATA(descr) = CAST cl_abap_classdescr( cl_abap_classdescr=>describe_by_name( class ) ).
    heading( val = 'Attributes' level = 2 ).
    LOOP AT descr->attributes ASSIGNING FIELD-SYMBOL(<attr>).

    ENDLOOP.
  ENDMETHOD.

  METHOD data_table.

    CHECK data IS NOT INITIAL.

    DATA(descr) = CAST cl_abap_tabledescr( cl_abap_tabledescr=>describe_by_data( data ) ).
    DATA(line_type) = descr->get_table_line_type( ).
    CASE line_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        DATA(line_type_as_struct) = CAST cl_abap_structdescr( line_type ).
      WHEN OTHERS.
        RAISE EXCEPTION NEW zcx_markdown( `Unsupported.` ).
    ENDCASE.

    DATA: md_table TYPE stringtab.
    IF auto_header_row = abap_true.
      DATA(header_column) = concat_lines_of( table =
        VALUE stringtab( FOR <c> IN line_type_as_struct->components ( CONV #( <c>-name ) ) ) sep = `;` ).
      APPEND header_column TO md_table.
    ENDIF.

    LOOP AT data ASSIGNING FIELD-SYMBOL(<item>).
      DATA(row) = ``.
      LOOP AT line_type_as_struct->components ASSIGNING FIELD-SYMBOL(<comp>).
        ASSIGN COMPONENT <comp>-name OF STRUCTURE <item> TO FIELD-SYMBOL(<value>).
        row = row && |{ <value> };|.
      ENDLOOP.
      APPEND row TO md_table.
    ENDLOOP.

    table( md_table ).

    self = me.
  ENDMETHOD.

ENDCLASS.
