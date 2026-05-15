trigger RestrictContactdelete on Account (before delete) {
    List<Contact> conlist=new List<Contact>();
    for(Account acc : Trigger.old)
    {
        conlist= [select id from contact where accountid =: acc.Id];
        if(Conlist.size()>2){
        acc.adderror('Cannot delete Account with more than 2 contacts');
    }
    }
    
    
}