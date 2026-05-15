trigger AttachmentTrigger on Attachment (after insert, before delete) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AttachmentTriggerHandler.handleAttachmentCreation(Trigger.new);
    } else if (Trigger.isBefore && Trigger.isDelete) {
        AttachmentTriggerHandler.handleAttachmentDeletion(Trigger.old);
    }
}