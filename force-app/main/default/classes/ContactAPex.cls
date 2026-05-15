/**
 * @description       : 
 * @author            : 
 * @group             : 
 * @last modified on  : 07-05-2023
 * @last modified by  : 
**/
public with sharing class ContactAPex {
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getcontacts() {
        try {
            List<Contact> conlist =[SELECT AccountId, Email, Is_Delete__c, LastName, Level__c, Name
            FROM Contact 
            WHERE AccountId != Null WITH User_Mode
            ORDER BY Name ASC NULLS FIRST
            LIMIT 10];

            return conlist;
        } 
        catch (Exception ex) {
            throw new AuraHandledException('exceptionText'+ex.getmessage()); 
        }

    }
    Public static contact createcon(string  name){
        try {
            Contact  con =new Contact();
            con.LastName= name;
            insert con;
            return con;
        } catch (Exception exe) {
            throw new AuraHandledException('exceptionText'+exe.getmessage()); 

        }
    }
}