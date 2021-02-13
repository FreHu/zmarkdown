CLASS zcl_markdown_demo DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    CLASS-METHODS get
      RETURNING VALUE(result) TYPE REF TO zcl_markdown.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_markdown_demo IMPLEMENTATION.


  METHOD get.

    DATA(md) = NEW zcl_markdown( ).
    DATA(style) = md->style.

    md = md->heading( level = 1 val = |Markdown generator - showcase| ).

    DO 6 TIMES.
      md = md->heading( level = sy-index val = |Heading { sy-index }| ).
    ENDDO.

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
        )->list( VALUE stringtab(
          ( `Item 1` )
          ( `Item 2` )
          ( `Item 3` ) )

      )->heading( level = 2 val = `Numbered Lists`
        )->numbered_list( VALUE stringtab(
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
    )->table( VALUE stringtab(
      ( `col1;col2;col3;col4;` )
      ( `a;b;c;d` )
      ( `1;2;3;4;`)
      ( `e;f;g;h;` )
      ( |{ style->bold( `bold` ) };{ style->italic( `italic` ) };{ style->bold_italic( `bold_italic` ) }{ style->inline_code( `code` ) };;| )
    ) ).

    result = md.
  ENDMETHOD.

ENDCLASS.
