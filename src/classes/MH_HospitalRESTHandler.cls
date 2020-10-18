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
    private Boolean invalidSession;
    public String token { get; set; }
    private Cache.SessionPartition sessionPartition;

    public MH_HospitalRESTHandler() {
        invalidSession = false;
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
                try {
                    sessionPartition = Cache.Session.getPartition('local.ModernHospitalSystem');
                } catch (Exception e) {
                    System.debug('ERROR IS IN PARTITION');
                    System.debug(e.getMessage());
                }
            }
            token = getAccessToken();
        }
    }

    public String getAccessToken() {

        String cachedToken;
        if (Test.isRunningTest()) {
            cachedToken = '';
        } else {
            if (!System.isQueueable() && !invalidSession) {
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
            hadnleAuthentication(responseFromHX);

            Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(responseFromHX.getBody());
            String requestToken = (String) jsonMap.get('access_token');
            if (!System.isQueueable()) {
                invalidSession = false;
                //this line is nessesary when you lost session
                token = requestToken;
                sessionPartition.put('token', requestToken);
            }
            return requestToken;
        } else {
            return cachedToken;
        }
    }

    public List<String> getCountryPicklistValues() {
        HttpRequest requestToHX = createRequest(countriesEndpoint, 'GET', null);
        HttpResponse responseFromHX;
        responseFromHX = createResponse(requestToHX);
        return (List<String>) JSON.deserialize(responseFromHX.getBody(), List<String>.class);
    }

    public List<MH_HospitalRESTResponseWrapper> getHospitals(Map<String, String> parameters) {
        String requestEndpoint = endpointBuilder(parameters,mainEndpoint);
        MH_LogExternalApi log;

        HttpRequest request = new HttpRequest();
        List<MH_HospitalRESTResponseWrapper> hospitals = new List<MH_HospitalRESTResponseWrapper>();
        HttpResponse response = new HttpResponse();
        try {
            request = createRequest(requestEndpoint, 'GET', null);
            response = createResponse(request);
            hospitals = (List<MH_HospitalRESTResponseWrapper>) JSON.deserialize(
                    response.getBody(), List<MH_HospitalRESTResponseWrapper>.class);
            log = new MH_LogExternalApi.Info(request, response, 'getHospitals');
        } catch (Exception e) {
            log = catchLog(request, response, e, 'getHospitals');
            log.createLog();
            return null;
        }
        log.createLog();
        return hospitals;
    }

    public MH_HospitalRESTWebServiceResponse addHospital(MH_HospitalRESTResponseWrapper hospitalWrapper) {
        MH_LogExternalApi log;
        HttpRequest request = new HttpRequest();
        HttpResponse response;
        try {
            request = createRequest(mainEndpoint, 'POST', hospitalWrapper);
            response = createResponse(request);
            log = new MH_LogExternalApi.Info(request, response, 'addHospital');
        } catch (Exception e) {
            log = catchLog(request, response, e, 'addHospital');
            log.createLog();
        }
        log.createLog();
        return (MH_HospitalRESTWebServiceResponse) JSON.deserialize(response.getBody(), MH_HospitalRESTWebServiceResponse.class);

    }

    public String updateHospital(MH_HospitalRESTResponseWrapper hospitalWrapper) {
        MH_LogExternalApi log;
        HttpRequest request = new HttpRequest();
        HttpResponse response;
        try {
            request = createRequest(mainEndpoint, 'PUT', hospitalWrapper);
            response = createResponse(request);
            log = new MH_LogExternalApi.Info(request, response, 'updateHospital');
        } catch (Exception e) {
            log = catchLog(request, response, e, 'updateHospital');
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
        MH_HospitalRESTWebServiceResponse responseWrapper;
        String requestEndpoint = mainEndpoint;
        MH_LogExternalApi log;
        requestEndpoint += ('?id=' + hospitalId);
        requestEndpoint += ('&isIntegration=' + isIntegration);
        HttpRequest request = new HttpRequest();
        HttpResponse response;
        try {
            request = createRequest(requestEndpoint, 'DELETE', null);
            response = createResponse(request);
            log = new MH_LogExternalApi.Info(request, response, 'deleteHospital');
            log.createLog();
        } catch (Exception e) {
            log = catchLog(request, response, e, 'deleteHospital');
            log.createLog();
        }
        if (response.getStatusCode() == 200) {
            return Label.MH_Success_Message;
        } else {
            responseWrapper = (MH_HospitalRESTWebServiceResponse)
                    JSON.deserializeStrict(response.getBody(), MH_HospitalRESTWebServiceResponse.class);
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

    private MH_LogExternalApi catchLog(HttpRequest request, HttpResponse response, Exception e, String methodName) {
        MH_LogExternalApi log;
        if (e instanceof CalloutException) {
            log = new MH_LogExternalApi.Error(request, e, methodName);
        } else {
            log = new MH_LogExternalApi.Error(request, response, e, methodName);
        }
        if (e.getMessage().contains('Read timed out') && e instanceof CalloutException) {
            if (log != null) {
                log.createLog();
            }
            throw e;
        }
        System.debug(e.getMessage());
        return log;
    }

    private HttpRequest createRequest(String endpoint, String methodType, MH_HospitalRESTResponseWrapper bodyWrapper) {
        String accessToken = 'OAuth ' + token;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(methodType);
        request.setHeader('Authorization', accessToken);
        request.setHeader('Content-Type', contentType);
        if (methodType.equals('POST') || methodType.equals('PUT')) {
            request.setBody(JSONSerializerForADDHospital(bodyWrapper));
        }
        return request;
    }

    private HttpResponse createResponse(HttpRequest request) {
        HttpResponse response = new Http().send(request);
        Integer statusCode = response.getStatusCode();
        if (statusCode == 401) {
            invalidSession = true;
            getAccessToken();
            String accessToken = 'OAuth ' + token;
            request.setHeader('Authorization', accessToken);
            response = new Http().send(request);
        }
        return response;
    }

    private void hadnleAuthentication(HttpResponse response) {
        Integer statusCode = response.getStatusCode();
        String body = response.getBody();
        if (statusCode == 400 && body.contains('invalid_grant')) {
            throw new MH_InvalidCredentialsException('Cannot log to external service. Please check your credentials.Page could invoke another exceptions, please do not use it until exception disappears.');
        } else if (statusCode != 200) {
            throw new MH_ExternalServiceConnetionException('There is a problem with connet to external service.');
        }
    }

    private String endpointBuilder(Map<String, String> parameters, String mainEndpoint){
        String requestEndpoint = mainEndpoint;
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
        return requestEndpoint;
    }
}