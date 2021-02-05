CLASS lcl_test DEFINITION FINAL FOR TESTING
  INHERITING FROM zcl_abap_unit_wrapper
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      regression_test FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_test IMPLEMENTATION.

  METHOD regression_test.
    DATA(demo) = zcl_markdown_demo=>get( ).
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
      |) ).\r\n| &
      |```| ).
  ENDMETHOD.

ENDCLASS.
