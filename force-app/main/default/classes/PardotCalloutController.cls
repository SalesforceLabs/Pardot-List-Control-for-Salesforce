/**
 * @description       : 
 * @author            : Jonathan Fox
 * @group             : 
 * @last modified on  : 21-07-2021
 * @last modified by  : Jonathan Fox
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   14-07-2021   Jonathan Fox   Initial Version
**/

public with sharing class PardotCalloutController {
    public class PardotCalloutControllerException extends Exception{}
    
    public static HTTPResponse createList(String listName, String listDesc){
        Id profileId = userinfo.getProfileId();
        pi_list_control__Pardot_List_Control__c piListControlSettings = pi_list_control__Pardot_List_Control__c.getInstance(profileId);
        String buId = piListControlSettings.pi_list_control__Business_Unit_Id__c; 
        String namedCredentialsName = piListControlSettings.pi_list_control__Named_Credential_Name__c; 
        HttpRequest req = new HttpRequest();
        req.setHeader('Pardot-Business-Unit-Id', buId);
        req.setMethod('POST');
        String name = 'name='+listName+'&Title='+listName;
        String andSymbol = '&';
        String description = 'description='+listDesc;
        String listParams = name+andSymbol+description;
        req.setBody(listParams);
        req.setEndpoint('callout:'+namedCredentialsName+'/list/version/4/do/create?format=json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }

    public static HTTPResponse queryList(String listName){
        String searchTerm = 'name='+listName;
        Id profileId = userinfo.getProfileId();
        pi_list_control__Pardot_List_Control__c piListControlSettings = pi_list_control__Pardot_List_Control__c.getInstance(profileId);
        String buId = piListControlSettings.pi_list_control__Business_Unit_Id__c; 
        String namedCredentialsName = piListControlSettings.pi_list_control__Named_Credential_Name__c; 
        HttpRequest req = new HttpRequest();
        req.setHeader('Pardot-Business-Unit-Id', buId);
        req.setMethod('GET');
        req.setBody(searchTerm);
        req.setEndpoint('callout:'+namedCredentialsName+'/list/version/4/do/query?format=json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }

    public static HTTPResponse queryListById(String listId){
        Id profileId = userinfo.getProfileId();
        pi_list_control__Pardot_List_Control__c piListControlSettings = pi_list_control__Pardot_List_Control__c.getInstance(profileId);
        String buId = piListControlSettings.pi_list_control__Business_Unit_Id__c; 
        String namedCredentialsName = piListControlSettings.pi_list_control__Named_Credential_Name__c; 
        HttpRequest req = new HttpRequest();
        req.setHeader('Pardot-Business-Unit-Id', buId);
        req.setMethod('GET');
        req.setEndpoint('callout:'+namedCredentialsName+'/list/version/4/do/read/id/'+listId+'?format=json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }

    public static HTTPResponse addToList(String listId, String prospectId){
        Id profileId = userinfo.getProfileId();
        pi_list_control__Pardot_List_Control__c piListControlSettings = pi_list_control__Pardot_List_Control__c.getInstance(profileId);
        String buId = piListControlSettings.pi_list_control__Business_Unit_Id__c; 
        String namedCredentialsName = piListControlSettings.pi_list_control__Named_Credential_Name__c; 
        HttpRequest req = new HttpRequest();
        req.setHeader('Pardot-Business-Unit-Id', buId);
        req.setMethod('POST');
        req.setEndpoint('callout:'+namedCredentialsName+'/listMembership/version/4/do/create/list_id/'+listId+'/prospect_id/'+prospectId+'?');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }
}