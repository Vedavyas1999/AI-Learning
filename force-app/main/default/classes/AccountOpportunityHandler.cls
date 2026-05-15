public with sharing class AccountOpportunityHandler {
    public static void updateAccountOpportunitySum(List<Opportunity> newOpportunities, List<Opportunity> oldOpportunities, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete) {
        Set<Id> accountIds = new Set<Id>();

        // Collect Account Ids affected by Opportunities
        for (Opportunity opp : (isInsert || isUpdate || isUndelete) ? newOpportunities : oldOpportunities) {
            accountIds.add(opp.AccountId);
        }

        // Calculate sum of Amount for each Account
        Map<Id, Decimal> accountAmountSumMap = new Map<Id, Decimal>();
        for (AggregateResult agg : [
            SELECT AccountId, SUM(Amount) totalAmount FROM Opportunity
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            accountAmountSumMap.put((Id)agg.get('AccountId'), (Decimal)agg.get('totalAmount'));
        }

        // Update Account fields based on the calculated sums
        List<Account> updateAccounts = new List<Account>();
        for (Id accountId : accountIds) {
            Account acc = new Account(Id = accountId, Annualrevenue = accountAmountSumMap.get(accountId));
            updateAccounts.add(acc);
        }

        // Update Accounts if there are changes
        if (!updateAccounts.isEmpty()) {
            update updateAccounts;
        }
    }
}