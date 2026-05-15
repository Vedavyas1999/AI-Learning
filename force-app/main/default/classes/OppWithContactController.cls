global with sharing class OppWithContactController {
    global Contact contact {get;set;}
    global Opportunity opp {get;set;}

    global OppWithContactController() {
       // contact = new Contact();
        opp = new Opportunity();
    }

    global PageReference saveContactAndOpportunity() {
        try {
           
            // Insert Opportunity
            insert opp;

            // Redirect to success page
            return Page.Successpage;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error creating Opportunity.'));
            return null; // Stay on the same page
        }
    }
}