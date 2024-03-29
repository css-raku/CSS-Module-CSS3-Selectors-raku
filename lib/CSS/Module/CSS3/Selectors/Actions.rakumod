use v6;
use CSS::Grammar::Actions;
class CSS::Module::CSS3::Selectors::Actions
    is CSS::Grammar::Actions {

    use CSS::Grammar::Defs :CSSValue, :CSSSelector;

    method combinator:sym<sibling>($/)  { make '~' }

    method no-namespace($/)     { make $.build.token('', :type(CSSValue::ElementNameComponent)) }
    method namespace-prefix($/) { make $.build.token( $<prefix>.ast, :type(CSSValue::NamespacePrefixComponent)) }
    method wildcard($/)         { make ~$/ }
    method qname($/)            { make $.build.token( $.build.node($/), :type(CSSValue::QnameComponent)) }
    method universal($/)        { make $.build.token( $.build.node($/), :type(CSSValue::QnameComponent)) }

    method structural-selector($/)  {
        my $ident = $<Ident>.lc;
        return $.warning('usage '~$ident~'(an[+/-b]|odd|even) e.g. "4" "3n+1"')
            if $<any-args>;

        my %node = %( $.build.node($/).Slip, :$ident );

        make $.build.token( %node, :type(CSSSelector::PseudoFunction));
    }
    method pseudo-function:sym<structural-selector>($/)  { make $<structural-selector>.ast }

    method negation-expr($/) {
        return $.warning('bad :not() argument', ~$<any-arg>)
            if $<any-arg>;
        return $.warning('illegal nested negation', ~$<pseudo>)
            if $<nested>;
        make $.build.list($/);
    }

    method pseudo-function:sym<negation>($/) {
        return $.warning('missing/incorrect arguments to :not()', ~$<any-args>)
            if $<any-args>;
        make $.build.pseudo-func('not', $_)
            with $<negation-expr>;
    }
}
