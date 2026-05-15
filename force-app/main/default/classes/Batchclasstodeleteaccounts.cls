global class Batchclasstodeleteaccounts implements database.batchable<sobject>{
    global database.querylocator Start(database.batchablecontext bc ){
       // Date today = Date.today();
        return Database.getQueryLocator([select id,name from Account Where CreatedDate = Today]);
    }
    global void execute(database.batchablecontext bc , list<account> acclist){
        delete acclist;
    }
    global void finish(database.batchablecontext bc){
        
    }

}