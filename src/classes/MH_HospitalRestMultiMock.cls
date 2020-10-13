@IsTest
global class MH_HospitalRestMultiMock implements HttpCalloutMock {

   global Map<String, HttpCalloutMock> requests;

    public MH_HospitalRestMultiMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    global HTTPResponse respond(HTTPRequest req) {
        System.debug('Wchodzi do respond');
        printMap();
        System.debug('Moj endpoint');
        System.debug(req.getEndpoint());
        System.debug('requests');
        System.debug(requests);
        HttpCalloutMock mock = requests.get(req.getEndpoint());

        System.debug('TEN NIESZCZESNY MOCK');
        System.debug(mock);
        System.debug(requests.get(req.getEndpoint()));
        if(mock != null) {
            return mock.respond(req);
        }else {
            throw new MH_MultiMockException('HTTP callout not supported for test methods');
        }
    }
    global void addRequestMock(String url, HttpCalloutMock mock){
        requests.put(url,mock);
    }

    public void printMap(){
        for(String key : requests.keySet()){
            System.debug(key);
            System.debug(requests.get(key));
        }
    }
}