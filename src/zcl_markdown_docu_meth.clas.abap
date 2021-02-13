CLASS zcl_markdown_docu_meth DEFINITION PUBLIC
  INHERITING FROM zcl_markdown_data.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF t_method_param,
        name          TYPE string,
        kind          TYPE string,
        by_value      TYPE abap_bool,
        optional      TYPE seooptionl,
        default_value TYPE seovalue,
        type          TYPE string,
      END OF t_method_param,
      t_method_params TYPE STANDARD TABLE OF t_method_param WITH EMPTY KEY,

      BEGIN OF t_seosubcodf,
        type       TYPE string,
        tableof    TYPE string,
        paroptionl TYPE seooptionl,
        parvalue   TYPE seovalue,
      END OF t_seosubcodf.

    METHODS constructor
      IMPORTING descr      TYPE abap_methdescr
                class_name TYPE seoclsname.

    METHODS parmkind_to_string
      IMPORTING
        parmkind      TYPE abap_parmkind
      RETURNING
        VALUE(result) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_markdown_docu_meth IMPLEMENTATION.

  METHOD constructor.

    super->constructor( ).

    DATA(method_name) = descr-name.
    DATA(params) = VALUE t_method_params( ).
    LOOP AT descr-parameters ASSIGNING FIELD-SYMBOL(<p>).

      DATA: seosubcodf TYPE t_seosubcodf.
      SELECT SINGLE type, tableof, paroptionl, parvalue INTO CORRESPONDING FIELDS OF @seosubcodf
      FROM seosubcodf
               WHERE clsname = @class_name
                 AND cmpname = @method_name
                 AND sconame = @<p>-name.

      APPEND VALUE #(
        name = to_lower( <p>-name )
        kind = parmkind_to_string( <p>-parm_kind )
        by_value = <p>-by_value
        optional = seosubcodf-paroptionl
        default_value = seosubcodf-parvalue
        type = style->inline_code( COND #(
          WHEN seosubcodf-tableof = abap_true THEN 'table of' )  && |{ seosubcodf-type }| ) )
      TO params.

    ENDLOOP.

    heading( level = 3 val = |{ to_lower( descr-name ) }| ).

    IF params IS NOT INITIAL.
      TYPES:
        BEGIN OF t_param,
          kind TYPE string,
          name TYPE string,
          type TYPE string,
        END OF t_param,
        t_params TYPE STANDARD TABLE OF t_param WITH DEFAULT KEY.
      DATA(parameters) = VALUE t_params(
        FOR <param> IN params (
          kind = parmkind_to_string( CONV #( <param>-kind ) )
          name = <param>-name
          type = <param>-type ) ).
      heading( level = 4 val = `Parameters` ).
      data_table( data = parameters ).
    ENDIF.

    IF descr-exceptions IS NOT INITIAL.
      heading( level = 4 val = `Exceptions` ).
      DATA(exceptions) = VALUE stringtab( FOR <x> IN descr-exceptions (
        COND #( WHEN <x>-is_resumable = abap_true
          THEN |{ <x>-name } [Resumable]|
          ELSE <x>-name ) ) ).
      data_table( data = exceptions auto_header_row = abap_false ).
    ENDIF.

  ENDMETHOD.

  METHOD parmkind_to_string.
    result = SWITCH #( parmkind
    WHEN 'I'
      THEN 'Importing'
    WHEN 'E'
      THEN 'Exporting'
    WHEN 'C'
      THEN 'Changing'
    WHEN 'R'
      THEN 'Returning'
    ELSE parmkind ).
  ENDMETHOD.


ENDCLASS.
