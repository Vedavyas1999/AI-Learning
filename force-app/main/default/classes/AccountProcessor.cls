public without sharing class AccountProcessor  {
    @future(callout=true)
    public static void countContacts(List<Id> accountids) {
     List<account> acclist=[select  id,(select id from contacts)from Account where id =:accountids];
        for(Account acc:acclist){
            acc.Number_Of_Contacts__c=acc.contacts.size();
        }
        update acclist;
        
    }
}