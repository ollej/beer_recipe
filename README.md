Beer Recipe
===========

Generate html web pages from BeerXML files exported from beer recipe programs like BeerSmith or Brew Pal.

Wrapper around nrb-beerxml to make calculations and simplify making output templates.

Usage
-----

```bash
$ ruby bin/beer_recipe -h
Usage:
  bin/beer_recipe <beer.xml> [--format=<format>]
  bin/beer_recipe -h | --help
  bin/beer_recipe --version
```

Format may be 'html' or 'text', but defaults to html.

