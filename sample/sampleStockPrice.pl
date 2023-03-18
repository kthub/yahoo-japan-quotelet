#!/usr/bin/perl
##
## Sample for stock price
##
use strict;
use warnings;
use Finance::Quote;

# Finance::Quote
my $q = Finance::Quote->new();
$q->timeout(30);

# Get Stock Price (IBM)
# my $exchange = "NYSE";
my $exchange = "yahoo_json"; # change exchange from NYSE to yashoo_json (2017/12/8)
my @symbols = ("IBM");
my %info = $q->fetch($exchange,@symbols);

print "[Stock Price]\n";
foreach my $stock (@symbols) {
	unless ($info{$stock,"success"}) {
		warn "Lookup of $stock failed - " . $info{$stock,"errormsg"} . "\n";
		next;
	}
	my $price = $info{$stock, "last"};
	my $date = $info{$stock,"date"};
	# my $time = $info{$stock,"time"}; # time is no longer available (2017/12/8)
	print "$stock:\t" . "\$". $price, " Date: ", $date, "\n";
}