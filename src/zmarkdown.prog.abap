report zmarkdown.

data(demo) = new zcl_markdown_demo( ).
cl_demo_output=>display_text( demo->get( )->as_markdown( ) ).

data(class_docu) = new zcl_markdown_docu_clas( `ZCL_MARKDOWN_DOCU_CLAS` ).

cl_demo_output=>display_text( class_docu->as_markdown( ) ).
cl_demo_output=>display_html( class_docu->as_html( ) ).
