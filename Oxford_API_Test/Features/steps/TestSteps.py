#!/usr/bin/python
# -*- coding: utf-8 -*-

from behave import given, when, then
import requests

global_general_variables = {}
authentication_header = {}


@given(u'Oxford API url is "{basic_app_url}"')
def set_basic_url(context, basic_app_url):
    global_general_variables['basic_application_URL'] = basic_app_url

@given(u'Add api_key and api_id on the header as "{key}" and "{value}" below')
def step_impl_1(context, key, value):
     for row in context.table:
         temp = row['value']
         authentication_header[row['key']] = str(temp)

@given(u'Searching in dictionary "{get_api_endpoint}"')
def set_api_endpoint(context, get_api_endpoint):
    global_general_variables['GET_api_endpoint'] = get_api_endpoint

@when(u'Search word "{word}"')
def set_search_word(context, word):
    global_general_variables['word'] = word
    
@when(u'Set HEADER param response accept type as "{header_accept_type}"')
def step_impl_3(context, header_accept_type):
    authentication_header['Accept'] = header_accept_type

@when(u'Raise "{http_request_type}" HTTP request')
def set_request_type(context, http_request_type):
    url = global_general_variables['basic_application_URL']
    if 'GET' == http_request_type:
        #Construct endpoint URL with given test parameters /%dictionary%/%searchword%
        url += global_general_variables['GET_api_endpoint']
        url += global_general_variables['word']
        print("url: ", url)
        print("headers: ", authentication_header)
        global_general_variables['response_full'] = requests.get(url, headers=authentication_header)

@then(u'Valid HTTP response should be received')
def check_response(context):
    if None in global_general_variables['response_full']:
        assert False, 'Null response received'

@then(u'Response http code should be {expected_response_code:d}')
def step_impl_11(context, expected_response_code):
     global_general_variables['expected_response_code'] = expected_response_code
     actual_response_code = global_general_variables['response_full'].status_code
     if str(actual_response_code) not in str(expected_response_code):
         #print (str(global_general_variables['response_full'].json()))
         assert False, '***ERROR: Following unexpected error response code received: ' + str(actual_response_code)