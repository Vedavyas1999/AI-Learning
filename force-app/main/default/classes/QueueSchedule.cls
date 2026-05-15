global class QueueSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        QueueableEx batchInstance = new QueueableEx();
        //Database.executeBatch(batchInstance);
        System.enqueueJob(batchInstance);
    }
}