/*******************************************************************************************
* @Name         Rest_Generic_service_Test 
* @Author       Evoke Technologies
* @Date          4/3/2023
* @Description  This class contains all service methods related to caching data in Salesforce.  
*				It is segregated as a service to make changing cache partition easy.
                Giving the code coverage of this class 'Rest_Generic_service' 
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              vedavyas chowdary       3/6/2023          Updated                                                      
*******************************************************************************************/

@isTest
private class Rest_Generic_service_Test {
 
    @testSetup
    static void setup() {
        list<account> insertList=new list<Account>();
        Account acc = new Account(Name='Test Account',Generic_External_Id__c='GenericIdacc',From_External_Update__c=true);
        insert acc;
        RestInsertAccountEdu.isFirstTime=true;
        

        
    }
    
    
    @isTest
    static void callRestInsertMethod(){
        
       Test.startTest();
        account acc=new account();
        acc.Name='edu satish';
        //acc.Generic_External_Id__c='0015i00000fE9xoAAC';
        String JsonMsg=JSON.serialize(acc);
        system.debug('JsonMsg : ' + JsonMsg);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/DemoUrl';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        Rest_Generic_service.createRecord();
     Test.stopTest();
    }
    
    @isTest
    static void testUpdateRecord() {
        // Set up test data
        Account acc = new Account(Name = 'Test Account',Generic_External_Id__c='0015i00000fE9xoAAC');
        insert acc;
        acc.Name = 'Updated Test Account';
        acc.Generic_External_Id__c=acc.id;
         String JsonMsg=JSON.serialize(acc);
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        // Set the request properties
        request.requestURI = '/services/apexrest/v3/generic/updateRecord';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf(JsonMsg);
        // Call the web service method
        RestContext.request = request;
        RestContext.response = response;
        Rest_Generic_service.updateRecord();
    }
    
    @isTest
    static void testDeleteRecord() {
        // Set up test data
        
        account delAcc=[SELECT id,name,Generic_External_Id__c,Generic_Id__c from Account limit 1];
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        delAcc.Name = 'Updated Test Account';
        delAcc.Generic_External_Id__c=acc.id;
         //String JsonMsg=JSON.serialize(acc);
         String JsonMsg=JSON.serialize(delAcc);
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        // Set the request properties
        request.requestURI = '/services/apexrest/v3/generic/updateRecord';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf(JsonMsg);
        //request.requestBody = Blob.valueOf('{"sobjectType" : "Account", "Id" : "' + acc.Id + '", "Name" : "Updated Test Account", "Generic_External_Id__c" : "' + acc.Id + '", "Generic_Id__c" : "' + acc.Id + '"}');
        
        // Call the web service method
        RestContext.request = request;
        RestContext.response = response;
        Rest_Generic_service.deleteRecord();
    }
    
}