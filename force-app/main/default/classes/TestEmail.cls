public class TestEmail {
public static void sendLeadOverlapCompleteNotification(id recid) {
    // Fetch the Contact and Account related to the Overlap__c record
    Contact contact = [SELECT Id, Email, AccountId FROM Contact WHERE Id = :recid LIMIT 1];
    Account account = [SELECT Id FROM Account WHERE Id = :contact.AccountId LIMIT 1];

    if (contact != null && account != null) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        
        // Set the target object ID to the Contact ID
        //message.setTargetObjectId(contact.Id);
        
        // Set email display properties
        message.setSenderDisplayName('Company Support');
        message.setReplyTo('no-reply@company.com');
        message.setUseSignature(false);
        message.setBccSender(false);
        message.setSaveAsActivity(false);
        
        // Fetch the email template
        EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Test_Account_Alert_Email' LIMIT 1];
        
        // Set the email template ID
        message.setTemplateId(emailTemplate.Id);
        
        // Set the related Account ID
        message.setWhatId(account.Id);
        
        // Set the recipient email address
        message.setToAddresses(new String[] { contact.Email });
        
        // Send the email
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> { message };
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    } else {
        System.debug('No valid Contact or Account found for the given Overlap__c record.');
    }
}

}