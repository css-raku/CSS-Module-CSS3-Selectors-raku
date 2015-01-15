use v6;

# CSS3 Selectors Module
# specification: http://www.w3.org/TR/2011/REC-css3-selectors-20110929/
# Notes:
# -- have relaxed negation rule to take a list of arguments - in common use
#    and supported  by major browsers.

use CSS::Grammar::CSS3;
grammar CSS3::Selectors:ver<20110929.000>
    is CSS::Grammar::CSS3 {

    # extensions:
    # ----------
    # inherited combinators: '+' (adjacent), '>' (child)
    rule combinator:sym<sibling> { '~' }

    rule no-namespace {<?>}
    rule wildcard {'*'}
    rule namespace-prefix {[<prefix=.Ident>|<prefix=.wildcard>|<prefix=.no-namespace>]'|'}

    # use <qname> in preference to <type_selector>
    # - see http://www.w3.org/TR/2008/CR-css3-namespace-20080523/#css-qnames
    rule qname      {<namespace-prefix>? <element-name>}
    rule universal  {<namespace-prefix>? <element-name=.wildcard>}
    rule simple-selector { [<qname><!before '|'>|<universal>][<id>|<class>|<attrib>|<pseudo>]*
                               | [<id>|<class>|<attrib>|<pseudo>]+ }

    rule attrib        {'[' <Ident> [ <op=.attribute-selector> [<Ident>|<string>] ]? ']'}

    rule term:sym<unicode-range> {:i<unicode-range>}

    # inherited from base: = ~= |=
    rule attribute-selector:sym<prefix>    {'^='}
    rule attribute-selector:sym<suffix>    {'$='}
    rule attribute-selector:sym<substring> {'*='}

    # to compute a.n + b
    proto rule structural-expr {*}
    rule structural-expr:sym<keyw> {:i [ odd | even ] & <keyw=.Ident> }
    token sign { <[ \+ \- ]> }
    rule structural-expr:sym<expr> {
        [:i <op=.sign>?$<int:a>=<.uint>?<op(rx:i/n/)> [<op=.sign> $<int:b>=<.uint>]?
        ||  <op=.sign>?$<int:b>=<.uint>
        ]
    }

    rule structural-selector {:i $<Ident>=[[nth|first|last|nth\-last]\-[child|of\-type]]'(' [ <expr=.structural-expr> || <any-args> ] ')'}
    rule pseudo-function:sym<structural-selector> {<structural-selector>}
    rule negation-expr {[<qname> | <universal> | <id> | <class> | <attrib> | [$<nested>=<?before [:i':not(']> || <?>] <pseudo> | <any-arg> ]+}
    rule pseudo-function:sym<negation>  {:i'not(' [ <negation-expr> || <any-args> ] ')'}

}

