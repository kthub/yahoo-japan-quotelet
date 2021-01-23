# Yahoo Japan Quotelet
GnuCashから評価額を自動的に取得するモジュールです。  
Yahoo!ファイナンスのwebページをスクレイピングして評価額を取得します。  
このモジュールはPerlのFinance::QuoteのQuoteletとして作成されており、Finance::Quoteに追加しておくことでGnuCashのGUIから設定して利用可能となります。

## ファイルの説明
[モジュール]
```
Finance/Quote/YahooJapanA.pm : yahoo_japan_a タイプのQuotelet
Finance/Quote/YahooJapanB.pm : yahoo_japan_b タイプのQuotelet
```
[テストコード]
```
testFinanceQuote.pl : FinanceQuoteの実行デモ
testYahooJapanA.pl  : YahooJapanAモジュールのテストコード
testYahooJapanB.pl  : YahooJapanBモジュールのテストコード
```

## インストール方法
- Perlのモジュールディレクトリの下記のパスにモジュールをコピー（パスは環境に依存するため適切に読み替えてください）
```
/Library/Perl/5.28/Finance/Quote
```
- 下記のファイルを編集し、177行目あたりの`@modules`を読み込んでいる箇所に`YahooJapanA`, `YahooJapanB`を追加
```
/Library/Perl/5.28/Finance/Quote.pm
```
追加部分のイメージ
```
@modules = qw/AEX AIAHK AlphaVantage ASEGR ASX BMONesbittBurns BSERO Bourso Cdnfundlibrary Citywire CSE Currencies DekaDWS FTPortfolios Fidelity FidelityFixed FinanceCanada FoolFTfunds HU GoldMoney HEX IndiaMutual LeRevenuManInvestments Morningstar MorningstarJP MStaruk NZXPlatinum SEB SIXfunds SIXshares StockHouseCanada TSP TSXTdefunds Tdwaterhouse Tiaacref TNetuk Troweprice TrustnetUnion USFedBonds VWD ZA Cominvest Finanzpartner YahooJSONYahoo::Asia Yahoo::Australia Yahoo::Brasil Yahoo::EuropeYahoo::NZ Yahoo::USA YahooYQL ZA_UnitTrusts YahooJapanA YahooJapanB/; }
```
