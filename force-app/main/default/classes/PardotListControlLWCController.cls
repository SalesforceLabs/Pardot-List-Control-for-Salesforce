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
public with sharing class PardotListControlLWCController {
    public static Boolean createList(String listName, String listDescription){
        HTTPResponse response = PardotCalloutController.createList(listName, listDescription);
        if(response.getStatusCode() > 299 || response.getStatusCode() < 200){
            //throw error
        }else{
            return true;
        }
    }
    public static String queryList(String listName){
        HTTPResponse response = PardotCalloutController.queryList(listName);
        if(response.getStatusCode() > 299 || response.getStatusCode() < 200){
            //throw error
        }else{
            //get list Id
            //return list Id
            return null;
        }
    }
    public static void addToList(String listId, String prospectId){
        HTTPResponse response = PardotCalloutController.addToList(listId, prospectId);
        if(response.getStatusCode() > 299 || response.getStatusCode() < 200){
            //throw error
        }else{
            return true;
        }
    }
}
