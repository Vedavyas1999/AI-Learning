public class UpdateOpportunityTestFieldHandler {
    public static void updateOpportunityTestField(List<Account> newAccounts) {
        Set<Id> accountIds = new Set<Id>();
        for (Account account : newAccounts) {
            accountIds.add(account.Id);
        }
        
        Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
        for (Contact contact : [SELECT Id, LastName, AccountId FROM Contact WHERE AccountId IN :accountIds Order BY LastName]) {
            if (!accountToContactMap.containsKey(contact.AccountId)) {
                
                accountToContactMap.put(contact.AccountId, contact);
            }
        }
        
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for (Opportunity opportunity : [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN :accountIds]) {
            Contact contact = accountToContactMap.get(opportunity.AccountId);
            if (contact != null) {
                opportunity.Test__c = contact.LastName;
                opportunitiesToUpdate.add(opportunity);
            }
        }
        
        update opportunitiesToUpdate;
    }
}