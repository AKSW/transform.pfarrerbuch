#!/usr/bin/env python3

import sys
import getopt
from lxml import etree
import calendar

class Validate:
    def __init__(self, filename):
        self.tree = etree.parse(filename)
        #root = ET.parse(fileName)
        #root = ET.fromstring(s)

    def write(self, outfile):
        if (outfile != None):
#            et = etree.ElementTree(self.tree)
            self.tree.write(outfile)

    def validate(self):
        #print(dayTester.source())
        #print(yearTester.source())
        self.elements = {
                "Jahr_Beginn": "year",
                "Jahr_Ende": "year",
                }

#        "tblSchulbesuch"
        self.idElement = ["Key_Stellenbesetzung", "Key_Schulbesuch"]
        self.firstnameElement = "Person_Key"
        self.birthElement = "Jahr_Beginn"
        self.deathElement = "Jahr_Ende"

        self.testElements()

    def testElements(self):
        # TODO beide ID Elemente verwenden
        for element in self.tree.xpath('/pma_xml_export/database/table[@name="tblStellenbesetzung" or @name="tblSchulbesuch"]'):
            idElement = element.xpath('column[@name="'+self.idElement[0]+'" or @name="'+self.idElement[1]+'"]')[0]
            firstnameElements = element.xpath('column[@name="'+self.firstnameElement+'"]')
            birthElements = element.xpath('column[@name="'+self.birthElement+'"]')
            deathElements = element.xpath('column[@name="'+self.deathElement+'"]')
            firstname = '<unbekannt>'
            geb = ''
            tot = ''
            if (len(firstnameElements) > 0):
                firstname = firstnameElements[0].text
            if (len(birthElements) > 0 and birthElements[0].text != "NULL"):
                geb = birthElements[0].text
            if (len(deathElements) > 0 and deathElements[0].text != "NULL"):
                tot = deathElements[0].text
            id = firstname + " (von" + geb + ", bis" + tot + "; id=" + idElement.text + ")"
            for elementName in self.elements:
                subElement = element.xpath('column[@name="'+elementName+'"]')[0]
                if (self.elements[elementName] == "year"):
                    if (not self.yearTest(subElement.text)):
                        print('"' + subElement.text + '" ist kein Jahr in "' + elementName + '" für ' + id)
                        subElement.text = "NULL"

    def yearTest(self, year):
        if (year == 'NULL'):
            return True
#        if (len(year) != 4 and len(year) != 2):
        if (len(year) != 4):
            return False
        if (not year.isdigit()):
            return False
        if (len(year) == 4 and (int(year) > 2014 or int(year) < 1400)):
            return False
        return True

    def dayTest(self, day, year):
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
        elif (int(parts[0]) < 0 or int(parts[0]) > 31):
            return False
        if (not parts[1].isdigit()):
            if (not parts[1].lower() == 'x' and not parts[1].lower() == 'xx'):
                return False
        elif (int(parts[1]) < 0 or int(parts[1]) > 12):
            return False
        if (parts[0].isdigit() and parts[1].isdigit()):
            if (int(parts[1]) == 2 and int(parts[0]) > 29):
                return False
            elif (int(parts[1]) == 2 and int(parts[0]) == 29):
                if self.yearTest(year) and not calendar.isleap(int(year)):
                    print("Kein Schaltjahr")
                    return False
            months = [4,6,9,11]
            if (int(parts[1]) in months and int(parts[0]) > 30):
                return False
        if (parts[0].isdigit() and (parts[1].lower() == 'x' or parts[1].lower() == 'xx' or (parts[1].isdigit() and int(parts[1]) == 0))):
            # catch: 05.XX.
            return False
        return True

    def dateTest(self, date):
        if (date == 'NULL'):
            return True
        return True


def main(argv):
    try:
        opts, args = getopt.getopt(argv, "i:o:", ["input", "output"])
    except getopt.GetoptError:
        usage()
        sys.exit(2)

    outputFile = None

    for o, a in opts:
        if o in ("-i", "--input"):
            inputFile = a
        if o in ("-o", "--output"):
            outputFile = a

    validate = Validate(inputFile)
    validate.validate()
    validate.write(outputFile)

def usage():
    print("""
Please use the following options:
    -i  --input     The input file
    -o  --output    The output file (optional). If not present, the output is written to stdout
""")

if __name__ == '__main__':
    main(sys.argv[1:])
