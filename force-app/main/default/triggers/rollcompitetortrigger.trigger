trigger rollcompitetortrigger on Competitor__c (after insert, after update, after delete) {
    
    List<Id> competitorIdsToUpdate = new List<Id>();
    List<Id> groupIdsToUpdate = new List<Id>();

    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Competitor__c plant : Trigger.new) {
            competitorIdsToUpdate.add(plant.Company__c);
            groupIdsToUpdate.add(plant.Group__c); // Add Group ID
        }
    } else if (Trigger.isDelete) {
        for (Competitor__c plant : Trigger.old) {
            competitorIdsToUpdate.add(plant.Company__c);
            groupIdsToUpdate.add(plant.Group__c); // Add Group ID
        }
    }
    if(!groupIdsToUpdate.isEmpty()){
    CompetitorTriggerHandler.updateGroupFields(groupIdsToUpdate);
        System.debug('Group code Called');
    }// Pass groupIdsToUpdate here
     if(!competitorIdsToUpdate.isEmpty()){
    CompetitorTriggerHandler.updateCompanyFields(competitorIdsToUpdate);
         System.debug('Company code Called');
     }
}