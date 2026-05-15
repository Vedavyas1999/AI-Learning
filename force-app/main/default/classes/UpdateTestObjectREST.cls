@RestResource(urlMapping='/updateTestObject/*')
global class UpdateTestObjectREST {

    @HttpPost
    global static String updateTestObject(String recordId, Boolean recordField, Integer numberField) {
        try {
             Test_OBJ__c objToUpdate = [SELECT Id, Number_field__c, Record__c FROM Test_OBJ__c WHERE Id = :recordId];

             objToUpdate.Number_field__c = numberField;
            objToUpdate.Record__c = recordField;

             update objToUpdate;

            return 'Record updated successfully: ' + objToUpdate.Id;
        } catch (Exception e) {
            return 'Error updating record: ' + e.getMessage();
        }
    }
}