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
        elements = {
                "Geburtsjahr": "year",
                "Geburtstag": "day",
                "Tauftag": "day",
                "Todesjahr": "year",
                "Begräbnistag": "day",
                "Ordinationsjahr": "year",
                "Ordinationstag": "day",
                "Emeritierungsjahr": "year",
                "Emeritierungstag": "day"
                }

        idElement = "Key_Personen"

        for element in elements:
            self.testElement(element, elements[element])

    def testElement(self, elementName, test):
        for element in self.tree.xpath('/pma_xml_export/database/table[@name="tblPersonen"]/column[@name="'+elementName+'"]'):
            if (test == "day"):
                if (not self.dayTest(element.text)):
                    print("'" + element.text + "' is not a day in " + elementName)
            elif (test == "year"):
                if (not self.yearTest(element.text)):
                    print("'" + element.text + "' is not a year in " + elementName)

    def yearTest(self, year):
        if (year == 'NULL'):
            return True
        if (len(year) != 4):
            return False
        if (not year.isdigit()):
            return False
        if (int(year) > 2014 or int(year) < 1400):
            return False
        return True

    def dayTest(self, day):
        if (day == 'NULL'):
            return True
        parts = day.split('.')
        if (len(parts) < 2 or len(parts) > 3):
            return False
        if (len(parts) == 3 and len(parts[2]) != 0):
            return False
        if (not parts[0].isdigit()):
            if (not parts[0].lower() == 'x' and not parts[0].lower() == 'xx'):
                return False
        elif (int(parts[0]) < 1 or int(parts[0]) > 31):
            return False
        if (not parts[1].isdigit()):
            if (not parts[1].lower() == 'x' and not parts[1].lower() == 'xx'):
                return False
        elif (int(parts[1]) < 1 or int(parts[1]) > 12):
            return False
        if (parts[0].isdigit() and parts[1].isdigit()):
            if (int(parts[1]) == 2 and int(parts[0]) > 29):
                return False
            months = [4,6,9,11]
            if (int(parts[1]) in months and int(parts[0]) > 30):
                return False
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
