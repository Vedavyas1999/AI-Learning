public class RollUpSummaryHandler {
    public static void updateAccountContactCount(List<Contact> newContacts, Map<Id, Contact> oldContacts) {
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();

        // Collect the Account IDs from the new and old Contacts
        for (Contact con : newContacts) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }

        for (Contact con : oldContacts.values()) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }

        // Query for the related Accounts and their associated Contact count
        for (Account acc : [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accountIds]) {
            Account updatedAccount = new Account(Id = acc.Id);
            updatedAccount.No_of_Contacts__c = acc.Contacts.size();
            accountsToUpdate.put(updatedAccount.Id, updatedAccount);
        }

        // Update the Account records
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate.values();
        }
    }
}