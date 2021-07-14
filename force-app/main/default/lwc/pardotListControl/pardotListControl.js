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
import createList from '@salesforce/apex/PardotListControlLWCController.createList';
import queryList from '@salesforce/apex/PardotListControlLWCController.queryList';
import addProspectToList from '@salesforce/apex/PardotListControlLWCController.addToList';

export default class PardotListControl extends LightningElement {
    @api recordId;
    
    //Modal controls
    isCreateList = false;
    isAddToList = false;

    //Text value
    createListTextNameValue = 'List A';
    createListTextDescriptionValue = 'List A';
    listNameSearchValue = 'List A';

    //Return results
    listFound = false;
    multipleListsFound = false;
    listId = '';


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

    handleCreateListTextNameValue(event){
        this.createListTextNameValue = event.value;
    }
    handlecreateListTextDescriptionValue(event){
        this.createListTextDescriptionValue = event.value;
    }

    createList(){
        let listName = this.createListTextNameValue;
        let listDescription = this.createListTextDescriptionValue;
        createList({listName : listName, listDescription : listDescription})
            .then(result => {
                if(result == true){
                    this.resetCmp();
                }
            })
            .catch(error => {
                this.error = error;
                //Throw error toast
            });
    }

    handleListNameSearchValueChange(event){
        this.listNameSearchValue = event.value;
    }

    handleSearch(){
        queryList({listName : this.listNameSearchValue})
            .then(result => {
                this.listId = result;
                if(result){
                    this.listFound = true;
                }
            })
            .catch(error => {
                this.error = error;
                //Throw error toast
            });
    }

    addToList(){
        if(this.listFound = true){
            let listId = this.listId;
            addProspectToList({listId : listId, prospectId})
            .then(result => {
                this.resetCmp();
            })
            .catch(error => {
                this.error = error;
                //Throw error toast
            });
        }else{
            //throw error
        }
    }


    resetCmp(){
        this.isCreateList = false;
        this.isAddToList = false;
        this.createListTextValue = 'List A'
    }
}