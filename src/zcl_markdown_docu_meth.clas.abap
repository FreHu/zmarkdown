class zcl_markdown_docu_meth definition public
  inheriting from zcl_markdown_data.

  public section.
    types:
      begin of t_method_param,
        name          type string,
        kind          type string,
        by_value      type abap_bool,
        optional      type seooptionl,
        default_value type seovalue,
        type          type string,
      end of t_method_param,
      t_method_params type standard table of t_method_param with empty key,

      begin of t_seosubcodf,
        type       type string,
        tableof    type string,
        paroptionl type seooptionl,
        parvalue   type seovalue,
      end of t_seosubcodf.

    methods constructor
      importing descr      type abap_methdescr
                class_name type seoclsname
                document   type ref to zif_zmd_document.

    methods parmkind_to_string
      importing
        parmkind      type abap_parmkind
      returning
        value(result) type string.

  protected section.
  private section.

endclass.



class zcl_markdown_docu_meth implementation.

  method constructor.

    super->constructor( document ).

    data(method_name) = descr-name.
    data(params) = value t_method_params( ).
    loop at descr-parameters assigning field-symbol(<p>).

      data: seosubcodf type t_seosubcodf.
      select single type, tableof, paroptionl, parvalue into corresponding fields of @seosubcodf
      from seosubcodf
               where clsname = @class_name
                 and cmpname = @method_name
                 and sconame = @<p>-name.

      append value #(
        name = to_lower( <p>-name )
        kind = parmkind_to_string( <p>-parm_kind )
        by_value = <p>-by_value
        optional = seosubcodf-paroptionl
        default_value = seosubcodf-parvalue
        type = cond #(
          when seosubcodf-tableof = abap_true then 'table of' )  && |{ seosubcodf-type }| )
      to params.

    endloop.

    doc->heading( level = 3 val = |{ to_lower( descr-name ) }| ).

    if params is not initial.
      types:
        begin of t_param,
          kind type string,
          name type string,
          type type string,
        end of t_param,
        t_params type standard table of t_param with empty key.
      data(parameters) = value t_params(
        for <param> in params (
          kind = parmkind_to_string( conv #( <param>-kind ) )
          name = <param>-name
          type = <param>-type ) ).
      doc->heading( level = 4 val = `Parameters` ).
      data_table( data = parameters ).
    endif.

    if descr-exceptions is not initial.
      doc->heading( level = 4 val = `Exceptions` ).
      data(exceptions) = value stringtab( for <x> in descr-exceptions (
        cond #( when <x>-is_resumable = abap_true
          then |{ <x>-name } [Resumable]|
          else <x>-name ) ) ).
      data_table( data = exceptions auto_header_row = abap_false ).
    endif.

  endmethod.

  method parmkind_to_string.
    result = switch #( parmkind
      when 'I'
        then 'Importing'
      when 'E'
        then 'Exporting'
      when 'C'
        then 'Changing'
      when 'R'
        then 'Returning'
      else parmkind ).
  endmethod.


endclass.
