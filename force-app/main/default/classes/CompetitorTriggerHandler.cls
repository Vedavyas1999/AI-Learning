public class CompetitorTriggerHandler {

    public static void updateCompanyFields(List<Id> competitorIds) {
        List<Competitor__c> competitorsToUpdate = [
            SELECT Id, 
                (SELECT Id, Estimated_Production_t_y__c, Nominal_Capacity_t_y__c FROM Plants__r) 
            FROM Competitor__c 
            WHERE Id IN :competitorIds AND RecordType.DeveloperName='Company'
        ];

        for (Competitor__c competitor : competitorsToUpdate) {
            // Check if Companies__r is not null before processing
            if (competitor.Plants__r != null) {
                // Example calculation:
                Double totalEstimatedProduction = 0;
                Double totalNominalCapacity = 0;

                for (Competitor__c plantsdata : competitor.Plants__r) {
                    // Check if fields are not null before adding to totals
                    if (plantsdata.Estimated_Production_t_y__c != null) {
                        totalEstimatedProduction += plantsdata.Estimated_Production_t_y__c;
                    }
                    if (plantsdata.Nominal_Capacity_t_y__c != null) {
                        totalNominalCapacity += plantsdata.Nominal_Capacity_t_y__c;
                    }
                }

                competitor.Estimated_Production_t_y_Company__c = totalEstimatedProduction;
                competitor.Nominal_Capacity_t_y_Company__c = totalNominalCapacity;
            }
        }

        update competitorsToUpdate;
    }
      public static void updateGroupFields(List<Id> competitorIds) {
        List<Competitor__c> competitorsToUpdate = [
            SELECT Id, 
                (SELECT Id, Estimated_Production_t_y_Company__c, Nominal_Capacity_t_y_Company__c FROM Companies__r) 
            FROM Competitor__c 
            WHERE Id IN :competitorIds AND RecordType.DeveloperName='Group'
        ];

        for (Competitor__c competitor : competitorsToUpdate) {
            // Check if Companies__r is not null before processing
            if (competitor.Companies__r != null) {
                // Example calculation:
                Double totalEstimatedProduction = 0;
                Double totalNominalCapacity = 0;

                for (Competitor__c companiesdata : competitor.Companies__r) {
                    // Check if fields are not null before adding to totals
                    if (companiesdata.Estimated_Production_t_y_Company__c != null) {
                        totalEstimatedProduction += companiesdata.Estimated_Production_t_y_Company__c;
                    }
                    if (companiesdata.Nominal_Capacity_t_y_Company__c != null) {
                        totalNominalCapacity += companiesdata.Nominal_Capacity_t_y_Company__c;
                    }
                }

                competitor.Estimated_Production_t_y_Group__c = totalEstimatedProduction;
                competitor.Nominal_Capacity_t_y_Group__c = totalNominalCapacity;
            }
        }

        update competitorsToUpdate;
    }
}