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
        System.debug(response.getBody());
        if(response.getStatusCode() > 299 || response.getStatusCode() < 200){
            throw new PardotListControlLWCControllerException('Failed to create list - ' + response.getBody());
        }else{
            return true;
        }
    }

    @AuraEnabled
    public static Map<String, String> queryList(String param, Boolean isListName){
        HTTPResponse response;
        Map<String, String> idToListNameMap = new Map<String, String>();
        if(isListName){
            response = PardotCalloutController.queryList(param);
            System.debug(response.getBody());
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
        }else{
            response = PardotCalloutController.queryListById(param);
            System.debug(response.getBody());
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> results = (Map<String, Object>) responseMap.get('list');
            Integer intId = (Integer)results.get('id');
            String sId = String.valueOf(intId);
            String sName = (String)results.get('name');
            idToListNameMap.put(sId, sName);
            return idToListNameMap;
        }
    }

    @AuraEnabled
    public static void addToList(String listId, String recordId){
        Id recId = (Id)recordId;
        String sobjectType = recId.getSObjectType().getDescribe().getName();
        String pardotURL;
        String prospectId;
        if(sobjectType == 'Contact'){
            Contact c = [Select Id, pi__url__c from Contact WHERE Id = :recordId WITH SECURITY_ENFORCED];
            if(c.pi__url__c != null){
                pardotURL = c.pi__url__c;
                prospectId = pardotURL.substringAfter('id=');
            }else{
                throw new PardotListControlLWCControllerException('This person is not a Pardot prospect!');
            }
            
        }else if(sobjectType == 'Lead'){
            Lead l = [Select Id, pi__url__c from Lead WHERE Id = :recordId WITH SECURITY_ENFORCED];
            if(l.pi__url__c != null){
                pardotURL = l.pi__url__c;
                prospectId = pardotURL.substringAfter('id=');
            }else{
                throw new PardotListControlLWCControllerException('This person is not a Pardot prospect!');
            }
        }else{
            throw new PardotListControlLWCControllerException('Could not find Pardot Prospect ID');
        }
        HTTPResponse response = PardotCalloutController.addToList(listId, prospectId);
        System.debug(response.getBody());
        if(response.getStatusCode() > 299 || response.getStatusCode() < 200){
            throw new PardotListControlLWCControllerException('Failed to add prospect to list - ' + response.getBody());  
        }
    }
}
