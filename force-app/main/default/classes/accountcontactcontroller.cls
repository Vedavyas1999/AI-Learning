public class accountcontactcontroller{
public static Map<Account, List<Contact>> accconmethod(){
 Map<Account, List<contact>> accconmap = new Map<Account, list<contact>>();
    
	List<account> accwithcons =[select id,name ,(select id,name from contacts) from Account where id in (select Accountid from contact)];
	
	for(Account acc : accwithcons){
		
		accconmap.put(acc,acc.contacts);
	}
      return accconmap;
}
  
}