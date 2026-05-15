import { LightningElement, api, wire, track } from 'lwc';
import getFieldsFromFieldSet from '@salesforce/apex/FieldsetAuraService.getFieldsFromFieldSet';

export default class CustomFieldset extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api fieldset;
    @track fields;

    @wire(getFieldsFromFieldSet, {fieldsetApiName: '$fieldset', sObjectApiName: '$objectApiName'})
    getFields({error, data}) {
        const objectApiName = this.objectApiName;
        if(Array.isArray(data)) {
            this.fields = data.map(fieldApiName => ({fieldApiName, objectApiName}));
        }
        else {
            console.log('error', JSON.stringify(error));
        }
    }

}