trigger SendEmailOnContactCreation on Contact (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        EmailToContacts.sendEmailToContacts(Trigger.new);
        
        List<Id> contactIds = new List<Id>();
        for (Contact con : Trigger.new) {
            contactIds.add(con.Id);
        }
        
    }
}