public class AccountHierarchyHandler {
    public static List<Account> getChildAccounts(String grandparentId) {
        List<Account> childAccounts = new List<Account>();

        // Step 1: Get Parent Account IDs related to the Grandparent Account
        List<Account> parentAccounts = [SELECT Id FROM Account WHERE ParentId = :grandparentId];

        // Step 2: Get Child Account records for each Parent Account
        for (Account parentAccount : parentAccounts) {
            List<Account> childAccountsForParent = [SELECT Id, Name FROM Account WHERE ParentId = :parentAccount.Id];
            childAccounts.addAll(childAccountsForParent);
        }

        return childAccounts;
    }
}