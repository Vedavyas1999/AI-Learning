public with sharing class CreateOppBatch implements Database.Batchable<SObject> {
    private static final Integer BATCH_SIZE = 200;
    private static final Integer NUM_CONTACTS = 9000;
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id FROM Account]);
        // You can modify the query to specify the accounts you want to associate the contacts with
    }
    
    public void execute(Database.BatchableContext context, List<Account> scope) {
        List<Opportunity> OppstoCreate = new List<Opportunity>();
        
        for (Integer i = 0; i < NUM_CONTACTS; i++) {
            Opportunity newopportunity = new Opportunity();
            newopportunity.CloseDate = Date.valueOf('2023-07-05');
            newopportunity.StageName='Value Proposition';
            newopportunity.Name='Opp Ved'+String.valueOf(i);
            OppstoCreate.add(newopportunity);
            
            if (OppstoCreate.size() == BATCH_SIZE) {
                insert OppstoCreate;
                OppstoCreate.clear();
            }
        }
        
        if (!OppstoCreate.isEmpty()) {
            insert OppstoCreate;
        }
    }
    
    public void finish(Database.BatchableContext context) {
    }
}