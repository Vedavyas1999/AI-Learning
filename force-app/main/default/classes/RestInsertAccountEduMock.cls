/*******************************************************************************************
* @Name         RestInsertAccountEduMock 
* @Author       Evoke Technologies
* @Date         3/6/2023
* @Description  This class contains all service methods related to caching data in Salesforce.  
				integrate one org to other org, If record Inseted, updated, or deleted in one org
                then same action is performed in the other org automatic/easy.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              vedavyas chowdary      3/7/2023          Updated                                                      
*******************************************************************************************/

public class RestInsertAccountEduMock implements HttpCalloutMock {
    private HttpResponse mockResponse;
    public RestInsertAccountEduMock(HttpResponse mockResponse) {
        this.mockResponse = mockResponse;
    }
    public HttpResponse respond(HttpRequest request) {
        system.debug('respond method called');
        // Simulate the REST endpoint response
        mockResponse.setStatusCode(200);
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"message": "Hello World!"}');
        return mockResponse;
    }
}