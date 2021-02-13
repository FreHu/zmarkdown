class zcl_markdown definition public.

  public section.

    data: document type string read-only,
          style    type ref to zcl_markdown_style.

    methods constructor.

    "! Horizontal rule
    methods ______________________________
      returning value(self) type ref to zcl_markdown.

    "! Heading (###)
    methods heading
      importing level       type i
                val         type string
      returning value(self) type ref to zcl_markdown.

    methods text
      importing val         type string
      returning value(self) type ref to zcl_markdown.

    methods blockquote
      importing val         type string
      returning value(self) type ref to zcl_markdown.

    methods list
      importing items       type stringtab
      returning value(self) type ref to zcl_markdown.

    methods numbered_list
      importing items       type stringtab
      returning value(self) type ref to zcl_markdown.

    methods code_block
      importing val         type string
                language    type string default `abap`
      returning value(self) type ref to zcl_markdown.

    methods table
      importing lines       type stringtab
                delimiter   type string default `;`
      returning value(self) type ref to zcl_markdown.

    methods as_markdown
      returning
        value(result) type string.

    methods as_html
      returning
        value(result) type string.

  private section.
    methods append_line
      importing val type string.

    class-methods n_times
      importing val           type string
                n             type i
      returning value(result) type string.
endclass.



class zcl_markdown implementation.

  method constructor.
    me->style = new #( ).
  endmethod.

  method text.
    document = document && |{ val }\r\n|.
    self = me.
  endmethod.

  method blockquote.
    split val at |\r\n| into table data(lines).
    loop at lines assigning field-symbol(<line>).
      document = document && |> { <line> }\r\n|.
    endloop.
    self = me.
  endmethod.

  method list.
    loop at items assigning field-symbol(<item>).
      document = document && |- { <item> }\r\n|.
    endloop.
    self = me.
  endmethod.

  method numbered_list.
    data(index) = 0.
    loop at items assigning field-symbol(<item>).
      index = index + 1.
      document = document && |{ index }. { <item> }\r\n|.
    endloop.
    self = me.
  endmethod.

  method n_times.
    do n times.
      result = result && val.
    enddo.
  endmethod.

  method code_block.
    document = document && |```{ language }\r\n{ val }\r\n```\r\n|.
    self = me.
  endmethod.

  method heading.

    if level < 1 or level > 6.
      raise exception new zcx_markdown( reason = 'Invalid heading level.' ).
    endif.

    document = document && |{ n_times( val = `#` n = level ) } { val }\r\n|.
    self = me.
  endmethod.

  method as_markdown.
    result = document.
  endmethod.

  method ______________________________.
    document = document && |{ n_times( val = `_` n = 10 ) } \r\n|.
    self = me.
  endmethod.

  method as_html.
    data(transformed) = cl_ktd_dita_markdown_api=>transform_md_to_html(
      iv_markdown = document iv_body_only = abap_true ).
    result = zcl_markdown_html=>html( transformed ).
  endmethod.

  method table.
    try.
        data(header) = lines[ 1 ].
        split header at delimiter into table data(columns).

        "| col1 | col2 | col3 | col4 |
        append_line( `| ` && concat_lines_of( table = columns sep = `| ` ) && ` |` ).

        "|------|------|------|------|
        append_line( n_times( val = `|------` n = lines( columns ) ) && `| ` ).

        loop at lines assigning field-symbol(<line>) from 2.
          split <line> at delimiter into table columns.
          " | a    | b    | c    | d    |
          append_line( `| ` && concat_lines_of( table = columns sep = ` | ` ) && ` |` ).
        endloop.

        append_line( `` ).

      catch cx_root.
        raise exception new zcx_markdown( reason = `Invalid table data.` ).
    endtry.
    self = me.
  endmethod.

  method append_line.
    document = document && val && |\r\n|.
  endmethod.

endclass.
