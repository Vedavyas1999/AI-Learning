global class QueueableEx  implements Queueable {
    
    global void execute(QueueableContext context) {
        // Query and delete Accounts created today
        List<Account> acclist = [SELECT Id, Name FROM Account WHERE CreatedDate = TODAY];
        delete acclist;
    }
}