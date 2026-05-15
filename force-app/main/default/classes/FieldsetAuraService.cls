/**
 * @description - This class is used to dynamically retrieve field metadata for a given object and fieldset.
 */ 
public with sharing class FieldsetAuraService {
    
    /** @descripion getFieldsFromFieldSet - This method helps to get information about fields such as labels, types and API names for a particular object.
     * @param fieldsetApiName - Accepts the string of fieldset Apiname
     * @param sObjectApiName - Accepts the string of object Apiname
     * @return retVals - Returns the fieldset values
     */ 
    @AuraEnabled(cacheable=true)
    public static List<String> getFieldsFromFieldSet(String fieldsetApiName, String sObjectApiName){
        List<Schema.FieldSetMember> fields = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe().fieldSets.getMap().get(fieldsetApiName).getFields();
        
        List<String> retVals = new List<String>();

        for(Schema.FieldSetMember field : fields) {
            retVals.add(field.getSObjectField().getDescribe().getName());
        }
        return retVals;
    }
}