package org.aksw.transform.pfarrerbuch;

import org.apache.jena.atlas.lib.Sink;
import org.apache.jena.graph.Node;
import org.apache.jena.graph.NodeFactory;
import org.apache.jena.graph.Triple;
import org.apache.jena.riot.RDFDataMgr;
import org.apache.jena.riot.out.SinkQuadOutput;
import org.apache.jena.riot.out.SinkTripleOutput;
import org.apache.jena.riot.system.ErrorHandler;
import org.apache.jena.riot.system.StreamRDF;
import org.apache.jena.riot.system.StreamRDFBase;
import org.apache.jena.riot.system.SyntaxLabels;
import org.apache.jena.sparql.core.Quad;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStream;

import static java.lang.System.exit;

public class App
{
    public static void main( String[] args ) throws FileNotFoundException {
        if (args.length < 2) {
            System.out.println("Missing arguments: <filepath> <maxURILength>");
            exit(1);
        }

        final String file = args[0];
        final int maxUriLength = Integer.parseInt(args[1]);

        parse(file, maxUriLength);
    }

    private static void parse(String file, int maxUriLength) throws FileNotFoundException {
        final OutputStream validStream = new FileOutputStream(file + "_valid");
        final OutputStream invalidStream = new FileOutputStream(file + "_invalid");

        final Sink<Triple> validOutput = new SinkTripleOutput(validStream, null, SyntaxLabels.createNodeToLabel()) ;
        final Sink<Quad> invalidOutput = new SinkQuadOutput(invalidStream, null, SyntaxLabels.createNodeToLabel());

        final StreamRDF filterStream = new FilterSinkRDF(validOutput, invalidOutput, maxUriLength) ;

        RDFDataMgr.parse(filterStream, file);
    }

    static class FilterSinkRDF extends StreamRDFBase {
        // Where to send the filtered triples.
        private final Sink<Triple> valid ;
        private final Sink<Quad> invalid ;
        private final int maxUriLenght;

        FilterSinkRDF(Sink<Triple> valid, Sink<Quad> invalid, int maxUriLenght) {
            this.valid = valid;
            this.invalid = invalid;
            this.maxUriLenght = maxUriLenght;
        }

        @Override
        public void triple(Triple triple) {
            final StringErrorHandler errorHandler = new StringErrorHandler();
            final TripleValidator validator = new TripleValidator(errorHandler, maxUriLenght);
            final boolean isValid = validator.validate(triple);

            if (isValid) {
                valid.send(triple) ;
            } else {
                final String errorMsgs = errorHandler.getMessages();
                final Quad quad = extendWithComment(triple, errorMsgs);
                invalid.send(quad) ;
            }

        }

        private Quad extendWithComment(final Triple triple, final String comment) {
            final Node commentNode = NodeFactory.createLiteral(comment);
            final Quad quad = new Quad(commentNode, triple);

            return quad;
        }

        @Override
        public void finish() {
            // Output may be buffered.
            valid.flush() ;
            invalid.flush() ;
        }

        class StringErrorHandler implements ErrorHandler {
        private String messages;

        StringErrorHandler() {
            messages = "";
        }

        public String getMessages() {
            return messages;
        }

        @Override
        public void warning(String message, long line, long col) {
            messages = messages.concat(message);
        }

        @Override
        public void error(String message, long line, long col) {
            messages = messages.concat(message);
        }

        @Override
        public void fatal(String message, long line, long col) {
            messages = messages.concat(message);
        }
    }
    }

}