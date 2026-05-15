trigger createacconconcreate on Contact (after insert) {
    list<account> acclist=new list<account>();
    list<contact> conlisttoupdate =new list<contact>();
    
    for(contact con : trigger.new){
        account acc =new account(name =con.lastname);
        acclist.add(acc);
    }
   // insert acclist;
    for(account acc: acclist){
        contact con =new contact();
        con.accountid =acc.id;
       conlisttoupdate.add(con); 
    }
  //  update conlisttoupdate;

}