#!/bin/bash
set -e -o pipefail

##
## install custom quotelets
##
readonly PROJ_DIR=$(dirname ${BASH_SOURCE:-$0})/../
readonly FQ_ROOT=$(dirname $(perldoc -l Finance::Quote))
readonly DO_TEST=true

# copy quotelets
#QUOTELETS="YahooJapanA.pm YahooJapanB.pm"
QUOTELETS="YahooJapanB.pm" # YahooJapanA is outdated. (2023/3/5)
for QUOTELET in $QUOTELETS; do
  sudo cp ${PROJ_DIR}/lib/Finance/Quote/${QUOTELET} ${FQ_ROOT}/Quote
  sudo chmod 444 ${FQ_ROOT}/Quote/${QUOTELET}
  
  # mac
  #sudo chown root:wheel ${FQ_ROOT}/Quote/${QUOTELET}
  # linux
  sudo chown root:root ${FQ_ROOT}/Quote/${QUOTELET}
done

# update Quote.pm
sudo perl ${PROJ_DIR}/script/updateFQ.pl ${FQ_ROOT}/Quote.pm "${QUOTELETS}"

# test quotelets
if "${DO_TEST}"; then
  pushd ${PROJ_DIR}
  prove t
  popd
fi
