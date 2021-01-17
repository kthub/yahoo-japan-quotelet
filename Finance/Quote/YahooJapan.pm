#!/usr/bin/perl -w
#
# Finance::Quote::YahooJapan module.
#
# To install this module, follow the steps below.
# 1. Copy YahooJapan.pm to the existing Finance/Quote directory.
# 2. Add following environment variable to the system profile.
#    $ export FQ_LOAD_QUOTELET = '-defaults YahooJapan'
# 3. Specify "Account Code" and "Type of Quote Source" (On-line updating)
#    on the "New Account" dialog of Gnucash.
#
#    Account Code			: code of Yahoo! Japan (ex. "29311041")
#    Type of Quote Source	: "yahoo_japan" (as unknown source) 
#
# 2019/08/30 Keiichi Tsuda <keiichi.tsuda@gmail.com> Revised for new format.
# 2015/12/27 Keiichi Tsuda <keiichi.tsuda@gmail.com> Created.
#
package Finance::Quote::YahooJapan;
use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use JSON;

our $VERSION = '1.0.0'; # VERSION

sub methods {
    return (yahoo_japan => \&yahoo_japan);
}

sub labels {
    return (yahoo_japan => ['method', 'success', 'symbol', 'name', 'date',
                            'isodate', 'time', 'currency', 'price', 'last', 'errormsg']);
}

sub yahoo_japan {
    my ($quoter, @symbols) = @_;
    return unless @symbols; # do nothing if no symbols.

    my $url_base = 'http://stocks.finance.yahoo.co.jp/stocks/detail/';
    my %info = ();
    
    # Account Code Loop.
    foreach my $code (@symbols) {
    	# Target URL.
    	my $url = new URI($url_base . "?code=" . $code);
    	
    	# scrape.
    	my %res = _scrape_url($url);
    	
    	# save result.
		%info = (%info, _save_result($quoter, $code, %res));
    }
	
	return wantarray ? %info : \%info;
}

sub _scrape_url {
	my ($url) = @_;
    my %res = ();
    my $index = 0;
	
	# request
    my $proxy = new LWP::UserAgent;
    my $req = HTTP::Request->new('GET' => $url);
    my $str = $proxy->request($req)->content;
	
	##
	## extract JSON from received HTML
	##
	my $startstr = "window.__PRELOADED_STATE__ =";
	my $endstr = "</script>";

	# remove front part
	my $stridx = index($str, $startstr) + length($startstr);
	$str = substr($str, $stridx);
	
	# remove rear part
	my $endidx = index($str, $endstr);
	$str = substr($str, 0, $endidx);
	
	# trim
	$str =~ s/^\s+|\s+$//g;
	
	##
	## parse JSON
	##
	my $json_data = JSON->new->decode($str);
	
	my $mainFundPriceBoard = $json_data->{'mainFundPriceBoard'};
	my $fundPrices = $mainFundPriceBoard->{'fundPrices'};
	
	my $name = $fundPrices->{'name'};
	my $date = $fundPrices->{'updateDate'};
	my $price = $fundPrices->{'price'};
	%res = (name => $name, price => $price, date => $date);
	
	return %res;
}

sub _save_result {
    my ($quoter, $code, %res) = @_;
    my %info = ();
    
    # set result value.
    $info{$code, 'symbol'}   = $code;
    $info{$code, 'currency'} = 'JPY';
    $info{$code, 'method'}   = 'yahoo_japan';
    
    # set "code" as name to avoid character encoding error.
    #$info{$code, 'name'}     = $res{'name'};
    $info{$code, 'name'}     = $code;
    
    $info{$code, 'date'}     = $res{'date'};
    $info{$code, 'time'}     = '00:00';
    
    # set price.
    my $price = $res{'price'};
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
