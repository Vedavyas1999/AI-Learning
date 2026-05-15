public class avoidcondeletionhandler {
    public static void deletionmethod(List<contact> cons){
        set<id> adminids =new Set<id>();
        List<USer> userids =[select id,name from user where Profile.Name='System Administrator'];
        for(User us: userids){
            adminids.add(us.Id);
        }
        for(contact con: cons){
            if(!adminids.contains(Userinfo.getuserid())){
                con.adderror('You cannot delete this record as an System Administrator');
            }  
        }
        
    }
}