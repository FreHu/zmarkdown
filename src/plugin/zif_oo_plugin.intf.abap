interface zif_oo_plugin public.

  constants: plugin_interface type seoclsname value `ZIF_OO_PLUGIN`.

  types:
    begin of t_plugin_info,
      id          type string,
      category    type string,
      class_name  type seoclsname,
      description type string,
    end of t_plugin_info.
    

  methods get_info returning value(result) type t_plugin_info.
  methods is_enabled returning value(result) type abap_bool.

endinterface.
