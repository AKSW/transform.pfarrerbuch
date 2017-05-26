package org.aksw.transform.pfarrerbuch;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import org.apache.jena.graph.Triple;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.riot.Lang;
import org.apache.jena.riot.RDFDataMgr;

import java.io.ByteArrayInputStream;
import java.io.InputStream;


/**
 * Unit test for simple App.
 */
public class AppTest 
    extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public AppTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( AppTest.class );
    }

    public void testValidDate() {
        final String ttlTriple = "<http://pfarrerbuch.aksw.org/kps/person/4495> <http://purl.org/vok/hp/birthDate> \"1615-02-28\"^^<http://www.w3.org/2001/XMLSchema#date> .\n";
        final Triple triple = getTriple(ttlTriple);
        final TripleValidator validator = new TripleValidator();

        assertTrue("28th February 1615 is valid", validator.validate(triple));
    }

    public void testInvalidDate() {
        final String ttlTriple = "<http://pfarrerbuch.aksw.org/kps/person/4495> <http://purl.org/vok/hp/birthDate> \"1615-02-29\"^^<http://www.w3.org/2001/XMLSchema#date> .\n";
        final Triple triple = getTriple(ttlTriple);
        final TripleValidator validator = new TripleValidator();

        assertFalse("29th February 1615 not valid", validator.validate(triple));
    }

    private Triple getTriple(final String ttlTriple) {
        final Model model = ModelFactory.createDefaultModel();
        final InputStream reader = new ByteArrayInputStream(ttlTriple.getBytes());

        RDFDataMgr.read(model, reader, Lang.TTL);

        return model.listStatements().toList().get(0).asTriple();
    }

}
