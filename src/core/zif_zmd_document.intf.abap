INTERFACE zif_zmd_document PUBLIC.

  DATA: content TYPE string READ-ONLY.

  CONSTANTS:
    BEGIN OF style,
      none        TYPE string VALUE 'none',
      bold        TYPE string VALUE 'bold',
      italic      TYPE string VALUE 'italic',
      bold_italic TYPE string VALUE 'bold_italic',
      italic_bold TYPE string VALUE 'italic_bold',
      inline_code TYPE string VALUE 'inline_code',
    END OF style.


  methods render
    RETURNING VALUE(result) type string.


  "! Horizontal rule
  METHODS ______________________________
    RETURNING VALUE(self) TYPE REF TO zif_zmd_document.

  "! Heading
  METHODS heading
    IMPORTING level       TYPE i
              val         TYPE string
    RETURNING VALUE(self) TYPE REF TO zif_zmd_document.

  METHODS text
    IMPORTING val         TYPE string
              style       TYPE string DEFAULT style-none
    RETURNING VALUE(self) TYPE REF TO zif_zmd_document.

  METHODS raw
    IMPORTING val         TYPE string
    RETURNING VALUE(self) TYPE REF TO zif_zmd_document.

  METHODS blockquote
    IMPORTING val         TYPE string
    RETURNING VALUE(self) TYPE REF TO zif_zmd_document.

  METHODS list
    IMPORTING items       TYPE stringtab
    RETURNING VALUE(self) TYPE REF TO zif_zmd_document.

  METHODS numbered_list
    IMPORTING items       TYPE stringtab
    RETURNING VALUE(self) TYPE REF TO zif_zmd_document.

  METHODS code_block
    IMPORTING val         TYPE string
              language    TYPE string DEFAULT `abap`
    RETURNING VALUE(self) TYPE REF TO zif_zmd_document.

  METHODS table
    IMPORTING lines       TYPE stringtab
              delimiter   TYPE string DEFAULT `;`
    RETURNING VALUE(self) TYPE REF TO zif_zmd_document.

ENDINTERFACE.
