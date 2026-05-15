public with sharing class FieldSetController {
    @AuraEnabled(cacheable=true)
    public static List<FieldDescribe> getOpportunityFields() {
        List<FieldDescribe> fields = new List<FieldDescribe>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType objectType = gd.get('Opportunity'); // Hardcoded Opportunity object name
        if (objectType != null) {
            Schema.DescribeSObjectResult objResult = objectType.getDescribe();
            Map<String, Schema.SObjectField> fieldMap = objResult.fields.getMap();
            for (String fieldName : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldResult = fieldMap.get(fieldName).getDescribe();
                fields.add(new FieldDescribe(fieldName, fieldResult.getLabel(), fieldResult.getType()));
            }
        }
        return fields;
    }
    
    public class FieldDescribe {
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String fieldLabel;
        @AuraEnabled
        public Schema.DisplayType fieldType;
        
        public FieldDescribe(String fieldName, String fieldLabel, Schema.DisplayType fieldType) {
            this.fieldName = fieldName;
            this.fieldLabel = fieldLabel;
            this.fieldType = fieldType;
        }
    }
}