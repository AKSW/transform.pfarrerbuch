<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE rdf:RDF [
<!ENTITY attendingschool "http://pfarrerbuch.de/attendingSchool/">
<!ENTITY hp "http://purl.org/vok/hp/">
<!ENTITY pfarrer "http://pfarrerbuch.de/">
<!ENTITY person "http://pfarrerbuch.de/person/">
<!ENTITY place "http://pfarrerbuch.de/place/">
<!ENTITY position "http://pfarrerbuch.de/position/">
<!ENTITY school "http://pfarrerbuch.de/school/">
<!ENTITY staffing "http://pfarrerbuch.de/staffing/">
<!ENTITY foaf "http://xmlns.com/foaf/0.1/">
<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
<!ENTITY xsd "http://www.w3.org/2001/XMLSchema#">
<!ENTITY xsl "http://www.w3.org/1999/XSL/Transform">
<!ENTITY str "http://exslt.org/strings">
]>
<xsl:stylesheet
  xmlns:xsl="&xsl;"
  xmlns:hp="&hp;"
  xmlns:rdf="&rdf;"
  xmlns:rdfs="&rdfs;"
  xmlns:xsd="&xsd;"
  xmlns:str="&str;"
  xmlns:foaf="&foaf;"
  version="1.0"
  >
  <xsl:output method="xml" indent="yes" encoding="utf-8"/>

  <xsl:template match="/pma_xml_export">
    <rdf:RDF
      xml:base="&pfarrer;"
      xmlns:hp="&hp;"
      xmlns:rdf="&rdf;"
      xmlns:rdfs="&rdfs;"
      xmlns:foaf="&foaf;"
      xmlns:attendingschool="&attendingschool;"
      xmlns:person="&person;"
      xmlns:place="&place;"
      xmlns:position="&position;"
      xmlns:school="&school;"
      xmlns:xsd="&xsd;"
      xmlns:staffing="&staffing;"
      >
      <xsl:apply-templates select="database"/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="database">
    <xsl:apply-templates select="table"/>
  </xsl:template>

  <!-- template for persons table -->
  <xsl:template match="table[@name='tblPersonen']">
    <xsl:element name="foaf:Person">
      <xsl:attribute name="rdf:about">&person;<xsl:value-of select="column[@name='Key_Personen']" /></xsl:attribute>
      <xsl:attribute name="rdfs:label"><xsl:value-of select="concat(column[@name='Vorname'], ' ', column[@name='Name'], ' (', column[@name='Geburtsjahr'], ')')" /></xsl:attribute>
      <xsl:attribute name="foaf:name"><xsl:value-of select="concat(column[@name='Vorname'], ' ', column[@name='Name'])" /></xsl:attribute>
      <xsl:attribute name="foaf:lastName"><xsl:value-of select="column[@name='Name']" /></xsl:attribute>
      <xsl:attribute name="foaf:firstName"><xsl:value-of select="column[@name='Vorname']" /></xsl:attribute>
      <xsl:attribute name="hp:nameVariant"><xsl:value-of select="column[@name='Namen_Varianten']" /></xsl:attribute>
      <xsl:attribute name="hp:birthName"><xsl:value-of select="column[@name='Geburtsname']" /></xsl:attribute>
      <xsl:attribute name="rdfs:comment"><xsl:value-of select="column[@name='Bemerkungen']" /></xsl:attribute>
      <xsl:attribute name="hp:isPastor"><xsl:value-of select="column[@name='Kz-Pfarrer']" /></xsl:attribute> <!-- use boolean values (true/false) -->

      <!-- Parents -->
      <xsl:call-template name="parent">
        <xsl:with-param name="parent" select="column[@name='Vater_Key']" />
        <xsl:with-param name="gender">male</xsl:with-param>
        <xsl:with-param name="property">hp:father</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="parent">
        <xsl:with-param name="parent" select="column[@name='Mutter_Key']" />
        <xsl:with-param name="gender">female</xsl:with-param>
        <xsl:with-param name="property">hp:mother</xsl:with-param>
      </xsl:call-template>

      <!-- Dates -->
      <xsl:call-template name="date">
        <xsl:with-param name="year" select="column[@name='Geburtsjahr']" />
        <xsl:with-param name="day" select="column[@name='Geburtstag']" />
        <xsl:with-param name="property">hp:birthDate</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="date">
        <xsl:with-param name="day" select="column[@name='Tauftag']" />
        <xsl:with-param name="property">hp:dayOfBaptism</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="date">
        <xsl:with-param name="year" select="column[@name='Ordinationsjahr']" />
        <xsl:with-param name="day" select="column[@name='Ordinationstag']" />
        <xsl:with-param name="property">hp:dateOfOrdination</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="date">
        <xsl:with-param name="year" select="column[@name='Emeritierungsjahr']" />
        <xsl:with-param name="day" select="column[@name='Emeritierungstag']" />
        <xsl:with-param name="property">hp:dateOfRetirement</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="date">
        <xsl:with-param name="year" select="column[@name='Todesjahr']" />
        <xsl:with-param name="day" select="column[@name='Todestag']" />
        <xsl:with-param name="property">hp:dateOfDeath</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="date">
        <xsl:with-param name="day" select="column[@name='Begraebnistag']" />
        <xsl:with-param name="property">hp:dayOfFuneral</xsl:with-param>
      </xsl:call-template>

      <!-- Places -->
      <xsl:call-template name="place">
        <xsl:with-param name="place" select="column[@name='Begraebnisort_Key']" />
        <xsl:with-param name="property">hp:burialPlace</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="place">
        <xsl:with-param name="place" select="column[@name='Emeritierungsort_Key']" />
        <xsl:with-param name="property">hp:placeOfRetirement</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="place">
        <xsl:with-param name="place" select="column[@name='Ordinationssort_Key']" />
        <xsl:with-param name="property">hp:placeOfOrdination</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="place">
        <xsl:with-param name="place" select="column[@name='Taufort_Key']" />
        <xsl:with-param name="property">hp:placeOfBaptism</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="place">
        <xsl:with-param name="place" select="column[@name='Todesort_Key']" />
        <xsl:with-param name="property">hp:placeOfDeath</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="place">
        <xsl:with-param name="place" select="column[@name='Geburtsort_Key']" />
        <xsl:with-param name="property">hp:birthPlace</xsl:with-param>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <!-- template for position table -->
  <xsl:template match="table[@name='tblStellen']">
    <xsl:element name="hp:Position">
      <xsl:attribute name="rdf:about">&position;<xsl:value-of select="column[@name='Key_Stelle']" /></xsl:attribute>
      <xsl:attribute name="rdfs:label"><xsl:value-of select="column[@name='Bezeichnung']" /></xsl:attribute>
      <xsl:attribute name="hp:positionDesignation"><xsl:value-of select="column[@name='Bezeichnung']" /></xsl:attribute>

      <!-- Places -->
      <xsl:call-template name="place">
        <xsl:with-param name="place" select="column[@name='Ort_Key']" />
        <xsl:with-param name="property">hp:place</xsl:with-param>
      </xsl:call-template>

      <!-- Note: Maybe it's good to distinguish between different churches in one town -->
    </xsl:element>
  </xsl:template>

  <!-- template for place table -->
  <xsl:template match="table[@name='tblOrte']">
    <xsl:element name="hp:Place">
      <xsl:attribute name="rdf:about">&place;<xsl:value-of select="column[@name='OrtKey']" /></xsl:attribute>
      <xsl:attribute name="rdfs:label"><xsl:value-of select="column[@name='ORT']" /></xsl:attribute>
      <xsl:attribute name="hp:nameOfPlace"><xsl:value-of select="column[@name='ORT']" /></xsl:attribute>
      <xsl:attribute name="hp:district"><xsl:value-of select="column[@name='KREIS']" /></xsl:attribute>
      <xsl:attribute name="hp:district1952"><xsl:value-of select="column[@name='KREIS_1952']" /></xsl:attribute>
      <xsl:attribute name="hp:ah1875"><xsl:value-of select="column[@name='AH_1875']" /></xsl:attribute>
      <xsl:attribute name="hp:nearby"><xsl:value-of select="column[@name='LAGE']" /></xsl:attribute>
      <xsl:attribute name="hp:community"><xsl:value-of select="column[@name='VERFASSUNG']" /></xsl:attribute>
      <xsl:attribute name="hp:hovID"><xsl:value-of select="column[@name='HOV_ID']" /></xsl:attribute>
      <xsl:attribute name="hp:positionDesignation"><xsl:value-of select="column[@name='Bezeichnung']" /></xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- template for school table -->
  <xsl:template match="table[@name='tblSchulen']">
    <xsl:element name="hp:School">
      <xsl:attribute name="rdf:about">&school;<xsl:value-of select="column[@name='Key_Schulen']" /></xsl:attribute>
      <xsl:choose>
        <xsl:when test="column[@name='Name'] != ''">
          <xsl:attribute name="rdfs:label"><xsl:value-of select="column[@name='Name']" /></xsl:attribute>
          <xsl:attribute name="hp:nameOfSchool"><xsl:value-of select="column[@name='Name']" /></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="ortId" select="column[@name='Ort_Key']" />
          <xsl:variable name="ort" select="document('Daten/tblOrte.xml')//table/column[@name='OrtKey'][text() = $ortId]/../column[@name='ORT']" />
          <xsl:variable name="name" select="concat(column[@name='Schulart'], ' ', $ort)" />
          <xsl:attribute name="rdfs:label"><xsl:value-of select="$name" /></xsl:attribute>
          <xsl:attribute name="hp:nameOfSchool"><xsl:value-of select="$name" /></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:attribute name="hp:schoolType"><xsl:value-of select="column[@name='Schulart']" /></xsl:attribute>

      <!-- Places -->
      <xsl:call-template name="place">
        <xsl:with-param name="place" select="column[@name='Ort_Key']" />
        <xsl:with-param name="property">hp:place</xsl:with-param>
      </xsl:call-template>

    </xsl:element>
  </xsl:template>

  <!-- template for staffing table -->
  <xsl:template match="table[@name='tblStellenbesetzung']">
    <xsl:element name="foaf:Person">
      <xsl:attribute name="rdf:about">&person;<xsl:value-of select="column[@name='Person_Key']" /></xsl:attribute>

      <!-- Places -->
      <xsl:call-template name="position">
        <xsl:with-param name="position" select="column[@name='Stellen_Key']" />
      </xsl:call-template>
    </xsl:element>
    <xsl:element name="hp:Event">
      <xsl:attribute name="rdf:about">&staffing;<xsl:value-of select="column[@name='Key_Stellenbesetzung']" /></xsl:attribute>
      <xsl:attribute name="rdfs:comment"><xsl:value-of select="column[@name='Bemerkungen']" /></xsl:attribute>
      <xsl:call-template name="date">
        <xsl:with-param name="year" select="column[@name='Jahr_Beginn']" />
        <xsl:with-param name="property">hp:start</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="date">
        <xsl:with-param name="year" select="column[@name='Jahr_Ende']" />
        <xsl:with-param name="property">hp:end</xsl:with-param>
      </xsl:call-template>
      <xsl:element name="rdf:subject">
        <xsl:element name="rdfs:Resource">
          <xsl:attribute name="rdf:about">&person;<xsl:value-of select="column[@name='Person_Key']" /></xsl:attribute>
        </xsl:element>
      </xsl:element>
      <xsl:element name="rdf:predicate">
        <xsl:element name="rdfs:Resource">
          <xsl:attribute name="rdf:about">hp:hasPosition</xsl:attribute>
        </xsl:element>
      </xsl:element>
      <xsl:element name="rdf:object">
        <xsl:element name="rdfs:Resource">
          <xsl:attribute name="rdf:about">&position;<xsl:value-of select="column[@name='Stellen_Key']" /></xsl:attribute>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- template for attending school -->
  <xsl:template match="table[@name='tblSchulbesuch']">
    <xsl:element name="foaf:Person">
      <xsl:attribute name="rdf:about">&person;<xsl:value-of select="column[@name='Person_Key']" /></xsl:attribute>

      <!-- References -->
      <xsl:call-template name="school">
        <xsl:with-param name="school" select="column[@name='Schule_Key']" />
      </xsl:call-template>
    </xsl:element>
    <xsl:element name="hp:Event">
      <xsl:attribute name="rdf:about">&attendingschool;<xsl:value-of select="column[@name='Key_Schulbesuch']" /></xsl:attribute>
      <xsl:attribute name="rdfs:comment"><xsl:value-of select="column[@name='Bemerkung']" /></xsl:attribute>
      <xsl:attribute name="hp:graduation"><xsl:value-of select="column[@name='Abschluss']" /></xsl:attribute>
      <xsl:call-template name="date">
        <xsl:with-param name="year" select="column[@name='Jahr_Beginn']" />
        <xsl:with-param name="property">hp:start</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="date">
        <xsl:with-param name="year" select="column[@name='Jahr_Ende']" />
        <xsl:with-param name="property">hp:end</xsl:with-param>
      </xsl:call-template>
      <xsl:element name="rdf:subject">
        <xsl:element name="rdfs:Resource">
          <xsl:attribute name="rdf:about">&person;<xsl:value-of select="column[@name='Person_Key']" /></xsl:attribute>
        </xsl:element>
      </xsl:element>
      <xsl:element name="rdf:predicate">
        <xsl:element name="rdfs:Resource">
          <xsl:attribute name="rdf:about">hp:attendedSchool</xsl:attribute>
        </xsl:element>
      </xsl:element>
      <xsl:element name="rdf:object">
        <xsl:element name="rdfs:Resource">
          <xsl:attribute name="rdf:about">&school;<xsl:value-of select="column[@name='Schule_Key']" /></xsl:attribute>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- Templates for sub objects -->
  <xsl:template name="parent">
    <xsl:param name="parent"/>
    <xsl:param name="gender"/>
    <xsl:param name="property"/>
    <xsl:choose>
      <xsl:when test="$parent != 9631">
        <xsl:element name="{$property}">
          <xsl:element name="foaf:Person">
            <xsl:attribute name="rdf:about">&person;<xsl:value-of select="$parent"/></xsl:attribute>
            <xsl:attribute name="foaf:gender"><xsl:value-of select="$gender"/></xsl:attribute>
            <xsl:element name="hp:child">
              <xsl:element name="foaf:Person">
                <xsl:attribute name="rdf:about">&person;<xsl:value-of select="column[@name='Key_Personen']"/></xsl:attribute>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="place">
    <xsl:param name="place"/>
    <xsl:param name="property"/>
    <xsl:choose>
      <xsl:when test="$place != 5693 and $place != ''">
        <xsl:element name="{$property}">
          <xsl:element name="hp:Place">
            <xsl:attribute name="rdf:about">&place;<xsl:value-of select="$place"/></xsl:attribute>
          </xsl:element>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="position">
    <xsl:param name="position"/>
    <xsl:element name="hp:hasPosition">
      <xsl:element name="hp:Position">
        <xsl:attribute name="rdf:about">&position;<xsl:value-of select="$position"/></xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="school">
    <xsl:param name="school"/>
    <xsl:element name="hp:attendedSchool">
      <xsl:element name="hp:School">
        <xsl:attribute name="rdf:about">&school;<xsl:value-of select="$school"/></xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="date">
    <xsl:param name="year"/>
    <xsl:param name="day"/>
    <xsl:param name="property"/>
    <xsl:choose>
      <xsl:when test="($year != '' and $year != 0) or ($day != '' and $day != 0)">
        <xsl:element name="{$property}">
          <xsl:choose>
            <xsl:when test="$year != '' and $year != 0">
              <xsl:choose>
                <xsl:when test="$day != '' and $day != 0">
                  <xsl:attribute name="rdf:datatype">&xsd;date</xsl:attribute>
                  <xsl:value-of select="concat($year,'-',str:tokenize($day,'.')[2],'-',str:tokenize($day,'.')[1])"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="rdf:datatype">&xsd;gYear</xsl:attribute>
                  <xsl:value-of select="$year"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$day != '' and $day != 0">
                  <xsl:attribute name="rdf:datatype">&xsd;gMonthDay</xsl:attribute>
                  <xsl:value-of select="concat(str:tokenize($day,'.')[2],'-',str:tokenize($day,'.')[1])"/>
                </xsl:when>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
