#!/usr/bin/perl
##
## Debug YahooJapanA
##
use strict;
use warnings;
use Finance::Quote;

# Finance::Quote
my $q = Finance::Quote->new();
$q->timeout(30);
$q->set_currency("JPY"); # Set Local Currency to JPY

my $exchange_yj = "yahoo_japan_b";
my @symbols_yj = ("03311187", "0431Q169");
my %itinfo_yj = $q->fetch($exchange_yj,@symbols_yj);

print "[YahooJapanB Module Sample]\n";
foreach my $code (@symbols_yj) {
	unless ($itinfo_yj{$code,"success"}) {
		if (defined $itinfo_yj{$code,"errormsg"}) {
			warn "Lookup of $code failed - " . $itinfo_yj{$code,"errormsg"} . "\n";
		} else {
			warn "Lookup of $code failed.\n";
		}
		next;
	}
	my $name = $itinfo_yj{$code,"name"};
	#$name = Encode::encode('utf-8', $name);
	my $price = $itinfo_yj{$code,"price"};
	my $date = $itinfo_yj{$code,"date"};
	print "$name:\t" . $price . " (" . $date . ")\n";
}
