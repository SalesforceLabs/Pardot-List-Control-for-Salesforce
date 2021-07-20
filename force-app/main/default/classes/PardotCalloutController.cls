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
public class PardotCalloutController {
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
        System.debug(res.getBody());
        return res;
    }

    public static HTTPResponse queryList(String listName, String listId){
        String searchTerm;
        System.debug('List Name ' + listName);
        System.debug('listId ' + listId);
        if(listName != null && listId == null){
            searchTerm = 'name='+listName;
        }else if(listId != null && listName == null){
            searchTerm = 'list_id='+listId;
        }else{
            throw new PardotCalloutControllerException('Either no list name or list ID was provided OR both search terms were passed into the method');
        }
        
        System.debug('searchTerm ' + searchTerm);
        
        HttpRequest req = new HttpRequest();
        req.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        req.setMethod('GET');
        req.setBody(searchTerm);
        req.setEndpoint('callout:APEX_Pardot_Credential/list/version/4/do/query?format=json');
        System.debug(req);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return res;
    }

    public static HTTPResponse addToList(String listId, String prospectId){
        HttpRequest req = new HttpRequest();
        req.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        req.setMethod('POST');
        req.setEndpoint('callout:APEX_Pardot_Credential/listMembership/version/4/do/create/list_id/'+listId+'/prospect_id/'+prospectId+'?');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return res;
    }
}