// Mock HTTP response generator class
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a mock HTTP response

        //
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"mockResponse": "sample response"}');
        res.setStatusCode(200);
        
        return res;
    }
}