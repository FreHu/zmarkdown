REPORT zmarkdown.

DATA(md) = NEW zcl_markdown( ).
DATA(md_string) = md->test( ).

cl_demo_output=>display_text( md_string ).

DATA(html_string) = cl_ktd_dita_markdown_api=>transform_md_to_html( md_string ).

cl_demo_output=>display_html( html_string ).
