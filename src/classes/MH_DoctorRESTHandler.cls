/**
 * Created by BRITENET on 08.10.2020.
 */

public with sharing class MH_DoctorRESTHandler {
    public with sharing class HD_HospitalRestServiceHandler {
//        private final String clientId = HD_Utils.getCustomSettingValue('WebServiceClientId');
//        private final String clientSecret = HD_Utils.getCustomSettingValue('WebServiceClientSecret');
        private final String username = HD_Utils.getCustomSettingValue('WebServiceLogin');
        private final String password = HD_Utils.getCustomSettingValue('WebServicePassword');
//        private final String authEndpoint = HD_Utils.getCustomSettingValue('AuthEndpoint');
        private final String requestEndpointPrefix = HD_Utils.getCustomSettingValue('RestRequestEndpoint');
        private final String hospitalApiName = HD_Utils.getCustomSettingValue('HospitalsRestApiName');
        private final String countryApiName = HD_Utils.getCustomSettingValue('CountryRestApiName');
        private final String requestEndpoint = requestEndpointPrefix + hospitalApiName;
        private final String contentType = 'application/json';
        private Cache.SessionPartition sessionPartition;
        public HospitalWrapper hospitalWrapper {get; set;}
        public HospitalWrapper hospitalForCRUD {get; set;}
        public String token {get; set;}
        private HD_IntegrationLog__c integrationLog {get; set;}
        public HD_HospitalRestServiceHandler() {
            if (!Test.isRunningTest()) {
                if (System.isQueueable() ) {
                    token = getAccessToken();
                } else {
                    sessionPartition = Cache.Session.getPartition('local.DoctorsHospitals');
                }
            }
        }
        public class HospitalWrapper {
            public String HX_Id {get; set;}
            public String name {get; set;}
            public String country {get; set;}
            public String town {get; set;}
            public String street {get; set;}
            public String postalCode {get; set;}
            public String email {get; set;}
            public String phone {get; set;}
            public String faxNumber {get; set;}
            public String website {get; set;}
            public HospitalWrapper(HD_Hospital__c hospital) {
                this.HX_Id = hospital.HX_Id__c;
                this.name = hospital.Name;
                this.country = hospital.Country__c;
                this.town = hospital.Town__c;
                this.street = hospital.Street__c;
                this.postalCode = hospital.Postal_Code__c;
                this.email = hospital.E_mail__c;
                this.phone = hospital.Phone__c;
                this.faxNumber = hospital.Fax_Number__c;
                this.website = hospital.Website__c;
            }
        }
        public class DeserializeResponse {
            public String Id;
            public String access_token;
        }
        public String getAccessToken() {
            HttpResponse responseFromHX = new HttpResponse();
            String endpointSuffix = '?grant_type=password&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password;
            HttpRequest requestToHX = new HttpRequest();
            requestToHX.setMethod('POST');
            requestToHX.setEndpoint(authEndpoint + endpointSuffix);
            responseFromHX = new Http().send(requestToHX);
            DeserializeResponse deserializeResponse = (DeserializeResponse) JSON.deserialize(responseFromHX.getBody(), DeserializeResponse.class);
            System.debug('is from batch >> ' + System.isBatch());
            if (!System.isQueueable()) {
                if (!System.isBatch()) {
                    sessionPartition.put('accessToken', deserializeResponse.access_token);
                } else {
                    return deserializeResponse.access_token;
                }
            }
            return deserializeResponse.access_token;
        }
        public List<String> getCountryPicklistValues() {
            HttpRequest requestToHX = new HttpRequest();
            requestToHX.setEndpoint(requestEndpointPrefix + countryApiName);
            requestToHX.setMethod('GET');
            String accessToken = 'OAuth ';
            HttpResponse responseFromHX;
            if (!Test.isRunningTest()) {
                if (sessionPartition.contains('accessToken')) {
                    accessToken += sessionPartition.get('accessToken');
                } else {
                    getAccessToken();
                    accessToken += sessionPartition.get('accessToken');
                }
            }
            requestToHX.setHeader('Authorization', accessToken);
            requestToHX.setHeader('Content-Type', contentType);
            responseFromHX = new Http().send(requestToHX);
            return (List<String>) JSON.deserialize(responseFromHX.getBody().substring(1, responseFromHX.getBody()
                    .length() - 1).replace('\\', ''), List<String>.class);
        }
        public String getHospitals(Map<String, String> params) {
            integrationLog = null;
            HttpResponse responseFromHX = new HttpResponse();
            responseFromHX = getResponse('GET', '?', params);
            return responseFromHX.getBody();
        }
        public List<HospitalWrapper> fetchHospitalsList(String hospitals) {
            return (List<HospitalWrapper>) JSON.deserialize(hospitals.substring(1, hospitals.length() - 1).replace('\\"', '"'), List<HospitalWrapper>.class);
        }
        public String createHospital(Map<String, String> params) {
            integrationLog = null;
            HttpResponse responseFromHX = new HttpResponse();
            responseFromHX = getResponse('POST', null, params);
            return responseFromHX.getBody();
        }
        public String updateHospital(String hospitalId, Map<String, String> params) {
            HttpResponse responseFromHX = new HttpResponse();
            integrationLog = new HD_IntegrationLog__c(HX_Id__c = hospitalId);
            String endpointSuffix = '' + hospitalId;
            responseFromHX = getResponse('PUT', endpointSuffix, params);
            return responseFromHX.getBody();
        }
        public String deleteHospital(String hospitalId) {
            HttpResponse responseFromHX = new HttpResponse();
            integrationLog = new HD_IntegrationLog__c(HX_Id__c = hospitalId);
            String endpointSuffix = '' + hospitalId;
            responseFromHX = getResponse('DELETE', endpointSuffix, null);
            return responseFromHX.getBody();
        }
        public HttpResponse getResponse(String methodType, String endpointSuffix, Map<String, String> params) {
            HttpRequest requestToHX = new HttpRequest();
//            if (!Test.isRunningTest()) {
//                if (System.isQueueable()) {
//                    requestToHX.setHeader('Authorization', 'OAuth ' + token);
//                } else {
//                    requestToHX.setHeader('Authorization', 'OAuth ' + (String) sessionPartition.get('accessToken'));
//                }
//            }
            requestToHX.setHeader('Content-Type', contentType);
            requestToHX.setMethod(methodType);
            if (methodType.equals('GET')) {
                for (String key : params.keySet()) {
                    endpointSuffix += key + '=' + params.get(key) + '&';
                }
            }
            if (params != null && !methodType.equals('GET')) {
                requestToHX.setBody(JSON.serialize(params));
            }
            if (endpointSuffix != null) {
                requestToHX.setEndpoint(requestEndpoint + endpointSuffix);
            } else {
                requestToHX.setEndpoint(requestEndpoint);
            }
            HttpResponse responseFromHX = new Http().send(requestToHX);
            if (integrationLog != null) {
                integrationLog.Request__c = requestToHX.getEndpoint();
                integrationLog.Request_Body__c = requestToHX.getBody();
                integrationLog.Method_Type__c = requestToHX.getMethod();
                integrationLog.Response__c = responseFromHX.getBody();
                integrationLog.Status__c = String.valueOf(responseFromHX.getStatusCode());
            }
            if (responseFromHX.getStatusCode() == 401) {
                if (integrationLog != null) {
                    createIntegrationLog(integrationLog.HX_Id__c, integrationLog.Request__c, integrationLog.Request_Body__c,
                            integrationLog.Method_Type__c, integrationLog.Response__c, integrationLog.Status__c, true);
                    integrationLog = null;
                }
                throw new HD_CustomException(System.Label.Unauthorized);
            }
            if (responseFromHX.getStatusCode() == 200) {
                if (responseFromHX.getBody().contains(System.Label.Error)) {
                    if (integrationLog != null) {
                        createIntegrationLog(integrationLog.HX_Id__c, integrationLog.Request__c, integrationLog.Request_Body__c,
                                integrationLog.Method_Type__c, integrationLog.Response__c, integrationLog.Status__c, true);
                        integrationLog = null;
                    }
                    throw new HD_CustomException(responseFromHX.getBody());
                }
                if (integrationLog != null) {
                    createIntegrationLog(integrationLog.HX_Id__c, integrationLog.Request__c, integrationLog.Request_Body__c,
                            integrationLog.Method_Type__c, integrationLog.Response__c, integrationLog.Status__c, false);
                    integrationLog = null;
                }
                return responseFromHX;
            } else {
                if (integrationLog != null) {
                    createIntegrationLog(integrationLog.HX_Id__c, integrationLog.Request__c, integrationLog.Request_Body__c,
                            integrationLog.Method_Type__c, integrationLog.Response__c, integrationLog.Status__c, true);
                    integrationLog = null;
                }
                throw new HD_CustomException(System.Label.Unhandled_Exception);
            }
        }
        public HttpResponse getIntegrationLogsResponse(String methodType, String endpoint, String body) {
            HttpRequest requestToHX = new HttpRequest();
            token = getAccessToken();
            requestToHX.setHeader('Authorization', 'OAuth ' + token);
            requestToHX.setMethod(methodType);
            requestToHX.setEndpoint(endpoint);
            if (body != null) {
                requestToHX.setBody(body);
            }
            HttpResponse responseFromHX = new Http().send(requestToHX);
            return responseFromHX;
        }
        @future(callout = true)
        public static void createIntegrationLog(String hospitalId, String request, String requestBody, String methodType, String response, String status, Boolean retry) {
            HD_IntegrationLog__c integrationLogToSend = new HD_IntegrationLog__c(
                    HX_Id__c = hospitalId, Request__c = request, Request_Body__c = requestBody, Method_Type__c = methodType,
                    Response__c = response, Status__c = status);
            if (retry) {
                integrationLogToSend.Retry__c = true;
            }
            List<HD_IntegrationLog__c> integrationLogs = [SELECT HX_Id__c, Retry__c, Attempt_Number__c FROM HD_IntegrationLog__c WHERE HX_Id__c = :hospitalId AND Retry__c = true LIMIT 1];
            if (!integrationLogs.isEmpty()) {
                integrationLogs[0].Retry__c = false;
                integrationLogToSend.Attempt_Number__c = integrationLogs[0].Attempt_Number__c + 1;
                if (integrationLogToSend.Attempt_Number__c > 4) {
                    integrationLogToSend.Retry__c = false;
                }
                try {
                    update integrationLogs;
                } catch (DmlException e) {
                    throw new HD_CustomException(e.getDmlMessage(0));
                }
            }
            try {
                insert integrationLogToSend;
            } catch (DmlException e) {
                throw new HD_CustomException(e.getDmlMessage(0));
            }
        }
    }