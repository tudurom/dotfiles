#!/bin/sh
#
# Push to all remotes
# (c) tudurom 2016 - wtfpl
#

for r in $(git remote); do
    git push "$r" master
done
