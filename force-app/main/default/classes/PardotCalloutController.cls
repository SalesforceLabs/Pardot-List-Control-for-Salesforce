/**
 * @description       : 
 * @author            : Jonathan Fox
 * @group             : 
 * @last modified on  : 14-07-2021
 * @last modified by  : Jonathan Fox
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   14-07-2021   Jonathan Fox   Initial Version
**/
public class PardotCalloutController {

    public static HTTPResponse createList(String listName, String listDesc){
        HttpRequest req = new HttpRequest();
        
        
        //Bussiness unit is not retrivable either? SO will have to be passed in as a param or stored in custom meta where the customer can set up using
        //an app page for us to have a 'set up' page
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

    public static HTTPResponse queryList(String listName){
        HttpRequest req = new HttpRequest();
        
        
        //Bussiness unit is not retrivable either? SO will have to be passed in as a param or stored in custom meta where the customer can set up using
        //an app page for us to have a 'set up' page
        req.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        req.setMethod('GET');
        String name = 'name='+listName;
        req.setBody(name);
        req.setEndpoint('callout:APEX_Pardot_Credential/list/version/4/do/query?format=json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        return res;
    }

    public static HTTPResponse addToList(String listId, String prospectId){

        HttpRequest req = new HttpRequest();
        
        
        //Bussiness unit is not retrivable either? SO will have to be passed in as a param or stored in custom meta where the customer can set up using
        //an app page for us to have a 'set up' page
        req.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        req.setMethod('POST');
        req.setEndpoint('callout:APEX_Pardot_Credential/listMembership/version/4/do/create/list_id/'+listId+'/prospect_id/'+prospectId+'?');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return res;
    }
}