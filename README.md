# zmarkdown

Markdown generator and documentation browser.

Many things do not work yet, if you want to have a stable version I suggest porting the classes to your namespace.

## Purpose and motivation

The end goal is to be able to export documentation for a full package in a folder structure which can be pushed to git.

I also needed a valid reason to name a method `_____________________________`.

## Example Usage

### Browsing documentation

Transaction `ZMARKDOWN_BROWSER` allows you to browse documentation.

![image](https://user-images.githubusercontent.com/5097067/107849655-fc7a6d00-6dfc-11eb-91e2-063ee0787ad5.png)

![image](https://user-images.githubusercontent.com/5097067/107849674-2df33880-6dfd-11eb-891b-beed843c6d7d.png)


### Usage from ABAP

This code will generate the markdown rendered below it.

```abap    md = NEW zcl_markdown( ).
        data(md) = new zcl_markdown( ).
    data(style) = md->style.

    md = md->heading( level = 1 val = |Markdown generator - showcase| ).

    do 6 times.
      md = md->heading( level = sy-index val = |Heading { sy-index }| ).
    enddo.

    md->text( 'This is text.'
      )->text( style->bold( 'This is bold text.' )
      )->text( style->italic( 'This is italic text.' )
      )->text( style->italic_bold( `This is italic bold text.` )
      )->text( style->bold_italic( `This is bold italic text. Carefully note the difference.` )
      )->text( |{ style->italic( 'This is italic' ) } and { style->bold( 'this is bold.' ) }|
            )->text( |The method { style->inline_code( 'zcl_mardown_style->inline_code' ) } outputs inline code.|
      )->heading( level = 2 val = `Blockquotes`
              )->blockquote( md->document
      )->heading( level = 2 val = `Nested Blockquotes`
              )->blockquote( md->document
      )->heading( level = 2 val = `Unordered Lists`
              )->list( value stringtab(
                ( `Item 1` )
                ( `Item 2` )
                ( `Item 3` ) )
      )->heading( level = 2 val = `Numbered Lists`
              )->numbered_list( value stringtab(
                ( `Item 1` )
                ( `Item 2` )
                ( `Item 3` ) )
            )->heading( level = 2 val = `Horizontal Rule`
      )->______________________________(
      )->heading( level = 2 val = `Code blocks`
            )->code_block(
              |  )->heading( level = 2 val = `Nested Blockquotes`\r\n| &
              |        )->blockquote( md->document\r\n| &
              |\r\n| &
              |      )->heading( level = 2 val = `Unordered Lists`\r\n| &
              |        )->list( VALUE stringtab(\r\n| &
              |          ( `Item 1` )\r\n| &
              |          ( `Item 2` )\r\n| &
              |          ( `Item 3` ) )\r\n| &
              |\r\n| &
              |      )->heading( level = 2 val = `Numbered Lists`\r\n| &
              |        )->numbered_list( VALUE stringtab(\r\n| &
              |          ( `Item 1` )\r\n| &
              |          ( `Item 2` )\r\n| &
              |          ( `Item 3` ) )\r\n| &
              |      )->heading( level = 2 val = `Horizontal Rule`\r\n| &
              |\r\n| &
              |      )->______________________________(|
    )->table( value stringtab(
      ( `col1;col2;col3;col4;` )
      ( `a;b;c;d` )
      ( `1;2;3;4;`)
      ( `e;f;g;h;` )
      ( |{ style->bold( `bold` ) };{ style->italic( `italic` )
        };{ style->bold_italic( `bold_italic` ) }{ style->inline_code( `code` ) };;| )
    ) ).
```

# Markdown generator - showcase
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6
This is text.
**This is bold text.**
*This is italic text.*
***This is italic bold text.***
***This is bold italic text. Carefully note the difference.***
*This is italic* and **this is bold.**
The method `zcl_mardown_style->inline_code` outputs inline code.
## Blockquotes
> # Markdown generator - showcase
> # Heading 1
> ## Heading 2
> ### Heading 3
> #### Heading 4
> ##### Heading 5
> ###### Heading 6
> This is text.
> **This is bold text.**
> *This is italic text.*
> ***This is italic bold text.***
> ***This is bold italic text. Carefully note the difference.***
> *This is italic* and **this is bold.**
> The method `zcl_mardown_style->inline_code` outputs inline code.
> ## Blockquotes
## Nested Blockquotes
> # Markdown generator - showcase
> # Heading 1
> ## Heading 2
> ### Heading 3
> #### Heading 4
> ##### Heading 5
> ###### Heading 6
> This is text.
> **This is bold text.**
> *This is italic text.*
> ***This is italic bold text.***
> ***This is bold italic text. Carefully note the difference.***
> *This is italic* and **this is bold.**
> The method `zcl_mardown_style->inline_code` outputs inline code.
> ## Blockquotes
> > # Markdown generator - showcase
> > # Heading 1
> > ## Heading 2
> > ### Heading 3
> > #### Heading 4
> > ##### Heading 5
> > ###### Heading 6
> > This is text.
> > **This is bold text.**
> > *This is italic text.*
> > ***This is italic bold text.***
> > ***This is bold italic text. Carefully note the difference.***
> > *This is italic* and **this is bold.**
> > The method `zcl_mardown_style->inline_code` outputs inline code.
> > ## Blockquotes
> ## Nested Blockquotes
## Unordered Lists
- Item 1
- Item 2
- Item 3
## Numbered Lists
1. Item 1
2. Item 2
3. Item 3
## Horizontal Rule
__________ 
## Code blocks
```abap
  )->heading( level = 2 val = `Nested Blockquotes`
        )->blockquote( md->document

      )->heading( level = 2 val = `Unordered Lists`
        )->list( VALUE stringtab(
          ( `Item 1` )
          ( `Item 2` )
          ( `Item 3` ) )

      )->heading( level = 2 val = `Numbered Lists`
        )->numbered_list( VALUE stringtab(
          ( `Item 1` )
          ( `Item 2` )
          ( `Item 3` ) )
      )->heading( level = 2 val = `Horizontal Rule`

      )->______________________________(
```
| col1| col2| col3| col4 |
|------|------|------|------| 
| a | b | c | d |
| 1 | 2 | 3 | 4 |
| e | f | g | h |
| **bold** | *italic* | ***bold_italic***`code` |  |

