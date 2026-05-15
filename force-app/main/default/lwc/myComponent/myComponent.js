import { LightningElement } from 'lwc';

export default class MyComponent extends LightningElement {
    message = 'Hello, World!';

    constructor() {
        super();
        console.log('Constructor called');
        this.message = 'This is the constructor message';
    }

    connectedCallback() {
        console.log('Connected Callback called');
        // You can perform DOM manipulation or data initialization here
    }

    renderedCallback() {
        console.log('Rendered Callback called');
        // You can perform post-render DOM manipulation here
    }

    disconnectedCallback() {
        console.log('Disconnected Callback called');
        // You can clean up resources when the component is removed from the DOM
    }

    reconnectedCallback() {
        console.log('Reconnected Callback called');
        // Perform actions when the component is reinserted into the DOM
    }

    changeMessage() {
        this.message = 'New Message';
    }
}