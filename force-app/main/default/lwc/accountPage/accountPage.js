// dependentPicklistAccount.js

import { LightningElement, wire, track } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import COUNTRY_FIELD from '@salesforce/schema/Account.Country__c';
import getRecordsByCountry from '@salesforce/apex/AccountController.getAccountsByCountry';

export default class DependentPicklistAccount extends LightningElement {
    @track countryOptions = [];
    @track selectedCountry;
    @track accountRecords = [];

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

    handleCountryChange(event) {
        this.selectedCountry = event.target.value;
        
    }

    handleGetRecords() {
        if (this.selectedCountry) {
            // Call  Apex method to fetch records selected country
            getRecordsByCountry({ country: this.selectedCountry })
                .then(result => {
                    this.accountRecords = result;
                })
                .catch(error => {
                    console.error('Error fetching records:', error);
                });
        } else {
            console.warn('Please select a country before fetching records.');
        }
    }
}