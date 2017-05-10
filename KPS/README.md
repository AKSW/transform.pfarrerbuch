These are the transformation files for KPS input data in an Access database.

A requirement is [SparqlMap](https://github.com/tomatophantastico/sparqlmap).

The transformation can be executed using the following command:

    ./bin/sparqlmap --action=dump --ds.type=ACCESS --ds.url=source.mdb --r2rmlFile=mapping.ttl > result.ttl

# Issues

- Some URIs are to long for the Store or for OntoWiki this happens for Parent (Father/Mother) URIs
- Some 29th of February ocure in Years, where Virtuoso says February only had 28 days
