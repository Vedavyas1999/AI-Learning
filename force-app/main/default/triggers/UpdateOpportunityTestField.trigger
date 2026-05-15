trigger UpdateOpportunityTestField on Account (after update) {
    UpdateOpportunityTestFieldHandler.updateOpportunityTestField(Trigger.new);
}