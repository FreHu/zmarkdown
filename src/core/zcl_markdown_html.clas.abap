"! Contains:
"! <ul>
"!  <li>Common style</li>
"!  <li>Common javascript</li>
"!  <li>Methods for basic html elements</li>
"! </ul>
CLASS zcl_markdown_html DEFINITION PUBLIC.

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

    TYPES: html_string   TYPE string,
           html_document TYPE string.

    CLASS-DATA: common_style TYPE string,
                common_js    TYPE string.

    CLASS-METHODS: class_constructor,
      html IMPORTING val         TYPE any OPTIONAL
           RETURNING VALUE(html) TYPE html_document,

      "! Common javascript is placed at the end of the body tag
      body IMPORTING val         TYPE any OPTIONAL
           RETURNING VALUE(html) TYPE html_string,

      li IMPORTING val         TYPE any OPTIONAL
                   omit_empty  TYPE abap_bool DEFAULT abap_false
         RETURNING VALUE(html) TYPE html_string,

      th IMPORTING val         TYPE any OPTIONAL
         RETURNING VALUE(html) TYPE html_string,

      tr IMPORTING val         TYPE any OPTIONAL
         RETURNING VALUE(html) TYPE html_string,

      td IMPORTING val         TYPE any OPTIONAL
                   omit_empty  TYPE abap_bool DEFAULT abap_false
         RETURNING VALUE(html) TYPE html_string,

      b IMPORTING val         TYPE any
        RETURNING VALUE(html) TYPE html_string,

      i IMPORTING val         TYPE any
        RETURNING VALUE(html) TYPE html_string,

      ul IMPORTING val         TYPE any
         RETURNING VALUE(html) TYPE html_string,

      ol IMPORTING val         TYPE any
         RETURNING VALUE(html) TYPE html_string,

      h1 IMPORTING val         TYPE any
         RETURNING VALUE(html) TYPE html_string,

      h2 IMPORTING val         TYPE any
         RETURNING VALUE(html) TYPE html_string,

      h3 IMPORTING val         TYPE any
         RETURNING VALUE(html) TYPE html_string,

      a IMPORTING href        TYPE any
                  val         TYPE any
        RETURNING VALUE(html) TYPE html_string,

      table_header IMPORTING content     TYPE string
                   RETURNING VALUE(html) TYPE html_string.

    CLASS-METHODS      br RETURNING VALUE(html) TYPE html_string.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_markdown_html IMPLEMENTATION.

  METHOD class_constructor.
    common_style =
    |<link href="https://unpkg.com/fundamental-styles@latest/dist/fundamental-styles.css" rel="stylesheet">| &&
    |<style>| &&
      `tr:nth-child(odd){ background: "#eeeeee" }` && |\r\n| &&
    |@font-face \{\r\n| &
    |    font-family: "72";\r\n| &
    |    src: url("~@sap-theming/theming-base-content/content/Base/baseLib/sap_base_fiori/fonts/72-Regular-full.woff")\r\n| &
    |        format("woff");\r\n| &
    |    font-weight: normal;\r\n| &
    |    font-style: normal;\r\n| &
    |\}| &&
    |@font-face \{\r\n| &
    |    font-family: "SAP-icons";\r\n| &
    |    src: url("~@sap-theming/theming-base-content/content/Base/baseLib/sap_fiori_3/fonts/SAP-icons.woff")\r\n| &
    |        format("woff");\r\n| &
    |    font-weight: normal;\r\n| &
    |    font-style: normal;\r\n| &
    |\}\r\n| &
    |\r\n| &
    |html \{\r\n| &
    |  font-size: 16px;\r\n| &
    |\}| &&
    |</style>|.

    common_js = |<script>| && |</script>|.
  ENDMETHOD.

  METHOD body.
    html = |<body class="fd-page fd-page--home fd-page--list">{ val }{ common_js }</body>|.
  ENDMETHOD.

  METHOD html.
    html =
    |<html>| &&
      |<head>| &&
      |<meta charset='utf-8'>| &&
      |{  common_style }| &&
      |</head>| &&
      val &&
    |</html>|.
  ENDMETHOD.

  METHOD li.
    html = COND #(
     WHEN omit_empty = abap_true AND val = `` THEN ``
     ELSE |<li>{ val }</li>| ).
  ENDMETHOD.

  METHOD table.

    IF lines IS INITIAL OR lines( lines ) = 1.
      text( '[Empty table]' ).
      RETURN.
    ENDIF.

    DATA(header) = lines[ 1 ].
    SPLIT header AT delimiter INTO TABLE DATA(columns).

    DATA(header_str) = table_header( REDUCE string( INIT res = ``
      FOR <x> IN columns
      NEXT res = res && th( <x> ) ) ).

    DATA: items type string.
    LOOP AT lines ASSIGNING FIELD-SYMBOL(<line>) FROM 2.
      SPLIT <line> AT delimiter INTO TABLE columns.
      DATA(row) = tr( REDUCE string( INIT res = ``
        FOR <x> IN columns
        NEXT res = res && td( val = <x> ) ) ).
      items = items && row.
    ENDLOOP.

    document = document && |<table class="fd-table">| &&
    |{ header_str } | &&
    |  <tbody class="fd-table__body">{ items }</tbody>| &&
    |</table>|.
    self = me.
  ENDMETHOD.

  METHOD td.
    html = COND #(
      WHEN omit_empty = abap_true AND val = `` THEN ``
      ELSE |<td>{ val }</td>| ).
  ENDMETHOD.

  METHOD th.
    html = |<th class="fd-table__cell">{ val }</th>|.
  ENDMETHOD.

  METHOD tr.
    html = |<tr class="fd-table__row fd-table__row--focusable">{ val }</tr>|.
  ENDMETHOD.

  METHOD b.
    html = |<b>{ val }</b>|.
  ENDMETHOD.

  METHOD i.
    html = |<i>{ val }</i>|.
  ENDMETHOD.

  METHOD ul.
    html = |<ul>{ val }</ul>|.
  ENDMETHOD.

  METHOD ol.
    html = |<ol>{ val }</ol>|.
  ENDMETHOD.

  METHOD h1.
    html = |<h1 class="fd-title fd-title--h1">{ val }</h1>|.
  ENDMETHOD.

  METHOD h2.
    html = |<h2 class="fd-title fd-title--h2">{ val }</h2>|.
  ENDMETHOD.

  METHOD h3.
    html = |<h3 fd-title fd-title--h3">{ val }</h3>|.
  ENDMETHOD.

  METHOD a.
    html = |<a href="{ href }" class="fd-link">{ val }</a>|.
  ENDMETHOD.

  METHOD br.
    html = |<br/>\r\n|.
  ENDMETHOD.

  METHOD zif_zmd_document~blockquote.
    document = document && |<blockquote>{ val }</blockquote>|.
    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~code_block.
    document = document && |<pre>{ val }</pre>|.
    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~heading.
    document = document && |<h{ level } class="fd-title fd-title--h{ level }">{ val }</h{ level }>|.
    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~list.
    ol( REDUCE string( INIT res = ``
              FOR <i> IN items
              NEXT res = res && li( val = <i> ) ) ).
    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~numbered_list.
    ul( REDUCE string( INIT res = ``
          FOR <i> IN items
          NEXT res = res && li( val = <i> ) ) ).
    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~text.

    CASE style.

      WHEN zif_zmd_document=>style-bold_italic.
      WHEN zif_zmd_document=>style-italic_bold.
        document = document && |<p><b><i>{ val }</i></b></p>|.

      WHEN zif_zmd_document=>style-bold.
        document = document && |<p><b>{ val }</b></p>|.

      WHEN zif_zmd_document=>style-italic.
        document = document && |<p><i>{ val }</i></p>|.

      WHEN zif_zmd_document=>style-inline_code.
        document = document && |<i>{ val }</i>|. " todo

      WHEN zif_zmd_document=>style-none.
        document = document && |<p>{ val }</p>|.

    ENDCASE.

    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~______________________________.
    document = document && `<hr/>`.
    self = me.
  ENDMETHOD.

  METHOD zif_zmd_document~render.
    result = html( body( document ) ).
  ENDMETHOD.

  METHOD table_header.
    html = |<thead class="fd-table__header">\r\n| &
           |    <tr class="fd-table__row">| &&
                    content &&
           |    </tr>\r\n| &
           |</thead>|.
  ENDMETHOD.

  METHOD zif_zmd_document~raw.
    document = document && val.
    self = me.
  ENDMETHOD.

ENDCLASS.
