public with sharing class AccountContactHandler {
    public static void onAfterUpdate(List<Account> newAccounts, Map<Id, Account> oldAccountMap, Map<Id, Account> newAccountMap) {
        List<Contact> updateCons = new List<Contact>();

        // Set to store unique Account Ids
        Set<Id> accountIds = new Set<Id>();

        for (Account updatedAcc : newAccounts) {
            Account oldAcc = oldAccountMap.get(updatedAcc.Id);

            // Check if Email__c is updated and not null or empty
            if (updatedAcc.Email__c != oldAcc.Email__c && 
                !String.isEmpty(updatedAcc.Email__c)) {
                accountIds.add(updatedAcc.Id);
            }
        }

        if (!accountIds.isEmpty()) {
            // Query contacts outside of the loop with the required fields
            List<Contact> conList = [SELECT Id, LastName, AccountId FROM Contact WHERE AccountId IN :accountIds];

            // Update contact email based on Account Email__c
            for (Contact con : conList) {
                con.Email = newAccountMap.get(con.AccountId).Email__c;
                updateCons.add(con);
            }

            // Update contacts if there are changes
            if (!updateCons.isEmpty()) {
                update updateCons;
            }
        }
    }
}