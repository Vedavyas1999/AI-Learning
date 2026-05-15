import { LightningElement, api } from 'lwc';

export default class CampaignMembersList extends LightningElement {
    @api campaignId;

    get campaignFields() {
        return ['Name', 'StartDate', 'EndDate']; // Add more fields as needed for the Campaign
    }

    get campaignMemberFields() {
        return ['Contact.Name', 'Contact.Email', 'Status', 'Amount']; // Add more fields as needed for CampaignMember
    }
}