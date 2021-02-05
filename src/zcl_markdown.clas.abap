CLASS zcl_markdown DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.

    "! Horizontal rule
    CLASS-DATA _____________________________ TYPE string.

    METHODS test
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS heading
      IMPORTING level         TYPE i
                val           TYPE string
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS text
      IMPORTING val           TYPE string
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS bold
      IMPORTING val           TYPE string
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS italic
      IMPORTING val           TYPE string
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS blockquote
      IMPORTING val           TYPE string
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS list
      IMPORTING items         TYPE stringtab
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS numbered_list
      IMPORTING items         TYPE stringtab
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS code_block
      IMPORTING val           TYPE string
                language      TYPE string DEFAULT `abap`
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS class_constructor.


  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS n_times
      IMPORTING
                string        TYPE string
                n             TYPE i
      RETURNING VALUE(result) TYPE string.
ENDCLASS.



CLASS zcl_markdown IMPLEMENTATION.

  METHOD class_constructor.
    _____________________________ = |{ n_times( string = `_` n = 10 ) } \r\n|.
  ENDMETHOD.

  METHOD test.

    TRY.
        DATA(md) = heading( level = 1 val = |Markdown generator - showcase| ).

        DO 6 TIMES.
          md = md && heading( level = sy-index val = |Heading { sy-index }| ).
        ENDDO.

        md = md && text( 'This is text.' ).
        md = md && text( bold( 'This is bold text.' ) ).
        md = md && text( italic( 'This is italic text.' ) ).
        md = md && text( italic( bold( 'This is italic bold text.' ) ) ).
        md = md && text( bold( italic( 'This is bold italic text.' ) ) ).

        md = md && heading( level = 2 val = `Blockquote` ) && blockquote( md ).

        md = md && heading( level = 2 val = `Nested Blockquote` ) && blockquote( md ).

        md = md && heading( level = 2 val = `Unordered list` ).

        md = md && list( VALUE stringtab(
          ( `Item 1` )
          ( `Item 2` )
          ( `Item 3` )
         ) ).

        md = md && heading( level = 2 val = `Numbered list` ).
        md = md && numbered_list( VALUE stringtab(
         ( `Item 1` )
         ( `Item 2` )
         ( `Item 3` )
        ) ).

        md = md && heading( level = 2 val = `Horizontal rule` ).
        md = md && _____________________________.


        md = md && heading( level = 2 val = `Code block` ).
        md = md && code_block(
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

        result = md.
      CATCH zcx_markdown INTO DATA(cx).
        result = |Error occurred: {  cx->reason }|.
    ENDTRY.

  ENDMETHOD.

  METHOD text.
    result = result && |{ val }\r\n|.
  ENDMETHOD.

  METHOD bold.
    result = result && |**{ val }**|.
  ENDMETHOD.

  METHOD italic.
    result = result && |*{  val }*|.
  ENDMETHOD.

  METHOD blockquote.
    SPLIT val AT |\r\n| INTO TABLE DATA(lines).
    LOOP AT lines ASSIGNING FIELD-SYMBOL(<line>).
      result = result && |> { <line> }\r\n|.
    ENDLOOP.
  ENDMETHOD.

  METHOD list.
    LOOP AT items ASSIGNING FIELD-SYMBOL(<item>).
      result = result && |- { <item> }\r\n|.
    ENDLOOP.
  ENDMETHOD.

  METHOD numbered_list.
    DATA(index) = 0.
    LOOP AT items ASSIGNING FIELD-SYMBOL(<item>).
      index = index + 1.
      result = result && |{ index }. { <item> }\r\n|.
    ENDLOOP.
  ENDMETHOD.


  METHOD n_times.
    DO n TIMES.
      result = result && string.
    ENDDO.
  ENDMETHOD.

  METHOD code_block.
    result = |```{ language }\r\n{ val }\r\n```|.
  ENDMETHOD.

  METHOD heading.

    IF level < 1 OR level > 6.
      RAISE EXCEPTION NEW zcx_markdown( reason = 'Invalid heading level.' ).
    ENDIF.

    result = |{ n_times( string = `#` n = level ) } { val }\r\n|.

  ENDMETHOD.

ENDCLASS.
