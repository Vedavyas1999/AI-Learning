/*******************************************************************************************
* @Name         RestinsertAccountEdu 
* @Author       Evoke Technologies
* @Date         2/28/2023
* @Description  This class contains all service methods related to caching data in Salesforce.  
*				integrate one org to other org, If record Inseted, updated, or deleted in one org
then same action is performed in the other org.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              vedavyas chowdary      4/11/2023          Updated                                                      
*******************************************************************************************/

public class RestinsertAccountEdu { 
    public static Boolean isFirstTime = true;
    
    /**************************************************************************************
* @Description  This class stores Variables/initilaze variables
* @Param		Null
* @Return       Null 
**************************************************************************************/
    public class resWrapper
    {
        public String id;
        public String access_token;
    }
    
    /**************************************************************************************
* @Description  This class stores Variables
* @Param		Null
* @Return       Null 
**************************************************************************************/ 
    public class deserializeResponse
    {
        public String id;
        public String access_token;
    }
    
    /**************************************************************************************
* @Description  This method gets checks for entries in org cache and returns access_token
* @Param		class - RestinsertAccountEdu, string - orgName
* @Return       string access_token 
**************************************************************************************/   
    public String getRequestToken(RestinsertAccountEdu accnt,String orgName){ 
        Third_Party_Details__c tpd = [SELECT ClientId__c, ClientSecret__c, Password__c, User_Name__c,
                                      Security_Token__c, setEndpoint__c, EndpointUrl__c,Test_Access_token__c 
                                      FROM Third_Party_Details__c WHERE name = : orgName];
        String clientId =tpd.ClientId__c ;
        String clientSecret = tpd.ClientSecret__c;
        String username = tpd.User_Name__c;
        String password = tpd.Password__c+tpd.Security_Token__c;
        String setEndpoint = tpd.setEndpoint__c;
        String TestAccessToken = tpd.Test_Access_token__c;
        
        String reqbody = 'grant_type=password'+'&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
        Http h1 = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint(setEndpoint);
        HttpResponse res = h1.send(req);      
        
        System.debug('response orig--->>>'+res);
        resWrapper response = (resWrapper)JSON.deserialize(res.getBody(),resWrapper.class);
        if(Test.isRunningTest())
        {
            response.access_token='abcd';
        }
        System.debug('response--->>>'+response);
        
        return response.access_token;
    }
    
    /**************************************************************************************
* @Description  This is future method gets checks for entries in org cache and update records
* @Param		Set<Id> - accIdSet, string - csName
* @Return       void
**************************************************************************************/ 
    @future(callout=true)
    public static void createAccountMethod(Set<id> accIdSet,string csName){
        isFirstTime = false;
        Third_Party_Details__c tpd = [SELECT EndpointUrl__c,objName__c, objFields__c,Name 
                                      FROM Third_Party_Details__c WHERE objName__c =:csName];
        string EndpointUrl =tpd.EndpointUrl__c;
        String objName = tpd.objName__c;
        String objFields = tpd.objFields__c;
        String Name =tpd.Name;
        
        system.debug('acidset'+accIdSet);
        String idsString = String.join(new List<Id>(accIdSet), '\',\'');
        RestinsertAccountEdu accnt = new RestinsertAccountEdu();
        String accessToken;
        String JSNBody;
        accessToken = accnt.getRequestToken(accnt,Name);
        List<sObject> sobj = new List<sObject>();
        if(accessToken != null) {
            
            String query = 'SELECT '+ objFields +' FROM ' + objName + ' WHERE Id IN (\'' + idsString + '\')';
            system.debug('Query'+query);
            
            String endPoint = EndpointUrl;  
            For(sObject record : Database.query(query)){
                sobj.add(record);
                system.debug('records'+record);                
                JSNBody = JSON.serialize(record.clone(false));	
                Http h2 = new Http();
                HttpRequest req1 = new HttpRequest();
                req1.setHeader('Authorization','Bearer ' + accessToken);
                req1.setHeader('Content-Type','application/json');
                req1.setHeader('accept','application/json');
                req1.setMethod('POST');
                req1.setBody(JSNBody);
                System.debug('body--->>'+JSNBody);
                req1.setEndpoint(endPoint);
                HttpResponse res1 = h2.send(req1);
                System.debug('Response one--->>'+res1);
                System.debug('res body--->>'+res1.getBody());
                String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
                System.debug('Trimmed one--->>'+trimmedResponse);
                sobject obj12;
                obj12 = (sobject)JSON.deserialize(trimmedResponse, sobject.class);
                System.debug('Log2'+obj12);
                String externalIdField = (String)obj12.get('Id');
                String externalGenericId = (String)obj12.get('Generic_External_Id__c');
                System.debug('Extv'+externalIdField);
                obj12.put('Id',externalGenericId );
                obj12.put('Generic_External_Id__c',externalIdField );
                update obj12;
                
                
            }
        }
        
    }
    
