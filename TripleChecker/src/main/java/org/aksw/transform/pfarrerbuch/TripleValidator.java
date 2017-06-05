package org.aksw.transform.pfarrerbuch;

import org.apache.jena.graph.Node;
import org.apache.jena.graph.Triple;
import org.apache.jena.iri.IRIFactory;
import org.apache.jena.riot.checker.CheckerIRI;
import org.apache.jena.riot.checker.CheckerLiterals;
import org.apache.jena.riot.system.ErrorHandler;
import org.apache.jena.riot.system.ErrorHandlerFactory;

import java.util.Optional;

public class TripleValidator {
    private final ErrorHandler errorHandler;
    private final Optional<Integer> maxUriLength;

    TripleValidator() {
        this.errorHandler = ErrorHandlerFactory.errorHandlerNoWarnings;
        this.maxUriLength = Optional.empty();
    }

    TripleValidator(ErrorHandler errorHandler, int maxUriLength) {
        this.errorHandler = errorHandler;
        this.maxUriLength = Optional.of(maxUriLength);
    }

    public boolean validate(Triple triple) {
        final boolean subjectIsValid = validateSubject(triple.getSubject());
        final boolean predicateIsValid = validatePredicate(triple.getPredicate());
        final boolean objectIsValid = validateObject(triple.getObject());

        final boolean isValid = subjectIsValid && predicateIsValid && objectIsValid;

        return isValid;
    }

    public boolean validateSubject(Node subject) {

        return subject != null && (hasValidUri(subject) || subject.isBlank());
    }

    public boolean validatePredicate(Node predicate) {
        return predicate != null && hasValidUri(predicate);
    }

    public boolean validateObject(Node object) {
        final boolean isLiteral = object != null && object.isLiteral() && CheckerLiterals.checkLiteral(object, errorHandler, -1L, -1L);

        return object != null && (isLiteral || hasValidUri(object) || object.isBlank());
    }

    public boolean hasValidUri(Node node) {
        final CheckerIRI checkerIRI = new CheckerIRI(errorHandler, IRIFactory.iriImplementation());
        final int uriLength = node.isURI() ? node.getURI().length() : 0;
        final boolean validLength =  maxUriLength.map(max -> uriLength <= max).orElse(true);

        if (!validLength) errorHandler.warning("URI too long with " + uriLength + " characters", -1L, -1L);

        return node.isURI() && validLength && checkerIRI.check(node, -1L, -1L);
    }

    public ErrorHandler getErrorHandler() {
        return errorHandler;
    }
}
