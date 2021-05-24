"! Contains:
"! <ul>
"!  <li>Common style</li>
"!  <li>Common javascript</li>
"!  <li>Methods for basic html elements</li>
"! </ul>
class zcl_markdown_html definition public.

  public section.


    interfaces: zif_zmd_document.
    aliases: ______________________________ for zif_zmd_document~______________________________,
             heading for zif_zmd_document~heading,
             text for zif_zmd_document~text,
             blockquote for zif_zmd_document~blockquote,
             list for zif_zmd_document~list,
             numbered_list for zif_zmd_document~numbered_list,
             code_block for zif_zmd_document~code_block,
             table for zif_zmd_document~table,
             render for zif_zmd_document~render,
             document for zif_zmd_document~content.

    types: html_string   type string,
           html_document type string.

    class-data: common_style type string,
                common_js    type string.

    class-methods: class_constructor,
      html importing val         type any optional
           returning value(html) type html_document,

      "! Common javascript is placed at the end of the body tag
      body importing val         type any optional
           returning value(html) type html_string,

      li importing val         type any optional
                   omit_empty  type abap_bool default abap_false
         returning value(html) type html_string,

      th importing val         type any optional
         returning value(html) type html_string,

      tr importing val         type any optional
         returning value(html) type html_string,

      td importing val         type any optional
                   omit_empty  type abap_bool default abap_false
         returning value(html) type html_string,

      b importing val         type any
        returning value(html) type html_string,

      i importing val         type any
        returning value(html) type html_string,

      ul importing val         type any
         returning value(html) type html_string,

      ol importing val         type any
         returning value(html) type html_string,

      h1 importing val         type any
         returning value(html) type html_string,

      h2 importing val         type any
         returning value(html) type html_string,

      h3 importing val         type any
         returning value(html) type html_string,

      a importing href        type any
                  val         type any
        returning value(html) type html_string,

      table_header importing content     type string
                   returning value(html) type html_string.

    class-methods      br returning value(html) type html_string.

  protected section.
  private section.

endclass.



class zcl_markdown_html implementation.

  method class_constructor.
    common_style =
|<link href="https://unpkg.com/fundamental-styles@latest/dist/fundamental-styles.css" rel="stylesheet">| &&
|<style>| &&
  `tr:nth-child(odd){ background: "#eeeeee" }` && |\r\n| &&
|@font-face \{\r\n| &
|font-family: "72";\r\n| &
|src: url("~@sap-theming/theming-base-content/content/Base/baseLib/sap_base_fiori/fonts/72-Regular-full.woff")\r\n| &
|    format("woff");\r\n| &
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
  endmethod.

  method body.
    html = |<body class="fd-page fd-page--home fd-page--list">{ val }{ common_js }</body>|.
  endmethod.

  method html.
    html =
    |<html>| &&
      |<head>| &&
      |<meta charset='utf-8'>| &&
      |{  common_style }| &&
      |</head>| &&
      val &&
    |</html>|.
  endmethod.

  method li.
    html = cond #(
     when omit_empty = abap_true and val = `` then ``
     else |<li>{ val }</li>| ).
  endmethod.

  method table.

    if lines is initial or lines( lines ) = 1.
      text( '[Empty table]' ).
      return.
    endif.

    data(header) = lines[ 1 ].
    split header at delimiter into table data(columns).

    data(header_str) = table_header( reduce string( init res = ``
      for <x> in columns
      next res = res && th( <x> ) ) ).

    data: items type string.
    loop at lines assigning field-symbol(<line>) from 2.
      split <line> at delimiter into table columns.
      data(row) = tr( reduce string( init res = ``
        for <x> in columns
        next res = res && td( val = <x> ) ) ).
      items = items && row.
    endloop.

    document = document && |<table class="fd-table">| &&
    |{ header_str } | &&
    |  <tbody class="fd-table__body">{ items }</tbody>| &&
    |</table>|.
    self = me.
  endmethod.

  method td.
    html = cond #(
      when omit_empty = abap_true and val = `` then ``
      else |<td>{ val }</td>| ).
  endmethod.

  method th.
    html = |<th class="fd-table__cell">{ val }</th>|.
  endmethod.

  method tr.
    html = |<tr class="fd-table__row fd-table__row--focusable">{ val }</tr>|.
  endmethod.

  method b.
    html = |<b>{ val }</b>|.
  endmethod.

  method i.
    html = |<i>{ val }</i>|.
  endmethod.

  method ul.
    html = |<ul>{ val }</ul>|.
  endmethod.

  method ol.
    html = |<ol>{ val }</ol>|.
  endmethod.

  method h1.
    html = |<h1 class="fd-title fd-title--h1">{ val }</h1>|.
  endmethod.

  method h2.
    html = |<h2 class="fd-title fd-title--h2">{ val }</h2>|.
  endmethod.

  method h3.
    html = |<h3 fd-title fd-title--h3">{ val }</h3>|.
  endmethod.

  method a.
    html = |<a href="{ href }" class="fd-link">{ val }</a>|.
  endmethod.

  method br.
    html = |<br/>\r\n|.
  endmethod.

  method zif_zmd_document~blockquote.
    document = document && |<blockquote>{ val }</blockquote>|.
    self = me.
  endmethod.

  method zif_zmd_document~code_block.
    document = document && |<pre>{ val }</pre>|.
    self = me.
  endmethod.

  method zif_zmd_document~heading.
    document = document && |<h{ level } class="fd-title fd-title--h{ level }">{ val }</h{ level }>|.
    self = me.
  endmethod.

  method zif_zmd_document~list.
    ol( reduce string( init res = ``
              for <i> in items
              next res = res && li( val = <i> ) ) ).
    self = me.
  endmethod.

  method zif_zmd_document~numbered_list.
    ul( reduce string( init res = ``
          for <i> in items
          next res = res && li( val = <i> ) ) ).
    self = me.
  endmethod.

  method zif_zmd_document~text.

    case style.

      when zif_zmd_document=>style-bold_italic.
      when zif_zmd_document=>style-italic_bold.
        document = document && |<p><b><i>{ val }</i></b></p>|.

      when zif_zmd_document=>style-bold.
        document = document && |<p><b>{ val }</b></p>|.

      when zif_zmd_document=>style-italic.
        document = document && |<p><i>{ val }</i></p>|.

      when zif_zmd_document=>style-inline_code.
        document = document && |<i>{ val }</i>|. " todo

      when zif_zmd_document=>style-none.
        document = document && |<p>{ val }</p>|.

    endcase.

    self = me.
  endmethod.

  method zif_zmd_document~______________________________.
    document = document && `<hr/>`.
    self = me.
  endmethod.

  method zif_zmd_document~render.
    result = html( body( document ) ).
  endmethod.

  method table_header.
    html = |<thead class="fd-table__header">\r\n| &
           |    <tr class="fd-table__row">| &&
                    content &&
           |    </tr>\r\n| &
           |</thead>|.
  endmethod.

  method zif_zmd_document~raw.
    document = document && val.
    self = me.
  endmethod.

endclass.
