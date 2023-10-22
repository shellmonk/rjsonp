use v6;

sub MAIN(Str $file where *.IO.f = 'tests\example.json') {
    my $contents = $file.IO.slurp;
    say $contents;
}