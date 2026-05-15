global class batchclassex implements Database.Batchable<Sobject>,Database.Stateful
{
        global    list<Account> accountlisttoupdate= new List<account>();

    global Database.QueryLocator start(Database.Batchablecontext db)
    {
      //List<Account> query=[select id,name,createddate,rating from Account];
       System.debug('Apex class Started');
        return Database.getQueryLocator('select id,name,createddate,rating from Account');
    }
    global void execute(Database.Batchablecontext bc,List<account> acclist)
    {
        for(account acc: acclist){
            acc.Rating = 'cool';
           accountlisttoupdate.add(acc);
        }
        if(!accountlisttoupdate.IsEmpty()){
               update accountlisttoupdate; 
        }
         
     
        System.debug('Apex class executed');
        
    }
    
    global void finish(Database.Batchablecontext db){
         AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :db.getJobId()]; 
    System.debug('>>>> finish ' + job.Status);
    }    

}