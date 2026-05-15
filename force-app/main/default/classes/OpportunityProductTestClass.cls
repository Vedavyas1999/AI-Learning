@IsTest
private class OpportunityProductTestClass {
    @IsTest
    static void testGetOpportunityProducts() {
        // Create test data
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            stagename ='closed',
            closedate=Date.today() + 30
        );
        Opportunity_Product__c oppProduct1 = new Opportunity_Product__c(
            Product_Id__c = 'P001',
            Opportunity_ID__c = testOpportunity.Id,
            ORD_Format__c = 'Format1',
            ORD_Year__c = '2023'
        );
        Opportunity_Product__c oppProduct2 = new Opportunity_Product__c(
            Product_Id__c = 'P002',
            Opportunity_ID__c = testOpportunity.Id,
            ORD_Format__c = 'Format2',
            ORD_Year__c = '2024'
        );
        insert new List<Opportunity_Product__c>{oppProduct1, oppProduct2};
            
            // Create a mock class
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.requestURI = '/services/apexrest/opportunityproduct';
        RestContext.request = request;
        // Call the method being tested
        Test.startTest();
        List<Opportunity_Product__c> result = RestApioppProdcontroller.getOpportunityProducts();
        Test.stopTest();
        
        // Verify the results
        System.assertEquals(2, result.size());
        
        Opportunity_Product__c result1 = result[0];
        System.assertEquals('P001', result1.Product_Id__c);
        System.assertEquals('Format1', result1.ORD_Format__c);
        System.assertEquals('2023', result1.ORD_Year__c);
        
        Opportunity_Product__c result2 = result[1];
        System.assertEquals('P002', result2.Product_Id__c);
        System.assertEquals('Format2', result2.ORD_Format__c);
        System.assertEquals('2024', result2.ORD_Year__c);
    }
    
    @IsTest
    static void testCreateOpportunityProduct() {
        // Create a test Opportunity
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Closed',
            CloseDate = Date.today() + 30
        );
        insert testOpportunity;
        
        // Create a mock REST request
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestURI = '/services/apexrest/opportunityProducts';
        String requestBody = '{"productId":"P001","opportunityId":"' + testOpportunity.Id + '","ordFormat":"Format1","ordYear":"2023"}';
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        
        // Call the method being tested
        Test.startTest();
        String result = RestApioppProdcontroller.createOpportunityProduct();
        Test.stopTest();
        
        // Verify the result
        System.assert(result.contains('record created successfully'));
        
        // Verify that the Opportunity_Product__c record was created
        List<Opportunity_Product__c> opportunityProducts = [
            SELECT Id, Product_Id__c, Opportunity_ID__c, ORD_Format__c, ORD_Year__c
            FROM Opportunity_Product__c
        ];
        System.assertEquals(1, opportunityProducts.size());
        Opportunity_Product__c createdOpportunityProduct = opportunityProducts[0];
        System.assertEquals('P001', createdOpportunityProduct.Product_Id__c);
        System.assertEquals(testOpportunity.Id, createdOpportunityProduct.Opportunity_ID__c);
        System.assertEquals('Format1', createdOpportunityProduct.ORD_Format__c);
        System.assertEquals('2023', createdOpportunityProduct.ORD_Year__c);
    }
    
}