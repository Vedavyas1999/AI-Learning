public with sharing class CreateOpportunityController {
    // Book Information
    public String bookTitle { get; set; }
    public Boolean hasBookBeenAdopted { get; set; }
    
    // Course Information
    public String courseName { get; set; }
    public String courseNumber { get; set; }
    public String courseOffered { get; set; }
    public Integer projectedEnrollment { get; set; }
    public String previousBookTitle { get; set; }
    
    // Personal Information
    public String professorName { get; set; }
    public String professorEmail { get; set; }
    public String professorPhone { get; set; }
    public String institutionName { get; set; }
    public String department { get; set; }
    public String title { get; set; }
    
    // Shipping Address
    public String mailingAddress { get; set; }
    
    public PageReference submitRequest() {
        // Create Opportunity
        Opportunity newOpportunity = new Opportunity(
            Name = bookTitle,
            StageName = 'Review' // Initial stage
            // Add other Opportunity fields
        );
        
        // Associate with Contact or create a new Contact
        Contact existingContact = [SELECT Id FROM Contact WHERE Email = :professorEmail LIMIT 1];
        if (existingContact != null) {
            newOpportunity.ContactId = existingContact.Id;
        } else {
            Contact newContact = new Contact(
                FirstName = professorName,
                Email = professorEmail,
                Phone = professorPhone
                // Add other Contact fields
            );
            insert newContact;
            newOpportunity.ContactId = newContact.Id;
        }
        
        // Insert Opportunity
        insert newOpportunity;
        
        return Page.successPage; // Redirect to a thank-you page
    }
}