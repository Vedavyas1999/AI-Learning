public class SendToWarehouse {
    public List<Opportunity> opplist1 { get; set; }
    public List<Opportunity> opplistWithSameContact { get; set; }

    public List<Opportunity> opplistWithoutSameContact { get; set; }
    
    public SendToWarehouse() {
        opplist1 = new List<Opportunity>();
        opplistWithSameContact = new List<Opportunity>();
        opplistWithoutSameContact = new List<Opportunity>();
        
        opplist1 = [SELECT Id, Name, Account.Name, CloseDate, StageName, Amount, Probability,
                    DeliveryInstallationStatus__c, Contact__c ,
                    Contact__r.MailingStreet, Contact__r.MailingCity, Contact__r.MailingState,
                    Contact__r.MailingPostalcode, Contact__r.MailingCountry, Contact__r.Email,
                    Owner.Name,Contact__r.LastName,Contact__r.Othercity,Contact__r.OtherState,Contact__r.OtherCountry,
                    Contact__r.OtherStreet,Contact__r.OtherPostalCode,Shipping_Address__c
                    FROM Opportunity
                    WHERE StageName = 'Closed Won' AND Contact__c!= Null 
                    ORDER BY Contact__c];
                    
        Map<Id, Integer> contactOpportunityCountMap = new Map<Id, Integer>();
        
        // Count the number of Opportunities for each Contact
        for (Opportunity opp : opplist1) {
            if (contactOpportunityCountMap.containsKey(opp.Contact__c)) {
                contactOpportunityCountMap.put(opp.Contact__c, contactOpportunityCountMap.get(opp.Contact__c) + 1);
            } else {
                contactOpportunityCountMap.put(opp.Contact__c, 1);
            }
        }
        
        // Separate Opportunities into lists based on whether they have the same Contact or not
        for (Opportunity opp : opplist1) {
            if (contactOpportunityCountMap.get(opp.Contact__c) > 1) {
                opplistWithSameContact.add(opp);
            } else {
                opplistWithoutSameContact.add(opp);
            }
        }
   }
}