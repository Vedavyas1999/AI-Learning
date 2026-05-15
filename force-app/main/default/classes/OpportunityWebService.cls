@RestResource(urlMapping='/opportunity/updateLastModified')
global class OpportunityWebService {
    @HttpGet
    global static String getCurrentUserName() {
        String currentUserName = UserInfo.getUserId();
        string uname =userinfo.getFirstName();
        return uname;
    }
    @HttpPost
    global static List<String> updateLastModified(List<OpportunityUpdateRequest> updateRequests) {
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        List<String> updateResults = new List<String>();
        
        for (OpportunityUpdateRequest request : updateRequests) {
            opportunitiesToUpdate.add(new Opportunity(
                Id = request.opportunityId,
                Amount=request.Amount,
                LastModifiedBy__c = request.LastModifiedBy,
                Last_Modified_By_User__c = request.LastModifiedByuser
            ));
        }
        
        try {
            update opportunitiesToUpdate;
            
            for (Opportunity opportunity : opportunitiesToUpdate) {
                String successMessage = 'Opportunity ' + opportunity.Id + ' updated successfully';
                successMessage += '|Last Modified By: ' + opportunity.LastModifiedBy__c;
                successMessage += '|Last Modified By User: ' + opportunity.Last_Modified_By_User__c;
                
                updateResults.add(successMessage);
            }
        } catch (DmlException ex) {
            for (Opportunity opportunity : opportunitiesToUpdate) {
                String failureMessage = 'Failed to update Opportunity ' + opportunity.Id + ': ' + ex.getMessage();
                updateResults.add(failureMessage);
            }
        }
        
        
        System.debug('opportunitiesToUpdate: ' + opportunitiesToUpdate);
        System.debug('updateResults: ' + updateResults);
        
        return updateResults;
    }
    
    global class OpportunityUpdateRequest {
        public String opportunityId;
        public String LastModifiedBy;
        public Id LastModifiedByuser;
        public Decimal Amount;
        
    }
}