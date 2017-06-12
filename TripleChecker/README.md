# TripleChecker

## Purpose
Filter triples: e.g. check if literal is in the range of its datatype (29th February issue) or if an URI is too long which might cause import problems.

## Usage
    
    # Build executable jar
    mvn package

    # Run with arguments <path/to/file> <maxURILength>
    java -jar target/TripleChecker-1.0-SNAPSHOT.jar  ~/foo/bar.ttl 255

    
## Output
Two files are generated next to the original file: `file_valid` and `file_invalid`.
`file_valid` consists of the correctly validated triples whereas `file_invalid` contains quads that describe invalid triples and the cause of their invalidity.