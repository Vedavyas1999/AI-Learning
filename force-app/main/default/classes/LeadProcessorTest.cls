@isTest
public class LeadProcessorTest {
    @isTest
    static void testLeadProcessor() {
        // Create a list of Lead records
        List<Lead> leadsToInsert = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            Lead lead = new Lead(
                FirstName = 'TestFirstName' + i,
                LastName = 'TestLastName' + i,
                Company = 'TestCompany' + i
            );
            leadsToInsert.add(lead);
        }
        insert leadsToInsert;

        // Start the batch job
        Test.startTest();
        LeadProcessor batch = new LeadProcessor();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify that all Lead records were updated correctly
        List<Lead> updatedLeads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, updatedLeads.size(), 'All Lead records should have been updated.');
    }
}