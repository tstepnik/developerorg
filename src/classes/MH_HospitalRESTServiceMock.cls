@isTest
global class MH_HospitalRESTServiceMock implements HttpCalloutMock {

    private String responseBody { get; set; }
    private Integer responseStatusCode { get; set; }

    public MH_HospitalRESTServiceMock(String responseBody, Integer responseStatusCode) {
        this.responseBody = responseBody;
        this.responseStatusCode = responseStatusCode;
    }

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(responseBody);
        res.setStatusCode(responseStatusCode);
        return res;
    }
}