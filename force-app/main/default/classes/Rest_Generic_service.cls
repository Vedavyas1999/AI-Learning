/*******************************************************************************************
* @Name         Rest_Generic_service 
* @Author       Evoke Technologies
* @Date         3/6/2023
* @Description  This Generic service class(Integration code) contains all service methods related to caching data in Salesforce org.  
				Integrate one org to other org, If record Inseted, updated, or deleted in one org
                then same action is performed in the other org automatic/easy.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              vedavyas chowdary       4/10/2023         Updated                                                      
*******************************************************************************************/

@RestResource(urlMapping='/v3/generic/*')
/**************************************************************************************
* @Description  This method gets checks for entries in org cache then after create sObject records
* @Param		null
* @Return       SObject 
**************************************************************************************/ 
global class Rest_Generic_service {
    @HttpPost
    global Static SObject createRecord(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        string jsonString=req.requestBody.tostring();
        System.debug('Log1'+jsonString);
        sobject obj12=(sobject)JSON.deserialize(jsonString, sobject.class);
        System.debug('Log2'+obj12);
        String externalIdValue = (String)obj12.get('Generic_Id__c');
        System.debug('Extv'+externalIdValue);
        obj12.put('Generic_External_Id__c',externalIdValue );
        insert obj12;
        System.debug('Obj.id'+obj12.Id);
        System.debug('response'+obj12);
        return  obj12;
    }
    
/**************************************************************************************
* @Description  This method gets checks for entries in org cache then after update sObject records
* @Param		null
* @Return       String - 'Success: ' + obj12.Id
**************************************************************************************/
    @HttpPut
    global static String updateRecord(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String jsonString = req.requestBody.tostring();
        System.debug('Log1'+jsonString);
        sobject obj12 = (sobject)JSON.deserialize(jsonString, sobject.class);
        System.debug('Log2'+obj12);
        String externalIdValue = (String)obj12.get('Generic_External_Id__c');
        String genericId = (String)obj12.get('Generic_Id__c');
        System.debug('Extv'+externalIdValue);
        obj12.put('Id',externalIdValue );
       // obj12.put('updatetimebyedu__c',system.now());
        obj12.put('Generic_External_Id__c',genericId);
        obj12.put('From_External_Update__c',true );
        update obj12;
        return 'Success: ' + obj12.Id;
    }
    
/**************************************************************************************
* @Description  This method gets checks for entries in org cache then after delete sObject records
* @Param		null
* @Return       String - Deleted: 
**************************************************************************************/
    @HttpDelete
    global static String deleteRecord(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String jsonString = req.requestBody.tostring();
        System.debug('Log1'+jsonString);
        sobject obj12 = (sobject)JSON.deserialize(jsonString, sobject.class);
        System.debug('Log2'+obj12);
        String externalIdValue = (String)obj12.get('Generic_External_Id__c');
        System.debug('Extv'+externalIdValue);
        obj12.put('Id',externalIdValue );
        delete obj12;
        return 'Deleted: ';
    }
    
}