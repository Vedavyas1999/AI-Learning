public class AddPrimaryContact implements Queueable {
    private Contact contact;
    private String billingStateAbbreviation;

    public AddPrimaryContact(Contact contact, String billingStateAbbreviation) {
        this.contact = contact;
        this.billingStateAbbreviation = billingStateAbbreviation;
    }

    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id FROM Account WHERE BillingState = :billingStateAbbreviation LIMIT 200];

        List<Contact> contactList = new List<Contact>();
        for (Account acc : accounts) {
            // Clone the Contact record and associate it with the Account
            Contact newContact = contact.clone(false, true);
            newContact.AccountId = acc.Id;
            contactList.add(newContact);
        }

        if (!contactList.isEmpty()) {
            insert contactList;
        }
    }
}