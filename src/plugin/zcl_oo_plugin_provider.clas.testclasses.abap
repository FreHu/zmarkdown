class lcl_test definition final for testing
inheriting from zcl_abap_unit_wrapper
duration short
risk level harmless.

  private section.
    methods:
      execute for testing.

endclass.


class lcl_test implementation.

  method execute.
    data(enabled) = zcl_oo_plugin_provider=>get_enabled( if_dmee_plugin_ci=>category ).
    assert_not_initial( enabled ).

    data(empty) = zcl_oo_plugin_provider=>get_enabled( '' ).
    assert_initial( empty ).
  endmethod.

endclass.
