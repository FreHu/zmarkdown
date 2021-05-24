CLASS lcl_test DEFINITION FINAL FOR TESTING
INHERITING FROM cl_dmee_test_base
DURATION SHORT
RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      execute FOR TESTING.

ENDCLASS.


CLASS lcl_test IMPLEMENTATION.

  METHOD execute.
    DATA(enabled) = zcl_oo_plugin_provider=>get_enabled( if_dmee_plugin_ci=>category ).
    assert_not_initial( enabled ).

    DATA(empty) = zcl_oo_plugin_provider=>get_enabled( '' ).
    assert_initial( empty ).
  ENDMETHOD.

ENDCLASS.
