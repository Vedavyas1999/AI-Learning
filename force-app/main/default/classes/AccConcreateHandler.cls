/**
 * Handler class for Account-related operations
 */
public with sharing class AccConcreateHandler {
    /**
     * Creates Contact records based on the provided Account list
     * @param acclist List of Account records to create contacts from
     */
    public static void createcon(List<account> acclist){
        List<Contact> conlist= new list<Contact>();
        for(Account acc:acclist){
          contact con =new contact();
            con.LastName= acc.Name;
            con.AccountId= acc.id;
            conlist.add(con);
        }
        insert as user conlist;
    }
}