global class ScheduleBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        Batchclasstodeleteaccounts batchInstance = new Batchclasstodeleteaccounts();
        Database.executeBatch(batchInstance);
    }
}