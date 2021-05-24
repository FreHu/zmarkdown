interface zif_oo_plugin_object_info public.

  interfaces: zif_oo_plugin.

  
  constants: category type string value `OBJECT_INFO`.

  methods display
    importing
      object_type type tadir-object
      object_name type tadir-obj_name
      gui_control type ref to cl_gui_html_viewer.

endinterface.
