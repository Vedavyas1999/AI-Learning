trigger rollUpSummaryTrigger on Contact (after insert,after delete,after undelete,after update) {
    //get all account ids which are already exist /new accs and add it to set
    // 
    List<Account> UpdateAcclist =new List<account>();
    set<id> accids =new set<id>();
    if(Trigger.Isinsert || Trigger.Isupdate ||Trigger.Isundelete){
        for(Contact con :Trigger.new)
        {
            if(con.AccountId !=null){
                accids.add(con.AccountId);
            }
        }
    }
    if(  Trigger.Isupdate ||Trigger.Isdelete){
        for(Contact con :Trigger.old)
        {
            if(con.AccountId !=null){
                accids.add(con.AccountId);
            }
        }
    }
    //get acc with contacts condition check with set 
    List<Account> acclist =New list<Account>([Select Id,(Select Id from contacts) from Account Where Id =:accids]);
    if(!acclist.isEmpty()){
        
        for(Account acc :acclist){
            
            acc.No_of_Contacts__c=acc.Contacts.Size();
            UpdateAcclist.add(acc);
        }
        if(!UpdateAcclist.IsEmpty()){
            update UpdateAcclist;
        }
    }
}