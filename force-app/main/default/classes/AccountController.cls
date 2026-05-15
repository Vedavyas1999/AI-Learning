// AccountController.cls
public with sharing class AccountController {
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

    @AuraEnabled(cacheable=true)
    public static List<String> getplantsBycompany(String country, String CompanyName) {
        List<String> plantNames = new List<String>();
        
        // Query child Companies related to the selected Group
        List<Account> plants = [SELECT Id, Name FROM Account WHERE Country__c = :country AND Parent.Name = :CompanyName];

        for (Account plant : plants) {
            plantNames.add(plant.Name);
        }

        return plantNames;
    }
    @AuraEnabled(cacheable=true)
    public static List<Account> DisplaycompaniesonselectedGroup(String selectedGroup) {
        system.debug('selected Group Name '+selectedGroup);
        return [SELECT Id, Name, Country__c FROM Account WHERE Type__c = 'Company' AND Parent.Name = :selectedGroup];
    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getChildRecordsofselectedcompany(String parentId) {
        return [SELECT Id, Name,Parent.Name, Country__c FROM Account WHERE ParentId = :parentId];
    }
}