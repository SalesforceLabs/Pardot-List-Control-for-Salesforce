/**
 * @description       : 
 * @author            : Jonathan Fox
 * @group             : 
 * @last modified on  : 21-07-2021
 * @last modified by  : Jonathan Fox
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   21-07-2021   Jonathan Fox   Initial Version
**/
@isTest
public with sharing class PardotListControlTest {
    @TestSetup
    static void makeData(){
        Profile profileRec = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
     	User u = new User(LastName = 'Test',
                           FirstName='Pardot Comp',
                           Alias = 'pict',
                           Email = 'tester@picomp.com',
                           Username = 'tester@picomp.com',
                           ProfileId = profileRec.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );

        insert u;

        pi_list_control__Pardot_List_Control__c piListControlSettings = new pi_list_control__Pardot_List_Control__c(
            pi_list_control__Business_Unit_Id__c = '0Uv4L000000004DSAQ',
            pi_list_control__Named_Credential_Name__c = 'APEX_Pardot_Credential',
            SetupOwnerId = profileRec.Id
        );
        insert piListControlSettings;

        Account a = new Account(
            Name = 'Test Pardot Comp'
        );
        insert a;

        Contact c = new Contact(
            Firstname = 'Tester',
            Lastname = 'PardotContact',
            pi__url__c = 'http://pi.pardot.com/prospect/read?id=910111213',
            AccountId = a.Id
        );
        insert c;

        Lead l = new Lead(
            Firstname = 'Test', 
            LastName = 'PardotLead',
            Company = 'Jeffy', 
            pi__url__c = 'http://pi.pardot.com/prospect/read?id=123456'
        );
        insert l;

    }


    @isTest(seeAllData=false)
    static void testCreateList(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PardotCalloutControllerMock());

        Boolean successfulCallout;

        Test.startTest();

            User u = [SELECT Id, Username From User WHERE Username = 'tester@picomp.com'];
            System.debug(u);
            System.runAs(u){
                // Call method to test
                successfulCallout = PardotListControlLWCController.createList('Test List Name', 'Test List Description');
            }
            
        Test.stopTest();

        //Assert results
        System.assertEquals(true, successfulCallout, 'Callout was not successful');
    }

    @isTest(seeAllData=false)
    static void testQuerySingleList(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PardotCalloutControllerMock());

        Map<String, String> parsedResponse;

        Test.startTest();

            User u = [SELECT Id, Username From User WHERE Username = 'tester@picomp.com'];
            System.debug(u);
            System.runAs(u){
                // Call method to test
                parsedResponse = PardotListControlLWCController.queryList('Test List Name Single', true);
            }
            
        Test.stopTest();

        //Assert results
        for(String key : parsedResponse.keySet()){
            System.assertEquals('Test List Name Single', parsedResponse.get(key), 'Queried list name reponse does not match the response');
            System.assertEquals('23829', key, 'Queried list id reponse does not match the response');
        }
    }

    @isTest(seeAllData=false)
    static void testQueryMultipleList(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PardotCalloutControllerMock());

        Map<String, String> parsedResponse;

        Test.startTest();

            User u = [SELECT Id, Username From User WHERE Username = 'tester@picomp.com'];
            System.debug(u);
            System.runAs(u){
                // Call method to test
                parsedResponse = PardotListControlLWCController.queryList('Test List Name Multiple', true);
            }
            
        Test.stopTest();

        //Assert results
        
        System.assertEquals('Test List Name Multiple', parsedResponse.get('22325'), 'Queried list name reponse does not match the response');
        System.assertEquals('Test List Name Multiple', parsedResponse.get('22553'), 'Queried list name reponse does not match the response');
    }

    @isTest(seeAllData=false)
    static void testQueryId(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PardotCalloutControllerMock());

        Map<String, String> parsedResponse;

        Test.startTest();

            User u = [SELECT Id, Username From User WHERE Username = 'tester@picomp.com'];
            System.debug(u);
            System.runAs(u){
                // Call method to test
                parsedResponse = PardotListControlLWCController.queryList('22325', false);
            }
            
        Test.stopTest();

        //Assert results
        System.assertEquals('Test List By Id', parsedResponse.get('22325'), 'Queried list name reponse does not match the response');
    }

    @isTest(seeAllData=false)
    static void testAddToListLead(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PardotCalloutControllerMock());

        Map<String, String> parsedResponse;

        Test.startTest();

            User u = [SELECT Id, Username From User WHERE Username = 'tester@picomp.com'];
            System.debug(u);
            System.runAs(u){
                Lead l = [SELECT Id, pi__url__c FROM Lead WHERE pi__url__c = 'http://pi.pardot.com/prospect/read?id=123456'];
                try{
                    PardotListControlLWCController.addToList('23831', l.Id);
                }catch(Exception e){
                    System.assertEquals(null, e);
                }
            }
            
        Test.stopTest();
    }

    @isTest(seeAllData=false)
    static void testAddToListContact(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PardotCalloutControllerMock());

        Map<String, String> parsedResponse;

        Test.startTest();

            User u = [SELECT Id, Username From User WHERE Username = 'tester@picomp.com'];
            System.debug(u);
            System.runAs(u){
                Contact c = [SELECT Id, pi__url__c FROM Contact WHERE pi__url__c = 'http://pi.pardot.com/prospect/read?id=910111213'];
                try{
                    PardotListControlLWCController.addToList('23831', c.Id);
                }catch(Exception e){
                    System.assertEquals(null, e);
                }
            }
            
        Test.stopTest();
    }
    
}
