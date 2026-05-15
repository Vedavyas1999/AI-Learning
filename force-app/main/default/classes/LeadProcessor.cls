global without sharing class LeadProcessor implements Database.Batchable<Sobject>,Database.Stateful
{
    public integer recordcount=0;
    public Database.QueryLocator start (Database.Batchablecontext bc){
        return Database.getQuerylocator([Select id,name from Lead]);
    }
    public void Execute(Database.Batchablecontext bc,List<Lead> leadslist){
        for(lead ld:leadslist){
            ld.leadsource='Dreamforce';
        }
        update leadslist;
        recordcount =recordcount+leadslist.size();
    }
    public void finish(Database.Batchablecontext bc){
        System.debug('Done');
        
    }
    
}