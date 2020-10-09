/**
 * Created by BRITENET on 09.10.2020.
 */

public with sharing class MH_HospitalRESTHandler {

    private final MH_ExternalOauth2Credentials__c credentials = MH_Utils.getExternalOauth2Credentials('MyCredentials');
    private final String clientId = credentials.client_id__c;
    private final String clientSecret = credentials.client_secret__c;
    private final String username = credentials.username__c;
    private final String password = credentials.password__c;
    private final String mainEndpoint = 'https://eu45.salesforce.com//services/apexrest/v1/hospitals/';
    private final String countriesEndpoint = 'https://eu45.salesforce.com//services/apexrest/v1/utils/getCountriesList';
    private final String authEndpoint = 'https://eu45.salesforce.com/services/oauth2/token?grant_type=password&client_id=' + clientId + '&username=' + username +
            '&password=' + password + '&client_secret=' + clientSecret;
    private final String contentType = 'application/json';
    public String token { get; set; }

    public MH_HospitalRESTHandler() {
        token = getAccessToken();
    }

    public String getAccessToken() {
        HttpResponse responseFromHX = new HttpResponse();
        HttpRequest requestToHX = new HttpRequest();
        requestToHX.setMethod('POST');
        requestToHX.setEndpoint(authEndpoint);
        responseFromHX = new Http().send(requestToHX);
        DeserializeResponse deserializeResponse =
                (DeserializeResponse) JSON.deserialize(responseFromHX.getBody(), DeserializeResponse.class);
        return deserializeResponse.access_token;
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
        System.debug('parameters');
        System.debug(parameters);
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
        System.debug('requestEndpoint');
        System.debug(requestEndpoint);

        Http httpProcess = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setEndpoint(requestEndpoint);
        HttpResponse response = httpProcess.send(request);
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
            return 'Success';
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
        request.setBody(JSON.serialize(hospitalWrapper));
        HttpResponse response = httpProcess.send(request);
        if (response.getStatusCode() == 200) {
            return 'Success';
        } else {
            MH_HospitalRESTWebServiceResponse responseWrapper = (MH_HospitalRESTWebServiceResponse)
                    JSON.deserialize( response.getBody(), MH_HospitalRESTWebServiceResponse.class );
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
        request.setBody(JSON.serialize(hospitalWrapper));
        HttpResponse response = httpProcess.send(request);
        if (response.getStatusCode() == 200) {
            return 'Success';
        } else {
            MH_HospitalRESTWebServiceResponse responseWrapper = (MH_HospitalRESTWebServiceResponse)
                    JSON.deserialize( response.getBody(), MH_HospitalRESTWebServiceResponse.class );
            return responseWrapper.statusMessage;
        }
    }
}