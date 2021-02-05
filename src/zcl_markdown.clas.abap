CLASS zcl_markdown DEFINITION
  PUBLIC FINAL.

  PUBLIC SECTION.

    DATA: document TYPE string READ-ONLY.

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
                bold        TYPE abap_bool DEFAULT abap_false
                italic      TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    "! Bold (**val**)
    METHODS bold
      IMPORTING val         TYPE string
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    "! Italic (**val**)
    METHODS italic
      IMPORTING val         TYPE string
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    "! Italic bold (***val***) <br>
    "! You might think this is the same thing as bold_italic, but <br>
    "! - in italic_bold, the first * represents italic and the last ** represent bold <br>
    "! - in bold_italic, the first two ** represent bold and the last * represents italic <br>
    "! This fact should have no practical consequences whatsoever.
    METHODS italic_bold
      IMPORTING val         TYPE string
      RETURNING VALUE(self) TYPE REF TO zcl_markdown.

    "! Bold italic (***val***) <br>
    "! You might think this is the same thing as italic_bold, but <br>
    "! - in italic_bold, the first * represents italic and the last ** represent bold <br>
    "! - in bold_italic, the first two ** represent bold and the last * represents italic <br>
    "! This fact should have no practical consequences whatsoever.
    METHODS bold_italic
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

    METHODS as_markdown
      RETURNING
        VALUE(result) TYPE string.

    METHODS as_html
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
    CLASS-METHODS n_times
      IMPORTING string        TYPE string
                n             TYPE i
      RETURNING VALUE(result) TYPE string.
ENDCLASS.



CLASS zcl_markdown IMPLEMENTATION.

  METHOD text.
    document = document && |{ val }\r\n|.
    self = me.
  ENDMETHOD.

  METHOD bold.
    document = document && |**{ val }**\r\n|.
    self = me.
  ENDMETHOD.

  METHOD italic.
    document = document && |*{  val }*\r\n|.
    self = me.
  ENDMETHOD.

  METHOD italic_bold.
    document = document && |***{  val }***\r\n|.
    self = me.
  ENDMETHOD.

  METHOD bold_italic.
    document = document && |***{  val }***\r\n|.
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
      result = result && string.
    ENDDO.
  ENDMETHOD.

  METHOD code_block.
    document = document && |```{ language }\r\n{ val }\r\n```|.
    self = me.
  ENDMETHOD.

  METHOD heading.

    IF level < 1 OR level > 6.
      RAISE EXCEPTION NEW zcx_markdown( reason = 'Invalid heading level.' ).
    ENDIF.

    document = document && |{ n_times( string = `#` n = level ) } { val }\r\n|.
    self = me.
  ENDMETHOD.


  METHOD as_markdown.
    result = document.
  ENDMETHOD.

  METHOD ______________________________.
    document = document && |{ n_times( string = `_` n = 10 ) } \r\n|.
    self = me.
  ENDMETHOD.

  METHOD as_html.
    result = cl_ktd_dita_markdown_api=>transform_md_to_html( document ).
  ENDMETHOD.

ENDCLASS.
