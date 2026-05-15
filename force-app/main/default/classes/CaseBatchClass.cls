public class CaseBatchClass implements Database.Batchable<SObject>, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext context) {
        // Query cases more than 4 days Open Stage
        return Database.getQueryLocator([
            SELECT Id, Subject, Owner.Email
            FROM Case
            WHERE StageName__c = 'Open'
                AND createdDate <= LAST_N_DAYS:4
        ]);
    }

 public void execute(Database.BatchableContext context, List<Case> scope) {
    List<Case> casesToClose = new List<Case>();
    List<Case> newCasesToCreate = new List<Case>();
    List<Task> tasksToCreate = new List<Task>();
    List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

    for (Case closedCase : scope) {
        // Update Stage to Closed
        closedCase.StageName__c = 'Closed';
        casesToClose.add(closedCase);

        // Create new case
        Case newCase = new Case(
            Subject = 'New Case: ' + closedCase.Subject,
            Priority = 'High'
            
        );
        newCasesToCreate.add(newCase);

        // Create a task for the new case
        Task newTask = new Task(
            Subject = 'Task for New Case',
            Priority = 'High',
            WhatId = newCase.Id,
            OwnerId = closedCase.OwnerId
        );
        tasksToCreate.add(newTask);

        //  send an email to the case owner
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { closedCase.Owner.Email });
        email.setSubject('New Case and Task Created');
        email.setPlainTextBody('A new case and task have been created for the closed case with ID: ' + closedCase.Id);
        emailsToSend.add(email);
    }

    // Update  cases to 'Closed'
    update casesToClose;

    // Insert new cases and tasks
    insert newCasesToCreate;

    // Insert new tasks
    insert tasksToCreate;

    // Send emails
    Messaging.sendEmail(emailsToSend);
}

    public void finish(Database.BatchableContext context) {
        
    }
}