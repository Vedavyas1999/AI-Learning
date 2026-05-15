import { LightningElement } from 'lwc';
export default class ParentNavBar extends LightningElement {

 handleTabChange(event) {
        const activeTabValue = event.detail.value;
        console.log('Active Tab Value:', activeTabValue);
 }
}