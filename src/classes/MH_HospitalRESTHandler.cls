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
            if (! System.isQueueable()) {
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
                cachedToken = (String) sessionPartition.get('token');
            }
        }
        if (String.isBlank(cachedToken)) {
            HttpResponse responseFromHX = new HttpResponse();
            HttpRequest requestToHX = new HttpRequest();
            requestToHX.setMethod('POST');
            requestToHX.setEndpoint(authEndpoint);
            responseFromHX = new Http().send(requestToHX);
            DeserializeResponse deserializeResponse =
                    (DeserializeResponse) JSON.deserialize(responseFromHX.getBody(), DeserializeResponse.class);
            String reqestToken = deserializeResponse.access_token;
            if(!System.isQueueable()) {
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
        HttpRequest requestToHX = new HttpRequest();
        requestToHX.setEndpoint(countriesEndpoint);
        requestToHX.setMethod('GET');
        String accessToken = 'OAuth ' + token;
        HttpResponse responseFromHX;
        requestToHX.setHeader('Authorization', accessToken);
        requestToHX.setHeader('Content-Type', contentType);
        responseFromHX = new Http().send(requestToHX);
        return (List<String>) JSON.deserialize(responseFromHX.getBody(), List<String>.class);
    }

    public List<MH_HospitalRESTResponseWrapper> getHospitals(Map<String, String> parameters) {
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

        Http httpProcess = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setEndpoint(requestEndpoint);
        HttpResponse response = new HttpResponse();

        response = httpProcess.send(request);

        List<MH_HospitalRESTResponseWrapper> hospitals = new List<MH_HospitalRESTResponseWrapper>();
        try {
            hospitals = (List<MH_HospitalRESTResponseWrapper>) JSON.deserialize(
                    response.getBody(), List<MH_HospitalRESTResponseWrapper>.class
            );
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
        return hospitals;
    }

    public String deleteHospital(String hospitalId) {
        String resultJSON;
        String requestEndpoint = mainEndpoint;
        requestEndpoint += ('?id=' + hospitalId);
        Http httpProcess = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('DELETE');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setEndpoint(requestEndpoint);
        HttpResponse response = httpProcess.send(request);
        if (response.getStatusCode() == 200) {
            return Label.MH_Success_Message;
        } else {
            MH_HospitalRESTWebServiceResponse responseWrapper = (MH_HospitalRESTWebServiceResponse)
                    JSON.deserializeStrict(response.getBody(), MH_HospitalRESTWebServiceResponse.class);

            return responseWrapper.statusMessage;
        }
    }

    public String addHospital(MH_HospitalRESTResponseWrapper hospitalWrapper) {
        String resultJSON;
        Http httpProcess = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', contentType);
        request.setEndpoint(mainEndpoint);
        request.setBody(JSONSerializerForADDHospital(hospitalWrapper));
        HttpResponse response = httpProcess.send(request);
        if (response.getStatusCode() == 201) {
            return Label.MH_Success_Message;
        } else {
            MH_HospitalRESTWebServiceResponse responseWrapper = (MH_HospitalRESTWebServiceResponse)
                    JSON.deserialize(response.getBody(), MH_HospitalRESTWebServiceResponse.class);
            return responseWrapper.statusMessage;

        }
    }

    public String updateHospital(MH_HospitalRESTResponseWrapper hospitalWrapper) {
        String resultJSON;
        Http httpProcess = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('PUT');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', contentType);
        request.setEndpoint(mainEndpoint);
        request.setBody(JSONSerializerForUPDATEHospital(hospitalWrapper));
        HttpResponse response = httpProcess.send(request);
        if (response.getStatusCode() == 200) {
            return Label.MH_Success_Message;
        } else {
            MH_HospitalRESTWebServiceResponse responseWrapper = (MH_HospitalRESTWebServiceResponse)
                    JSON.deserialize(response.getBody(), MH_HospitalRESTWebServiceResponse.class);
            return responseWrapper.statusMessage;
        }
    }

    private String JSONSerializerForADDHospital(MH_HospitalRESTResponseWrapper wrapper) {
        Map<String, String> jsonMap = new Map<String, String>();

        jsonMap.put('externalId', wrapper.externalId);
        jsonMap.put('name', wrapper.name);
        jsonMap.put('country', wrapper.country);
        jsonMap.put('town', wrapper.town);
        jsonMap.put('street', wrapper.street);
        jsonMap.put('email', wrapper.email);

        return JSON.serialize(jsonMap);
    }

    private String JSONSerializerForUPDATEHospital(MH_HospitalRESTResponseWrapper wrapper) {
        Map<String, String> jsonMap = new Map<String, String>();

        jsonMap.put('externalId', wrapper.externalId);
        jsonMap.put('id', wrapper.id);
        jsonMap.put('name', wrapper.name);
        jsonMap.put('country', wrapper.country);
        jsonMap.put('town', wrapper.town);
        jsonMap.put('street', wrapper.street);
        jsonMap.put('email', wrapper.email);

        return JSON.serialize(jsonMap);
    }
}