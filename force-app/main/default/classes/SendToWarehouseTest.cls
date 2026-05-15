@IsTest
public class SendToWarehouseTest {
    @IsTest
    static void testSendToWarehouse() {
        // Create test data
        Contact testContact1 = new Contact(LastName = 'Smith');
        Contact testContact2 = new Contact(LastName = 'Johnson');
        insert new List<Contact>{ testContact1, testContact2 };
        
        Opportunity testOpportunity1 = new Opportunity(
            Name = 'Opportunity 1',
            StageName = 'Closed Won',
            Amount = 1000,
            CloseDate = Date.today(),
            Contact__c = testContact1.Id
        );
        
        Opportunity testOpportunity2 = new Opportunity(
            Name = 'Opportunity 2',
            StageName = 'Closed Won',
            Amount = 2000,
            CloseDate = Date.today(),
            Contact__c = testContact1.Id
        );
        
        Opportunity testOpportunity3 = new Opportunity(
            Name = 'Opportunity 3',
            StageName = 'Closed Won',
            Amount = 3000,
            CloseDate = Date.today(),
            Contact__c = testContact2.Id
        );
        
        insert new List<Opportunity>{ testOpportunity1, testOpportunity2, testOpportunity3 };
        
        // Create an instance of the SendToWarehouse class
        SendToWarehouse sendToWarehouse = new SendToWarehouse();
        
        // Verify the lists are populated correctly
        System.assertEquals(3, sendToWarehouse.opplist1.size(), 'opplist1 should contain 3 opportunities');
        System.assertEquals(2, sendToWarehouse.opplistWithSameContactShipping.size(), 'opplistWithSameContact should contain 2 opportunities');
        System.assertEquals(1, sendToWarehouse.opplistWithoutSameContact.size(), 'opplistWithoutSameContact should contain 1 opportunity');
    }
}