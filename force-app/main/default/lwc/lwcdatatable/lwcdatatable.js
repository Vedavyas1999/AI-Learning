import { LightningElement,wire } from 'lwc';
import lwchandlerm from '@salesforce/apex/lwchandler.lwchandlerm';

const columns =[
    {label: 'Account Name', fieldName: 'Name' },
    {label:'Account Rating',fieldName: 'Rating'},
    {label:'Phone',fieldName:'Phone'},
    {label:'Industry',fieldName:'Industry'},
];

export default class Lwcdatatable extends LightningElement {
  
 columns =columns;
 accounts=[];
 @wire(lwchandlerm)
    wiredaccounts({error,data}){
        
           
      
           
         if(error){
            console.log(error+'error');
        }
        else if(data){
            this.accounts=data;

        }

    }
    
 
}