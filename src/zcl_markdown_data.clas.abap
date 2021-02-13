class zcl_markdown_data definition public
  inheriting from zcl_markdown.

  public section.

    constants:
      begin of initial_handling,
        omit    type string value `omit`,
        include type string value `include`,
      end of initial_handling.

    methods structure
      importing data             type data
                initial_elements type abap_bool default abap_false
      returning value(self)      type ref to zcl_markdown_data.

    methods data_table
      importing data             type any table
                auto_header_row  type abap_bool default abap_true
      returning value(self)      type ref to zcl_markdown_data.

  protected section.
  private section.
endclass.



class zcl_markdown_data implementation.

  method structure.
    data(descr) = cast cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( data ) ).
    data(table_data) = value stringtab( ( `Component;Value` ) ).
    loop at descr->components assigning field-symbol(<component>).
      assign component <component>-name of structure data to field-symbol(<value>).
      if <value> is not initial.
        append |{ <component>-name };{ <value> };| to table_data.
      else.
        case initial_elements.
          when initial_handling-include.
            append |{ <component>-name };;| to table_data.
          when others.
            continue.
        endcase.
      endif.
    endloop.

    table( table_data ).

    self = me.
  endmethod.

  method data_table.

    check data is not initial.

    data(descr) = cast cl_abap_tabledescr( cl_abap_tabledescr=>describe_by_data( data ) ).
    data(line_type) = descr->get_table_line_type( ).
    case line_type->kind.
      when cl_abap_typedescr=>kind_struct.
        data(line_type_as_struct) = cast cl_abap_structdescr( line_type ).
      when others.
        blockquote( |Generation from type { line_type->get_relative_name( ) } not yet supported.| ).
        return.
    endcase.

    data: md_table type stringtab.
    if auto_header_row = abap_true.
      data(header_column) = concat_lines_of( table =
        value stringtab( for <c> in line_type_as_struct->components ( conv #( <c>-name ) ) ) sep = `;` ).
      append header_column to md_table.
    endif.

    loop at data assigning field-symbol(<item>).
      data(row) = ``.
      loop at line_type_as_struct->components assigning field-symbol(<comp>).
        assign component <comp>-name of structure <item> to field-symbol(<value>).
        row = row && |{ <value> };|.
      endloop.
      append row to md_table.
    endloop.

    table( md_table ).

    self = me.
  endmethod.

endclass.
