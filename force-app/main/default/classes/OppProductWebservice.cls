@RestResource(urlMapping='/opportunityProduct/RestService')

global class OppProductWebservice {
    
    @HttpGet
    global static String getCurrentUserName() {
        String currentUserName = UserInfo.getUserId();
        string uname =userinfo.getFirstName();
        return uname;
    }
    @HttpPost
    global static List<String> updateLastModified(List<OpportunityUpdateRequest> updateRequests) {
        List<Opportunity_Product__c> oppproduct = new List<Opportunity_Product__c>();
        List<String> updateResults = new List<String>();
        
        for (OpportunityUpdateRequest request : updateRequests) {
            oppproduct.add(new Opportunity_Product__c(
                Id = request.opportunityprodId,
                Opportunity_ID__c=request.opportunityId,
                 ORD_Format__c=request.OrdFormat
            ));
        }
        
        try {
            update oppproduct;
            
            for (Opportunity_Product__c opportunityprod : oppproduct) {
                String successMessage = 'Opportunity ' + opportunityprod.Id + ' updated successfully';
               
                
                updateResults.add(successMessage);
            }
        } catch (DmlException ex) {
            for (Opportunity_Product__c opportunity : oppproduct) {
                String failureMessage = 'Failed to update Opportunity ' + opportunity.Id + ': ' + ex.getMessage();
                updateResults.add(failureMessage);
            }
        }
        
        
        System.debug('opportunitiesToUpdate: ' + oppproduct);
        System.debug('updateResults: ' + updateResults);
        
        return updateResults;
    }
    
    global class OpportunityUpdateRequest {
        public String opportunityId;
        public String opportunityProdId;
        public String OrdFormat;
        public Id LastModifiedByuser;
        public Decimal Amount;
        
    }
}