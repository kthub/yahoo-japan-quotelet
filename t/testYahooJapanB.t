use strict;
use warnings;
use Test::More;
use Finance::Quote;

# Finance::Quote
my $q = Finance::Quote->new();
$q->timeout(30);

my $exchange_yj = "yahoo_japan_b";

{
my @symbols_yj = ("03311187", "0431Q169");
my %itinfo_yj = $q->fetch($exchange_yj,@symbols_yj);
foreach my $code (@symbols_yj) {
	unless ($itinfo_yj{$code,"success"}) {
		if (defined $itinfo_yj{$code,"errormsg"}) {
			warn "Lookup of $code failed - " . $itinfo_yj{$code,"errormsg"} . "\n";
		}
    fail("TEST-" . $itinfo_yj{$code,"name"});
		next;
	}
  pass("TEST-" . $itinfo_yj{$code,"name"});
}
}

done_testing;