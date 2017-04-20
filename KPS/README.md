These are the transformation files for KPS input data in an Access database.

A requirement is [SparqlMap](https://github.com/tomatophantastico/sparqlmap).

The transformation can be executed using the following command:

    ./bin/sparqlmap --action=dump --ds.type=ACCESS --ds.url=source.mdb --r2rmlFile=mapping.ttl > result.ttl
