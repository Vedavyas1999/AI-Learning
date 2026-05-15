public class MyApexClass {
    @future(callout=true)
        public static void sendPostRequest()
        {
        String url = 'https://myra.evoketechnologies.com:4002/chatbot';
        String requestBody = '{"message": "hi"}'; // Replace with your actual request body
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(requestBody);
        
        // Set a longer timeout value (in milliseconds)
        Integer timeoutMilliseconds = 12000; // 12 seconds
        request.setTimeout(timeoutMilliseconds);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if (response != null) {
            System.debug('Response: ' + response);
            
            if (response.getStatusCode() == 200) {
                // Request successful, handle the response
                String responseBody = response.getBody();
                System.debug('Response Body: ' + responseBody);
            } else {
                // Request failed
                System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            System.debug('Error: Null response received.');
        }
    }
}