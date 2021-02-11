CLASS zcl_markdown DEFINITION PUBLIC.

  PUBLIC SECTION.

    DATA: document TYPE string READ-ONLY,
          style    TYPE REF TO zcl_markdown_style.

    METHODS constructor.

    "! Horizontal rule
    METHODS ______________________________
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    "! Heading (###)
    METHODS heading
      IMPORTING level       TYPE i
                val         TYPE string
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    METHODS text
      IMPORTING val         TYPE string
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    METHODS blockquote
      IMPORTING val         TYPE string
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    METHODS list
      IMPORTING items       TYPE stringtab
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    METHODS numbered_list
      IMPORTING items       TYPE stringtab
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    METHODS code_block
      IMPORTING val         TYPE string
                language    TYPE string DEFAULT `abap`
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    METHODS table
      IMPORTING lines       TYPE stringtab
                delimiter   TYPE string DEFAULT `;`
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    METHODS as_markdown
      RETURNING
        VALUE(result) TYPE string.

    METHODS as_html
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
    METHODS append
      IMPORTING val TYPE string.

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

  METHOD text.
    document = document && |{ val }\r\n|.
    self = me.
  ENDMETHOD.

  METHOD blockquote.
    SPLIT val AT |\r\n| INTO TABLE DATA(lines).
    LOOP AT lines ASSIGNING FIELD-SYMBOL(<line>).
      document = document && |> { <line> }\r\n|.
    ENDLOOP.
    self = me.
  ENDMETHOD.

  METHOD list.
    LOOP AT items ASSIGNING FIELD-SYMBOL(<item>).
      document = document && |- { <item> }\r\n|.
    ENDLOOP.
    self = me.
  ENDMETHOD.

  METHOD numbered_list.
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

  METHOD code_block.
    document = document && |```{ language }\r\n{ val }\r\n```\r\n|.
    self = me.
  ENDMETHOD.

  METHOD heading.

    IF level < 1 OR level > 6.
      RAISE EXCEPTION NEW zcx_markdown( reason = 'Invalid heading level.' ).
    ENDIF.

    document = document && |{ n_times( val = `#` n = level ) } { val }\r\n|.
    self = me.
  ENDMETHOD.

  METHOD as_markdown.
    result = document.
  ENDMETHOD.

  METHOD ______________________________.
    document = document && |{ n_times( val = `_` n = 10 ) } \r\n|.
    self = me.
  ENDMETHOD.

  METHOD as_html.
    result = cl_ktd_dita_markdown_api=>transform_md_to_html( document ).
  ENDMETHOD.

  METHOD table.
    TRY.
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
        RAISE EXCEPTION NEW zcx_markdown( reason = `Invalid table data.` ).
    ENDTRY.
  ENDMETHOD.

  METHOD append.
    document = document && val.
  ENDMETHOD.

  METHOD append_line.
    document = document && val && |\r\n|.
  ENDMETHOD.

ENDCLASS.