    /**************************************************************************************
* @Description  This is future method gets checks for entries in org cache and put request to other org
* @Param		Set<Id> - accIdSet, string - csName
* @Return       void
**************************************************************************************/ 
    @future(callout=true)
    public static void updateObjectMethod(Set<Id> accIdSet, String csName){
        isFirstTime = false;
        String idExternal;
        Third_Party_Details__c tpd = [SELECT EndpointUrl__c, objName__c, objFields__c, Name FROM Third_Party_Details__c WHERE objName__c =:csName];
        String endpointUrl = tpd.EndpointUrl__c;
        String objName = tpd.objName__c;
        String objFields = tpd.objFields__c;
        String name = tpd.Name;
        System.debug('accIdSet'+accIdSet);
        String idsString = String.join(new List<Id>(accIdSet), '\',\'');
        RestinsertAccountEdu accnt = new RestinsertAccountEdu();
        String accessToken = accnt.getRequestToken(accnt, name);
        List<sObject> sobj = new List<sObject>();
        if (accessToken != null) {
            String query = 'SELECT '+ objFields +' FROM ' + objName + ' WHERE Id IN (\'' + idsString + '\')';
            System.debug('query'+query);
            String endPoint = endpointUrl;
            For(sObject record : Database.query(query)){
                sobj.add(record);
                System.debug('record=='+record);
                idExternal=(string)record.get('Generic_External_Id__c');
                System.debug('query==='+idExternal);
                String jsnBody = JSON.serialize(record);
                Http h2 = new Http();
                HttpRequest req1 = new HttpRequest();
                req1.setHeader('Authorization', 'Bearer ' + accessToken);
                req1.setHeader('Content-Type', 'application/json');
                req1.setHeader('accept', 'application/json');
                req1.setMethod('PUT');
                req1.setBody(jsnBody);
                String idString = idExternal.substring(idExternal.lastIndexOf('/') + 1);
                
                System.debug('body--->>'+jsnBody);
                req1.setEndpoint(endPoint + idString);
                HttpResponse res1 = h2.send(req1);
                System.debug('response--->>'+res1);
            }
        }
    }
    
    /**************************************************************************************
* @Description  This is future method gets checks for entries in org cache and Delete record from one org record to other org
* @Param		Set<Id> - accIdSet, string - csName
* @Return       void
**************************************************************************************/ 
    @future(callout=true)
    public static void deleteObjectMethod(Set<Id> accIdSet, String csName){
        isFirstTime = false;
        Third_Party_Details__c tpd = [SELECT EndpointUrl__c, objName__c, objFields__c, Name FROM Third_Party_Details__c WHERE objName__c =:csName];
        String endpointUrl = tpd.EndpointUrl__c;
        String objName = tpd.objName__c;
        String objFields = tpd.objFields__c;
        String name = tpd.Name;
        System.debug('accIdSet'+accIdSet);
        String idsString = String.join(new List<Id>(accIdSet), '\',\'');
        RestinsertAccountEdu accnt = new RestinsertAccountEdu();
        String accessToken = accnt.getRequestToken(accnt, name);
        List<sObject> sobj = new List<sObject>();
        if (accessToken != null) {
            String query = 'SELECT '+ objFields +' FROM ' + objName + ' WHERE Id IN (\'' + idsString + '\') ALL ROWS';
            System.debug('query'+query);
            String endPoint = endpointUrl;
            For(sObject record : Database.query(query)){
                sobj.add(record);
                System.debug('record'+record);
                String idExternal=(string)record.get('Generic_External_Id__c');
                System.debug('query'+idExternal);
                String idString = idExternal.substring(idExternal.lastIndexOf('/') + 1);
                String jsnBody = JSON.serialize(record);
                Http h2 = new Http();
                HttpRequest req1 = new HttpRequest();
                req1.setHeader('Authorization', 'Bearer ' + accessToken);
                req1.setHeader('Content-Type', 'application/json');
                req1.setHeader('accept', 'application/json');
                req1.setMethod('DELETE');
                req1.setBody(jsnBody);
                System.debug('body--->>'+jsnBody);
                req1.setEndpoint(endPoint + idString);
                HttpResponse res1 = h2.send(req1);
                System.debug('response--->>'+res1);
            }
        }
    }
    
}