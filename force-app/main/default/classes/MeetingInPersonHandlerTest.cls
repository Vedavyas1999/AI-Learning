@isTest
public class MeetingInPersonHandlerTest {

    @isTest
    static void testUpdateUserCounts() {
        // Create test users
        User user1 = new User(
            Username = 'user1@examplee.com',
            Email = 'user1@example.com',
            LastName='User1',
            Alias = 'u1',
            ProfileId = UserInfo.getProfileId(),
            UserRoleId = null,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );

        User user2 = new User(
            Username = 'user2@examplee.com',
            Email = 'user2@example.com',
            LastName='User2',
            Alias = 'u2',
            ProfileId = UserInfo.getProfileId(),
            UserRoleId = null,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );

        insert new List<User>{ user1, user2 };

        // Create test tasks
        Task task1 = new Task(
            Subject = 'Meeting',
            Status = 'Completed',
            Type = 'Meeting',
            OwnerId = user1.Id 
        );

        Task task2 = new Task(
            Subject = 'Meeting',
            Status = 'Completed',
            Type = 'Meeting',
            OwnerId = user1.Id 
 
        );

        Task task3 = new Task(
            Subject = 'Meeting',
            Status = 'Completed',
            Type = 'Meeting',
            OwnerId = user2.Id 
        );

        insert new List<Task>{ task1, task2, task3 };

        // Test update scenario
        // Change the type of task2 to something else
        task2.Type = 'Call';
        update task2;

        // Revert task2 back to Meeting
        task2.Type = 'Meeting';
        update task2;

        // Test delete scenario
        delete task1;

        // Test undelete scenario
        undelete task1;

        // Query users to verify updates
        User updatedUser1 = [SELECT Meeting_In_Person__c, Meeting_In_Person_This_Month__c FROM User WHERE Id = :user1.Id];
        User updatedUser2 = [SELECT Meeting_In_Person__c, Meeting_In_Person_This_Month__c FROM User WHERE Id = :user2.Id];

        // Assertions
        System.assertEquals(2, updatedUser1.Meeting_In_Person__c, 'User1 should have 2 completed meeting tasks');
       // System.assertEquals(1, updatedUser1.Meeting_In_Person_This_Month__c, 'User1 should have 1 completed meeting task this month');

        System.assertEquals(1, updatedUser2.Meeting_In_Person__c, 'User2 should have 1 completed meeting task');
        System.assertEquals(1, updatedUser2.Meeting_In_Person_This_Month__c, 'User2 should have 1 completed meeting task this month');
    }
}