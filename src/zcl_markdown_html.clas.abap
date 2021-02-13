"! Utility class for HTML outputs in ifme_test. To be inherited from.
"! Contains:
"! <ul>
"!  <li>Common style</li>
"!  <li>Common javascript</li>
"!  <li>Methods for basic html elements</li>
"! </ul>
class zcl_markdown_html definition public.

  public section.

    types: html_string   type string,
           html_document type string.

    class-data: common_style type string,
                common_js    type string.

    class-methods:
      class_constructor,
      html importing val         type any optional
           returning value(html) type html_document,

      "! Common javascript is placed at the end of the body tag
      body importing val         type any optional
           returning value(html) type html_string,

      collapsible
        importing header      type html_string
                  content     type html_string
        returning value(html) type html_string,

      li importing val         type any optional
                   omit_empty  type abap_bool default abap_false
         returning value(html) type html_string,

      table importing val         type any optional
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

      h1 importing val         type any
         returning value(html) type html_string,

      h2 importing val         type any
         returning value(html) type html_string,

      h3 importing val         type any
         returning value(html) type html_string,

      p importing val         type any
        returning value(html) type html_string,

      pre importing val         type any
          returning value(html) type html_string,

      a importing href        type any
                  val         type any
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
    html = |<table class="fd-table">{ val }</table>|.
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
    html = |<tr class="fd-table__row">{ val }</tr>|.
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

  method h1.
    html = |<h1 class="fd-title fd-title--h1">{ val }</h1>|.
  endmethod.

  method h2.
    html = |<h2 class="fd-title fd-title--h2">{ val }</h2>|.
  endmethod.

  method h3.
    html = |<h3 fd-title fd-title--h3">{ val }</h3>|.
  endmethod.

  method pre.
    html = |<pre>{ val }</pre>|.
  endmethod.

  method p.
    html = |<p>{ val }</p>|.
  endmethod.

  method a.
    html = |<a href="{ href }" class="fd-link">{ val }</a>|.
  endmethod.

  method br.
    html = |<br/>\r\n|.
  endmethod.

  method collapsible.
    html = |<div class="collapsible">| &&
              |<div class="c-header">{ header }</div>| &&
              |<div class="c-content">{ content }</div>| &&
           |</div>|.
  endmethod.

endclass.
