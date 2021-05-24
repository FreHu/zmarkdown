class zcl_markdown definition public.

  public section.

    interfaces: zif_zmd_document.
    aliases: ______________________________ for zif_zmd_document~______________________________,
             heading for zif_zmd_document~heading,
             text for zif_zmd_document~text,
             blockquote for zif_zmd_document~blockquote,
             list for zif_zmd_document~list,
             numbered_list for zif_zmd_document~numbered_list,
             code_block for zif_zmd_document~code_block,
             table for zif_zmd_document~table,
             render for zif_zmd_document~render,

             document for zif_zmd_document~content.

    data: style    type ref to zcl_markdown_style.

    methods constructor.

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

  method zif_zmd_document~render.
    result = document.
  endmethod.

  method zif_zmd_document~text.

    case style.

      when zif_zmd_document=>style-bold_italic.
      when zif_zmd_document=>style-italic_bold.
        document = document && |***{ val }***\r\n|.

      when zif_zmd_document=>style-bold.
        document = document && |**{ val }**\r\n|.

      when zif_zmd_document=>style-italic.
        document = document && |*{ val }*\r\n|.

      when zif_zmd_document=>style-inline_code.
        document = document && |`{ val }`\r\n|.

      when zif_zmd_document=>style-none.
        document = document && |{ val }\r\n|.
    endcase.

    self = me.
  endmethod.

  method zif_zmd_document~blockquote.
    split val at |\r\n| into table data(lines).
    loop at lines assigning field-symbol(<line>).
      document = document && |> { <line> }\r\n|.
    endloop.
    self = me.
  endmethod.

  method zif_zmd_document~list.
    loop at items assigning field-symbol(<item>).
      document = document && |- { <item> }\r\n|.
    endloop.
    self = me.
  endmethod.

  method zif_zmd_document~numbered_list.
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

  method zif_zmd_document~code_block.
    document = document && |```{ language }\r\n{ val }\r\n```\r\n|.
    self = me.
  endmethod.

  method zif_zmd_document~heading.

    if level < 1 or level > 6.
      raise exception new zcx_markdown( reason = 'Invalid heading level.' ).
    endif.

    document = document && |{ n_times( val = `#` n = level ) } { val }\r\n|.
    self = me.
  endmethod.


  method zif_zmd_document~______________________________.
    document = document && |{ n_times( val = `_` n = 10 ) } \r\n|.
    self = me.
  endmethod.

  method zif_zmd_document~table.
    try.
        check lines( lines ) > 0.
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

      catch cx_root into data(cx).
        raise exception new zcx_markdown( reason = `Invalid table data.` previous = cx ).
    endtry.
    self = me.
  endmethod.

  method append_line.
    document = document && val && |\r\n|.
  endmethod.

  method zif_zmd_document~raw.
    document = document && val.
  endmethod.

endclass.
