public with sharing class ObjectListController {
    
    @AuraEnabled(cacheable=true)
    public static List<String> getObjectList() {
        //getObjectList stores all the SObjects
        List<String> objectList = new List<String>();
        Map<String, Schema.SObjectType> objects = Schema.getGlobalDescribe();
        for (Schema.SObjectType obj : objects.values()) {
            if (obj.getDescribe().isAccessible() && obj.getDescribe().isQueryable()) {
                objectList.add(obj.getDescribe().getName());
            }
        }
        return objectList;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<User> getCustomLookupUser (String UName){
        //UName refers to  AllUsers(active&inactive)
        List<User> uLookupList =  new List<User>();
        if(UName != ''){
            String userName = '%' + UName + '%';
            uLookupList = [Select Id, Name From User Where Name like:userName];
            //return uLookupList;
        }
        return uLookupList;
    } 
    
    @AuraEnabled(cacheable=true)
    public static List<User> getCustomLookupUser1 (String UName1){
        //UName1 refers to  AllActiveUsers
        List<User> uLookupList1 =  new List<User>();
        if(UName1 != ''){
            String userName1 = '%' + UName1 + '%';
            uLookupList1 = [Select Id, Name From User Where Name like:userName1 AND IsActive =:true ];
            //return uLookupList1;
        }
        return uLookupList1;
    } 
    
    
    @future
    public static void transferOwnershipAsync(String oldOwnerId, String newOwnerId, List<String> objectNames) {
        List<sObject> recordsToUpdate = new List<sObject>();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        for (String objectName : objectNames) {
            Schema.SObjectType objectType = globalDescribe.get(objectName);
            if (objectType != null) {
                String query = 'SELECT Id, OwnerId FROM ' + objectName + ' WHERE OwnerId = :oldOwnerId';
                recordsToUpdate.addAll(Database.query(query));
            }
        }
        for (sObject record : recordsToUpdate) {
            record.put('OwnerId', newOwnerId);
        }
        update recordsToUpdate;
    }
    
    @AuraEnabled(cacheable=true)
    public static void transferOwnerships(String oldOwnerId, String newOwnerId, List<String> objectNames) {
        transferOwnershipAsync(oldOwnerId, newOwnerId, objectNames);
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getObjectRecordCounts(List<String> objectNames, String userId) {
        Map<String, Integer> recordCounts = new Map<String, Integer>();
        for (String objectName : objectNames) {
            String query = 'SELECT COUNT() FROM ' + objectName + ' WHERE OwnerId = \'' + userId + '\'';
            Integer count = Database.countQuery(query);
            recordCounts.put(objectName, count);
        }
        return recordCounts;
    }
}

/* @future
public static void transferOwnershipAsync(String oldOwnerId, String newOwnerId, List<String> objectNames) {
List<sObject> recordsToUpdate = new List<sObject>();
for (String objectName : objectNames) {
String query = 'SELECT Id, OwnerId FROM ' + objectName + ' WHERE OwnerId = \'' + oldOwnerId + '\'';
recordsToUpdate.addAll(Database.query(query));
}
for (sObject record : recordsToUpdate) {
record.put('OwnerId', newOwnerId);
}
update recordsToUpdate;
}*/ 




/* @AuraEnabled(cacheable=true)
public static List<Id> getObjectList1() {
List<Id> objectIdList = new List<Id>();
Map<String, Schema.SObjectType> objects = Schema.getGlobalDescribe();
for (Schema.SObjectType obj : objects.values()) {
if (obj.getDescribe().isAccessible() && obj.getDescribe().isQueryable()) {
objectIdList.add(obj.getDescribe().getKeyPrefix());
}
}
return objectIdList;
}

@AuraEnabled(cacheable=true)
public static List<Option> getUsers() {
List<User> users = [SELECT Id, Name FROM User ORDER BY Name ASC];
List<Option> options = new List<Option>();
for (User u : users) {
options.add(new Option(u.Id, u.Name));
}
return options;
}

@AuraEnabled(cacheable=true)
public static List<Option> getQueues() {
List<Group> queues = [SELECT Id, Name FROM Group WHERE Type = 'Queue' ORDER BY Name ASC];
List<Option> options = new List<Option>();
for (Group q : queues) {
options.add(new Option(q.Id, q.Name));
}
return options;
}

@AuraEnabled(cacheable=true)
public static List<Option> getPublicGroups() {
List<Group> publicGroups = [SELECT Id, Name FROM Group WHERE Type = 'Regular' ORDER BY Name ASC];
List<Option> options = new List<Option>();
for (Group pg : publicGroups) {
options.add(new Option(pg.Id, pg.Name));
}
return options;
}

public class Option {
@AuraEnabled
public String value;
@AuraEnabled
public String label;

public Option(String value, String label) {
this.value = value;
this.label = label;
}
}*/