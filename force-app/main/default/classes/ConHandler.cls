public class ConHandler  {
    private static Map<String, String> existingEmails = new Map<String, String>();
    private static Map<String, String> existingPhoneNumbers = new Map<String, String>();

    public static void handleDuplicate(List<Contact> cons) {
        if (existingEmails.isEmpty() || existingPhoneNumbers.isEmpty()) {
            // Only query the existing contacts once
            List<Contact> conList = [SELECT Email, Phone, Name FROM Contact];
            for (Contact con : conList) {
                existingEmails.put(con.Email, con.Name);
                existingPhoneNumbers.put(con.Phone, con.Name);
            }
        }

        for (Contact con : cons) {
            if (existingEmails.containsKey(con.Email)) {
                con.addError('Cannot create a contact with a duplicate email. An existing contact with the same email: ' + existingEmails.get(con.Name));
            }
            if (existingPhoneNumbers.containsKey(con.Phone)) {
                con.addError('Cannot create a contact with a duplicate phone number. An existing contact with the same phone number: ' + existingPhoneNumbers.get(con.Name));
            }
        }
    }
}