public class AccounttypeCOntroller {
 
    public static Map<String, integer> CountofAccconmethod() {
        Map<String, Integer> accountcontactsmap = new Map<String, Integer>();
        Aggregateresult[] results =[select Type__c, Count(ID) Acccount from Account Group By Type__c];
        for (Aggregateresult ar : results){
            accountcontactsmap.put((String)ar.get('Type__c'),(Integer)ar.get('Acccount'));
            System.debug('v');
        }
        for(String accountName : accountcontactsmap.KeySet() ){
            System.debug('AccountName ' +accountName + ', Contacts Count' + accountcontactsmap.get(accountName));
            
        }
        return accountcontactsmap;
    }
}