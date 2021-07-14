/**
 * @description       : 
 * @author            : Jonathan Fox
 * @group             : 
 * @last modified on  : 14-07-2021
 * @last modified by  : Jonathan Fox
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   13-07-2021   Jonathan Fox   Initial Version
**/
import { LightningElement, api } from 'lwc';

export default class PardotListControl extends LightningElement {
    @api recordId;
    
    //Modal controls
    isCreateList = false;
    isAddToList = false;

    //Text value
    createListTextValue = 'List A';
    listNameSearchValue = 'List A';

    //Return results
    listFound = false;


    //-- Modal Handlers --//
    handleCreateList(){
        this.isCreateList = true;
    }

    handleAddToList(){
        this.isAddToList = true;
    }

    handleCloseModal(){
        this.isCreateList = false;
        this.isAddToList = false;
    }

    handleCreateListTextValueChange(event){
        this.createListTextValue = event.value;
    }

    createList(){
        let listName = this.createListTextValue;
        //Maybe on apex promise
        this.resetCmp();
    }

    handleListNameSearchValueChange(event){
        this.listNameSearchValue = event.value;
    }

    handleSearch(){
        //call Apex
        //If result found
        //this.listFound = true;
    }
    addToList(){
        let listName;
        if(this.listFound = true){
            listName = this.listNameSearchValue;
            //call apex
        }else{
            //throw error
        }
        //Maybe on apex promise
        this.resetCmp();
    }


    resetCmp(){
        this.isCreateList = false;
        this.isAddToList = false;
        this.createListTextValue = 'List A'
    }
}