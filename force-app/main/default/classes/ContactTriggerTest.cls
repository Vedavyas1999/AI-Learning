@isTest
private class ContactTriggerTest {
    @isTest
    static void testPersonAccountTrigger() {
        // Enable Person Account creation
        Account acct = new Account(
            LastName = 'Test Person',
            PersonEmail ='ved@email.com',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()
        );
        insert acct;

        // Check trigger debug logs for behavior
        Test.startTest();
        acct.LastName = 'Updated Person';
        update acct;
        Test.stopTest();

        // Add asserts or validations if needed
        System.assertEquals('Updated Person', [SELECT LastName FROM Account WHERE Id = :acct.Id].LastName);
    }

    @isTest
    static void testStandardContactTrigger() {
        Account businessAcc = new Account(Name = 'Business Account');
        insert businessAcc;

        Contact con = new Contact(LastName = 'Business Contact', AccountId = businessAcc.Id);
        insert con;

        Test.startTest();
        con.LastName = 'Updated Contact';
        update con;
        Test.stopTest();

        System.assertEquals('Updated Contact', [SELECT LastName FROM Contact WHERE Id = :con.Id].LastName);
    }
}