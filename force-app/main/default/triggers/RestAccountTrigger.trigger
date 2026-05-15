/*******************************************************************************************
* @Name         RestAccountTrigger 
* @Object Name  Account
* @Author       Evoke Technologies
* @Date         2/28/2023
* @Description  This class contains all service methods related to caching data in Salesforce.  
                integrate one org to other org, If record Inseted, updated, or deleted in one org
                then same action is performed in the other org automatic/easy.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              vedavyas chowdary      4/11/2023          Updated                                                      
*******************************************************************************************/

trigger RestAccountTrigger on Account (after insert, after update,before delete) {
    
    Set<Id> accIdSet = new Set<Id>();
    Set<String> extId = new Set<String>();
    Set<Id> accIdSetDel = new Set<Id>();
    boolean hasDelete=false;
    boolean isUpdated=false;
    
    if(RestinsertAccountEdu.isFirstTime){
        RestinsertAccountEdu.isFirstTime = false;
        
        if (Trigger.isinsert || Trigger.isupdate ){
                 for (Account acc : Trigger.new) {
                      if (acc.Name != null) {
                        accIdSet.add(acc.Id);
                        extId.add(acc.Generic_External_Id__c);
                      }
                     if(acc.From_External_Update__c){
                         isUpdated=true;
                     }
                    }
            String objName = Trigger.new.getSObjectType().getDescribe().getName();
            if (accIdSet.size() > 0  && Trigger.isinsert && extId.contains(null) && !test.isRunningTest()){
                RestinsertAccountEdu.createAccountMethod(accIdSet, objName);
                  } 
            else if(Trigger.isupdate && !isUpdated) {
            RestinsertAccountEdu.updateObjectMethod(accIdSet, objName);
                  } 
        }
        if(Trigger.isdelete) {
            for (Account acc : Trigger.old) {
                    if (acc.Name != null) {
                       accIdSetDel.add(acc.Id);
                        system.debug('idset'+accIdSetDel);
                      }
                 if(acc.Is_Delete__c){
                    hasDelete=true;
                }
            }
            String objName = Trigger.old.getSObjectType().getDescribe().getName();
            if(hasDelete)RestinsertAccountEdu.deleteObjectMethod(accIdSetDel, objName);
        } 
    }
}