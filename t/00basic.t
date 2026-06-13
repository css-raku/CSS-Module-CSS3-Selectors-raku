#!/usr/bin/env perl6

use Test;
use JSON::Fast;
use CSS::Module::CSS3::Selectors;
use CSS::Module::CSS3::Selectors::Actions;
use CSS::Grammar::Test;
use CSS::Writer;

lives-ok {require CSS::Grammar:ver(v0.3.3+) }, "CSS::Grammar version";
my $actions = CSS::Module::CSS3::Selectors::Actions.new: :xml;
my CSS::Writer $xml-writer .= new: :xml;
my CSS::Writer $html-writer .= new;

for ( 't/00basic.json'.IO.lines ) {
    next 
        if .substr(0,2) eq '//';
    my ($rule, $expected) = @( from-json($_) );
    my $input = $expected<input>;
    with $expected<ast> -> $ast {
        my $xml-output = $expected<xml> // $input;
        is $xml-writer.write($ast), $xml-output, $input.raku ~ "xml output";
        with $expected<html> -> $html-output  {
            is $html-writer.write($ast), $html-output, $input.raku ~ "html output";
        }
    }

    &CSS::Grammar::Test::parse-tests(CSS::Module::CSS3::Selectors, $input,
                                     :$rule,
                                     :$actions,
                                     :suite<css3x-selectors>,
                                     :$expected );
}

done-testing;
