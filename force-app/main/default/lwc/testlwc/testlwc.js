import { LightningElement, track, wire } from 'lwc';
import getaccounts from '@salesforce/apex/testlwc.getAccounts';

   
const ACCOUNT_FIELDS = [
  { fieldName: 'Name', label: 'Account Name' },
  { fieldName: 'Type', label: 'Account Type' },
  { fieldName: 'Industry', label: 'Industry' },
  { fieldName: 'Phone', label: 'Phone' },
  { fieldName: 'Website', label: 'Website', type: 'url' }
];

export default class AccountList extends LightningElement {
  accountData = [];
  accountColumns = ACCOUNT_FIELDS;
 
  @wire(getaccounts)
  wiredAccountData({ error, data }) {
    if (data) {
      this.accountData = data;
    } else if (error) {
      console.error(error);
    }
  }

  handleRowSelection(event) {
    const selectedRows = event.detail.selectedRows;
    console.log('Selected Rows:', selectedRows);
  }
}