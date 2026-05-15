trigger OpportunityEmailTrigger on Opportunity (after insert) {
    // List to hold email messages
    List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
    
    // Loop through the newly created opportunities
    for (Opportunity opp : Trigger.new) {
        if (opp.Custom_Email_Field__c != null) { // Make sure the email field is not empty
            // Create an email message
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{ opp.Custom_Email_Field__c }); // Set the recipient's email address
            email.setSubject('New Opportunity Created');
            email.setPlainTextBody('A new opportunity has been created with the following details:\n\nName: ' + opp.Name +
                                  '\nStage: ' + opp.StageName +
                                  '\nAmount: ' + opp.Amount +
                                  '\nClose Date: ' + opp.CloseDate);
            emailMessages.add(email);
        }
    }
    
    // Send the email messages
    if (!emailMessages.isEmpty()) {
        Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(emailMessages);
        for (Messaging.SendEmailResult result : sendResults) {
            if (!result.isSuccess()) {
                System.debug('Error sending email: ' + result.getErrors());
                // You can add additional error handling logic here if needed
            }
        }
    }
}