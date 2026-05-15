public class CloneQuoteWithRelatedController {

    @AuraEnabled
    public static String cloneQuoteWithRelated(String QuoteId) {
        try {
            
            List<Quote> QuoteList = new List<Quote>();
            List<QuoteLineItem> QuoteLineList = new List<QuoteLineItem>();
 
            Schema.FieldSet quoteFieldSet = Schema.SObjectType.Quote.fieldSets.getMap().get('Fields_for_Cloning_Quote');
            System.debug('Quote FieldSet available: ' + (quoteFieldSet != null));

            if (quoteFieldSet != null) {
                System.debug('Fields in Quote FieldSet: ' + quoteFieldSet.getFields());
            }

            String quoteQuery = 'SELECT ';

            
            for (Schema.FieldSetMember fsm : quoteFieldSet.getFields()) {
                quoteQuery += fsm.getFieldPath() + ', ';
            }

            quoteQuery = quoteQuery.removeEnd(', '); 
            quoteQuery += ' FROM Quote WHERE Id = :QuoteId';
           System.debug('Generated Quote Query: ' + quoteQuery);
            Quote quotee = Database.query(quoteQuery);
          if (quotee == null) {
                System.debug('No Quote found with Id: ' + QuoteId);
                return null;  
            }
            
            // Log the fetched quote details
            System.debug('Fetched Quote: ' + quotee);

            // Clone the Quote
            Quote quoteObj = (Quote)quotee.clone(false, true);
            quoteObj.Status = 'Draft'; // Setting the status to Draft for the new Quote
            quoteObj.Description = 'Cloned from ' + quotee.Name; // Modify description or other fields as needed
            QuoteList.add(quoteObj);

            // Fetch related Quote Line Items using FieldSet for QuoteLineItem
            Schema.FieldSet quoteLineFieldSet = Schema.SObjectType.QuoteLineItem.fieldSets.getMap().get('QLI_FIeldset');
            System.debug('QuoteLineItem FieldSet available: ' + (quoteLineFieldSet != null));

            if (quoteLineFieldSet != null) {
                System.debug('Fields in QuoteLineItem FieldSet: ' + quoteLineFieldSet.getFields());
            }

            String quoteLineQuery = 'SELECT ';

            // Dynamically build the query for QuoteLineItem fields from the FieldSet
            for (Schema.FieldSetMember fsm : quoteLineFieldSet.getFields()) {
                quoteLineQuery += fsm.getFieldPath() + ', ';
            }
            Id clonedquoteId = quotee.Id;
            quoteLineQuery = quoteLineQuery.removeEnd(', '); // Remove trailing comma
            quoteLineQuery += ' FROM QuoteLineItem WHERE QuoteId = :clonedquoteId';

            // Log the dynamically generated query for the QuoteLineItem object
            System.debug('Generated QuoteLineItem Query: ' + quoteLineQuery);

            // Execute the dynamic query to fetch the related QuoteLineItems
            List<QuoteLineItem> quoteLineItems = Database.query(quoteLineQuery);
            System.debug('Fetched Quote Line Items: ' + quoteLineItems);

            // Clone each QuoteLineItem and assign it to the new Quote
            for (QuoteLineItem QL : quoteLineItems) {
                QuoteLineItem quoteLineObj = (QuoteLineItem)QL.clone(false, true);
                quoteLineObj.QuoteId = quoteObj.Id; // Assign the new Quote Id to the cloned Quote Line
                QuoteLineList.add(quoteLineObj);
            }

            // Insert the new Quote record
            if (QuoteList.size() > 0) {
                insert QuoteList;
                System.debug('Cloned Quote: ' + QuoteList);
            }

            // Insert the cloned Quote Line Items
            if (QuoteLineList.size() > 0) {
                insert QuoteLineList;
                System.debug('Cloned Quote Line Items: ' + QuoteLineList);
            }

            // Return the Id of the newly created Quote
            return QuoteList.size() > 0 ? QuoteList[0].Id : null;

        } catch (Exception e) {
            System.debug('Caught exception: ' + e.getMessage());  // Log the error message for debugging
            String errorMessage = 'An error occurred while cloning Quote with Related: ' + e.getMessage();
            throw new AuraHandledException(errorMessage);
        }
    }
    
}