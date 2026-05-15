public with sharing class testlwc {
    @AuraEnabled(cacheable=true)
    public static List<accwrapper> getAccounts(String searchKey) {
        String searchQuery = 'SELECT Id, Name, AccountSource, Industry FROM Account';
        if (String.isNotBlank(searchKey)) {
            searchQuery += ' WHERE Name LIKE \'%' + searchKey + '%\'';
        }
        List<accwrapper> wrapperList = new List<accwrapper>();
        List<Account> accountList = Database.query(searchQuery);
        for (Account acc : accountList) {
            accwrapper awrp = new accwrapper();
            awrp.Id = acc.Id;
            awrp.Name = acc.Name;
            awrp.AccountSource = acc.AccountSource;
            awrp.Industry = acc.Industry;
            wrapperList.add(awrp);
        }
        return wrapperList;
    }

    public class accwrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String AccountSource;
        @AuraEnabled public String Industry;
    }
}