CLASS zcl_markdown_demo DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.
    CLASS-METHODS get
      RETURNING VALUE(md) TYPE REF TO zcl_markdown.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_markdown_demo IMPLEMENTATION.


  METHOD get.

    md = NEW zcl_markdown( ).
    md = md->heading( level = 1 val = |Markdown generator - showcase| ).

    DO 6 TIMES.
      md = md->heading( level = sy-index val = |Heading { sy-index }| ).
    ENDDO.

    md->text( 'This is text.'
      )->bold( 'This is bold text.'
      )->italic( 'This is italic text.'
      )->italic_bold( `This is italic bold text.`
      )->bold_italic( `This is bold italic text. Carefully note the difference.`

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
        |md = md && list( VALUE stringtab(\r\n| &
        |  ( `Item 1` )\r\n| &
        |  ( `Item 2` )\r\n| &
        |  ( `Item 3` )\r\n| &
        |) ).\r\n| &
        |\r\n| &
        |md = md && numbered_list( VALUE stringtab(\r\n| &
        |  ( `Item 1` )\r\n| &
        |  ( `Item 2` )\r\n| &
        |  ( `Item 3` )\r\n| &
        |) ).| ).
  ENDMETHOD.

ENDCLASS.
