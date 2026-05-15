({
    navigateToEditLines: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var navService = component.find("navService");
        var pageReference = {
            type: "standard__component",
            attributes: {
                componentName: "c__SBQQ__sbqq__sb_EditLines"
            },
            state: {
                c__recordId: recordId
            }
        };
        navService.navigate(pageReference);
    }
})