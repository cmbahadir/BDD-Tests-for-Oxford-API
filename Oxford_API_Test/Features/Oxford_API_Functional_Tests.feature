
# -*- coding: UTF-8 -*-
#Author : Cihan Mete BAHADIR - c.mete.bahadir@gmail.com
#Date : 15/Sept/2018

#Summary : BDD Test Exercise - Oxford API - Functional Service Tests
#Choosen API : Oxford API Entries - https://od-api.oxforddictionaries.com/api/v1/entries/ - Release v.1.11.0
#Authentication : { API KEY : 24546146559ad87f2a67815d879a5589
#					API ID  : 7907b8ad }

Feature: Oxford HTTP API Functional Features Testing - Release v.1.11.0
	More than 128 characters - Security Feature
	Punctuation symbols in search word - Functional Feature

Background: 
	Given Oxford API url is "https://od-api.oxforddictionaries.com/api/v1/entries/"
	    And Add api_key and api_id on the header as "<key>" and "<value>" below
		| key                                      			| value                               	|
		| Accept                               				| Application/json						|
		| app_id                                           	| 7907b8ad                           	|
		| app_key                                      		| 24546146559ad87f2a67815d879a5589      |


#Functional Features
#Below two test cases are added with respect to the security feature delivered on https://developer.oxforddictionaries.com/updates - Release v.1.11.0

# Requirement :
# # Security fix
# # The API will now return 414 HTTP status code for any entry ID in excess of 128 characters. 
# # Instead of processing very long strings which don’t exist in our dictionary, we response 
# # with an 414 status code which means that the URL requested is longer than what the server 
# # is willing to interpret. 

#Just equal to 128 characters
Scenario: GET request for a long word - Equal to 128 chars
	Given Searching in dictionary "en/"
	When Search word "1234567890abcdefghıijklmnoöpakjfkajkjefejaflnelfnafnajfnrstsfajaefjabfajenfalafklakfljdafajkfjfjakjfasadafadfadfafdfafafadfafa"
		And Raise "GET" HTTP request
	Then Response http code should be 404

#More than 238 characters
Scenario: GET request for an long word - More than 128 chars
	Given Searching in dictionary "en/"
	When Search word "1234567890abcdefghıijklmnoöpakjfkajkjefejaflnelfnafnajfnrstsfajaefjabfajenfalafklakfljdafajkfjfjakjfasadafadfadfafdfafafadfafalaskdlaksflaklfkalflsakflalll"
		And Raise "GET" HTTP request
	Then Response http code should be 414

# This test case also added with respect to the below feature delivered on https://developer.oxforddictionaries.com/updates - Release v.1.11.0

# Requirement :
# # Words passed to the Entries endpoint will be cleaned for stray punctuation, 
# # which will improve your chances of lookup success. This removes spaces and 
# # every appearance of ^ , . : ; from the begging of the string and spaces and 
# # every appearance of ^ , : ; from the end of the string, so a string such as 
# # ‘…^tidy,;::’ is cleaned as ‘tidy’ and a string like ‘.,:;;;tidy;…:’ is cleaned 
# # as ‘tidy…’. It has this behaviour as there are a number of entries which end 
# # with ‘…’, and this means that it will still be possible to find these entries in the API

#200 is expected for "…^tidy,;::’" since it is transformed into "tidy"
Scenario: GET request for a proper word containing punctuation marks - Successful
  	Given Searching in dictionary "en/"
  	When Search word "…^tidy,;::’"
		And Raise "GET" HTTP request
  	Then Response http code should be 200
		And Valid HTTP response should be received

#404 is expected for ".,:;;;tidy;…:" since it is transformed into "tidy…"
Scenario: GET request for a proper word containing punctuation marks - Ends with ...
  	Given Searching in dictionary "en/"
  	When Search word ".,:;;;tidy;…:"
		And Raise "GET" HTTP request
  	Then Response http code should be 404
		And Valid HTTP response should be received