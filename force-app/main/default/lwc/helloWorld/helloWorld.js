import { LightningElement, wire } from 'lwc';
import getaccounts from '@salesforce/apex/testlwc.getaccounts';


const columns = [
    { label: 'Account Name', fieldName: 'Name', type: 'text', editable: false },
    { label: 'Id ', fieldName: 'Id', type: 'text', editable: false },
    {label: 'Industry', fieldName: 'Industry', type: 'text', editable: false },
    {label: 'AccountSource', fieldName: 'AccountSource', type: 'text', editable: false },
     
];

export default class AllQuotesDataTable extends LightningElement {
  accounts = [];
    

    @wire(getaccounts)
    wiredQuoteProducts({ data, error }) {
        if (data) {
            this.data = accounts;
        } else if (error) {
            console.error(error);
        }
    }
  }