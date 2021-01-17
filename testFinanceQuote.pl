#!/usr/bin/perl -w
##
## Get stock price using Finance::Quote module.
##
use strict;
use warnings;
use Finance::Quote;
use Math::Round;

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
	$price = $info{$stock, "last"};
	my $date = $info{$stock,"date"};
	# my $time = $info{$stock,"time"}; # time is no longer available (2017/12/8)
	print "$stock:\t\t\$" . $price, " (Date: ", $date, ")\n";
}

# IBM株の評価額を出力
my $num = 8.493; #保有株数（将来的には外部ファイルに定義するように変更する）
my $price_j = $price * $usd; #日本円に換算
my $value = round($price_j * $num);
1 while $value =~ s/^([-+]?\d+)(\d\d\d)/$1,$2/; # カンマ編集
print "IBM評価額:\t", $value, "円", "（保有株数：", $num, "）\n";
