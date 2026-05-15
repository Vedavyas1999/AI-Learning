trigger UpdateMeetingInPersonCounts on Task (after insert, after update, after delete, after undelete) {
    // Call the handler method to update user counts
   // MeetingInPersonHandler.updateUserCounts(Trigger.old, Trigger.new);
}