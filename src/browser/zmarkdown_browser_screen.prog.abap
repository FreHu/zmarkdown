selection-screen begin of block mode
  with frame title text-003.

  parameters:
    x_one  radiobutton group fsrc user-command sel_mode default 'X',
    x_more radiobutton group fsrc,
    x_pkg  radiobutton group fsrc.

selection-screen end of block mode.

selection-screen begin of block b_single
  with frame title text-001.

  parameters:
    p_type like tadir-object modif id sgl,
    p_name like tadir-obj_name modif id sgl.

selection-screen end of block b_single.

selection-screen begin of block b_multiple
  with frame title text-002.

  select-options:
      s_type for tadir-object modif id mtp,
      s_name for tadir-obj_name modif id mtp.

selection-screen end of block b_multiple.

selection-screen begin of block b_package
  with frame title text-004.

  parameters:
       p_pkg like tdevc-devclass modif id pkg.

selection-screen end of block b_package.

at selection-screen output.
  loop at screen into data(wa).
    case wa-group1.
      when 'SGL'.
        if x_one = abap_false.
          wa-active = '0'.
          modify screen.
          continue.
        endif.
      when 'MTP'.
        if x_more = abap_false.
          wa-active = '0'.
          modify screen.
          continue.
        endif.
      when 'PKG'.
        if x_pkg = abap_false.
          wa-active = '0'.
          modify screen.
          continue.
        endif.
    endcase.
  endloop.
