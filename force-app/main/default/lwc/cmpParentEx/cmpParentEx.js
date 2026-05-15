import { LightningElement } from 'lwc';

export default class CmpParentEx extends LightningElement {
     msg;
    handleCustomEvent(event) {
        const textVal = event.detail;
        this.msg = textVal;
    }
}