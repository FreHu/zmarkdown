class zcl_markdown_data definition public.

  public section.

    data: doc type ref to zif_zmd_document read-only.

    constants:
      begin of initial_handling,
        omit    type string value `omit`,
        include type string value `include`,
      end of initial_handling.


    methods structure
      importing data             type data
                initial_elements type abap_bool default abap_false
      returning value(self)      type ref to zcl_markdown_data.

    

    methods constructor
      importing doc type ref to zif_zmd_document.

  protected section.
  private section.
endclass.



class zcl_markdown_data implementation.

  method constructor.
    me->doc = doc.
  endmethod.

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

    doc->table( table_data ).

    self = me.
  endmethod.

  method data_table.

    check data is not initial.

    if title is not initial.
      doc->raw( |<div class="fd-toolbar fd-toolbar--solid fd-toolbar--title fd-toolbar-active">\r\n| &
                |  <h4 style="margin: 0;">{ title }</h4>| &
                |  <span class="fd-toolbar__spacer fd-toolbar__spacer--auto"></span>\r\n| &
                |</div>| ).
    endif.

    data(descr) = cast cl_abap_tabledescr( cl_abap_tabledescr=>describe_by_data( data ) ).
    data(line_type) = descr->get_table_line_type( ).
    case line_type->kind.
      when cl_abap_typedescr=>kind_struct.

        data(line_type_as_struct) = cast cl_abap_structdescr( line_type ).
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

      when cl_abap_typedescr=>kind_elem.
        data(line_type_as_elem) = cast cl_abap_elemdescr( line_type ).
        data: items type stringtab.
        

        doc->list( value stringtab( for <x> in data ( conv string( <x> ) ) ) ).
      when others.
        doc->blockquote( |Generation from type { line_type->get_relative_name( ) } not yet supported.| ).
        return.
    endcase.


    doc->table( md_table ).

    self = me.
  endmethod.



endclass.
