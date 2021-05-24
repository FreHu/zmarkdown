class zcl_markdown_demo definition
  public final.

  public section.
    class-methods get
      returning value(result) type string.

  protected section.
  private section.

endclass.


class zcl_markdown_demo implementation.


  method get.

    data(md) = new zcl_markdown_data( new zcl_markdown( ) ).
    data(doc) = md->doc.

    doc = doc->heading( level = 1 val = |Markdown generator - showcase| ).

    do 6 times.
      doc = doc->heading( level = sy-index val = |Heading { sy-index }| ).
    enddo.

    doc->text( val = 'This is text.'
      )->text( val = 'This is bold text.' style = 'bold'
      )->text( val = 'This is italic text.' style = 'bold'
      )->text( val = `This is italic bold text.` style = 'italic_bold'
      )->heading( level = 2 val = `Blockquotes`
              )->blockquote( doc->content
      )->heading( level = 2 val = `Nested Blockquotes`
              )->blockquote( doc->content
      )->heading( level = 2 val = `Unordered Lists`
              )->list( value stringtab(
                ( `Item 1` )
                ( `Item 2` )
                ( `Item 3` ) )
      )->heading( level = 2 val = `Numbered Lists`
              )->numbered_list( value stringtab(
                ( `Item 1` )
                ( `Item 2` )
                ( `Item 3` ) )
            )->heading( level = 2 val = `Horizontal Rule`
      )->______________________________(
      )->heading( level = 2 val = `Code blocks`
      )->code_block(
        |  )->heading( level = 2 val = `Nested Blockquotes`\r\n| &
        |        )->blockquote( doc->document\r\n| &
        |\r\n| &
        |      )->heading( level = 2 val = `Unordered Lists`\r\n| &
        |        )->list( VALUE stringtab(\r\n| &
        |          ( `Item 1` )\r\n| &
        |          ( `Item 2` )\r\n| &
        |          ( `Item 3` ) )\r\n| &
        |\r\n| &
        |      )->heading( level = 2 val = `Numbered Lists`\r\n| &
        |        )->numbered_list( VALUE stringtab(\r\n| &
        |          ( `Item 1` )\r\n| &
        |          ( `Item 2` )\r\n| &
        |          ( `Item 3` ) )\r\n| &
        |      )->heading( level = 2 val = `Horizontal Rule`\r\n| &
        |\r\n| &
        |      )->______________________________(|
    )->table( value stringtab(
      ( `col1;col2;col3;col4;` )
      ( `a;b;c;d` )
      ( `1;2;3;4;`)
      ( `e;f;g;h;` )
    ) ).

    result = doc->content.
  endmethod.

endclass.
