import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CompanyEditPage extends LightningElement {
    @api selectedCompany;
    @api receivedRecordId;
    @api hasNoChildRecords;
    @api childRecords=[];
    @api hasChildRecords;

    get hasChildRecords() {
        return this.childRecords && this.childRecords.length > 0;
    }
    get hasNoChildRecords() {
        return !this.hasChildRecords;
    }

    handleSubmit(event) {
        console.log('onsubmit event recordEditForm', event.detail.fields);
    }

    handleSuccess(event) {
        console.log('onsuccess event recordEditForm', event.detail.id);

        // Show a success toast message
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record updated successfully',
                variant: 'success',
            })
        );
    }
}