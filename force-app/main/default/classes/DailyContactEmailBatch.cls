global class DailyContactEmailBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query contacts from the last day, where business unit is 'Carmeuse Systems' and email is null
        String query = 'SELECT Id, Name, OwnerId, Business_Unit__c, Email ' + 
                       'FROM Contact ' +
                       'WHERE CreatedDate = LAST_N_DAYS:1 ' +
                        
                       'AND Email = null';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        // Map to store owner id to contacts without email
        Map<Id, List<Contact>> ownerToContactsMap = new Map<Id, List<Contact>>();
        
        for (Contact c : scope) {
            if (!ownerToContactsMap.containsKey(c.OwnerId)) {
                ownerToContactsMap.put(c.OwnerId, new List<Contact>());
            }
            ownerToContactsMap.get(c.OwnerId).add(c);
        }

        // Send email to each owner
        for (Id ownerId : ownerToContactsMap.keySet()) {
            List<Contact> contacts = ownerToContactsMap.get(ownerId);
            if (!contacts.isEmpty()) {
                sendEmail(ownerId, contacts);
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        // This method is called after all batches are processed.
    }

    private void sendEmail(Id ownerId, List<Contact> contacts) {
        // Query the owner details
        User owner = [SELECT Id, Email FROM User WHERE Id = :ownerId LIMIT 1];

        if (owner != null && owner.Email != null) {
            // Prepare the email body
            String emailBody = 'The following contacts do not have an email address:\n\n';
            for (Contact c : contacts) {
                emailBody += 'Contact Name: ' + c.Name + '\n';
            }

            // Create email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { owner.Email });
            mail.setSubject('Contacts without email addresses');
            mail.setPlainTextBody(emailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    global void execute(SchedulableContext sc) {
        // Schedule the batch to run daily
        DailyContactEmailBatch batch = new DailyContactEmailBatch();
        Database.executeBatch(batch, 200); // Adjust batch size as needed
    }
}