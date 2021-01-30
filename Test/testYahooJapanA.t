#!/usr/bin/perl -w
##
## Test YahooJapanA
##
use strict;
use warnings;
use Finance::Quote;
use Math::Round;
use Logger::Simple;
#use lib '.';

# インスタンスの生成
my $q = Finance::Quote->new();
$q->timeout(30);
#$q->set_currency("JPY"); # Set Local Currency to JPY

# 投資信託基準価額の取得 (Investment Trust)
# 自前の Web Scraping Module (ScrapeUtil) によるサンプル
#print "[投資信託]\n";
#my %itinfo = ScrapeUtil::fetch();
#foreach my $key (sort keys %itinfo) {
#	#print $itinfo{$key}{name}, ":\t", $itinfo{$key}{price}, "\n";
#	# TODO utf-8 だったら encode するというロジックに変更する必要がある。
#	print Encode::encode('utf-8', $itinfo{$key}{name}), ":\t", 
#			$itinfo{$key}{price}, " (",
#			$itinfo{$key}{date}, ")",
#			"\n";
#}

# Finance::Quote::YahooJapan によるサンプル
my $exchange_yj = "yahoo_japan_two";
#my @symbols_yj = ("0331302B", "2931113C", "2931213C", "29311041");
my @symbols_yj = ("1326", "1542");
my %itinfo_yj = $q->fetch($exchange_yj,@symbols_yj);

print "[YahooJapan2 Module Sample]\n";
foreach my $code (@symbols_yj) {
	unless ($itinfo_yj{$code,"success"}) {
		warn "Lookup of $code failed - ".$itinfo_yj{$code,"errormsg"}.
		     "\n";
		next;
	}
	my $name = $itinfo_yj{$code,"name"};
	$name = Encode::encode('utf-8', $name);
	my $price = $itinfo_yj{$code,"price"};
	my $date = $itinfo_yj{$code,"date"};
	print "$name:\t" . $price . " (" . $date . ")\n";
}

# Logging demo
#my $log=Logger::Simple->new(LOG=>"/Users/keiichi/Home/dev/finance_quote.log");
#$log->write("sample log message");
#my %yjinfo = $q->fetch("yahoo_japan","0331302B");
