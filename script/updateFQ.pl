#!/usr/bin/perl
##
## Update Quote.pm
##
use strict;
use warnings;
use File::Copy "cp";

my $fn = $ARGV[0];
my $fn_bkup = $fn . ".bkup";
my $fn_tmp = $fn . ".tmp";
my $quotelets_str = $ARGV[1];
my @quotelets = split(/ /, $quotelets_str);

# backup original
cp($fn, $fn_bkup);

# create modified version
open (my $in, '<', $fn) or die "Can't open file: $!";
open (my $out, '>', $fn_tmp) or die "Can't open file: $!";

while( <$in> ) {
  if ($_ =~ /^\@MODULES\s*=\s*qw.*/) {
    print $out $_;
    while( <$in> ) {
      if ($_ =~ /.*;.*/) {
        foreach ( @quotelets ) {
          my $quotelet_name = $_;
          $quotelet_name =~ s/\.pm//;
          print $out "    $quotelet_name\n";
        }
        last;
      };
      print $out $_;
    }
  }
  print $out $_;
}
close $out;

# overwrite original
chmod(0666, $fn);
cp($fn_tmp, $fn);
chmod(0444, $fn);
unlink($fn_tmp);

1;
__END__