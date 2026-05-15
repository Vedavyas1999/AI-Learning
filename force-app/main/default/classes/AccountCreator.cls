public class AccountCreator {
    public static Account createAccount(String accountName) {
        // Create new Account instance
        Account newAccount = new Account();
        newAccount.Name = accountName;
        
        try {
            insert newAccount;
            System.debug('Account created successfully with Id: ' + newAccount.Id);
            return newAccount;
        } catch(DmlException e) {
            System.debug('Error creating account: ' + e.getMessage());
            throw e;
        }
    }
}