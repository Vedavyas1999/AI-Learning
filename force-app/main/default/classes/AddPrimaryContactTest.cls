@isTest
public class AddPrimaryContactTest {
    @isTest
    static void testAddPrimaryContact() {
        // Create 50 Account records with BillingState = 'NY'
        List<Account> accountsNY = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            Account acc = new Account(
                Name = 'Account NY ' + i,
                BillingState = 'NY'
            );
            accountsNY.add(acc);
        }
        insert accountsNY;

        // Create 50 Account records with BillingState = 'CA'
        List<Account> accountsCA = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            Account acc = new Account(
                Name = 'Account CA ' + i,
                BillingState = 'CA'
            );
            accountsCA.add(acc);
        }
        insert accountsCA;

        // Create a Contact record to be associated with the Accounts
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'johndoe@example.com'
        );

        // Create an instance of the AddPrimaryContact class and enqueue the job
        AddPrimaryContact job = new AddPrimaryContact(testContact, 'CA');
        System.enqueueJob(job);

        // Assert that a Contact record was inserted for each of the 50 Accounts with BillingState 'CA'
        List<Contact> insertedContacts = [SELECT Id FROM Contact WHERE Account.BillingState = 'CA'];
        System.assertEquals(50, insertedContacts.size(), 'Contact records should have been inserted for BillingState = CA.');
    }
}