public class ContactHandler {
    
    public static void handleAfterInsert(List<Contact> newContacts) {
        for (Contact con : newContacts) {
            if (con.IsPersonAccount) {
                System.debug('Created Person Account: ' + con.Name);
            } else {
                System.debug('Created standard Contact: ' + con.Name);
            }
        }
    }
    
    public static void handleAfterUpdate(List<Contact> newContacts, Map<Id, Contact> oldMap) {
        for (Contact con : newContacts) {
            Contact oldCon = oldMap.get(con.Id);
            if (con.IsPersonAccount) {
                System.debug('Updated Person Account: ' + con.Name);
            } else {
                System.debug('Updated standard Contact: ' + con.Name);
            }
        }
    }
}