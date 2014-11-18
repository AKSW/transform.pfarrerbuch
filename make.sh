#!/bin/sh

# Die XML Eingabedaten werden in dem Ordner Daten erwartet. Die Ausgaben werden in den aktuellen
# Ordner geschrieben.

files=""

for file in $@
do
    basename=${file##*/}
    newrdf=${basename%.xml}.rdf
    newttl=${basename%.xml}.ttl
    echo "Konvertiere ${file} in ${newrdf} …"
    xsltproc tbl-transform.xsl ${file} | xsltproc normlize-space.xsl - > ${newrdf}
    rapper -i 'rdfxml' -o 'turtle' ${newrdf} > ${newttl}
    files="${files} ${newttl}"
done
#cat ${files} > all.ttl
#rapper -o 'rdfxml' -i 'turtle' all.ttl > all.rdf
