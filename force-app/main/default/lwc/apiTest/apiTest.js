import { LightningElement,api,track } from 'lwc';

export default class ApiTest extends LightningElement {
    @track message ='Track Property';
    @api message1 ='Api Message Property';

    handleChange(event){
        this.message1 =event.target.value;
        console.log('Update the Message '+this.message1);

    }

}