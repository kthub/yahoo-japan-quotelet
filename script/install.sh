#!/bin/bash
set -e -o pipefail

##
## install custom quotelets
##
readonly FQ_ROOT=`dirname $(perldoc -l Finance::Quote)`
readonly DO_TEST=false

# copy quotelets
#QUOTELETS="YahooJapanA.pm YahooJapanB.pm"
QUOTELETS="YahooJapanB.pm" # YahooJapanA is outdated. (2023/3/5)
for QUOTELET in $QUOTELETS; do
  sudo cp $(dirname $BASH_SOURCE)/../lib/Finance/Quote/${QUOTELET} ${FQ_ROOT}/Quote
  sudo chmod 444 ${FQ_ROOT}/Quote/${QUOTELET}
  
  # mac
  sudo chown root:wheel ${FQ_ROOT}/Quote/${QUOTELET}
  # linux
  #sudo chown root:root ${FQ_ROOT}/Quote/${QUOTELET}
done

# update Quote.pm
sudo perl updateFQ.pl ${FQ_ROOT}/Quote.pm "${QUOTELETS}"

# test quotelets
if "${DO_TEST}"; then
  TESTS="testYahooJapanB.t"
  for TEST in $TESTS; do
    perl t/${TEST}
  done
fi