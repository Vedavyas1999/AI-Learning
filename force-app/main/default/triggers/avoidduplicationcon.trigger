trigger avoidduplicationcon on Contact (before insert, before update) {
    Map<String, String> existingEmails = new Map<String, String>();
    Map<String, String> existingPhones = new Map<String, String>();
    
    List<Contact> conlist = [SELECT LastName, Email, Phone FROM Contact WHERE Email != null OR Phone != null];
    
    if (!conlist.isEmpty()) {
        for (Contact con : conlist) {
            existingEmails.put(con.Email, con.LastName);
            existingPhones.put(con.Phone, con.LastName);
        }
        
        for (Contact con : Trigger.new) {
           
        }
    }
}