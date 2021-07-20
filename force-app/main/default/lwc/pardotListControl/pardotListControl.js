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

    //Text value
    createListTextNameValue = '';
    createListTextDescriptionValue = '';
    listNameSearchValue = '';
    searchTextReadOnly = false;

    //Return results
    singleListFound = false;
    multipleListsFound = false;
    noListFound = true;
    listIdObj;
    listArray = [];
    

    //Search values
    SearchOptionsValue;
    searchButtonDisabled = true;
    addToListButtonDisabled = true;

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
    sortBy;
    sortDirection;
    selectedRow = [];
    


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
        console.log('listName :' + this.createListTextNameValue + '>> ' + 'listDescription :' + this.createListTextDescriptionValue);
        createList({listName : this.createListTextNameValue, listDescription : this.createListTextDescriptionValue})
            .then(result => {
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
        console.log(this.SearchOptionsValue + ' : ' + this.listNameSearchValue);
        if(this.SearchOptionsValue != null && this.listNameSearchValue != ''){
            this.searchButtonDisabled = false;
        }
    }

    handleSearch(){
        this.searchTextReadOnly = true;
        this.searchButtonDisabled = true;
        if(this.SearchOptionsValue == 'byName'){
            queryList({param : this.listNameSearchValue, isListName : true})
            .then(result => {
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
                this.listIdObj = result;
                console.log('this.listIdObj >' + this.listIdObj);
                this.handleResults();
                this.isAddToListDisabled();
            })
            .catch(error => {
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
        console.log('***************');
        console.log(this.listArray);
        if(this.listArray != null){
            if(this.listArray.length > 1){
                this.multipleListsFound = true;
                this.noListFound = false;
            }else if(this.listArray.length == 1){
                this.singleListFound = true;
                this.noListFound = false;
            }else {
                this.noListFound = true;
            }
        }else{
            this.noListFound = true;
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
        let localListId = this.listArray.length == 1 ? this.listArray[0].Id : this.selectedRow[0];
        console.log(this.listArray);
        console.log('**********' + this.selectedRow);
        console.log(localListId);
        
        addProspectToList({listId : localListId, recordId : this.recordId})
        .then(result => {
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
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(toastEvent);t
        });
        
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
            console.log('this.selectedRow ' + this.selectedRow);
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
            console.log(this.selectedRow);
            this.isAddToListDisabled();
        }
        console.log('+++++++++' + this.selectedRow);
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