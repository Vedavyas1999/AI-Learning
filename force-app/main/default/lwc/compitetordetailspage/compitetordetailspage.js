import { LightningElement, wire,track,api } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import getGroupsByCountry from '@salesforce/apex/CompitetorController.getGroupsByCountry';
import getCompaniesByGroup from '@salesforce/apex/CompitetorController.getCompaniesByGroup';
import getplantsBycompany from '@salesforce/apex/CompitetorController.getplantsBycompany';
import DisplaycompaniesonselectedGroup from '@salesforce/apex/CompitetorController.DisplaycompaniesonselectedGroup';
import Compitetor_OBJECT from '@salesforce/schema/Competitor__c';
import COUNTRY_FIELD from '@salesforce/schema/Competitor__c.Country__c';

export default class MyLWC extends LightningElement {
    selectedCountry = '';
    selectedGroup = '';
    selectedGroupName='';
    selectedCompany = '';
    selectedCompanyName='';
    selectedplant = '';
    selectedplantName='';
    countryOptions = [];
    groupOptions = [];
    companyOptions = [];
    plantOptions = [];
    groupRecords=[];
    childRecords=[];
    @api receivedRecordId;
   @track showTabsetgroup=false;
   @track showTabsetCompany=false;
    morebuttonclicked=false;
    hidecurrentcomponent=false;

    @wire(getObjectInfo, { objectApiName: Compitetor_OBJECT })
    compitetorInfo;

    @wire(getPicklistValues, { recordTypeId: '$compitetorInfo.data.defaultRecordTypeId', fieldApiName: COUNTRY_FIELD })
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
 

    handleCountryChange(event) {
        
        this.selectedCountry = event.detail.value;
         this.selectedGroup = '';
        this.selectedCompany = '';
        this.selectedplant='';

        if (this.selectedCountry) {
            getGroupsByCountry({ country: this.selectedCountry })
                .then(result => {
                    this.groupOptions = result.map(group => ({
                        label: group.Name,
                        value: group.Id
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
       // this.selectedGroupName = event.detail.label;
         this.selectedCompany = '';
        this.selectedplant='';

        // selected value
    const selectedValue = event.detail.value;

    // Find the corresponding option in the groupOptions array
    const selectedOption = this.groupOptions.find(option => option.value === selectedValue);

    // Update the selectedGroupValue with the selected value
    this.selectedGroup = selectedValue;

    // Update the selectedGroupLabel with the label of the selected option
    this.selectedGroupName = selectedOption ? selectedOption.label : '';
    console.log('group name '+ this.selectedGroupName);
         if (this.selectedCountry && this.selectedGroup) {
            getCompaniesByGroup({ country: this.selectedCountry, groupName: this.selectedGroup })
                .then(result => {
                    this.companyOptions = result.map(company => ({
                        label: company.Name,
                        value: company.Id
                        
                    }));
                })
                .catch(error => {
                    console.error('Error fetching companies:', error);
                });
        } else {
            console.warn('Please select a country and group before fetching companies.');
        }
    }
    handleCompanyChange(event) {
        this.selectedCompany = event.detail.value;
         this.selectedplant='';
          // selected value
    const selectedValue = event.detail.value;

    // Find the corresponding option in the companyOptions array
    const selectedOption = this.companyOptions.find(option => option.value === selectedValue);

    // Update the selectedcompanyValue with the selected value
    this.selectedCompany = selectedValue;

    // Update the selectedcompanyLabel with the label of the selected option
    this.selectedCompanyName = selectedOption ? selectedOption.label : '';
    console.log('company name '+ this.selectedCompanyName);

         if (this.selectedCountry && this.selectedCompany) {
            getplantsBycompany({ country: this.selectedCountry, CompanyName: this.selectedCompany })
                .then(result => {
                    this.plantOptions = result.map(plant=> ({
                        label: plant.Name,
                        value: plant.Id
                    }));
                })
                .catch(error => {
                    console.error('Error fetching plants:', error);
                });
        } else {
            console.warn('Please select a country and company before fetching plants.');
        }
    }

    handleGetGroups() {
        this.showTabsetgroup=true;
        this.showTabsetCompany=false;
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
   
    handleValuesFromChild(){

    }
    

    handleGetCompanies() {
        this.showTabsetgroup=false;
        this.showTabsetCompany=true;
       
    }
    handleChildGoEvent(event) {
             
            
    
            this.showTabsetgroup = !this.showTabsetgroup;
            this.showTabsetCompany = !this.showTabsetCompany;
    
            this.receivedRecordId = event.detail.recordId;
            console.log('Received recordId in parent:', this.receivedRecordId);
   
    }
    handleGetcountry(){

    }

    

    handleGetplants() {
      
    }

    handleplantChange(event) {
        this.selectedplant = event.detail.value;
    }
}