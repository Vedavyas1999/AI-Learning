/*******************************************************************************************
* @Name         RestContactTrigger 
* @Object Name  Contact
* @Author       Evoke Technologies
* @Date         3/2/2023
* @Description  This class contains all service methods related to caching data in Salesforce.  
                integrate one org to other org, If record Inseted, updated, or deleted in one org
                then same action is performed in the other org automatic/easy.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              vedavyas chowdary       4/12/2023          Updated                                                      
*******************************************************************************************/

trigger RestContactTrigger on Contact (after insert, after update,before delete) {
    Set<Id> conidset = new Set<Id>();
    Set<String> extId = new Set<String>();
    Set<Id> conIdsetdel = new Set<Id>();
    boolean hasFirstRun=true;
    boolean hasDelete=false;
    boolean isUpdated=false;
    system.debug('testing'+(RestInsertAccountEdu.isFirstTime));
    if(RestInsertAccountEdu.isFirstTime){
        RestInsertAccountEdu.isFirstTime = false;
        if ((Trigger.isinsert || Trigger.isupdate )) {
                 for (Contact con : Trigger.new) {
                      if (con.LastName != null) {
                        conidset.add(con.Id);
                          extId.add(con.Generic_External_Id__c);
                      }
                     if(con.From_External_Update__c){
                         isUpdated=true;
                     }
                    }
            
            String objName = Trigger.new.getSObjectType().getDescribe().getName();
            system.debug('testttttttttttttt'+extId);
            system.debug('testttttttttttttt'+extId.size());
            if (conidset.size() > 0  && Trigger.isinsert && extId.contains(null)  && !test.isRunningTest()){
                RestInsertAccountEdu.createAccountMethod(conidset, objName);
                  } 
            else if(Trigger.isupdate && hasFirstRun && !isUpdated) {
            RestInsertAccountEdu.updateObjectMethod(conidset, objName);
                hasFirstRun=false;
                  } 
        }
          
        if(Trigger.isdelete) {
            for (Contact con : Trigger.old) {
                    if (con.LastName != null) {
                       conIdsetdel.add(con.Id);
                        system.debug('idset'+conIdsetdel);
                      }
                if(con.Is_Delete__c){
                    hasDelete=true;
                }
            }
            String objName = Trigger.old.getSObjectType().getDescribe().getName();
            
            if(hasDelete)RestInsertAccountEdu.deleteObjectMethod(conIdsetdel, objName);
        } 
    }
}