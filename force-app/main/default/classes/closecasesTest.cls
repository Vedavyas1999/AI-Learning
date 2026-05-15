@isTest
public class closecasesTest {

    static testMethod void testCaseBatchClass() {
        // Create test data: a sample case that meets the criteria for batch execution
        Case testCase = new Case(
            Subject = 'Test Case',
            StageName__c = 'Open',
             OwnerId = UserInfo.getUserId()
        );
        insert testCase;

        // Set a valid email address for the owner
        User owner = [SELECT Email FROM User WHERE Id = :testCase.OwnerId LIMIT 1];
        owner.Email = 'test@example.com';
        update owner;

        // Start the batch job
        CaseBatchClass batch = new CaseBatchClass();
        Test.startTest();
        ID batchInstanceId = Database.executeBatch(batch);
        Test.stopTest();

        // Query the original case after the batch job completes
        Case closedCase = [SELECT Id, StageName__c FROM Case WHERE Id = :testCase.Id LIMIT 1];

        // Verify that the original case is now closed
        System.assertEquals('Closed', closedCase.StageName__c, 'Case should be closed after batch execution');

        // Query the new case and task created by the batch
        List<Case> newCases = [SELECT Id, Subject FROM Case WHERE Subject LIKE 'Test Case:%'];
        List<Task> newTasks = [SELECT Id, Subject, WhatId FROM Task WHERE WhatId IN :newCases];

        // Debug the number of new tasks created
        System.debug('Number of new tasks created: ' + newTasks.size());

        // Verify that a new case and task were created
        System.assertEquals(1, newCases.size(), 'One new case should be created');
        System.assertEquals(1, newTasks.size(), 'One new task should be created');

       

    }
}