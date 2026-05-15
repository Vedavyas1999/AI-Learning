trigger acccopybillingtoshipping on Account (before insert,before update) {
    list<account> acctoupdate =new list<account>();
    for(account acc:trigger.new )
    {
        if(acc.Copy_Billing_Address_to_Shipping_Address__c = true && acc.BillingCity!= null
           && acc.BillingCountry!= null && acc.BillingPostalCode != null
           && acc.BillingState != null && acc.BillingStreet != null)
            acc.ShippingCity=acc.BillingCity;
        acc.ShippingCountry=acc.BillingCountry;
        acc.ShippingPostalCode=acc.BillingPostalCode;
        acc.ShippingState=acc.BillingState;
        acc.ShippingStreet=acc.BillingStreet;
         
      
        
    }
}