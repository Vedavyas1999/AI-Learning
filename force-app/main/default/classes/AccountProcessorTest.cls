@isTest
private class AccountProcessorTest {
    @isTest
    private static void countContactsTest(){
        list<Account> accounts = new list<Account>();
        for(Integer i=0; i<=300;i++){
            accounts.add(new account(Name='Test Account'+i));
        }
        
        insert accounts;
        List<Contact> contacts=new List<contact>();
        List<id> accountids=new List<id>();
        for(Account acc:accounts){
            contacts.add(new contact(FirstName=acc.Name,LastName='Contact Test',Accountid=acc.id));
            accountids.add(acc.id);
        }
        insert contacts;
        Test.StartTest();
        AccountProcessor.countContacts(accountids);
        Test.StopTest();
    }
}