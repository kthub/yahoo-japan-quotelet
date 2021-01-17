#!/usr/bin/perl -w
##
## Get stock price using Finance::Quote module.
##
use strict;
use warnings;
use Finance::Quote;
use Math::Round;
use Logger::Simple;
use lib '.';

# インスタンスの生成
my $q = Finance::Quote->new();
$q->timeout(30);
#$q->set_currency("JPY"); # Set Local Currency to JPY

# 為替レートの取得
my $usd = $q->currency("USD", "JPY");
my $cny = $q->currency("CNY", "JPY");
print "[為替レート]\n";
print "USドル\t\t" . $usd . "\n";
print "中国元\t\t" . $cny . "\n";

# IBM株価の取得
# my $exchange = "NYSE";
my $exchange = "yahoo_json"; # change exchange from NYSE to yashoo_json (2017/12/8)
my @symbols = ("IBM");
my %info = $q->fetch($exchange,@symbols); #株価のQuery
my $price = 0;

print "[株価]\n";
foreach my $stock (@symbols) {
	unless ($info{$stock,"success"}) {
		warn "Lookup of $stock failed - ".$info{$stock,"errormsg"}.
		     "\n";
		next;
	}
	#$price = $info{$stock,"price"};
	$price = $info{$stock, "last"};
	my $date = $info{$stock,"date"};
	# my $time = $info{$stock,"time"}; # time is no longer available (2017/12/8)
	print "$stock:\t\t",
	      # "Volume: ",$info{$stock,"volume"},"\t",
	      # "Price: " ,$info{$stock,"price"},"\n";
	      "\$". $price, " Date: ", $date, "\n";
}

# IBM株の評価額を出力
my $num = 7; #保有株数（将来的には外部ファイルに定義するように変更する）
my $price_j = $price * $usd; #日本円に換算
my $value = round($price_j * $num);
1 while $value =~ s/^([-+]?\d+)(\d\d\d)/$1,$2/;
print "IBM評価額:\t", $value, "円", "（保有株数：", $num, "）\n";

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
