CLASS zcl_markdown_demo DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    CLASS-METHODS get
      RETURNING VALUE(result) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_markdown_demo IMPLEMENTATION.


  METHOD get.

    DATA(md) = NEW zcl_markdown_data( NEW zcl_markdown( ) ).
    DATA(doc) = md->doc.

    doc = doc->heading( level = 1 val = |Markdown generator - showcase| ).

    DO 6 TIMES.
      doc = doc->heading( level = sy-index val = |Heading { sy-index }| ).
    ENDDO.

    doc->text( val = 'This is text.'
      )->text( val = 'This is bold text.' style = 'bold'
      )->text( val = 'This is italic text.' style = 'bold'
      )->text( val = `This is italic bold text.` style = 'italic_bold'
      )->heading( level = 2 val = `Blockquotes`
              )->blockquote( doc->content
      )->heading( level = 2 val = `Nested Blockquotes`
              )->blockquote( doc->content
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
    )->table( VALUE stringtab(
      ( `col1;col2;col3;col4;` )
      ( `a;b;c;d` )
      ( `1;2;3;4;`)
      ( `e;f;g;h;` )
    ) ).

    result = doc->content.
  ENDMETHOD.

ENDCLASS.
