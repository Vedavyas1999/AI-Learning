@RestResource(urlMapping='/quoteservice/*')
global with sharing class QuoteService {

    @HttpGet
    global static void getQuoteWithLineItems() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String quoteId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        // Query the Quote and related QuoteLineItems
        List<Quote> quoteRecord = [
           SELECT Id, Name, TotalPrice,Customer_Name__c, QuoteNumber,ShippingAddress,(SELECT Id,Product2.Name,Operating_Unit__c,Unit_of_Measure__c,Warehouse__c, Shipping_Method__c,Currency__c,QuoteId, Quantity, UnitPrice, TotalPrice FROM QuoteLineItems)
            FROM Quote where Id=:quoteId and Status ='Approved' 
           
           
        ];

        // Convert the Quote record to JSON
        res.responseBody = Blob.valueOf(JSON.serialize(quoteRecord));
        res.statusCode = 200;
    }
}