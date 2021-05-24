report zmarkdown_browser.

tables tadir.
include zmarkdown_browser_screen.

start-of-selection.
  data: modes type zcl_oo_plugin_provider=>tt_implementations.
  perform everything.

initialization.
  try.
      modes = zcl_oo_plugin_provider=>get_enabled( zif_oo_plugin_object_info=>category ).
      p_mode = modes[ 1 ]-info-id.
    catch cx_root.
      message 'No plugin implementations found' type 'S' display like 'E'.
      return.
  endtry.

at selection-screen on value-request for p_mode.

  data: listbox_values type vrm_values.
  listbox_values = value #( for <x> in modes (
    key = <x>-instance->get_info( )-id
    text = <x>-instance->get_info( )-description ) ).

  call function 'VRM_SET_VALUES'
    exporting
      id              = 'P_MODE'
      values          = listbox_values
    exceptions
      id_illegal_name = 1
      others          = 2.


form everything.

  data(objects) = value zif_markdown_browser_types=>t_objects( ).
  data(select) = new zcl_markdown_browser_select( ).
  if x_one = abap_true.
    objects = select->single_object(
      object_type = p_type
      object_name = p_name ).
  elseif x_more = abap_true.
    objects = select->multiple_objects(
      object_types = s_type[]
      object_names = s_name[] ).
  elseif x_pkg = abap_true.
    if p_pkg is initial.
      message 'Provide a package' type 'S' display like 'E'.
      return.
    endif.
    objects = select->package( package_name = p_pkg ).
  endif.

  if objects is initial.
    message 'Selection empty' type 'S' display like 'E'.
    return.
  else.
    

    call screen 0999.
  endif.

endform.

end-of-selection.

module status_0999 output.
  set pf-status 'RESULTS'.
endmodule.

module user_command_0999 input.
  case sy-ucomm.
    when 'BACK' or 'EXIT' or 'CANCEL'.
      leave to screen 0.
  endcase.
endmodule.
