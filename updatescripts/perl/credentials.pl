use File::Basename;

sub get_credential {
    local ($name)  = @_;
    $here = dirname(__FILE__);
    $credfile = "$here/../credentials/$name";
    open my $f, $credfile or die "Could not open $credfile: $!";
    my @lines = <$f>;
    close $f;
    chomp @lines;
    return @lines;
}

return(1);
