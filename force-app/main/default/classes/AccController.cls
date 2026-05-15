public with sharing class AccController {
    @AuraEnabled(cacheable=true)
    public static List<String> getGroupsByCountry(String country) {
        List<String> groupNames = new List<String>();
        
        // Query Group records based on selected country
        List<Account> groups = [SELECT Id, Name FROM Account WHERE Country__c = :country AND Type__c = 'Group'];

        for (Account grp : groups) {
            groupNames.add(grp.Name);
        }

        return groupNames;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getCompaniesByGroup(String country, String groupName) {
        List<String> companyNames = new List<String>();
        
        // Query child Companies related to the selected Group
        List<Account> companies = [SELECT Id, Name FROM Account WHERE Country__c = :country AND Parent.Name = :groupName];

        for (Account company : companies) {
            companyNames.add(company.Name);
        }

        return companyNames;
    }
      
}