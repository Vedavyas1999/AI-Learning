import { LightningElement, track } from 'lwc';
import createAccount from '@salesforce/apex/AccountController.createAccount';

export default class AccountForm extends LightningElement {
    @track accountName = '';
    website='';
    @track showToast = false;

    handleAccountChange(event) {
        this[event.target.name] = event.target.value;
    }

    createAccount() {
        createAccount({ accountName: this.accountName, website: this.website })
            .then(accountId => {
                console.log('Account created with Id:', accountId);
                this.showToast = true;

                // Reset the form fields after successful creation
                this.accountName = '';
                this.website = '';
            })
            .catch(error => {
                console.error('Error creating account:', error.body.message);
            });
    }
}