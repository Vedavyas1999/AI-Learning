({
    openRedirectWindow: function(component, event, helper) {
        var accountId = component.get("v.recordId");
        var redirectURL = $A.get("$Label.c.Custom_pricetool")+ accountId;
        window.open(redirectURL, 'RedirectWindow');
        $A.get("e.force:closeQuickAction").fire();
        
    },
    
    handleInit: function(component, event, helper) {
        component.set("v.ownerId", component.get("v.recordId"));
        
    }
    
})