@isTest
private class ObjectListControllerTest {
    
    @testSetup
    static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User
            (Alias = 'testu1', 
             Email='testuser1@testorg.com', 
             EmailEncodingKey='UTF-8', 
             LastName='Testing', 
             LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US',
             TimeZoneSidKey='America/Los_Angeles',
             UserName='testuser1@testorg.com', 
             ProfileId = p.Id, 
             IsActive = true);
        insert u;
        
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<10; i++) {
            Account a = new Account(Name='Test Account ' + i, OwnerId=Userinfo.getUserId());
            accounts.add(a);
        }
        insert accounts;
        
    }
    
    @isTest
    static void testGetObjectList() {
        Test.startTest();
        List<String> objectList = ObjectListController.getObjectList();
        Test.stopTest();
        System.assertEquals(true, objectList.size()>0, 'Object list is not returned.');
    }
    
    @isTest
    static void testGetCustomLookupUser() {
        Test.startTest();
        List<User> userList = ObjectListController.getCustomLookupUser('Test');
        Test.stopTest();
        System.assertEquals(true, userList.size()==1, 'User list is not returned.');
    }
    
    @isTest
    static void testGetCustomLookupUser1() {
        Test.startTest();
        List<User> userList = ObjectListController.getCustomLookupUser1('Test');
        Test.stopTest();
        System.assertEquals(true, userList.size()==1, 'User list is not returned.');
    }
    
    @isTest
    static void testGetObjectRecordCounts() {
        Test.startTest();
        List<String> objectNames = new List<String>{'Account', 'Contact'};
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'testu2',
                          Email='testuser2@testorg.com', 
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', 
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='testuser2@testorg.com', 
                          ProfileId = p.Id, IsActive = true);
        insert u;
        Map<String, Integer> recordCounts = ObjectListController.getObjectRecordCounts(objectNames, u.Id);
        Test.stopTest();
        System.assertEquals(0, recordCounts.get('Account'), 'Account record count is not 0.');
        System.assertEquals(0, recordCounts.get('Contact'), 'Contact record count is not 0.');
    }
    
    @isTest
    static void testTransferOwnershipAsync() {
        // Set up test data
        String oldOwnerId = UserInfo.getUserId();
        User newOwner = new User(Alias='newuser', 
                                 Email='newuser@testorg.com', 
                                 EmailEncodingKey='UTF-8',
                                 LastName='Testing', 
                                 LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', 
                                 ProfileId = UserInfo.getProfileId(),
                                 TimeZoneSidKey='America/Los_Angeles',
                                 UserName='newuser@testorg.com');
        insert newOwner;
        String newOwnerId = newOwner.Id;
        List<String> objectNames = new List<String>{'Account'};
            
            // Call the method being tested
            Test.startTest();
        ObjectListController.transferOwnershipAsync(oldOwnerId, newOwnerId, objectNames);
        Test.stopTest();
        
        // Verify the results
        List<Account> accounts = [SELECT Id, OwnerId FROM Account WHERE OwnerId = :newOwnerId];
        System.assertEquals(10, accounts.size(), 'All accounts should have been transferred to the new owner');
    }
    
    @isTest
    static void testTransferOwnerships() {
        // Set up test data
        String oldOwnerId = UserInfo.getUserId();
        User newOwner = new User(Alias='newuser', 
                                 Email='newuser@testorg.com', 
                                 EmailEncodingKey='UTF-8',
                                 LastName='Testing', 
                                 LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US',
                                 ProfileId = UserInfo.getProfileId(),
                                 TimeZoneSidKey='America/Los_Angeles',
                                 UserName='newuser@testorg.com');
        insert newOwner;
        String newOwnerId = newOwner.Id;
        List<String> objectNames = new List<String>{'Account'};
            
        // Call the method being tested
        Test.startTest();
        ObjectListController.transferOwnerships(oldOwnerId, newOwnerId, objectNames);
        Test.stopTest();
        
        // Verify the results
        List<Account> accounts = [SELECT Id, OwnerId FROM Account WHERE OwnerId = :newOwnerId];
        System.assertEquals(10, accounts.size(), 'All accounts should have been transferred to the new owner');
    }
}


/*@isTest
public class ObjectListController_Test {

@IsTest
static void testGetObjectList() {
// Test getObjectList method
Test.startTest();
List<String> objectList = ObjectListController.getObjectList();
Test.stopTest();

// Validate results
System.assert(objectList.contains('Account'));
System.assert(objectList.contains('Contact'));
System.assert(objectList.contains('Opportunity'));
}

@IsTest
static void testGetCustomLookupUser() {
// Create test data
User testUser = new User(
FirstName = 'Test',
LastName = 'User',
Email = 'testuser@example.com',
Username = 'testuser1@example.com',
Alias = 'testuser',
TimeZoneSidKey = 'America/Los_Angeles',
LocaleSidKey = 'en_US',
EmailEncodingKey = 'UTF-8',
LanguageLocaleKey = 'en_US',
ProfileId = UserInfo.getProfileId()
);
insert testUser;

// Test getCustomLookupUser method
Test.startTest();
List<User> userList = ObjectListController.getCustomLookupUser('Test');
Test.stopTest();

// Validate results
System.assertEquals(1, userList.size());
System.assertEquals('Test User', userList[0].Name);
}
}*/