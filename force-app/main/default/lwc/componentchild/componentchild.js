import { LightningElement,api } from 'lwc';

export default class Componentchild extends LightningElement {
    
    @api message="";

    modalclose(){
        this.dispatchEvent(new CustomEvent('close'))
    }
    }