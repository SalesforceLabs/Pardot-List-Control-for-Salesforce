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
public class PardotCalloutControllerMock implements HttpCalloutMock {
    HttpResponse[] responses = new HttpResponse[0];
    public HttpResponse respond(HttpRequest request) {
        System.debug(request.getEndpoint());
        System.debug(request.getBody());
        if(request.getEndpoint() == 'callout:APEX_Pardot_Credential/list/version/4/do/create?format=json'){
            createListMock(request);
        }else if(request.getEndpoint() == 'callout:APEX_Pardot_Credential/list/version/4/do/query?format=json' && request.getBody() == 'name=Test List Name Single'){
            queryListSingleMock(request);
        }else if(request.getEndpoint() == 'callout:APEX_Pardot_Credential/list/version/4/do/query?format=json' && request.getBody() == 'name=Test List Name Multiple'){
            queryListMultipleMock(request);
        }else if(request.getEndpoint().contains('callout:APEX_Pardot_Credential/list/version/4/do/read/id/')){
            queryListByIdMock(request);
        }else if(request.getEndpoint().contains('callout:APEX_Pardot_Credential/listMembership/version/4/do/create/list_id')){
            addToListMock(request);
        }
        System.debug(responses);
        return responses.remove(0);
    }

    public void createListMock(HTTPRequest req) {
        System.assertEquals('callout:APEX_Pardot_Credential/list/version/4/do/create?format=json', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        res.setBody('{"@attributes":{"stat":"ok","version":1},"list":{"id":23829,"name":"Test List Name","is_public":false,"is_dynamic":false,"title":null,"description":"Test List Description","is_crm_visible":false,"created_at":"2021-07-21 10:53:40","updated_at":"2021-07-21 10:53:40"}}');
        res.setStatusCode(200);
        responses.add(res);
    }

    public void queryListSingleMock(HTTPRequest req) {
        System.assertEquals('callout:APEX_Pardot_Credential/list/version/4/do/query?format=json', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        res.setBody('{"@attributes":{"stat":"ok","version":1},"result":{"total_results":1,"list":{"id":23829,"name":"Test List Name Single","is_public":false,"is_dynamic":false,"title":null,"description":"Test List Description Single","is_crm_visible":false,"created_at":"2021-07-21 10:53:40","updated_at":"2021-07-21 10:53:40"}}}');
        res.setStatusCode(200);
        responses.add(res);
    }

    public void queryListMultipleMock(HTTPRequest req) {
        System.assertEquals('callout:APEX_Pardot_Credential/list/version/4/do/query?format=json', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        res.setBody('{"@attributes":{"stat":"ok","version":1},"result":{"total_results":2,"list":[{"id":22325,"name":"Test List Name Multiple","is_public":false,"is_dynamic":false,"title":null,"description":"Unique","is_crm_visible":false,"created_at":"2021-07-19 20:54:15","updated_at":"2021-07-19 20:54:15"},{"id":22553,"name":"Test List Name Multiple","is_public":false,"is_dynamic":false,"title":null,"description":"JFoxUK List duplicate","is_crm_visible":false,"created_at":"2021-07-20 19:35:08","updated_at":"2021-07-20 19:35:08"}]}}');
        res.setStatusCode(200);
        responses.add(res);
    }

    public void queryListByIdMock(HTTPRequest req) {
        System.assert(req.getEndpoint().contains('callout:APEX_Pardot_Credential/list/version/4/do/read/id/'));
        System.assertEquals('GET', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        res.setBody('{"@attributes":{"stat":"ok","version":1},"list":{"id":22325,"name":"Test List By Id","is_public":false,"is_dynamic":false,"title":null,"description":"Test List By Id","is_crm_visible":false,"created_at":"2021-07-19 20:54:15","updated_at":"2021-07-19 20:54:15"}}');
        res.setStatusCode(200);
        responses.add(res);
    }

    public void addToListMock(HTTPRequest req) {
        System.assert(req.getEndpoint().contains('callout:APEX_Pardot_Credential/listMembership/version/4/do/create/list_id'));
        System.assertEquals('POST', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        res.setBody('{"@attributes":{"stat":"ok","version":1},"list_membership":{"id":2916093,"list_id":23831,"prospect_id":1994589,"opted_out":false,"created_at":"2021-07-21 11:08:51","updated_at":"2021-07-21 11:08:51"}}');
        res.setStatusCode(200);
        responses.add(res);
    }
}
