@RestResource(urlMapping = '/v1/hospitals/*')
global with sharing class MH_HospitalRESTService {
    private static String className = MH_HospitalRESTService.class.getName();

    @HttpGet
    global static List<MH_HospitalRESTResponseWrapper> getHospitals() {
        Datetime requestTime = Datetime.now();
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
        log.requestTime = requestTime;
        log.responseTime = Datetime.now();
        log.insertLog();
        return responseWrappers;
    }
    @HttpPost
    global static MH_HospitalRESTWebServiceResponse createHospital(String externalId, String name, String country, String town, String street, String email, Boolean isIntegration) {
        return MH_HospitalRESTServiceHelper.upsertServiceResponse(null, externalId, name, country, town, street, email, isIntegration);
    }
    @HttpPut
    global static MH_HospitalRESTWebServiceResponse updateHospital(String id, String externalId, String name, String country, String town, String street, String email, Boolean isIntegration) {
        return MH_HospitalRESTServiceHelper.upsertServiceResponse(id, externalId, name, country, town, street, email, isIntegration);
    }
    @HttpDelete
    global static MH_HospitalRESTWebServiceResponse deleteHospital() {
        Datetime requestTime = Datetime.now();
        MH_HospitalRESTWebServiceResponse serviceResponse;
        RestResponse response = RestContext.response;
        RestRequest request = RestContext.request;
        String endpoint = MH_Utils.getFullGetResourcePath(request);
        MH_LogRestApi log;

        String hospitalId = request.params.get('id');
        String isIntegration = request.params.get('isIntegration');
        if (String.isBlank(hospitalId)) {
            RestContext.response.statusCode = 400;
            String errorMsg = 'Id is blank. Returned null.';
            log = new MH_LogRestApi.Info('Not Found', request, response);
            serviceResponse = new MH_HospitalRESTWebServiceResponse(null, false, errorMsg);
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
        log.requestTime = requestTime;
        log.responseTime = Datetime.now();
        log.insertLog();
        //FOR TEST todo REMOVE IT AFTER
//        Integer start = System.Now().millisecond();
//        while(System.Now().millisecond()< start+130000){
//        }
        return serviceResponse;
    }

    @HttpPatch
    global static MH_HospitalRESTWebServiceResponse undeleteHospital() {
        Datetime requestTime = Datetime.now();
        MH_HospitalRESTWebServiceResponse serviceResponse;
        RestResponse response = RestContext.response;
        RestRequest request = RestContext.request;
        String endpoint = MH_Utils.getFullGetResourcePath(request);
        MH_LogRestApi log;

        String hospitalId = request.params.get('id');
        String isIntegration = request.params.get('isIntegration');
        String isUndelete = request.params.get('isUndelete');

        if (String.isBlank(hospitalId) || String.isBlank(isUndelete)) {
            String errorMsg = 'Wrond parameters, Id or isUndelete flag are invalid.';
            log = new MH_LogRestApi.Info('Not Found', request, response);
            serviceResponse = new MH_HospitalRESTWebServiceResponse(null, false, errorMsg);
        }

        else {

            try {

                Hospital__c hospital = new Hospital__c(Id = hospitalId);
                if (String.isNotBlank(isIntegration) && isIntegration.equals('true')) {
                    MH_Utils.disableTrigger(Hospital__c.getSObjectType());
                }
                Database.undelete(hospital);
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
        log.apexMethodName = 'undeleteHospital';
        log.requestBody = null;
        log.responseBody = JSON.serialize(serviceResponse);
        log.requestEndpoint = endpoint;
        log.requestTime = requestTime;
        log.responseTime = Datetime.now();
        log.requestMethod = 'UNDELETE';
        log.insertLog();
        //FOR TEST todo REMOVE IT AFTER
//        Integer start = System.Now().millisecond();
//        while(System.Now().millisecond()< start+130000){
//        }
        return serviceResponse;


    }
}