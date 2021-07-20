/**
 * @description       : 
 * @author            : Jonathan Fox
 * @group             : 
 * @last modified on  : 20-07-2021
 * @last modified by  : Jonathan Fox
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   13-07-2021   Jonathan Fox   Initial Version
**/
import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createList from '@salesforce/apex/PardotListControlLWCController.createList';
import queryList from '@salesforce/apex/PardotListControlLWCController.queryList';
import addProspectToList from '@salesforce/apex/PardotListControlLWCController.addToList';

export default class PardotListControl extends LightningElement {
    @api recordId;
    
    //Modal controls
    isCreateList = false;
    isAddToList = false;
    showSpinner = false;

    //Text value
    createListTextNameValue = '';
    createListTextDescriptionValue = '';
    listNameSearchValue = '';
    searchTextReadOnly = false;

    //Return results
    singleListFound = false;
    multipleListsFound = false;
    listIdObj;
    listArray = [];
    

    //Search values
    SearchOptionsValue;
    searchButtonDisabled = true;
    addToListButtonDisabled = true;
    sortBy;
    sortDirection;
    selectedRow = [];
    get SearchOptions() {
        return [
            { label: 'By Name', value: 'byName' },
            { label: 'By ID', value: 'byId' },
        ];
    }
    columns = [
        { label: 'Id', fieldName: 'Id', type: "text", sortable: "true"},
        { label: 'Name', fieldName: 'Name', type: "text", sortable: "true" }
    ];
    
    //-- Modal Handlers --//
    handleCreateList(){
        this.isCreateList = true;
    }

    handleAddToList(){
        this.isAddToList = true;
    }

    handleCloseModal(){
        this.resetCmp();
    }

    handleCreateListTextNameValue(event){
        this.createListTextNameValue = event.target.value;
    }
    handleCreateListTextDescriptionValue(event){
        this.createListTextDescriptionValue = event.target.value;
    }

    createList(){
        this.showSpinner = true;
        createList({listName : this.createListTextNameValue, listDescription : this.createListTextDescriptionValue})
            .then(result => {
                this.showSpinner = false;
                if(result == true){
                    this.resetCmp();
                }
                const toastEventSuccess = new ShowToastEvent({
                    title: 'Success',
                    message: 'List Created!',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(toastEventSuccess);
            })
            .catch(error => {
                this.showSpinner = false;
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
        if(this.SearchOptionsValue != null && this.listNameSearchValue != ''){
            this.searchButtonDisabled = false;
        }
    }

    handleSearchOptionsValueChange(event){
        this.SearchOptionsValue = event.detail.value;
        
        if(this.SearchOptionsValue != null && this.listNameSearchValue != ''){
            this.searchButtonDisabled = false;
        }
    }

    handleSearch(){
        this.showSpinner = true;
        this.searchTextReadOnly = true;
        this.searchButtonDisabled = true;
        if(this.SearchOptionsValue == 'byName'){
            queryList({param : this.listNameSearchValue, isListName : true})
            .then(result => {
                this.showSpinner = false;
                this.listIdObj = result;
                this.handleResults();
                this.isAddToListDisabled();
                const toastEventSuccess = new ShowToastEvent({
                    title: 'Success',
                    message: 'List(s) Found!',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(toastEventSuccess);
            })
            .catch(error => {
                this.showSpinner = false;
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
                this.showSpinner = false;
                this.listIdObj = result;
                this.handleResults();
                this.isAddToListDisabled();
            })
            .catch(error => {
                this.showSpinner = false;
                
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

    handleResults(){
        for (let [key, value] of Object.entries(this.listIdObj)) {
            let listObj = {Id:key, Name:value};
            this.listArray.push(listObj);
        }
        if(this.listArray != null){
            if(this.listArray.length > 1){
                this.multipleListsFound = true;
            }else if(this.listArray.length == 1){
                this.singleListFound = true;
            }
        }else{
            this.noListFound = true;
        }
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.listArray));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.listArray = parseData;
    }

    handleRowSelect(event){
        var selectedRows = event.detail.selectedRows;
        if(selectedRows.length > 1){
            let el = this.template.querySelector('lightning-datatable');
            selectedRows = el.selectedRows = el.selectedRows.slice(1);
            this.selectedRow = selectedRows;
            
            this.isAddToListDisabled();
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: 'Only one row can be selected',
                variant: 'warning',
                mode: 'pester'
            });
            this.dispatchEvent(toastEvent);
            event.preventDefault();
        }else if(selectedRows.length == 1){
            let el = this.template.querySelector('lightning-datatable');
            selectedRows = el.selectedRows;
            this.selectedRow = selectedRows;
            this.isAddToListDisabled();
        }
        
    }

    isAddToListDisabled(){
        let firstResultFinal = this.listArray.length == 1 ? true : false;
        let selectedRowResultFinal = this.selectedRow.length == 1 ? true : false;
        if(firstResultFinal === true || selectedRowResultFinal === true ){
            this.addToListButtonDisabled = false;
        }
    }

    addToList(){
        this.showSpinner = true;
        let localListId = this.listArray.length == 1 ? this.listArray[0].Id : this.selectedRow[0];
        addProspectToList({listId : localListId, recordId : this.recordId})
        .then(result => {
            this.showSpinner = false;
            this.resetCmp();
            const toastEventSuccess = new ShowToastEvent({
                title: 'Success',
                message: 'Member Added To List!',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(toastEventSuccess);
        })
        .catch(error => {
            this.showSpinner = false;
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(toastEvent);t
        });
    }

    resetCmp(){
        this.isCreateList = false;
        this.isAddToList = false;
        this.createListTextNameValue = '';
        this.createListTextDescriptionValue = '';
        this.listNameSearchValue = '';
        this.searchTextReadOnly = false;
        this.singleListFound = false;
        this.multipleListsFound = false;
        this.noListFound = true;
        this.listIdObj;
        this.listArray = [];
        this.SearchOptionsValue;
        this.searchButtonDisabled = true;
        this.addToListButtonDisabled = true;
    }

    resetSearch(){
        this.createListTextNameValue = '';
        this.createListTextDescriptionValue = '';
        this.listNameSearchValue = '';
        this.searchTextReadOnly = false;
        this.singleListFound = false;
        this.multipleListsFound = false;
        this.noListFound = true;
        this.listIdObj;
        this.listArray = [];
        this.SearchOptionsValue;
        this.searchButtonDisabled = true;
        this.addToListButtonDisabled = true;
    }
}