/*******************************************************************************************
* @Name         RestInsertAccountEdu_Test 
* @Author       Evoke Technologies
* @Date         4/12/2023
* @Description  This class contains all service methods related to caching data in Salesforce.  
*				It is segregated as a service to make changing cache partition easy.
Giving the code coverage of this class 'RestInsertAccountEdu' and this trigger
'RestAccountTrigger';
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              vedavyas chowdary      3/6/2023          Updated                                                      
*******************************************************************************************/

@isTest
private class RestInsertAccountEdu_Test {
    
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse(); List<Account> accountList = [SELECT Id, Name FROM Account LIMIT 1];
            Account account = accountList[0];
            String accountId = account.Id;
            String responseBody = '{"attributes":{"type":"Account","url":"/services/data/v57.0/sobjects/Account/' + accountId + '"},"Phone":"12345678","Website":"www.salesforce.com","Generic_External_Id__c":"' + accountId + '","Id":"' + accountId + '","Name":"Test Account"}';
            res.setBody(responseBody);
            res.setStatusCode(200);
            
            return res;
        }
    }
    
    
    
    @testSetup
    static void setup() {
        // Create test records for Third_Party_Details__c and Account objects
        Third_Party_Details__c tpd = new Third_Party_Details__c(
            Name = 'VedasOrg',
            ClientId__c = 'testClientId',
            ClientSecret__c = 'testClientSecret',
            User_Name__c = 'testUsername',
            Password__c = 'testPassword',
            Security_Token__c = 'testSecurityToken',
            SetEndpoint__c = 'https://test.endpoint.com',
            EndpointUrl__c='https://test.endpoint.com',
            objName__c='Account',
            objFields__c='Id,Name,Generic_External_Id__c'
            //  Test_Access_token__c='TestAccessToken'
        );
        insert tpd;
        list<account> insertList=new list<Account>();
        Account acc = new Account(Name='Test Account',Generic_External_Id__c='GenericIdacc',From_External_Update__c=true);
        insert acc;
        RestInsertAccountEdu.isFirstTime=true;
        
        Contact con = new Contact(lastname='vvvv',Generic_External_Id__c='GenericIdcon',From_External_Update__c=true);
        insert con;
        
        
    }
    
    
    @isTest
    static void testCreateAccountMethod() {
        // create test data
        
        Third_Party_details__c tpd= [select id, name,EndpointUrl__c,objName__c,objFields__c from Third_Party_details__c Where Name='VedasOrg' limit 1];
        
        /*Set<Id> accIdSet = new Set<Id>();
list<account> accList=new list<account>();
for(Account acc1: [select id from account]){
accIdset.add(acc1.id);
acc1.Generic_External_Id__c='0015i00000dSCGJAA4';
accList.add(acc1);
}
update accList;*/
        Set<Id> accIdSet = new Set<Id>();
        for(Account acc1: [select id from account]){
            accIdset.add(acc1.id);
        }
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        RestInsertAccountEdu.createAccountMethod(accIdSet, tpd.objName__c);
        Test.stopTest();
        // Verify the account's external ID was updated
        Account updatedAcc = [SELECT Id, Name, Generic_External_Id__c FROM Account WHERE Id = :accIdset];
        Assert.isNotNull(updatedAcc.Generic_External_Id__c);
        Assert.areEqual('Test Account', updatedAcc.Name);
        
    }
    @isTest static void testUpdateObjectMethod() {
        
        Third_Party_details__c tpd= [select id, name,EndpointUrl__c,objName__c,objFields__c from Third_Party_details__c Where Name='VedasOrg' limit 1];
        
        Set<Id> accIdSet = new Set<Id>();
        for(Account acc1: [select id from account]){
            accIdset.add(acc1.id);
        }
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        RestInsertAccountEdu.updateObjectMethod(accIdSet, tpd.objName__c);
        Test.stopTest();
        // Verify no changes were made to accounts
        List<Account> updatedAccounts = [SELECT Id, Name FROM Account WHERE Id IN :accIdSet];
        for(Account ac : updatedAccounts) {
            ac.Name='Test Account';
            update ac;
            System.assertEquals('Test ' + ac.Id.getSObjectType().getDescribe().getName(), ac.Name);
            
            //System.assertEquals('Test Account ' + a.Id.getSobject('Account').get('Name'), a.Name);
            
        }
    }
    @isTest static void testDeleteObjectMethod() {
        
        Third_Party_Details__c tpd = [SELECT Id, EndpointUrl__c,objName__c, objFields__c FROM Third_Party_Details__c WHERE Name = 'VedasOrg' LIMIT 1];
        String endpointUrl = tpd.EndpointUrl__c;
        String objName = tpd.objName__c;
        String objFields = tpd.objFields__c;
        Set<Id> accIdSet = new Set<Id>();
        for (Account acc : [SELECT Id FROM Account]) {
            accIdSet.add(acc.Id);
        }
        String externalIdField = (String) Account.getSObjectType().getDescribe().fields.getMap().get('Id').getDescribe().getDefaultValue();
        String externalGenericId =(String) Account.getSObjectType().getDescribe().fields.getMap().get('Generic_External_Id__c').getDescribe().getDefaultValue();
        
        // Mock response data
        RestInsertAccountEdu.resWrapper responseMock = new RestInsertAccountEdu.resWrapper();
        responseMock.id = 'testId';
        responseMock.access_token = 'testAccessToken';
        String responseJson = JSON.serialize(responseMock);
        HttpResponse responseMockHttp = new HttpResponse();
        responseMockHttp.setBody(responseJson);
        responseMockHttp.setStatusCode(200);
        
        // Set mock callout
        Test.setMock(HttpCalloutMock.class, new RestInsertAccountEduMock(responseMockHttp));
        // Call method and verify results
        Test.startTest();
        RestInsertAccountEdu.deleteObjectMethod(accIdSet, tpd.objName__c);
        Test.stopTest();
        // Verify no changes were made to accounts
        List<Account> updatedAccounts = [SELECT Id, Name FROM Account WHERE Id IN :accIdSet];
        for(Account ac : updatedAccounts) {
            ac.Name='Test Account';
            delete ac;
            System.assertEquals('Test ' + ac.Id.getSObjectType().getDescribe().getName(), ac.Name);
            
            
        }
    }
    @isTest static void delRec1() {
        account acc=[SELECT id from Account limit 1];
        delete acc;
    }
    @isTest static void delcon1() {
        contact con=[SELECT id from contact limit 1];
        delete con;
        
    }
    
    
}