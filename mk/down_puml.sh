#!/bin/bash

PLANTUML_JAR=$1
URL=$(wget -O - https://plantuml.com/download |
    perl -pe 's/</\n</g' |
    grep -E "plantuml-bsd.+Compiled jar" |
    perl -pe 's/^.+"(https[^"]+\.jar)".+$/$1/')

wget -O ${PLANTUML_JAR} ${URL}
