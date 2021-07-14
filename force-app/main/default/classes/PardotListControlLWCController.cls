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
    public static Map<String, String> queryList(String listName){
        HTTPResponse response = PardotCalloutController.queryList(listName);
        Map<String, String> idToListNameMap = new Map<String, String>();
        if(response.getStatusCode() > 299 || response.getStatusCode() < 200){
            throw new PardotListControlLWCControllerException('Failed to query lists - ' + response.getBody());
        }else{
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> results = (Map<String, Object>) responseMap.get('result');
            List<Object> listObj = (List<Object>) results.get('list');
            if(listObj.size() > 1){
                for(Object o : listObj){
                    String listObjSerialised = JSON.serialize(o);
                    PardotList parList = (PardotList)JSON.deserialize(listObjSerialised, PardotList.class);
                    idToListNameMap.put(parList.id, parList.name);
                }
            }else if(listObj.size() == 1){
                String listObjSerialised = JSON.serialize(listObj[0]);
                PardotList parList = (PardotList)JSON.deserialize(listObjSerialised, PardotList.class);
                idToListNameMap.put(parList.id, parList.name);
            }else{
                throw new PardotListControlLWCControllerException('No lists found');
            }
            System.debug(idToListNameMap);
            return idToListNameMap;
        }
    }

    @AuraEnabled
    public static void addToList(String listId, String prospectId){
        HTTPResponse response = PardotCalloutController.addToList(listId, prospectId);
        if(response.getStatusCode() > 299 || response.getStatusCode() < 200){
            throw new PardotListControlLWCControllerException('Failed to add prospect to list - ' + response.getBody());  
        }
    }
}
