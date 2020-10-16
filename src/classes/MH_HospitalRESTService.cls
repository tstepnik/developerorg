@RestResource(urlMapping = '/v1/hospitals/*')
global with sharing class MH_HospitalRESTService {
    private static String className = MH_HospitalRESTService.class.getName();

    @HttpGet
    global static List<MH_HospitalRESTResponseWrapper> getHospitals() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        Map<String, String> parameters = request.params;
        String endpoint = MH_Utils.getFullGetResourcePath(request);
        String query = MH_HospitalRESTServiceHelper.generateQuery(parameters);
        List<Hospital__c> hospitals;
        List<MH_HospitalRESTResponseWrapper> responseWrappers;
        MH_LogRestApi log;
        try {
            RestContext.response.statusCode = 200;
            hospitals = Database.query(query);
            log = new MH_LogRestApi.Info('OK', request, response);
        } catch (Exception e) {
            hospitals = new List<Hospital__c>();
            RestContext.response.statusCode = 404;
            log = new MH_LogRestApi.Error('Not Found', request, response, e);
        }

        responseWrappers = MH_HospitalRESTServiceHelper.convertDoctorsToDoctorsServiceWrapper(hospitals);
        log.apexClassName = className;
        log.apexMethodName = 'getHospitals';
        log.requestBody = null;
        log.responseBody = JSON.serialize(responseWrappers);
        log.requestEndpoint = endpoint;
        log.createLog();
        return responseWrappers;
    }

    @HttpPost
    global static MH_HospitalRESTWebServiceResponse createHospital(String externalId, String name, String country, String town, String street, String email, Boolean isIntegration) {
        String methodName = 'createHospital';
        String requestBody = MH_Utils.fromParamsToJSON(externalId, name, country, town, street, externalId, isIntegration);
        MH_HospitalRESTWebServiceResponse serviceResponse;
        MH_LogRestApi log;
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        if (isIntegration == null) {
            isIntegration = false;
        }
        try {
            MH_HospitalRESTServiceHelper.throwErrorIfEmptyName(name);
            response.statusCode = 201;
            serviceResponse = MH_HospitalRESTServiceHelper.upsertHospital(null, externalId, name, country, town, street, email, isIntegration);
            log = new MH_LogRestApi.Info('Created', request, response);

        } catch (Exception e) {
            response.statusCode = 400;
            serviceResponse = new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
            log = new MH_LogRestApi.Error('Bad Request', request, response, e);

        } finally {
            if (MH_Utils.disabledTriggers.contains(Hospital__c.getSObjectType())) {
                MH_Utils.enableTrigger(Hospital__c.getSObjectType());
            }
        }
        log.apexClassName = className;
        log.apexMethodName = methodName;
        log.requestBody = requestBody;
        log.responseBody = JSON.serialize(serviceResponse);
        log.createLog();
        return serviceResponse;
    }
    @HttpPut
    global static MH_HospitalRESTWebServiceResponse updateHospital(String id, String externalId, String name, String country, String town, String street, String email, Boolean isIntegration) {
        String methodName = 'updateHospital';
        String requestBody = MH_Utils.fromParamsToJSON(id, externalId, name, country, town, street, externalId, isIntegration);
        MH_HospitalRESTWebServiceResponse serviceResponse;
        MH_LogRestApi log;
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        if (isIntegration == null) {
            isIntegration = false;
        }
        try {
            MH_HospitalRESTServiceHelper.throwErrorIfEmptyName(name);
            response.statusCode = 200;
            serviceResponse = MH_HospitalRESTServiceHelper.upsertHospital(id, externalId, name, country, town, street, email, isIntegration);
            log = new MH_LogRestApi.Info('OK', request, response);

        } catch (Exception e) {
            response.statusCode = 400;
            serviceResponse = new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
            log = new MH_LogRestApi.Error('Bad Request', request, response, e);

        } finally {
            if (MH_Utils.disabledTriggers.contains(Hospital__c.getSObjectType())) {
                MH_Utils.enableTrigger(Hospital__c.getSObjectType());
            }
        }
        log.apexClassName = className;
        log.apexMethodName = methodName;
        log.requestBody = requestBody;
        log.responseBody = JSON.serialize(serviceResponse);
        log.createLog();
        return serviceResponse;
    }

    @HttpDelete
    global static MH_HospitalRESTWebServiceResponse deleteHospital() {
        MH_HospitalRESTWebServiceResponse serviceResponse;
        RestResponse response = RestContext.response;
        RestRequest request = RestContext.request;
        String endpoint = MH_Utils.getFullGetResourcePath(request);
        MH_LogRestApi log;

        String hospitalId = request.params.get('id');
        String isIntegration = request.params.get('isIntegration');
        if (String.isBlank(hospitalId)) {
            log.message = 'Id is blank. Returned null.';
            return null;
        } else {

            try {
                Hospital__c hospital = new Hospital__c(Id = hospitalId);

                if (String.isNotBlank(isIntegration) && isIntegration.equals('true')) {
                    MH_Utils.disableTrigger(Hospital__c.getSObjectType());
                }
                Database.delete(hospital);
                serviceResponse = new MH_HospitalRESTWebServiceResponse(hospitalId, true, Label.MH_Success_Message);
                RestContext.response.statusCode = 200;
                log = new MH_LogRestApi.Info('OK', request, response);
            } catch (Exception e) {
                RestContext.response.statusCode = 400;
                serviceResponse = new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
                log = new MH_LogRestApi.Error('Not Found', request, response, e);
            } finally {
                if (MH_Utils.disabledTriggers.contains(Hospital__c.getSObjectType())) {
                    MH_Utils.enableTrigger(Hospital__c.getSObjectType());
                }
            }
        }
        log.apexClassName = className;
        log.apexMethodName = 'deleteHospital';
        log.requestBody = null;
        log.responseBody = JSON.serialize(serviceResponse);
        log.requestEndpoint = endpoint;
        log.createLog();
        return serviceResponse;
    }
}