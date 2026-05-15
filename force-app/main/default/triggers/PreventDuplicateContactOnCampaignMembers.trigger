trigger PreventDuplicateContactOnCampaignMembers on Campaign (before update) {
    Set<String> contactStatusCombinations = new Set<String>();

    for (Campaign updatedCampaign : Trigger.new) {
        if (updatedCampaign.Id == null) {
            continue;
        }

        List<CampaignMember> existingCampaignMembers = [SELECT ContactId, Status
                                                        FROM CampaignMember
                                                        WHERE CampaignId = :updatedCampaign.Id];

        for (CampaignMember existingCampaignMember : existingCampaignMembers) {
            String key = existingCampaignMember.ContactId + '-' + existingCampaignMember.Status;

            if (contactStatusCombinations.contains(key)) {
                updatedCampaign.addError('One or more Contacts have duplicate Status values in the Campaign.');
                break;
            } else {
                contactStatusCombinations.add(key);
            }
        }
    }

    // Debug statements to check execution flow
    System.debug('Trigger executed successfully.');
}