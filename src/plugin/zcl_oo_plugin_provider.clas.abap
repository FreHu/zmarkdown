class zcl_oo_plugin_provider definition
  public final.

  public section.
    types:
      begin of t_implementation,
        info     type zif_oo_plugin=>t_plugin_info,
        instance type ref to zif_oo_plugin,
      end of t_implementation,
      tt_implementations type sorted table of t_implementation with unique key info.

    class-methods get_all
      importing
        category       type zif_oo_plugin=>t_plugin_info-category
      returning
        value(results) type tt_implementations.

    class-methods get_by_id
      importing
        category       type zif_oo_plugin=>t_plugin_info-category
        id             type zif_oo_plugin=>t_plugin_info-id
      returning
        value(results) type t_implementation.


    class-methods get_enabled
      importing
        category       type zif_oo_plugin=>t_plugin_info-category
      returning
        value(results) type tt_implementations.

    class-data: cache type tt_implementations.

endclass.


class zcl_oo_plugin_provider implementation.

  method get_all.

    if cache is not initial.
      results = cache.
      return.
    endif.

    try.
        data: impl type ref to zif_oo_plugin.
        data(intf) = new cl_oo_interface( zif_oo_plugin=>plugin_interface ).
        data(implementations) = intf->get_implementing_classes( ).
        loop at implementations assigning field-symbol(<impl>).
          create object impl type (<impl>-clsname).
          data(info) = impl->get_info( ).
          if info-category = category.
            insert value #(
              info = impl->get_info( )
              instance = impl ) into table results.
          endif.
        endloop.
      catch cx_root.
    endtry.

    cache = results.
  endmethod.

  method get_enabled.
    data(all) = get_all( category ).
    loop at all assigning field-symbol(<one>).
      if <one>-instance->is_enabled( ).
        insert <one> into table results.
      endif.
    endloop.
  endmethod.

  method get_by_id.
    try.
        data(sane_category) = to_upper( condense( category ) ).
        data(sane_id) = to_upper( condense( id ) ).
        results = cache[ info-category = sane_category info-id = sane_id ].
      catch cx_root.
    endtry.
  endmethod.

endclass.
