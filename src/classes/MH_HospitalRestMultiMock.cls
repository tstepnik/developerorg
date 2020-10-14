@IsTest
global class MH_HospitalRestMultiMock implements HttpCalloutMock {

   global Map<String, HttpCalloutMock> requests;

    public MH_HospitalRestMultiMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    global HTTPResponse respond(HTTPRequest req) {
        HttpCalloutMock mock = requests.get(req.getEndpoint());
        if(mock != null) {
            return mock.respond(req);
        }else {
            throw new MH_MultiMockException('HTTP callout not supported for test methods');
        }
    }
    global void addRequestMock(String url, HttpCalloutMock mock){
        requests.put(url,mock);
    }


}