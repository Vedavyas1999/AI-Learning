public with sharing class Testclass {
    public Testclass() {
     List<Account> acclist =[select id,name from Account ];
    }
}