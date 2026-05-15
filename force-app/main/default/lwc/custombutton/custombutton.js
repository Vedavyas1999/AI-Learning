import { LightningElement, api, track } from 'lwc';

export default class CustomButtonLWC extends LightningElement {
    @api recordId;
    @track buttonClass = 'slds-button_brand'; // Default to brand variant

    connectedCallback() {
        this.checkTimeFrame();
    }

    checkTimeFrame() {
        const currentTime = new Date();
        const startTime = new Date();
        const endTime = new Date();

        // Set start time to 6 AM
        startTime.setHours(6, 0, 0, 0);

        // Set end time to 4 PM
        endTime.setHours(16, 0, 0, 0);

        const isWithinTimeFrame = currentTime >= startTime && currentTime <= endTime;

        if (!isWithinTimeFrame) {
            this.buttonClass = 'slds-hide'; // Hide the button if not within the time frame
        }
    }

    handleButtonClick() {
        const flowName = 'Your_Flow_API_Name';

        const flowParams = [
            { name: 'recordId', type: 'String', value: this.recordId }
        ];

        this.dispatchEvent(
            new CustomEvent('launchflow', {
                detail: {
                    flowName,
                    flowParams
                }
            })
        );
    }
}