public class ScheduleUpdatebatchclassex implements schedulable {
    public void execute (schedulablecontext sc){
        
        batchclassex bcx =new batchclassex();
        Database.executebatch(bcx);
        
         ScheduleUpdatebatchclassex sch =new  ScheduleUpdatebatchclassex();
       string cronex ='0 0 13 * * ?';
    System.schedule('ClassSchedulable', 'cronex',sch);
    }
   

}