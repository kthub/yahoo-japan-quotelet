#!/bin/sh
FQ_ROOT=`dirname $(perldoc -l Finance::Quote)`
QUOTELETS="YahooJapanA.pm YahooJapanB.pm"

# install
for QUOTELET in $QUOTELETS; do
  sudo cp lib/Finance/Quote/${QUOTELET} ${FQ_ROOT}/Quote
  sudo chmod 444 ${FQ_ROOT}/Quote/${QUOTELET}
  sudo chown root:root ${FQ_ROOT}/Quote/${QUOTELET}
done

# test
perl t/testYahooJapanB.t
