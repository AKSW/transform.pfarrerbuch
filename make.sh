#!/bin/sh

# Die XML Eingabedaten werden in dem Ordner Daten erwartet. Die Ausgaben werden in den aktuellen
# Ordner geschrieben.


for file in $@
do
    basename=${file##*/}
    newfile=${basename%.xml}.rdf
    echo "Konvertiere ${file} in ${newfile} …"
    xsltproc tbl-transform.xsl ${file} | xsltproc normlize-space.xsl - > ${newfile}
done
