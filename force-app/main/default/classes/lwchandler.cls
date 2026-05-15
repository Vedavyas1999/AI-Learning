public with sharing class lwchandler {
    @auraenabled(cacheable=true)
    public static list<account> lwchandlerm() {
        return [select id,name ,rating,industry,phone from Account limit 10];


    }
}