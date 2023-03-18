#!/usr/bin/perl
##
## Sample for currency exchange rate
##
use strict;
use warnings;
use Finance::Quote;

# Alpha Vantage API Key
my $av_key = 'OBVVLLL6VYB9VJFW';

my $q = Finance::Quote->new(currency_rates => {order        => ['AlphaVantage'],
                                               alphavantage => {API_KEY => $av_key}});
$q->timeout(30);
$q->set_currency("JPY"); # Set Local Currency to JPY

# Get currency exchange rate
my $usd = $q->currency("USD", "JPY");
my $cny = $q->currency("CNY", "JPY");

print "[Currency Exchange Rate]\n";
print "USD\t" . $usd . "\n";
print "CNY\t" . $cny . "\n";