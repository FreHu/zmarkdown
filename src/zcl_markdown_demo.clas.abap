class zcl_markdown_demo definition
  public final.

  public section.
    class-methods get
      returning value(result) type ref to zcl_markdown.

  protected section.
  private section.

endclass.


class zcl_markdown_demo implementation.


  method get.

    data(md) = new zcl_markdown( ).
    data(style) = md->style.

    md = md->heading( level = 1 val = |Markdown generator - showcase| ).

    do 6 times.
      md = md->heading( level = sy-index val = |Heading { sy-index }| ).
    enddo.

    md->text( 'This is text.'
      )->text( style->bold( 'This is bold text.' )
      )->text( style->italic( 'This is italic text.' )
      )->text( style->italic_bold( `This is italic bold text.` )
      )->text( style->bold_italic( `This is bold italic text. Carefully note the difference.` )
)->text( |{ style->italic( 'This is italic' ) } and { style->bold( 'this is bold.' ) }|
      )->text( |The method { style->inline_code( 'zcl_mardown_style->inline_code' ) } outputs inline code.|
)->heading( level = 2 val = `Blockquotes`
        )->blockquote( md->document
)->heading( level = 2 val = `Nested Blockquotes`
        )->blockquote( md->document
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
        |        )->blockquote( md->document\r\n| &
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
      ( |{ style->bold( `bold` ) };{ style->italic( `italic` ) 
        };{ style->bold_italic( `bold_italic` ) }{ style->inline_code( `code` ) };;| )
    ) ).

    result = md.
  endmethod.

endclass.
