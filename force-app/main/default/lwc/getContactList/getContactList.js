import { LightningElement ,wire} from 'lwc';
import getcontacts from "@salesforce/apex/ContactAPex.getcontacts";
export default class GetContactList extends LightningElement {
     @wire(getcontacts) ContactList
}