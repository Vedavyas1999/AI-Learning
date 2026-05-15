public with sharing class CampaignMembersController {
    @AuraEnabled(cacheable=true)
    public static List<CampaignMember> getCampaignMembers(String campaignId) {
        return [SELECT Id, ContactId, Contact.Name, Contact.Email
                FROM CampaignMember
                WHERE CampaignId = :campaignId];
    }
}