/**
 * @description       : 
 * @author            : Jonathan Fox
 * @group             : 
 * @last modified on  : 15-07-2021
 * @last modified by  : Jonathan Fox
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   13-07-2021   Jonathan Fox   Initial Version
**/
import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createList from '@salesforce/apex/PardotListControlLWCController.createList';
import queryList from '@salesforce/apex/PardotListControlLWCController.queryList';
import addProspectToList from '@salesforce/apex/PardotListControlLWCController.addToList';

export default class PardotListControl extends LightningElement {
    @api recordId;
    
    //Modal controls
    isCreateList = false;
    isAddToList = false;

    //Text value
    createListTextNameValue = '';
    createListTextDescriptionValue = '';
    listNameSearchValue = '';

    //Return results
    listFound = false;
    multipleListsFound = false;
    listId = '';

    //Search values
    usingListName = true;


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
        this.createListTextNameValue = event.target.value;
    }
    handleCreateListTextDescriptionValue(event){
        this.createListTextDescriptionValue = event.target.value;
    }

    createList(){
        console.log('listName :' + this.createListTextNameValue + '>> ' + 'listDescription :' + this.createListTextDescriptionValue);
        createList({listName : this.createListTextNameValue, listDescription : this.createListTextDescriptionValue})
            .then(result => {
                if(result == true){
                    this.resetCmp();
                }
            })
            .catch(error => {
                this.error = error;
                const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(toastEvent);
            });
    }

    handleListNameSearchValueChange(event){
        this.listNameSearchValue = event.target.value;
    }

    //NEED TO HANDLE MORE THAN ONE LIST RETURNED
    handleSearch(){
        if(this.usingListName === true){
            queryList({param : this.listNameSearchValue, isListName : true})
            .then(result => {
                this.listIdMap = result;
                console.log('this.listIdMap >' + this.listIdMap);
                if(result){
                    this.listFound = true;
                    if(result.size > 1){
                        this.multipleListsFound = true
                    }
                }
            })
            .catch(error => {
                this.error = error;
                console.log(error);
                const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(toastEvent);
            });
        }else{
            queryList({param : this.listNameSearchValue, isListName : false})
            .then(result => {
                this.listIdMap = result;
                console.log('this.listIdMap >' + this.listIdMap);
                if(result){
                    this.listFound = true;
                    if(result.size > 1){
                        this.multipleListsFound = true
                    }
                }
            })
            .catch(error => {
                this.error = error;
                const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(toastEvent);
            });
        }
        
    }

    addToList(){
        if(this.listFound = true){
            let listId = this.listId;
            addProspectToList({listId : listId, recordId : this.recordId})
            .then(result => {
                this.resetCmp();
            })
            .catch(error => {
                this.error = error;
                const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(toastEvent);t
            });
        }else{
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: 'You need to have a valid list to add the prospect to.',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(toastEvent);
        }
    }


    resetCmp(){
        this.isCreateList = false;
        this.isAddToList = false;
        this.createListTextValue = 'List A'
    }
}