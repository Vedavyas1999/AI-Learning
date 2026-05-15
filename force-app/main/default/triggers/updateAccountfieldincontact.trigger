trigger updateAccountfieldincontact on Account (after update) {
     // Call the handler to process the update
    AccountContactHandler.onAfterUpdate(Trigger.new, Trigger.oldMap,Trigger.newmap);
}