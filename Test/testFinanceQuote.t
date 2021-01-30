#!/usr/bin/perl -w
##
## Get stock price using Finance::Quote module.
##
use strict;
use warnings;
use Finance::Quote;
use Math::Round;

# Create fq instance
my $q = Finance::Quote->new();
$q->timeout(30);
#$q->set_currency("JPY"); # Set Local Currency to JPY

# Get fx rate
my $usd = $q->currency("USD", "JPY");
my $cny = $q->currency("CNY", "JPY");
print "[FX Rate]\n";
print "US Dollar\t\t" . $usd . "\n";
print "China Yuan Renminbi\t" . $cny . "\n";

# Get IBM stock price
# my $exchange = "NYSE";
my $exchange = "yahoo_json"; # change exchange from NYSE to yashoo_json (2017/12/8)
my @symbols = ("IBM");
my %info = $q->fetch($exchange,@symbols); #query price
my $price = 0;

print "[Stock Price]\n";
foreach my $stock (@symbols) {
	unless ($info{$stock,"success"}) {
		warn "Lookup of $stock failed - ".$info{$stock,"errormsg"}.
		     "\n";
		next;
	}
	$price = $info{$stock, "last"};
	my $date = $info{$stock,"date"};
	# my $time = $info{$stock,"time"}; # time is no longer available (2017/12/8)
	print "$stock:\t\t\$" . $price, " (Date: ", $date, ")\n";
}