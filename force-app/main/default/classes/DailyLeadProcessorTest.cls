@isTest
public class DailyLeadProcessorTest {
    @isTest
    static void testDailyLeadProcessor() {
        // Create 200 Lead records with a blank LeadSource field
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            Lead lead = new Lead(
                FirstName = 'TestFirstName' + i,
                LastName = 'TestLastName' + i
            );
            leads.add(lead);
        }
        insert leads;

        // Schedule the DailyLeadProcessor job
        Test.startTest();
        String jobId = System.schedule('DailyLeadProcessor Test', '0 0 0 * * ?', new DailyLeadProcessor());
        Test.stopTest();

        // Ensure the scheduled job has executed
        System.assertNotEquals(null, jobId, 'Scheduled job ID should not be null.');

        // Wait for a moment to allow the scheduled job to run (actual execution time may vary)
        // Since we cannot predict the exact execution time, you may need to monitor the job's execution status in a real Salesforce environment
        // The above 'System.sleep' approach may not be suitable for a real Salesforce environment, and you should use monitoring mechanisms available in Salesforce

        // Verify that all Lead records were updated correctly
        List<Lead> updatedLeads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, updatedLeads.size(), 'All Lead records should have been updated.');
    }
}