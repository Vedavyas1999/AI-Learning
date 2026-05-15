import { LightningElement, wire, track, api } from 'lwc';
import getObjectList from '@salesforce/apex/ObjectListController.getObjectList';
//import getUsers from '@salesforce/apex/ObjectListController.getUsers';
import getCustomLookupUser from '@salesforce/apex/ObjectListController.getCustomLookupUser';
import getCustomLookupUser1 from '@salesforce/apex/ObjectListController.getCustomLookupUser1';
import getObjectRecordCounts from '@salesforce/apex/ObjectListController.getObjectRecordCounts';
import transferOwnerships from '@salesforce/apex/ObjectListController.transferOwnerships';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ObjectListLWC extends LightningElement {


    @api selectedObjects;
    @api userId;
    @api userName;
    @api userName1;
    @track userName1 = '';
    userName1 = '';
    @track userList1 = [];
    @track objectApiName = 'User';
    @track iconName;
    @track userId1;
    @track isShow1 = false;
    @track messageResult1 = false;
    @track isShowResult1 = true;
    @track showSearchedValues1 = false;
    recordCounting;
    selectedObjects = [];
    objectOptions;

    @wire(getCustomLookupUser1, { UName1: '$userName1' })
    retrieveUsers1({ error, data }) {
        this.messageResult1 = false;
        if (data) {
            console.log('data## ' + data.length);
            if (data.length > 0 && this.isShowResult1) {
                this.userList1 = data;
                this.showSearchedValues1 = true;
                this.messageResult1 = false;
            }
            else if (data.length == 0) {
                this.userList1 = [];
                this.showSearchedValues1 = false;
                if (this.userName1 != '') {
                    this.messageResult1 = true;
                }
            }
            else if (error) {
                this.userId1 = '';
                this.userName1 = '';
                this.userList1 = [];
                this.showSearchedValues1 = false;
                this.messageResult1 = true;
            }
        }
    }

    searchHandleClick1(event) {
        this.isShowResult1 = true;
        this.messageResult1 = false;
    }

    searchHandleKeyChange1(event) {
        this.messageResult1 = false;
        this.userName1 = event.detail.value;
        this.userId1 = event.detail.value;
    }

    parentHandleAction1(event) {
        this.showSearchedValues1 = false;
        this.isShowResult1 = false;
        this.messageResult1 = false;
        this.userId1 = event.target.dataset.value;
        this.userName1 = event.target.dataset.label;
        console.log('userId1:' + this.userId1);
        const selectedEvent1 = new CustomEvent('selected', { detail: this.userId1 });
        this.dispatchEvent(selectedEvent1);
    }

    get disableButton() {
        return (this.userName == this.userName1 || this.userName == '' || this.userName1 == '' || this.selectedObjects == '');
    }

    get disableButtons() {
        return (this.userName == '' || this.selectedObjects == '');
    }

    @track userName = '';
    @track userList = [];
    @track objectApiName = 'User';
    @track iconName;
    @track userId;
    @track isShow = false;
    @track messageResult = false;
    @track isShowResult = true;
    @track showSearchedValues = false;

    @wire(getCustomLookupUser, { UName: '$userName' })
    retrieveUsers({ error, data }) {
        this.messageResult = false;
        if (data) {
            console.log('data##' + data.length);
            if (data.length > 0 && this.isShowResult) {
                this.userList = data;
                this.showSearchedValues = true;
                this.messageResult = false;
            }
            else if (data.length == 0) {
                this.userList = [];
                this.showSearchedValues = false;
                if (this.userName != '') {
                    this.messageResult = true;
                }
            }
            else if (error) {
                this.userId = '';
                this.userName = '';
                this.userList = [];
                this.showSearchedValues = false;
                this.messageResult = true;
            }
        }
    }

    searchHandleClick(event) {
        this.isShowResult = true;
        this.messageResult = false;
    }

    searchHandleKeyChange(event) {
        this.messageResult = false;
        this.userName = event.target.value;
    }

    parentHandleAction(event) {
        this.showSearchedValues = false;
        this.isShowResult = false;
        this.messageResult = false;
        this.userId = event.target.dataset.value;
        this.userName = event.target.dataset.label;
        console.log('userId::' + this.userId);
        const selectedEvent = new CustomEvent('selected', { detail: this.userId });
        this.dispatchEvent(selectedEvent);
    }

    @track isModalOpen = false;
    openModal(event) {
        this.isModalOpen = true;
        this.userName1 = this.userName1;
        this.userName = this.userName;
        const selectedId = event.target.value;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    submitDetails() {
        this.isModalOpen = false;
    }

    @wire(getObjectList)
    wiredObjectList({ error, data }) {
        if (data) {
            this.objectOptions = data.map(obj => ({ label: obj, value: obj }));
        } else if (error) {
            console.error(error);
        }
    }

    handleRemove(event) {
        this.selectedObjects = this.selectedObjects.filter(
            obj => obj !== event.detail.previousElementSibling.textContent);
    }

    //for multiselect picklist
    handleSelectOptionList(event) {
        console.log(event.detail);
        this.selectedObjects = event.detail;
        console.log(this.selectedObjects);
    }

    @track recordCounts;

    handleButtonClick() {
        getObjectRecordCounts({ objectNames: this.selectedObjects, userId: this.userId })
            .then(result => {
                this.recordCounts = JSON.stringify(result);
                JSON.parse(this.recordCounts);
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleTransferOwnership() {
        //  const oldOwnerId = 'Old Owner ID'; 
        //  const newOwnerId = 'New Owner ID'; 
        //  const objectName = 'Object API Name'; 

        transferOwnerships({ oldOwnerId: this.userId, newOwnerId: this.userId1, objectNames: this.selectedObjects })
            .then(result => {
                this.ownerUpdate = result;
                console.log('Records updated successfully');
                this.submitDetails();
                const event = new ShowToastEvent({
                    title: 'Ownership Updated',
                    message: 'The ownership of the record has been updated.',
                    variant: 'success'
                });
                this.dispatchEvent(event);
                //refreshApex(this.getObjectRecordCounts);
                //return refreshApex(this.retrieveUsers);
                //window.location.reload();
                setTimeout(function () { (eval("$A.get('e.force:refreshView').fire()")) }, 1000);
                this[NavigationMixin.Navigate]({
                    type: 'standard__namedPage',
                    attributes: {
                        pageName: 'home'
                    },
                });


                //refreshApex(this.retrieveUsers).then(() => {
                //this.userName = [];
                //});
            })
            .catch(error => {
                console.error(error);
            });
    }
}