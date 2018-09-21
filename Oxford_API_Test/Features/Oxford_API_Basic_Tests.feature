# -*- coding: UTF-8 -*-
#Author : Cihan Mete BAHADIR - c.mete.bahadir@gmail.com
#Date : 15/Sept/2018

#Summary : BDD Test Exercise - Oxford API - Basic Service Tests
#Choosen API : Oxford API Entries - https://od-api.oxforddictionaries.com/api/v1/entries/ - Release v.1.11.0
#Authentication : { API KEY : 24546146559ad87f2a67815d879a5589
#					API ID  : 7907b8ad }

Feature: Oxford HTTP API Basic Features Testing 
	Validate HTTP Return Code
	Validate HTTP Response Body
	Add the Oxford API Base URL and Headers as Background

Background: 
	Given Oxford API url is "https://od-api.oxforddictionaries.com/api/v1/entries/"
	    And Add api_key and api_id on the header as "<key>" and "<value>" below
		| key                                      			| value                               	|
		| Accept                               				| Application/json						|
		| app_id                                           	| 7907b8ad                           	|
		| app_key                                      		| 24546146559ad87f2a67815d879a5589      |

#Basic Functionality Cases
Scenario: GET request for a proper word
  	Given Searching in dictionary "en/"
  	When Search word "ace"
		And Raise "GET" HTTP request
  	Then Response http code should be 200
		And Valid HTTP response should be received
	 
Scenario: GET request for an unknown word
	Given Searching in dictionary "en/"
	When Search word "sdksda"
		And Raise "GET" HTTP request
	Then Response http code should be 404

Scenario: GET request for an empty word
	Given Searching in dictionary "en/"
	When Search word " "
		And Raise "GET" HTTP request
	Then Response http code should be 404

Scenario: GET request for a symbol string
	Given Searching in dictionary "en/"
	When Search word "!%&/.,"
		And Raise "GET" HTTP request
	Then Response http code should be 400
