import { LightningElement } from 'lwc';

export default class FlowLaunchComponent extends LightningElement {
    handleFlowLaunch(event) {
        const { flowName, flowParams } = event.detail;

        this.template.querySelector('lightning-flow').startFlow(flowName, flowParams);
    }
}