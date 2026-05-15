public class UpdateUserRecordWithMeetingCount {
    
    // Method to update the Type__C field with the count of 'Meeting in Person' tasks
    public static void updateUserMeetingCount() {
        // List to hold the users to be updated
        List<User> usersToUpdate = new List<User>();

        // Query to get the count of 'Meeting in Person' tasks grouped by User
        AggregateResult[] taskCounts = [
            SELECT OwnerId, COUNT(Id) taskCount
            FROM Task
            WHERE Type = 'Meeting'
            GROUP BY OwnerId
        ];

        // Loop through the aggregate results to build the list of users to update
        for (AggregateResult ar : taskCounts) {
            Id userId = (Id) ar.get('OwnerId');
            Integer count = (Integer) ar.get('taskCount');
            
            // Create a new User object with the updated Type__C field
            User u = new User(
                Id = userId,
                Meeting_Count__C = count
            );

            usersToUpdate.add(u);
            system.debug('usersToUpdate'+usersToUpdate);
        }

        // Update the users
      
            
                update usersToUpdate;
            
                System.debug('An error occurred while updating users: '  );
            
       }
    }