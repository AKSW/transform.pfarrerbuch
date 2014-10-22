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
        self.elements = {
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

        self.idElement = "Key_Personen"
        self.firstnameElement = "Vorname"
        self.lastnameElement = "Nachname"

        self.testElements()

    def testElements(self):
        for element in self.tree.xpath('/pma_xml_export/database/table[@name="tblPersonen"]'):
            idElement = element.xpath('column[@name="'+self.idElement+'"]')[0]
            firstnameElements = element.xpath('column[@name="'+self.firstnameElement+'"]')
            lastnameElements = element.xpath('column[@name="'+self.lastnameElement+'"]')
            if (len(firstnameElements) > 0):
                firstname = firstnameElements[0].text
            else:
                firstname = '<unbekannt>'
            if (len(lastnameElements) > 0):
                lastname = lastnameElements[0].text
            else:
                lastname = '<unbekannt>'
            id = lastname + "," + firstname + " (id=" + idElement.text + ")"
            for elementName in self.elements:
                subElement = element.xpath('column[@name="'+elementName+'"]')[0]
                if (self.elements[elementName] == "day"):
                    if (not self.dayTest(subElement.text)):
                        print('"' + subElement.text + '" ist kein Tag in "' + elementName + '" für ' + id)
                elif (self.elements[elementName] == "year"):
                    if (not self.yearTest(subElement.text)):
                        print('"' + subElement.text + '" ist kein Jahr in "' + elementName + '" für ' + id)

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
        if (parts[0].isdigit() and (parts[1].lower() == 'x' or parts[1].lower() == 'xx')):
            # catch: 05.XX.
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