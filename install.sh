#!/bin/sh

# copy modules
sudo cp Finance/Quote/YahooJapanA.pm /Library/Perl/5.28/Finance/Quote
sudo cp Finance/Quote/YahooJapanB.pm /Library/Perl/5.28/Finance/Quote

# change permission
sudo chmod 444 /Library/Perl/5.28/Finance/Quote/YahooJapanA.pm
sudo chown root:wheel /Library/Perl/5.28/Finance/Quote/YahooJapanA.pm

sudo chmod 444 /Library/Perl/5.28/Finance/Quote/YahooJapanB.pm
sudo chown root:wheel /Library/Perl/5.28/Finance/Quote/YahooJapanB.pm
