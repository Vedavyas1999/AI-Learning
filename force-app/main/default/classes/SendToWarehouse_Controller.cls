public class SendToWarehouse_Controller
{
    public List<Opportunity> opplist1{get;set;}
    
    
    public SendToWarehouse_Controller(){
        opplist1 = new list<Opportunity>();
        
        opplist1 = [Select Id, 
                    Contact__r.Name,
                    Contact__r.Department,
                    Contact__r.MailingPostalcode,
                    Contact__r.MailingCity,
                    Contact__r.MailingStreet,
                    Contact__r.MailingState,
                    Contact__r.MailingCountry,
                    Contact__r.Email,
                    NextStep,
                    Name,
                    Description
                    From Opportunity
                    WHERE Send_to_Warehouse__c != False AND 
                    Send_To_Warehouse_Date__c != null AND 
                    Send_To_Warehouse_Date__c = today];
        
        System.debug('Opp List'+opplist1);
        
    }    
}