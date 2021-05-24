CLASS zcl_markdown_data DEFINITION PUBLIC.

  PUBLIC SECTION.

    DATA: doc TYPE REF TO zif_zmd_document READ-ONLY.

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
                title            TYPE string OPTIONAL
                auto_header_row  TYPE abap_bool DEFAULT abap_false
                initial_elements TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(self)      TYPE REF TO zcl_markdown_data.

    METHODS constructor
      IMPORTING doc TYPE REF TO zif_zmd_document.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_markdown_data IMPLEMENTATION.

  METHOD constructor.
    me->doc = doc.
  ENDMETHOD.

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

    doc->table( table_data ).

    self = me.
  ENDMETHOD.

  METHOD data_table.

    CHECK data IS NOT INITIAL.

    if title is not initial.
      doc->raw( |<div class="fd-toolbar fd-toolbar--solid fd-toolbar--title fd-toolbar-active">\r\n| &
                |  <h4 style="margin: 0;">{ title }</h4>| &
                |  <span class="fd-toolbar__spacer fd-toolbar__spacer--auto"></span>\r\n| &
                |</div>| ).
    endif.

    DATA(descr) = CAST cl_abap_tabledescr( cl_abap_tabledescr=>describe_by_data( data ) ).
    DATA(line_type) = descr->get_table_line_type( ).
    CASE line_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.

        DATA(line_type_as_struct) = CAST cl_abap_structdescr( line_type ).
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

      WHEN cl_abap_typedescr=>kind_elem.
        DATA(line_type_as_elem) = CAST cl_abap_elemdescr( line_type ).
        DATA: items TYPE stringtab.
        DATA(name) = line_type_as_elem->get_relative_name( ).

        doc->list( VALUE stringtab( FOR <x> IN data ( CONV string( <x> ) ) ) ).
      WHEN OTHERS.
        doc->blockquote( |Generation from type { line_type->get_relative_name( ) } not yet supported.| ).
        RETURN.
    ENDCASE.


    doc->table( md_table ).

    self = me.
  ENDMETHOD.



ENDCLASS.
