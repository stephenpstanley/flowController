@IsTest
global class FlowManagerControllerCalloutMockPatch implements HttpCalloutMock {
    // Implement this interface method
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('');
        res.setStatusCode(204);
        return res;
    }
}
