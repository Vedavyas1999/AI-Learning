public class conrestrict{
    public static void methodcon(List<contact> conlist){
        set<id> accids =new set<id>();
        for (Contact con:conlist){
            if(con.AccountId!=Null)
            {
                accids.add(con.AccountId);
                
            }
        }
        Map<Id,Account> acclist =new Map<Id,account>([select id,(Select Id from contacts) from Account Where Id =:accids]);
        for (Contact  con  :conlist){
            if(con.AccountId !=null && acclist.containskey(con.AccountId)){
                Account acc = acclist.get(con.AccountId);
                if(acc.contacts.size()>5){
                    con.adderror('You cannot create more than 5 contacts for an Account ');
                }
                
            }
        }
    }
}