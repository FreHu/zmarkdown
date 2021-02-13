class lcl_test definition final for testing
  inheriting from zcl_abap_unit_wrapper
  duration short
  risk level harmless.

  private section.
    methods:
      regression_test for testing raising cx_static_check.

endclass.


class lcl_test implementation.

  method regression_test.
    data(demo) = zcl_markdown_demo=>get( ).
    assert_equals(
      act = demo->as_markdown( )
      exp =
      |# Markdown generator - showcase\r\n| &
      |# Heading 1\r\n| &
      |## Heading 2\r\n| &
      |### Heading 3\r\n| &
      |#### Heading 4\r\n| &
      |##### Heading 5\r\n| &
      |###### Heading 6\r\n| &
      |This is text.\r\n| &
      |**This is bold text.**\r\n| &
      |*This is italic text.*\r\n| &
      |***This is italic bold text.***\r\n| &
      |***This is bold italic text. Carefully note the difference.***\r\n| &
      |*This is italic* and **this is bold.**\r\n| &
      |The method `zcl_mardown_style->inline_code` outputs inline code.\r\n| &
      |## Blockquotes\r\n| &
      |> # Markdown generator - showcase\r\n| &
      |> # Heading 1\r\n| &
      |> ## Heading 2\r\n| &
      |> ### Heading 3\r\n| &
      |> #### Heading 4\r\n| &
      |> ##### Heading 5\r\n| &
      |> ###### Heading 6\r\n| &
      |> This is text.\r\n| &
      |> **This is bold text.**\r\n| &
      |> *This is italic text.*\r\n| &
      |> ***This is italic bold text.***\r\n| &
      |> ***This is bold italic text. Carefully note the difference.***\r\n| &
      |> *This is italic* and **this is bold.**\r\n| &
      |> The method `zcl_mardown_style->inline_code` outputs inline code.\r\n| &
      |> ## Blockquotes\r\n| &
      |## Nested Blockquotes\r\n| &
      |> # Markdown generator - showcase\r\n| &
      |> # Heading 1\r\n| &
      |> ## Heading 2\r\n| &
      |> ### Heading 3\r\n| &
      |> #### Heading 4\r\n| &
      |> ##### Heading 5\r\n| &
      |> ###### Heading 6\r\n| &
      |> This is text.\r\n| &
      |> **This is bold text.**\r\n| &
      |> *This is italic text.*\r\n| &
      |> ***This is italic bold text.***\r\n| &
      |> ***This is bold italic text. Carefully note the difference.***\r\n| &
      |> *This is italic* and **this is bold.**\r\n| &
      |> The method `zcl_mardown_style->inline_code` outputs inline code.\r\n| &
      |> ## Blockquotes\r\n| &
      |> > # Markdown generator - showcase\r\n| &
      |> > # Heading 1\r\n| &
      |> > ## Heading 2\r\n| &
      |> > ### Heading 3\r\n| &
      |> > #### Heading 4\r\n| &
      |> > ##### Heading 5\r\n| &
      |> > ###### Heading 6\r\n| &
      |> > This is text.\r\n| &
      |> > **This is bold text.**\r\n| &
      |> > *This is italic text.*\r\n| &
      |> > ***This is italic bold text.***\r\n| &
      |> > ***This is bold italic text. Carefully note the difference.***\r\n| &
      |> > *This is italic* and **this is bold.**\r\n| &
      |> > The method `zcl_mardown_style->inline_code` outputs inline code.\r\n| &
      |> > ## Blockquotes\r\n| &
      |> ## Nested Blockquotes\r\n| &
      |## Unordered Lists\r\n| &
      |- Item 1\r\n| &
      |- Item 2\r\n| &
      |- Item 3\r\n| &
      |## Numbered Lists\r\n| &
      |1. Item 1\r\n| &
      |2. Item 2\r\n| &
      |3. Item 3\r\n| &
      |## Horizontal Rule\r\n| &
      |__________ \r\n| &
      |## Code blocks\r\n| &
      |```abap\r\n| &
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
      |      )->______________________________(\r\n| &
      |```\r\n| &
      |\| col1\| col2\| col3\| col4 \|\r\n| &
      |\|------\|------\|------\|------\| \r\n| &
      |\| a \| b \| c \| d \|\r\n| &
      |\| 1 \| 2 \| 3 \| 4 \|\r\n| &
      |\| e \| f \| g \| h \|\r\n| &
      |\| **bold** \| *italic* \| ***bold_italic***`code` \|  \|\r\n\r\n| ).
  endmethod.

endclass.
