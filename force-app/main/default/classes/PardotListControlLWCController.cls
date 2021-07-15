/**
 * @description       : 
 * @author            : Jonathan Fox
 * @group             : 
 * @last modified on  : 15-07-2021
 * @last modified by  : Jonathan Fox
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   14-07-2021   Jonathan Fox   Initial Version
**/
public with sharing class PardotListControlLWCController {
    public class PardotListControlLWCControllerException extends Exception{}

    public class PardotList{
        public String created_at; 
        public String description; 
        public String id; 
        public Boolean is_crm_visible; 
        public Boolean is_dynamic; 
        public Boolean is_public; 
        public String name; 
        public String title; 
        public String updated_at;
    }

    @AuraEnabled
    public static Boolean createList(String listName, String listDescription){

        HTTPResponse response = PardotCalloutController.createList(listName, listDescription);

        if(response.getStatusCode() > 299 || response.getStatusCode() < 200){
            throw new PardotListControlLWCControllerException('Failed to create list - ' + response.getBody());
        }else{
            return true;
        }
    }

    @AuraEnabled
    public static Map<String, String> queryList(String param, Boolean isListName){
        HTTPResponse response;
        if(isListName){
            response = PardotCalloutController.queryList(param, null);
        }else{
            response = PardotCalloutController.queryList(null, param);
        }
        Map<String, String> idToListNameMap = new Map<String, String>();
        if(response.getStatusCode() > 299 || response.getStatusCode() < 200){
            throw new PardotListControlLWCControllerException('Failed to query lists - ' + response.getBody());
        }else{
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> results = (Map<String, Object>) responseMap.get('result');
            List<Object> listObj = new List<Object>();
            if(Integer.valueOf(results.get('total_results')) > 1){
                listObj = (List<Object>) results.get('list');
            }
            if(listObj.size() > 1){
                for(Object o : listObj){
                    String listObjSerialised = JSON.serialize(o);
                    PardotList parList = (PardotList)JSON.deserialize(listObjSerialised, PardotList.class);
                    idToListNameMap.put(parList.id, parList.name);
                }
            }else if(results.get('total_results') == 1){
                String listObjSerialised = JSON.serialize(results.get('list'));
                PardotList parList = (PardotList)JSON.deserialize(listObjSerialised, PardotList.class);
                idToListNameMap.put(parList.id, parList.name);
            }else{
                throw new PardotListControlLWCControllerException('No lists found');
            }
            return idToListNameMap;
        }
    }

    @AuraEnabled
    public static void addToList(String listId, String recordId){
        Id recId = (Id)recordId;
        String sobjectType = recId.getSObjectType().getDescribe().getName();
        System.debug('sobjectType > ' + sobjectType);
        String pardotURL;
        String prospectId;
        if(sobjectType == 'Contact'){
            pardotURL = [Select Id, pi__url__c from Contact WHERE Id = :recordId].pi__url__c;
            prospectId = pardotURL.substringAfter('id=');
        }else if(sobjectType == 'Lead'){
            pardotURL = [Select Id, pi__url__c from Lead WHERE Id = :recordId].pi__url__c;
            prospectId = pardotURL.substringAfter('id=');
        }else{
            throw new PardotListControlLWCControllerException('Could not find Pardot Prospect ID');
        }
        HTTPResponse response = PardotCalloutController.addToList(listId, prospectId);
        if(response.getStatusCode() > 299 || response.getStatusCode() < 200){
            throw new PardotListControlLWCControllerException('Failed to add prospect to list - ' + response.getBody());  
        }
    }
}
