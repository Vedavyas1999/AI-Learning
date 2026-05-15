@RestResource(urlMapping='/opportunityproduct')
global class RestApiOppProdcontroller {
/*
    @HttpGet
    global static List<Opportunity_Product__c> getOpportunityProducts() {
        String oppProdId = RestContext.request.params.get('id');
        List<Opportunity_Product__c> opportunityProducts;

        if (String.isNotBlank(oppProdId)) {
            // Retrieve a specific Opportunity Product record by ID
            opportunityProducts = [
                SELECT Id, Product_Id__c, Opportunity_ID__c, Opportunity_ID__r.Name, ORD_Format__c, ORD_Year__c
                FROM Opportunity_Product__c
                WHERE Id = :oppProdId
                LIMIT 1
            ];
        } else {
            // Retrieve all Opportunity Product records
            opportunityProducts = [
                SELECT Id, Product_Id__c, Opportunity_ID__c, Opportunity_ID__r.Name, ORD_Format__c, ORD_Year__c
                FROM Opportunity_Product__c
            ];
        }

        return opportunityProducts;
    }

    // POST method to create or update Opportunity_Product__c records
    @HttpPost
    global static string upsertOpportunityProducts() {
        try {
            RestRequest request = RestContext.request;
            String requestBody = request.requestBody.toString();
            List<OpportunityProductRequest> opportunityProductRequests = (List<OpportunityProductRequest>) JSON.deserialize(requestBody, List<OpportunityProductRequest>.class);

            List<Opportunity_Product__c> upsertOpportunityProducts = new List<Opportunity_Product__c>();
            List<ApiResponse> responseList = new List<ApiResponse>();

            for (OpportunityProductRequest opportunityProductRequest : opportunityProductRequests) {
                Opportunity_Product__c opportunityProduct = new Opportunity_Product__c(
                    Product_Id__c = opportunityProductRequest.productId,
                    Opportunity_ID__c = opportunityProductRequest.opportunityId,
                    ORD_Format__c = opportunityProductRequest.ordFormat,
                    ORD_Year__c = opportunityProductRequest.ordYear
                );
                upsertOpportunityProducts.add(opportunityProduct);
            }

            Database.UpsertResult[] upsertResults = Database.upsert(upsertOpportunityProducts, false);

            for (Integer i = 0; i < upsertResults.size(); i++) {
                ApiResponse response;
                if (upsertResults[i].isSuccess()) {
                    response = new ApiResponse(upsertResults[i].getId(), true, new List<String>());
                } else {
                    response = new ApiResponse(null, false, upsertResults[i].getErrors());
                }
                responseList.add(response);
            }

            String serializedJson = JSON.serializePretty(responseList).replaceAll('\\\\n', '\n');

            return serializedJson;
        } catch (Exception e) {
            return getErrorApiResponse(e);
        }
    }

    // PUT method to update Opportunity_Product__c records
    @HttpPut
    global static string updateOpportunityProducts() {
        try {
            RestRequest request = RestContext.request;
            String requestBody = request.requestBody.toString();
            List<OpportunityProductUpdateRequest> opportunityProductUpdateRequests = (List<OpportunityProductUpdateRequest>) JSON.deserialize(requestBody, List<OpportunityProductUpdateRequest>.class);

            List<Opportunity_Product__c> updatedOpportunityProducts = new List<Opportunity_Product__c>();
            List<ApiResponse> responseList = new List<ApiResponse>();

            for (OpportunityProductUpdateRequest opportunityProductUpdateRequest : opportunityProductUpdateRequests) {
                Opportunity_Product__c existingOpportunityProduct = [
                    SELECT Id, Product_Id__c, Opportunity_ID__c, ORD_Format__c, ORD_Year__c
                    FROM Opportunity_Product__c
                    WHERE Id = :opportunityProductUpdateRequest.ProdId
                    LIMIT 1
                ];

                if (existingOpportunityProduct != null) {
                    // Update the fields if the Opportunity Product exists
                    existingOpportunityProduct.Product_Id__c = opportunityProductUpdateRequest.productId;
                    existingOpportunityProduct.Opportunity_ID__c = opportunityProductUpdateRequest.opportunityId;
                    existingOpportunityProduct.ORD_Format__c = opportunityProductUpdateRequest.ordFormat;
                    existingOpportunityProduct.ORD_Year__c = opportunityProductUpdateRequest.ordYear;

                    updatedOpportunityProducts.add(existingOpportunityProduct);
                } else {
                    // Add an error response for the Opportunity Product that doesn't exist
                    ApiResponse response = new ApiResponse(opportunityProductUpdateRequest.productId, false, new List<String>{'Opportunity Product not found.'});
                    responseList.add(response);
                }
            }

            if (!updatedOpportunityProducts.isEmpty()) {
                update updatedOpportunityProducts;
                for (Opportunity_Product__c updatedOpportunityProduct : updatedOpportunityProducts) {
                    ApiResponse response = new ApiResponse(updatedOpportunityProduct.Id, true, new List<String>());
                    responseList.add(response);
                }
            }

            String serializedJson = JSON.serializePretty(responseList).replaceAll('\\\\n', '\n');

            return serializedJson;

        } catch (Exception e) {
            return getErrorApiResponse(e);
        }
    }

    // Helper method to create JSON response for errors
    private static String getErrorApiResponse(Exception e) {
        List<Map<String, Object>> errorDataList = new List<Map<String, Object>>();
        Map<String, Object> errorData = new Map<String, Object>();
        errorData.put('id', null);
        errorData.put('success', false);

        List<Map<String, Object>> errorsList = new List<Map<String, Object>>();
        Map<String, Object> error = new Map<String, Object>();
        error.put('statusCode', 'UNKNOWN_ERROR');
        error.put('message', e.getMessage());

        List<Object> fields = new List<Object>();
        error.put('fields', fields);
        errorsList.add(error);

        errorData.put('errors', errorsList);
        errorDataList.add(errorData);

        return JSON.serializePretty(errorDataList);
    }

    // Existing OpportunityProductRequest class code here...

    public class OpportunityProductRequest {
        public String productId;
        public Id opportunityId;
        public String ordFormat;
        public String ordYear;
    }

    public class OpportunityProductUpdateRequest {
        public String productId;
        public String ProdId;
        public Id opportunityId;
        public String ordFormat;
        public String ordYear;
    }

    public class ApiResponse {
    public String id;
    public Boolean success;
    public List<String> errors;

    public ApiResponse(String id, Boolean success, List<String> errors) {
        this.id = id;
        this.success = success;
        this.errors = errors;
    }

    public ApiResponse(String id, Boolean success, List<Database.Error> dbErrors) {
        this.id = id;
        this.success = success;
        this.errors = new List<String>();
        for (Database.Error error : dbErrors) {
            this.errors.add(error.getMessage());
        }
    }
}*/

}