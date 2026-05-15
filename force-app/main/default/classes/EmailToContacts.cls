public with sharing class EmailToContacts {
  public static void sendEmailToContacts(List<Contact> newContacts) {
        Set<String> emailSet = new Set<String>();
      System.debug('Contacts Sizze'+newContacts.size());
        for(Contact con : newContacts){
            if(String.isNotBlank(con.Email)){
                emailSet.add(con.Email);
            }
        }

        // Create and send an email to each unique email
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        for(String emailAddress : emailSet){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //mail.setTemplateId('00X9D000001wTBBUA2');
            mail.setToAddresses(new String[] {emailAddress});
            mail.setSubject('Subject here');
            mail.setPlainTextBody('Body here');
            mailList.add(mail);
        }

 

        // Call the Salesforce email service
        Messaging.sendEmail(mailList);
    }
}