public class FinalAmountHandler {
    public static void calculateTotal(List<Opportunity> opportunities) {
        for (Opportunity opp : opportunities) {
            // Check for null values and replace them with zero
            Decimal fieldOne = opp.Field_one__c != null ? opp.Field_one__c : 0;
            Decimal fieldTwo = opp.Field_two__c != null ? opp.Field_two__c : 0;

            opp.Total__c = fieldOne + fieldTwo;
        }
    }
}