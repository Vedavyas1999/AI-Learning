public class AttachmentTriggerHandler {
    public static void handleAttachmentCreation(List<Attachment> newAttachments) {
        List<Task> tasksToCreate = new List<Task>();
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Attachment attachment : newAttachments) {
            Task task = new Task();
            task.Subject = 'Review Attachment';
            task.WhatId = attachment.ParentId; // The parent record's ID
            task.OwnerId = [SELECT OwnerId FROM Attachment WHERE Id = :attachment.Id].OwnerId;
            task.ActivityDate = System.today().addDays(3); // Due date in three days
            tasksToCreate.add(task);

            // Send email with the attachment content as an attachment
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('New Attachment');
            email.setHtmlBody('Please review the attachment.');
            email.setToAddresses(new List<String>{task.OwnerId});
            email.setSaveAsActivity(false);

            // Attach the attachment content
            Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
            emailAttachment.setFileName(attachment.Name);
            emailAttachment.setBody(attachment.Body);

            email.setFileAttachments(new Messaging.EmailFileAttachment[]{emailAttachment});
            emailsToSend.add(email);
        }

        insert tasksToCreate;
        Messaging.sendEmail(emailsToSend);
    }

  public static void handleAttachmentDeletion(List<Attachment> deletedAttachments) {
        List<Messaging.SingleEmailMessage> deletionEmailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Attachment deletedAttachment : deletedAttachments) {
            Task task = [SELECT Id, WhatId, OwnerId FROM Task WHERE WhatId = :deletedAttachment.ParentId LIMIT 1];

            if (task != null) {
                // Send  deletion emi
                Messaging.SingleEmailMessage deletionEmail = new Messaging.SingleEmailMessage();
                deletionEmail.setSubject('Attachment Deleted');
                deletionEmail.setHtmlBody('An attachment has been deleted. Please take appropriate action.');
                deletionEmail.setToAddresses(new List<String>{task.OwnerId});
                deletionEmail.setSaveAsActivity(false);
                deletionEmailsToSend.add(deletionEmail);
            }
        }

        if (!deletionEmailsToSend.isEmpty()) {
            Messaging.sendEmail(deletionEmailsToSend);
        }
    }
}