/**
 * @description       : 
 * @author            : Jonathan Fox
 * @group             : 
 * @last modified on  : 20-07-2021
 * @last modified by  : Jonathan Fox
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   14-07-2021   Jonathan Fox   Initial Version
**/


//TO DO:
// PASS IN ? STORE BUID
public with sharing class PardotCalloutController {
    public class PardotCalloutControllerException extends Exception{}
    public static HTTPResponse createList(String listName, String listDesc){
        HttpRequest req = new HttpRequest();
        req.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        req.setMethod('POST');
        String name = 'name='+listName+'&Title='+listName;
        String andSymbol = '&';
        String description = 'description='+listDesc;
        String listParams = name+andSymbol+description;
        req.setBody(listParams);
        req.setEndpoint('callout:APEX_Pardot_Credential/list/version/4/do/create?format=json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }

    public static HTTPResponse queryList(String listName){
        String searchTerm = 'name='+listName;
        HttpRequest req = new HttpRequest();
        req.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        req.setMethod('GET');
        req.setBody(searchTerm);
        req.setEndpoint('callout:APEX_Pardot_Credential/list/version/4/do/query?format=json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }

    public static HTTPResponse queryListById(String listId){
        HttpRequest req = new HttpRequest();
        req.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        req.setMethod('GET');
        req.setEndpoint('callout:APEX_Pardot_Credential/list/version/4/do/read/id/'+listId+'?format=json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }

    public static HTTPResponse addToList(String listId, String prospectId){
        HttpRequest req = new HttpRequest();
        req.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        req.setMethod('POST');
        req.setEndpoint('callout:APEX_Pardot_Credential/listMembership/version/4/do/create/list_id/'+listId+'/prospect_id/'+prospectId+'?');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }
}