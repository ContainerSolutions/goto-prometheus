#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Deleting $DIR/README.md"
rm -rf $DIR/README.md;
echo "Creating $DIR/README.md"
cat $DIR/*.md > $DIR/README.md
