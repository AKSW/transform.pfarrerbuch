#!/usr/bin/env python3

import sys
import getopt
#import elementtree.ElementTree as ET
from lxml import etree
from verbal_expressions import VerEx

class Validate:
    def __init__(self, filename):
        self.tree = etree.parse(filename)
        #root = ET.parse(fileName)
        #root = ET.fromstring(s)

    def validate(self):
        #print(dayTester.source())
        #print(yearTester.source())
        for text in self.tree.xpath('/pma_xml_export/database/table/column[@name="Geburtsjahr"]/text()'):
            if (!self.yearTest(text)):
                print(text)
        for text in self.tree.xpath('/pma_xml_export/database/table/column[@name="Geburtstag"]/text()'):
            if (text != 'NULL' and not dayTester.match(text)):
                print(text)
        for text in self.tree.xpath('/pma_xml_export/database/table/column[@name="Tauftag"]/text()'):
            if (text != 'NULL' and not dayTester.match(text)):
                print(text)
        for text in self.tree.xpath('/pma_xml_export/database/table/column[@name="Todesjahr"]/text()'):
            if (text != 'NULL' and not yearTester.match(text)):
                print(text)
        for text in self.tree.xpath('/pma_xml_export/database/table/column[@name="Begräbnistag"]/text()'):
            if (text != 'NULL' and not dayTester.match(text)):
                print(text)
        for text in self.tree.xpath('/pma_xml_export/database/table/column[@name="Ordinationsjahr"]/text()'):
            if (text != 'NULL' and not yearTester.match(text)):
                print(text)
        for text in self.tree.xpath('/pma_xml_export/database/table/column[@name="Ordinationstag"]/text()'):
            if (text != 'NULL' and not dayTester.match(text)):
                print(text)
        for text in self.tree.xpath('/pma_xml_export/database/table/column[@name="Emeritierungsjahr"]/text()'):
            if (text != 'NULL' and not yearTester.match(text)):
                print(text)
        for text in self.tree.xpath('/pma_xml_export/database/table/column[@name="Emeritierungstag"]/text()'):
            if (text != 'NULL' and not dayTester.match(text)):
                print(text)
        testElemente("Emeritierungstag", "")

    def testElement(self, element, test):
        for element in self.tree.xpath('/pma_xml_export/database/table/column[@name="'+element+'"]/'):
            if (not dayTest(element.text())):
                print(element.text())

    def yearTest(self, year):
        if (year == 'NULL'):
            return True
        year_expression = VerEx()
        yearTester = (year_expression.
                start_of_line().
                range(0,9).
                range(0,9).
                range(0,9).
                range(0,9).
                end_of_line()
                )
        return True

    def dayTest(self, day):
        if (day == 'NULL'):
            return True
        day_expression = VerEx()
        dayTester = (day_expression.
                start_of_line().
                range(0,9).
                range(0,9).
                any('.').
                range(0,9).
                range(0,9).
                any('.').
                end_of_line()
                )
        return True

    def dateTest(self, date):
        if (date == 'NULL'):
            return True
        return True


def main(argv):
    try:
        opts, args = getopt.getopt(argv, "i:", ["input"])
    except getopt.GetoptError:
        usage()
        sys.exit(2)

    for o, a in opts:
        if o in ("-i", "--input"):
            inputFile = a

    validate = Validate(inputFile)
    validate.validate()

def usage():
    print("""
Please use the following options:
    -i  --input     The input file
    -o  --output    The output file (optional). If not present, the output is written to stdout
""")

if __name__ == '__main__':
    main(sys.argv[1:])
