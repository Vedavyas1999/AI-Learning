trigger FinalAmountTrigger on Opportunity (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            FinalAmountHandler.calculateTotal(Trigger.new);
        }
    }
}