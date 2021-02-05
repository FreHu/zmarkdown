# zmarkdown
Markdown generator

Early draft, I would not start depending on this yet if I were you.

## Purpose and motivation

I needed a valid reason to name a method `_____________________________`.

## Features

Supports the following:

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

***This is bold italic text.***

## Blockquote

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

> ***This is bold italic text.***

## Nested Blockquote

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

> ***This is bold italic text.***

> ## Blockquote

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

> > ***This is bold italic text.***

## Unordered list

- Item 1

- Item 2

- Item 3

## Numbered list

1. Item 1

2. Item 2

3. Item 3

## Horizontal rule

__________ 

## Code block

```abap

md = md && list( VALUE stringtab(

 ( `Item 1` )

 ( `Item 2` )

 ( `Item 3` )

) ).



md = md && numbered_list( VALUE stringtab(

 ( `Item 1` )

 ( `Item 2` )

 ( `Item 3` )

) ).

```
