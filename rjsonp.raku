use v6;

# very useful package, use it to debug grammars
# when included, it automatically enables debugging for 
# every grammar in lexical scope of "use"
# install it with:
# zef install Grammar::Debugger

# use Grammar::Debugger;

grammar MCCJSON
{
    # first we match start and end
    # and ignore leading and trailing whitespaces
    token TOP { ^ \s* <object> \s* $ }
    
    # next we define an object as optional pair list
    # between curly brackets 
    token object { '{' \s* <pairlist>? \s* '}' }

    # pair list is one or more pairs, separated by comma
    # and mandatory whitespace cleanup
    token pairlist { <pair> \s* [',' \s* <pair> \s*]* }

    # pair is, unsurprisingly, "key : value"
    token pair { <string> \s* ':' \s* <value> }

    # next, we need an array, which is one or more list of values
    # between square brackets
    token array { '[' \s* <valuelist>? \s* ']' }

    # value is one or more values, separated by comma
    token valuelist { <value> \s* [',' \s* <value> \s*]* }

    # value can be string, number, object, array
    # or special cases: true, false or null
    token value {
        | <string>
        | <number>
        | <object>
        | <array>
        | 'true' | 'false' | 'null'
    }

    # string regex is a bit more complicated to describe here
    # but https://docs.raku.org/language/regexes is our friend
    token string { '"' ( <-[\\"]>+  | '\\' . )* '"' }

    # matching numbers, including negative and ones with floating point
    token number { '-'? \d+ [ \. \d+ ]? }
}

# read file name from command line if present
# if not, default to tests\example.json
sub MAIN(Str $file where *.IO.f = 'tests\example.json') {
    my $contents = $file.IO.slurp;
  
    my $parsed = MCCJSON.parse($contents);

    if $parsed {
        say "JSON is valid!";
        # This can be done nicely with grammar actions
        # but we'll leave that for another version
        say $parsed.raku;
    } else {
        say "Invalid JSON!";
    }
}