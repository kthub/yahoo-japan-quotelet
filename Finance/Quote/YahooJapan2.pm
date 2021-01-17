#!/usr/bin/perl -w
#
# Finance::Quote::YahooJapan2 module.
#
# To install this module, follow the steps below.
# 1. Copy YahooJapan2.pm to the existing Finance/Quote directory.
# 2. Add following environment variable to the system profile.
#    $ export FQ_LOAD_QUOTELET = '-defaults YahooJapan'
# 3. Specify "Account Code" and "Type of Quote Source" (On-line updating)
#    on the "New Account" dialog of Gnucash.
#
#    Account Code			: code of Yahoo! Japan (ex. "29311041")
#    Type of Quote Source	: "yahoo_japan_two" (as unknown source) 
#
# 2020/1/3 Keiichi Tsuda <keiichi.tsuda@gmail.com>
#

package Finance::Quote::YahooJapan2;
use Web::Scraper;
use URI;
use strict;
use warnings;

our $VERSION = '1.0.0'; # VERSION

sub methods {
    return (yahoo_japan_two => \&yahoo_japan_two);
}

sub labels {
    return (yahoo_japan_two => ['method', 'success', 'symbol', 'name', 'date',
                            'isodate', 'time', 'currency', 'price', 'last', 'errormsg']);
}

sub yahoo_japan_two {
    my ($quoter, @symbols) = @_;
    return unless @symbols; # do nothing if no symbols.

    my $url_base = 'http://stocks.finance.yahoo.co.jp/stocks/detail/';
    my %info = ();
    
    # Generate scraper for Yahoo! Japan using Web::Scraper.
	my $scraper = scraper {
		process 'td[class="stoksPrice"]', 'price' => 'TEXT';
		#process 'th[class="symbol"] > h1', 'name' => 'TEXT';
		process 'dd[class="yjSb real"] > span', 'date' => 'TEXT';
	};
    
    # Account Code Loop.
    foreach my $code (@symbols) {
    	# Target URL.
    	my $url = new URI($url_base . "?code=" . $code);
    	
    	# scrape.
    	my $res = $scraper->scrape($url);
    	
    	# save result.
		%info = (%info, _save_result($quoter, $code, $res));
    }
	
	return wantarray ? %info : \%info;
}

sub _save_result {
    my ($quoter, $code, $res) = @_;
    my %info = ();
    
    # set result value.
    $info{$code, 'symbol'}   = $code;
    $info{$code, 'currency'} = 'JPY';
    $info{$code, 'method'}   = 'yahoo_japan_two';
    #$info{$code, 'name'}     = $res->{'name'};
    $info{$code, 'name'}     = $code;
    $info{$code, 'date'}     = $res->{'date'};
    $info{$code, 'time'}     = '00:00';
    
    # set price.
    my $price = $res->{'price'};
    $price =~ s/,//g; # exclude comma.
    $info{$code, 'last'}    = $price;
    $info{$code, 'price'}   = $price;

    # validate quote.
    my @errors = ();
    push @errors, 'Invalid name.' if ($info{$code, 'name'} =~ /^\s*$/); # if all space => error.
    push @errors, 'Invalid price.' if ($info{$code, 'price'} eq '');
    if ($info{$code, 'date'} eq '') {
        push @errors, 'Invalid datetime.';
    } else {
    	# update date value to the isodate format.
    	my $isodate = _convert_to_isodate($info{$code, 'date'});
    	
    	# update date/isodate value using Quote.pm sub-routine.
        $quoter->store_date(\%info, $code, { isodate => $isodate });
    }

    $info{$code, 'errormsg'} = join ' / ', @errors;
    $info{$code, 'success'}  = $info{$code, 'errormsg'} ? 0 : 1;

    return %info;
}

sub _convert_to_isodate() {
    my $datetime = shift; # datetime format is MM/DD
    my @now = localtime;
    my ($year, $mon, $mday, $time) = ($now[5] + 1900, 0, 0, '15:00:00');

    if ($datetime =~ /(\d{1,2})\/(\d{1,2})/) {
        # MM/DD
        ($mon, $mday) = ($1, $2);
        $year-- if ($now[4] + 1 < $mon); # MM may point last December in January.
    }

    my $date = sprintf '%04d-%02d-%02d', $year, $mon, $mday; #isodate format
    return $date;
}

1;
__END__
