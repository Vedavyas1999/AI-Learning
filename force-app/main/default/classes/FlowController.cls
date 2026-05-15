public class FlowController {
    public static void executeFlow(String recordId) {
        // Get the Flow's API name
        String flowAPIName = 'Update_Owner'; // Replace with your actual Flow API name

        // Create a Map of input parameters
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('recordId', recordId);

        // Create a Flow.Interview instance using the factory method
        Flow.Interview myFlow = Flow.Interview.createInterview(flowAPIName, inputMap);

        // Start the Flow
        myFlow.start();
    }
}