import { LightningElement, wire } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import getGroupsByCountry from '@salesforce/apex/AccountController.getGroupsByCountry';
import getCompaniesByGroup from '@salesforce/apex/AccountController.getCompaniesByGroup';
import getplantsBycompany from '@salesforce/apex/AccountController.getplantsBycompany';
import DisplaycompaniesonselectedGroup from '@salesforce/apex/AccountController.DisplaycompaniesonselectedGroup';
import getChildRecordsofselectedcompany from '@salesforce/apex/AccountController.getChildRecordsofselectedcompany';



import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import COUNTRY_FIELD from '@salesforce/schema/Account.Country__c';

export default class MyLWC extends LightningElement {
    selectedCountry = '';
    selectedGroup = '';
    selectedCompany = '';
    selectedplant = '';
    countryOptions = [];
    groupOptions = [];
    companyOptions = [];
    plantOptions = [];
    groupRecords=[];
    childRecords=[];
    showTabset=false;
    morebuttonclicked=false;

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountInfo;

    @wire(getPicklistValues, { recordTypeId: '$accountInfo.data.defaultRecordTypeId', fieldApiName: COUNTRY_FIELD })
    countryFieldInfo({ data, error }) {
        if (data) {
            this.countryOptions = data.values.map(option => ({
                label: option.label,
                value: option.value
            }));
        } else if (error) {
            console.error('Error retrieving picklist values for Country field:', error);
        }
    }
    get hasChildRecords() {
        return this.childRecords && this.childRecords.length > 0;
    }
    get hasNoChildRecords() {
        return !this.hasChildRecords;
    }

    handleCountryChange(event) {
        this.selectedCountry = event.detail.value;
        // Clear selectedGroup and selectedCompany when country changes
        this.selectedGroup = '';
        this.selectedCompany = '';
        this.selectedplant='';

        if (this.selectedCountry) {
            getGroupsByCountry({ country: this.selectedCountry })
                .then(result => {
                    this.groupOptions = result.map(groupName => ({
                        label: groupName,
                        value: groupName
                    }));
                })
                .catch(error => {
                    console.error('Error fetching groups:', error);
                });
        } else {
            console.warn('Please select a country before fetching groups.');
        }
    }

    handleGroupChange(event) {

        this.selectedGroup = event.detail.value;
        // Clear selectedCompany when group changes
        this.selectedCompany = '';
        this.selectedplant='';
        //Get companies by selected Group name
        if (this.selectedCountry && this.selectedGroup) {
            getCompaniesByGroup({ country: this.selectedCountry, groupName: this.selectedGroup })
                .then(result => {
                    this.companyOptions = result.map(companyName => ({
                        label: companyName,
                        value: companyName,
                        recordId:companyName.Id
                    }));
                })
                .catch(error => {
                    console.error('Error fetching companies:', error);
                });
        } else {
            console.warn('Please select a country and group before fetching companies.');
        }
    }

    handleGetGroups() {
        this.showTabset=true;
         if (this.selectedGroup) {

             
            DisplaycompaniesonselectedGroup({ selectedGroup: this.selectedGroup })
                .then(result => {
                    this.groupRecords = result;
                })
                .catch(error => {
                    console.error('Error fetching groups:', error);
                });
        } else {
            console.warn('Please select a name before fetching groups.');
        }
    }
    handleMoreClick(event) {
        this.morebuttonclicked=true;
        const recordId = event.target.dataset.recordId;
    
        if (recordId) {
            getChildRecordsofselectedcompany({ parentId: recordId })
                .then(result => {
                    // Handle the result, for example, update a property to hold child records
                    this.childRecords = result;
    
                    // Handle success (you can add your own logic)
                    console.log('Child records loaded successfully.');
                })
                .catch(error => {
                    console.error('Error fetching child records:', error);
    
                    // Handle error (you can add your own logic)
                    console.error('Error fetching child records.');
                });
        }
    }
    handleGoClick(event) {
        const recordId = event.target.dataset.recordId;
        if (recordId) {
           
           // window.location.href = '/' + recordId;
           window.open('/' + recordId, '_blank');
        }
    }
    
    

    handleGetCompanies() {
       
    }
    handleGetcountry(){

    }

    handleCompanyChange(event) {
        this.selectedCompany = event.detail.value;
        // Handle the selected company value as needed
        this.selectedplant='';
        //Get plant account records based on selected Company 
        if (this.selectedCountry && this.selectedCompany) {
            getplantsBycompany({ country: this.selectedCountry, CompanyName: this.selectedCompany })
                .then(result => {
                    this.plantOptions = result.map(plantName => ({
                        label: plantName,
                        value: plantName
                    }));
                })
                .catch(error => {
                    console.error('Error fetching plants:', error);
                });
        } else {
            console.warn('Please select a country and company before fetching plants.');
        }
    }

    handleGetplants() {
      
    }

    handleplantChange(event) {
        this.selectedplant = event.detail.value;
    }
}