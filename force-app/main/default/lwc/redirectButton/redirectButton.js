import { LightningElement, api } from 'lwc';

export default class RedirectButton extends LightningElement {
    @api recordId;

    handleRedirect() {
        if (this.recordId) {
            const redirectURL = `/lightning/r/Account/${this.recordId}/view`;
            const redirectWindowName = 'RedirectWindow';
            
            const redirectWindow = window.open(redirectURL, redirectWindowName);
            
            if (!redirectWindow || redirectWindow.closed) {
                window.location.href = redirectURL;
            }
        }
    }
}