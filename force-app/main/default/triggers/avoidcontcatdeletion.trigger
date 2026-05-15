trigger avoidcontcatdeletion on Contact (before delete) {
   
    if(Trigger.isdelete && Trigger.isBefore){
       avoidcondeletionhandler.deletionmethod(trigger.old);
    }

}