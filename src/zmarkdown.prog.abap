REPORT zmarkdown.

DATA(demo) = zcl_markdown_demo=>get( ).

cl_demo_output=>display_text( demo->as_markdown( ) ).
cl_demo_output=>display_html( demo->as_html( ) ).
