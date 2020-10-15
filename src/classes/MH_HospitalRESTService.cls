@RestResource(urlMapping = '/v1/hospitals/*')
global with sharing class MH_HospitalRESTService {

    @HttpGet
    global static List<MH_HospitalRESTResponseWrapper> getHospitals() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        Map<String, String> parameters = request.params;
        String query = MH_HospitalRESTServiceHelper.generateQuery(parameters);
        List<Hospital__c> hospitals = Database.query(query);

        MH_ApexLog.Information info = new MH_ApexLog.Information(
                MH_HospitalRESTService.class.getName(),
                'getHospitals',
                RestContext.request,
                RestContext.response,
                ' working on this feature'
        );
        new MH_ApexLog().createLog(info);
        return MH_HospitalRESTServiceHelper.convertDoctorsToDoctorsServiceWrapper(hospitals);
    }

    @HttpPost
    global static MH_HospitalRESTWebServiceResponse createHospital(String externalId, String name, String country, String town, String street, String email, Boolean isIntegration) {
        String jsonBody = MH_Utils.fromParamsToJSON(externalId, name, country, town, street, externalId, isIntegration);
        if (isIntegration == null) {
            isIntegration = false;
        }
        try {
            MH_HospitalRESTServiceHelper.throwErrorIfEmptyName(name);
            RestContext.response.statusCode = 201;
            MH_HospitalRESTWebServiceResponse response = MH_HospitalRESTServiceHelper.upsertHospital(null, externalId, name, country, town, street, email, isIntegration);
            MH_ApexLog.Information info = new MH_ApexLog.Information(
                    MH_HospitalRESTService.class.getName(),
                    'createHospital',
                    RestContext.request,
                    RestContext.response,
                    jsonBody
            );
            new MH_ApexLog().createLog(info);
            return response;

        } catch (Exception e) {
            MH_ApexLog.Error error = new MH_ApexLog.Error(e.getMessage(), e.getLineNumber(), e.getStackTraceString());
            new MH_ApexLog().createLog(error);
            RestContext.response.statusCode = 400;
            return new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
        } finally {
            if (MH_Utils.disabledTriggers.contains(Hospital__c.getSObjectType())) {
                MH_Utils.enableTrigger(Hospital__c.getSObjectType());
            }
        }
    }
    @HttpPut
    global static MH_HospitalRESTWebServiceResponse updateHospital(String id, String externalId, String name, String country, String town, String street, String email, Boolean isIntegration) {
        if (isIntegration == null) {
            isIntegration = false;
        }
        try {
            MH_HospitalRESTServiceHelper.throwErrorIfEmptyName(name);
            return MH_HospitalRESTServiceHelper.upsertHospital(id, externalId, name, country, town, street, email, isIntegration);
        } catch (Exception e) {
            RestContext.response.statusCode = 400;
            return new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
        } finally {
            if (MH_Utils.disabledTriggers.contains(Hospital__c.getSObjectType())) {
                MH_Utils.enableTrigger(Hospital__c.getSObjectType());
            }
        }
    }

    @HttpDelete
    global static MH_HospitalRESTWebServiceResponse deleteHospital() {

        RestRequest request = RestContext.request;
        String hospitalId = request.params.get('id');
        String isIntegration = request.params.get('isIntegration');
        if (String.isBlank(hospitalId)) {
            return null;
        } else {

            try {
                Hospital__c hospital = new Hospital__c(Id = hospitalId);

                if (String.isNotBlank(isIntegration) && isIntegration.equals('true')) {
                    MH_Utils.disableTrigger(Hospital__c.getSObjectType());
                }

                Database.DeleteResult result = Database.delete(hospital);
                System.debug('DELETE RESULT');
                System.debug(result);
                return new MH_HospitalRESTWebServiceResponse(
                        hospitalId,
                        true,
                        Label.MH_Success_Message);
            } catch (Exception e) {
                RestContext.response.statusCode = 400;
                return new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
            } finally {
                if (MH_Utils.disabledTriggers.contains(Hospital__c.getSObjectType())) {
                    MH_Utils.enableTrigger(Hospital__c.getSObjectType());
                }
            }
        }
    }
}