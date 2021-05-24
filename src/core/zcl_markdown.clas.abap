CLASS zcl_markdown DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES: zif_zmd_document.
    ALIASES: ______________________________ FOR zif_zmd_document~______________________________,
             heading FOR zif_zmd_document~heading,
             text FOR zif_zmd_document~text,
             blockquote FOR zif_zmd_document~blockquote,
             list FOR zif_zmd_document~list,
             numbered_list FOR zif_zmd_document~numbered_list,
             code_block FOR zif_zmd_document~code_block,
             table FOR zif_zmd_document~table,
             render FOR zif_zmd_document~render,

             document FOR zif_zmd_document~content.

    DATA: style    TYPE REF TO zcl_markdown_style.

    METHODS constructor.

  PRIVATE SECTION.
    METHODS append_line
      IMPORTING val TYPE string.

    CLASS-METHODS n_times
      IMPORTING val           TYPE string
                n             TYPE i
      RETURNING VALUE(result) TYPE string.
ENDCLASS.



CLASS zcl_markdown IMPLEMENTATION.

  METHOD constructor.
    me->style = NEW #( ).
  ENDMETHOD.

  METHOD zif_zmd_document~render.
    result = document.
  ENDMETHOD.

  METHOD zif_zmd_document~text.

    CASE style.

      WHEN zif_zmd_document=>style-bold_italic.
      WHEN zif_zmd_document=>style-italic_bold.
        document = document && |***{ val }***\r\n|.

      WHEN zif_zmd_document=>style-bold.
        document = document && |**{ val }**\r\n|.

      WHEN zif_zmd_document=>style-italic.
        document = document && |*{ val }*\r\n|.

      WHEN zif_zmd_document=>style-inline_code.
        document = document && |`{ val }`\r\n|.

      WHEN zif_zmd_document=>style-none.
        document = document && |{ val }\r\n|.
    ENDCASE.

    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~blockquote.
    SPLIT val AT |\r\n| INTO TABLE DATA(lines).
    LOOP AT lines ASSIGNING FIELD-SYMBOL(<line>).
      document = document && |> { <line> }\r\n|.
    ENDLOOP.
    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~list.
    LOOP AT items ASSIGNING FIELD-SYMBOL(<item>).
      document = document && |- { <item> }\r\n|.
    ENDLOOP.
    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~numbered_list.
    DATA(index) = 0.
    LOOP AT items ASSIGNING FIELD-SYMBOL(<item>).
      index = index + 1.
      document = document && |{ index }. { <item> }\r\n|.
    ENDLOOP.
    self = me.
  ENDMETHOD.

  METHOD n_times.
    DO n TIMES.
      result = result && val.
    ENDDO.
  ENDMETHOD.

  METHOD zif_zmd_document~code_block.
    document = document && |```{ language }\r\n{ val }\r\n```\r\n|.
    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~heading.

    IF level < 1 OR level > 6.
      RAISE EXCEPTION NEW zcx_markdown( reason = 'Invalid heading level.' ).
    ENDIF.

    document = document && |{ n_times( val = `#` n = level ) } { val }\r\n|.
    self = me.
  ENDMETHOD.


  METHOD zif_zmd_document~______________________________.
    document = document && |{ n_times( val = `_` n = 10 ) } \r\n|.
    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~table.
    TRY.
        CHECK lines( lines ) > 0.
        DATA(header) = lines[ 1 ].
        SPLIT header AT delimiter INTO TABLE DATA(columns).

        "| col1 | col2 | col3 | col4 |
        append_line( `| ` && concat_lines_of( table = columns sep = `| ` ) && ` |` ).

        "|------|------|------|------|
        append_line( n_times( val = `|------` n = lines( columns ) ) && `| ` ).

        LOOP AT lines ASSIGNING FIELD-SYMBOL(<line>) FROM 2.
          SPLIT <line> AT delimiter INTO TABLE columns.
          " | a    | b    | c    | d    |
          append_line( `| ` && concat_lines_of( table = columns sep = ` | ` ) && ` |` ).
        ENDLOOP.

        append_line( `` ).

      CATCH cx_root INTO DATA(cx).
        RAISE EXCEPTION NEW zcx_markdown( reason = `Invalid table data.` previous = cx ).
    ENDTRY.
    self = me.
  ENDMETHOD.

  METHOD append_line.
    document = document && val && |\r\n|.
  ENDMETHOD.

  METHOD zif_zmd_document~raw.
    document = document && val.
  ENDMETHOD.

ENDCLASS.
