report zmarkdown_browser.

tables tadir.
include zmarkdown_browser_screen.

start-of-selection.
  perform everything.

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
    data(gui) = new zcl_markdown_browser_gui(
      program = sy-repid
      screen_number = '0999'
      objects = objects ).

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
    when 'REFRESH'.
      message 'Not yet implemented' type 'S' display like 'E'.
  endcase.
endmodule.