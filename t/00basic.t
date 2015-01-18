#!/usr/bin/env perl6

use Test;
use JSON::Tiny;

use CSS3::Module::Selectors;
use CSS3::Module::Selectors::Actions;
use CSS::Grammar::Test;

my $actions = CSS3::Module::Selectors::Actions.new;

for ( 't/00basic.json'.IO.lines ) {
    next 
        if .substr(0,2) eq '//';

    my ($rule, $expected) = @( from-json($_) );
    my $input = $expected<input>;

    CSS::Grammar::Test::parse-tests(CSS3::Module::Selectors, $input,
				    :$rule,
				    :$actions,
				    :suite<css3x-selectors>,
				    :$expected );
}

done;
