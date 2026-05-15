import { LightningElement ,api} from 'lwc';

import getChildRecordsofselectedcompany from '@salesforce/apex/CompitetorController.getChildRecordsofselectedcompany';

export default class LwctabsetCompitetor extends LightningElement {
    @api groupRecords;
    @api morebuttonclicked;
    @api hasChildRecords;
    @api childRecords=[];
    @api hasNoChildRecords;
    @api handleGoClick;
    @api selectedCompanyName;
    @api selectedGroupName;
    @api selectedCountry;
    @api receivedRecordId;
    @api selectedGroup;


    handleMoreClick(event) {
        this.morebuttonclicked=true;
        const recordId = event.target.dataset.recordId;
    
        if (recordId) {
            getChildRecordsofselectedcompany({ parentId: recordId })
                .then(result => {
                    
                    this.childRecords = result;
                    
                })
                .catch(error => {
                    console.error('Error fetching child records:', error);
     
                });
        }
    }
    get hasChildRecords() {
        return this.childRecords && this.childRecords.length > 0;
    }
    get hasNoChildRecords() {
        return !this.hasChildRecords;
    }
    handleChildGoClick(event) {
        const recordId = event.target.dataset.recordId;
        console.log('handleChildGoClick called'+recordId);
        // Dispatch a custom event to notify the parent to hide/show components
         const recordIdEvent = new CustomEvent('childgoevent', {
        detail: { recordId }
    });

    this.dispatchEvent(recordIdEvent);
       // this.dispatchEvent(new CustomEvent('childgoevent'));
    }
   
}