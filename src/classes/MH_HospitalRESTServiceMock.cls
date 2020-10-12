@isTest
global class MH_HospitalRESTServiceMock implements HttpCalloutMock {


    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        res.setBody('{"town": "Lublin","street": "Zdrowa","name": "CENTRUM ONKOLOGII ZIEMI LUBELSKIEJ IM. ŚW JANA Z DUKLI","id": "a012X00003kPBhbQAG","email": "centrum@gmail.com","country": "NL"}');

        res.setStatusCode(200);
        return res;
    }
}