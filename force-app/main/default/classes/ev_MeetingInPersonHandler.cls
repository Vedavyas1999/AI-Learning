public class ev_MeetingInPersonHandler {
    
    public static void updateUserCounts(List<Task> oldTasks, List<Task> newTasks) {
        // Calculate start and end of the current month
        Date today = Date.today();
        Date firstDayOfMonth = Date.newInstance(today.year(), today.month(), 1);
        Date lastDayOfMonth = Date.newInstance(today.year(), today.month() + 1, 1).addDays(-1);

        
        Set<Id> userIds = new Set<Id>();

        // Collect user IDs from the tasks
        if (newTasks != null) {
            for (Task t : newTasks) {
                if (t.Type == 'Meeting') {
                    userIds.add(t.OwnerId);
                }
            }
        }

        if (oldTasks != null) {
            for (Task t : oldTasks) {
                if (t.Type == 'Meeting') {
                    userIds.add(t.OwnerId);
                }
            }
        }

       
        System.debug('Impacted User IDs: ' + userIds);

        // Query to get the current counts from User records
        Map<Id, User> users = new Map<Id, User>([SELECT Id, Meeting_In_Person__c, Meeting_In_Person_This_Month__c FROM User WHERE Id IN :userIds]);
        Map<Id, Integer> meetingInPersonCompleteMap = new Map<Id, Integer>();
        Map<Id, Integer> meetingInPersonThisMonthMap = new Map<Id, Integer>();

        // To get the current count of "Meeting In Person" tasks for each user
        for (AggregateResult ar : [SELECT OwnerId, COUNT(Id) taskCount 
                                   FROM Task 
                                   WHERE Type = 'Meeting' 
                                   AND Status = 'Completed' 
                                   GROUP BY OwnerId]) {
            meetingInPersonCompleteMap.put((Id) ar.get('OwnerId'), (Integer) ar.get('taskCount'));
            System.debug('Updated meetingInPersonCompleteMap for User: ' + ar.get('OwnerId') + ' with Count: ' + ar.get('taskCount'));
        }

        // Query to get the current count of "Meeting In Person" tasks for this month for each user
        for (AggregateResult ar : [SELECT OwnerId, COUNT(Id) taskCount 
                                   FROM Task 
                                   WHERE Type = 'Meeting' 
                                   AND Status = 'Completed' 
                                   AND CompletedDatetime >= :firstDayOfMonth 
                                   AND CompletedDatetime <= :lastDayOfMonth 
                                   GROUP BY OwnerId]) {
            meetingInPersonThisMonthMap.put((Id) ar.get('OwnerId'), (Integer) ar.get('taskCount'));
            System.debug('Updated meetingInPersonThisMonthMap for User: ' + ar.get('OwnerId') + ' with Count: ' + ar.get('taskCount'));
        }

        
        List<User> usersToUpdate = new List<User>();

        // Update user records with the counts
        for (Id userId : users.keySet()) {
            User u = users.get(userId);
            
            //  total completed "Meeting In Person" count
            u.Meeting_In_Person__c = meetingInPersonCompleteMap.get(userId) != null ? meetingInPersonCompleteMap.get(userId) : 0;
            System.debug('User ' + userId + ' Meeting_In_Person__c: ' + u.Meeting_In_Person__c);
            
            //  this month's count
            u.Meeting_In_Person_This_Month__c = meetingInPersonThisMonthMap.get(userId) != null ? meetingInPersonThisMonthMap.get(userId) : 0;
            System.debug('User ' + userId + ' Meeting_In_Person_This_Month__c: ' + u.Meeting_In_Person_This_Month__c);

            usersToUpdate.add(u);
        }

        // Update the user records  
        if (!usersToUpdate.isEmpty()) {
            System.debug('Users to Update: ' + usersToUpdate);
            update usersToUpdate;
        }
    }
}