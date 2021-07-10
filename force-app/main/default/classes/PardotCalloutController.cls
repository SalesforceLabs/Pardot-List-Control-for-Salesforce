public class PardotCalloutController {
    public static void doCallout(){
        //Using named credentials and self signed cert.
        //For the app, we will need to generate the named credentails but show how to name the integration user also instruct how to create cert and upload it
        //Connected app is also used for Salesforce access token so will have create and then instruct how to auth users as an admin
        //
        //TO DO:
        //Update the Named Credential Named Principle to an Integration user
        //Add Integration user to Connected app
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:APEX_Pardot_Credential/account/version/4/do/read?format=json');
        
        //Bussiness unit is not retrivable either? SO will have to be passed in as a param or stored in custom meta where the customer can set up using
        //an app page for us to have a 'set up' page
        req.setHeader('Pardot-Business-Unit-Id', '0Uv4L000000004DSAQ');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
            
    }
}