public with sharing class OpportunityCloner {
    @Auraenabled
    public static Opportunity cloneOpportunity(Id opportunityId) {
        // Retrieve the original opportunity
        Opportunity originalOpportunity = [SELECT Name, StageName, CloseDate, Amount, 
                                                  AccountId, OwnerId, Type, LeadSource,
                                                  Pricebook2Id, CampaignId, 
                                                  Description, Probability, NextStep, 
                                                  ForecastCategory, ForecastCategoryName
                                           FROM Opportunity
                                           WHERE Id = :opportunityId];

        // Clone the opportunity
        Opportunity clonedOpportunity = originalOpportunity.clone(false, true, false, false);

        // Insert the cloned opportunity
        insert clonedOpportunity;

        return clonedOpportunity;
    }
}