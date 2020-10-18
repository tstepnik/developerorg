public with sharing class MH_HospitalRESTHandler {
    private final String clientId;
    private final String clientSecret;
    private final String username;
    private final String password;
    private final String prefix;
    private final String mainEndpoint;
    private final String countriesEndpoint;
    private final String authEndpoint;
    private final String contentType;
    public String token { get; set; }
    private Cache.SessionPartition sessionPartition;

    public MH_HospitalRESTHandler() {
        if (Test.isRunningTest()) {
            mainEndpoint = 'https://eu45.salesforce.com//services/apexrest/hcs/v1/hospitals/';
            clientId = '';
            clientSecret = '';
            username = '';
            password = '';
            countriesEndpoint = '';
            contentType = '';
        } else {
            clientId = MH_Utils.getConfigurationsValue('MH_HospitalRestClientId');
            clientSecret = MH_Utils.getConfigurationsValue('MH_HospitalRestClientSecret');
            username = MH_Utils.getConfigurationsValue('MH_HospitalRestUsername');
            password = MH_Utils.getConfigurationsValue('MH_HospitalRestPassword');
            prefix = MH_Utils.getConfigurationsValue('MH_HospitalRestEndpointPrefix');
            mainEndpoint = prefix + MH_Utils.getConfigurationsValue('MH_HospitalRestHospitalsEndpoint');
            countriesEndpoint = prefix + MH_Utils.getConfigurationsValue('MH_HospitalRestCountriesEndpoint');
            contentType = MH_Utils.getConfigurationsValue('MH_HospitalRestContentType');
        }

        if (Test.isRunningTest()) {
            authEndpoint = '';
        } else {
            authEndpoint = prefix + MH_Utils.getConfigurationsValue('MH_HospitalRestOAuthEndpoint') + clientId + '&username=' + username +
                    '&password=' + password + '&client_secret=' + clientSecret;
        }

        if (Test.isRunningTest()) {
            token = '';
        } else {
            if (!System.isQueueable()) {
                sessionPartition = Cache.Session.getPartition('local.ModernHospitalSystem');
            }
                token = getAccessToken();
        }
    }

    public String getAccessToken() {

        String cachedToken;
        if (Test.isRunningTest()) {
            cachedToken = '';
        } else {
            if (!System.isQueueable()) {
//            if (false) {
                cachedToken = (String) sessionPartition.get('token');
            }
        }

        if (String.isBlank(cachedToken)) {
//        if (true) {
            HttpResponse responseFromHX = new HttpResponse();
            HttpRequest requestToHX = new HttpRequest();
            requestToHX.setMethod('POST');
            requestToHX.setEndpoint(authEndpoint);
            responseFromHX = new Http().send(requestToHX);
            DeserializeResponse deserializeResponse =
                    (DeserializeResponse) JSON.deserialize(responseFromHX.getBody(), DeserializeResponse.class);
            String reqestToken = deserializeResponse.access_token;
            if (!System.isQueueable()) {
                sessionPartition.put('token', reqestToken);
            }
            return reqestToken;
        } else {
            return cachedToken;
        }
    }

    public class DeserializeResponse {
        public String Id;
        public String access_token;
    }

    public List<String> getCountryPicklistValues() {
        HttpRequest requestToHX = createRequest(countriesEndpoint,'GET');
        HttpResponse responseFromHX;
        responseFromHX = new Http().send(requestToHX);
        return (List<String>) JSON.deserialize(responseFromHX.getBody(), List<String>.class);
    }

    public List<MH_HospitalRESTResponseWrapper> getHospitals(Map<String, String> parameters) {
        String requestEndpoint = mainEndpoint;
        MH_LogExternalApi log;

        if (!parameters.isEmpty() && parameters.isEmpty() != null) {
            Iterator<String> iterator = parameters.keySet().Iterator();
            requestEndpoint += '?';
            while (iterator.hasNext()) {
                String key = iterator.next();
                requestEndpoint += (key + '=' + parameters.get(key));
                if (iterator.hasNext())
                    requestEndpoint += '&';
            }
        }
        Http httpProcess = new Http();
        HttpRequest request = new HttpRequest();
        List<MH_HospitalRESTResponseWrapper> hospitals = new List<MH_HospitalRESTResponseWrapper>();
        HttpResponse response = new HttpResponse();
        try {
            request = setRequest('GET',requestEndpoint,null);
            response = httpProcess.send(request);
            hospitals = (List<MH_HospitalRESTResponseWrapper>) JSON.deserialize(
                    response.getBody(), List<MH_HospitalRESTResponseWrapper>.class);
            log = new MH_LogExternalApi.Info(request, response, 'getHospitals');
        } catch (Exception e) {
            log =  catchLog(request,response,e,'getHospitals');
            log.createLog();
            return null;
        }
        log.createLog();
        return hospitals;
    }
    
    public MH_HospitalRESTWebServiceResponse addHospital(MH_HospitalRESTResponseWrapper hospitalWrapper) {
        MH_LogExternalApi log;
        Http httpProcess = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response;
        try {
            request = setRequest('POST',mainEndpoint, hospitalWrapper);
            response = httpProcess.send(request);
            log = new MH_LogExternalApi.Info(request, response, 'addHospital');
        } catch (Exception e) {
           log =  catchLog(request,response,e,'addHospital');
            log.createLog();
        }
        log.createLog();
        return (MH_HospitalRESTWebServiceResponse) JSON.deserialize(response.getBody(), MH_HospitalRESTWebServiceResponse.class);

    }

    public String updateHospital(MH_HospitalRESTResponseWrapper hospitalWrapper) {
        MH_LogExternalApi log;
        Http httpProcess = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response;
        try {
            request = setRequest('PUT',mainEndpoint,hospitalWrapper);
            response = httpProcess.send(request);
            log = new MH_LogExternalApi.Info(request,response, 'updateHospital');
        } catch (Exception e) {
            log = catchLog(request,response,e,'updateHospital');
            log.createLog();
        }

        if (response.getStatusCode() == 200) {
            log.createLog();
            return Label.MH_Success_Message;
        } else {
            MH_HospitalRESTWebServiceResponse responseWrapper = (MH_HospitalRESTWebServiceResponse)
                    JSON.deserialize(response.getBody(), MH_HospitalRESTWebServiceResponse.class);
            log.createLog();
            return responseWrapper.statusMessage;
        }
    }

    public String deleteHospital(String hospitalId, String isIntegration) {
        String requestEndpoint = mainEndpoint;
        MH_LogExternalApi log;
        requestEndpoint += ('?id=' + hospitalId);
        requestEndpoint += ('&isIntegration=' + isIntegration);
        Http httpProcess = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response;
        try {
            request = setRequest('DELETE',requestEndpoint,null);
             response = httpProcess.send(request);
            log = new MH_LogExternalApi.Info(request,response,'deleteHospital');
        }catch (Exception e) {
            log = catchLog(request,response,e,'deleteHospital');
            log.createLog();
        }
            if (response.getStatusCode() == 200) {
                log.createLog();
            return Label.MH_Success_Message;
        } else {
            MH_HospitalRESTWebServiceResponse responseWrapper = (MH_HospitalRESTWebServiceResponse)
                    JSON.deserializeStrict(response.getBody(), MH_HospitalRESTWebServiceResponse.class);
                log.createLog();
            return responseWrapper.statusMessage;
        }
    }

    private String JSONSerializerForADDHospital(MH_HospitalRESTResponseWrapper wrapper) {
        Map<String, Object> jsonMap = new Map<String, Object>();

        jsonMap.put('externalId', wrapper.externalId);
        jsonMap.put('name', wrapper.name);
        jsonMap.put('country', wrapper.country);
        jsonMap.put('town', wrapper.town);
        jsonMap.put('street', wrapper.street);
        jsonMap.put('email', wrapper.email);
        jsonMap.put('isIntegration', wrapper.isIntegration);

        return JSON.serialize(jsonMap);
    }

    private String JSONSerializerForUPDATEHospital(MH_HospitalRESTResponseWrapper wrapper) {
        Map<String, Object> jsonMap = new Map<String, Object>();

        jsonMap.put('externalId', wrapper.externalId);
        jsonMap.put('id', wrapper.id);
        jsonMap.put('name', wrapper.name);
        jsonMap.put('country', wrapper.country);
        jsonMap.put('town', wrapper.town);
        jsonMap.put('street', wrapper.street);
        jsonMap.put('email', wrapper.email);
        jsonMap.put('isIntegration', wrapper.isIntegration);

        return JSON.serialize(jsonMap);
    }

    private void handleCalloutError(Exception e) {
        if (e.getMessage().contains('Read timed out') && e instanceof CalloutException) {
            throw e;
        }
        System.debug(e.getMessage());
    }

    private MH_LogExternalApi catchLog(HttpRequest request, HttpResponse response, Exception e, String methodName){
        MH_LogExternalApi log;
        if (e instanceof CalloutException) {
            log = new MH_LogExternalApi.Error(request, e, methodName);
        } else {
            log = new MH_LogExternalApi.Error(request, response, e, methodName);
        }
        handleCalloutError(e);
        return log;
    }

    private HttpRequest setRequest(String method, String endpoint, MH_HospitalRESTResponseWrapper bodyWrapper){
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setHeader('Authorization', 'OAuth ' + token);
//        request.setHeader('Authorization', 'Bearer ' + token);
        request.setEndpoint(endpoint);
        if (method.equals('POST') || method.equals('PUT')) {
            request.setHeader('Content-Type', contentType);
            request.setBody(JSONSerializerForADDHospital(bodyWrapper));
        }
        return request;
    }

    private HttpRequest createRequest(String endpoint, String methodType){
        String accessToken = 'OAuth ' + token;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(methodType);
        request.setHeader('Authorization', accessToken);
        request.setHeader('Content-Type', contentType);
        return request;
    }
}