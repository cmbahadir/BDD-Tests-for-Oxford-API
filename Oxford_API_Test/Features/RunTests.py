#!/usr/bin/python
# -*- coding: utf-8 -*-

import glob
from json2html import *
import sys
import os
import datetime
import requests
import urllib3
from shutil import rmtree
from behave import __main__ as runner_with_options

def CreateReportingFolder():
    sys.stdout.flush()
    datetimestr = datetime.datetime.now().strftime("_%Y_%m_%d_%H_%M_%S")
    reportFolder = 'Oxford_API_Test_Results_Release_v_1_11_0' + datetimestr
    if os.path.exists(reportFolder):
        rmtree(reportFolder)
    os.makedirs(reportFolder)
    return reportFolder

#Setting Behave Configuration 
def SetBehaveConfig(folder):
    behaveReportOptions = ' -f allure_behave.formatter:AllureFormatter -o ' + folder + '  '
    behavefeatureFilePath = ' ./Oxford_API_Test/Features'
    tagOptions = ' --tags=-tag_me '
    tagOptions = ''
    behaveCommonOptions = ' --no-capture --no-capture-stderr -f plain '
    behaveConfig = tagOptions + behavefeatureFilePath + behaveReportOptions + behaveCommonOptions
    return behaveConfig

#Create Results HTML from json result files
def CreateResultHTML(folder):
    listOfJsonFiles = glob.glob(resultFolder + "/*.json")
    finalJson = ''
    for cnt in range(0, len(listOfJsonFiles)):
        listOfJsonFiles[cnt] = ' {"' + "Scenario_" + str(cnt) + '"' + ' : ' + open(listOfJsonFiles[cnt], 'r').read() + '}'
        if cnt < (-1 + len(listOfJsonFiles)):
            listOfJsonFiles[cnt] = listOfJsonFiles[cnt] + ','
        finalJson = finalJson + listOfJsonFiles[cnt]
    finalJson = '[ ' + finalJson + ' ]'

    html_content = json2html.convert(json=finalJson)
    html_report_file = open(resultFolder + '/' + 'index.html', 'w')
    html_report_file.write(html_content)
    html_report_file.close()

#Behave Main Function
if __name__ == '__main__':
    resultFolder = CreateReportingFolder()
    fullRunnerOptions = SetBehaveConfig(resultFolder)
    runner_with_options.main(fullRunnerOptions)
    CreateResultHTML(resultFolder)

