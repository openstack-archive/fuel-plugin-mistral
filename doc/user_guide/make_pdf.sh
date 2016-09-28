#!/bin/bash

lsb_release -a 2>/dev/null | grep 'Distributor ID:' | grep -q Ubuntu || \
  { echo 'Not an Ubuntu'; exit 1; }

apt-cache policy texlive-latex-extra | grep 'Installed:' | grep -q '(none)' && \
 { echo 'Please install texlive-latex-extra package'; exit 1; }

rm -rf _build

make latexpdf

echo -e -n '\nCreated pdf : '

find _build/ | grep -e '.*\.pdf'

echo ''
