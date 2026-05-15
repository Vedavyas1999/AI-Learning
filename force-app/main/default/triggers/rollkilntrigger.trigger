trigger rollkilntrigger on Kiln_Report__c (after insert, after update, after delete) {
   /* List<Id> competitorIdsToUpdate = new List<Id>();

    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Kiln_report__c kilnReport : Trigger.new) {
            competitorIdsToUpdate.add(kilnReport.Competitor__c);
        }
    } else if (Trigger.isDelete) {
        for (Kiln_report__c kilnReport : Trigger.old) {
            competitorIdsToUpdate.add(kilnReport.Competitor__c);
        }
    }

    CompetitorTriggerHandler.updateCompetitorFields(competitorIdsToUpdate);*/
}