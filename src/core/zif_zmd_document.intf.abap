interface zif_zmd_document public.

  data: content type string read-only.

  constants:
    begin of style,
      none        type string value 'none',
      bold        type string value 'bold',
      italic      type string value 'italic',
      bold_italic type string value 'bold_italic',
      italic_bold type string value 'italic_bold',
      inline_code type string value 'inline_code',
    end of style.


  methods render
    returning value(result) type string.


  "! Horizontal rule
  methods ______________________________
    returning value(self) type ref to zif_zmd_document.

  "! Heading
  methods heading
    importing level       type i
              val         type string
    returning value(self) type ref to zif_zmd_document.

  methods text
    importing val         type string
              style       type string default style-none
    returning value(self) type ref to zif_zmd_document.

  methods raw
    importing val         type string
    returning value(self) type ref to zif_zmd_document.

  methods blockquote
    importing val         type string
    returning value(self) type ref to zif_zmd_document.

  methods list
    importing items       type stringtab
    returning value(self) type ref to zif_zmd_document.

  methods numbered_list
    importing items       type stringtab
    returning value(self) type ref to zif_zmd_document.

  methods code_block
    importing val         type string
              language    type string default `abap`
    returning value(self) type ref to zif_zmd_document.

  methods table
    importing lines       type stringtab
              delimiter   type string default `;`
    returning value(self) type ref to zif_zmd_document.

endinterface.
