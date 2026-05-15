import { LightningElement ,track} from 'lwc';

export default class Componentparent extends LightningElement {
    @track Message="vyas";
    handleChangeEvent(event){
          this.Message=event.target.value;
          console.log('Track'+this.Message);
        //this.template.querySelector('c-componentchild').Message(event.target.value);
    }
}