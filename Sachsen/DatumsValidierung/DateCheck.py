# -*- coding: utf-8 -*-

import re
import xml.etree.ElementTree as ET

class DateCheck:

    def __init__(self, filename):
        self.filename = filename

    def readInputFile(self):              # reads the input file
        f = open(self.filename, 'r', encoding="utf8")
        text = []
        for line in f:
            text.append(line)
        f.close()
        return text

    def checkDates(self, line):
        #mm.dd or dd.mm, searching only for  \d\d.\d\d. since XX, xx, NULL is valid
        tags = ['Geburtsjahr', 'Geburtstag', 'Tauftag', 'Todesjahr', 'Todestag', 'Begräbnistag', 'Ordinationsjahr', 'Ordinationstag', 'Emeritierungsjahr', 'Emeritierungstag']
        if (re.search('>\d\d\.\d\d\.<', line) and any(tag in line for tag in tags)):
            date = re.findall('\d\d\.\d\d', line)[0].split('.')
            if (re.search('[4-9]\d', date[0]) or re.search('[2-9]\d', date[1])):
                return True
        elif (re.search('>\d\d\.\d\d\.\d\d\d\d<', line) and any(tag in line for tag in tags)):
            date = re.findall('\d\d\.\d\d', line)[0].split('.')
            if (re.search('[4-9]\d', date[0]) or re.search('[2-9]\d', date[1])):
                return True
        else:
            return False

    def checkLine(self, text):
        for i, line in enumerate(text):
            if(self.checkDates(line)):
                print ('Error found in line: ' + str(i + 1) + '\nRawtext:' + line)


def main():
    dc = DateCheck(input('Please insert the name of the inputfile: '))
    dc.checkLine(dc.readInputFile())

if __name__ == '__main__':
    main()