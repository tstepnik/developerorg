@RestResource(urlMapping = '/v1/hospitals/*')
global with sharing class MH_HospitalRESTService {

    @HttpGet
    global static List<MH_HospitalRESTResponseWrapper> getHospitals() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        Map<String, String> parameters = request.params;
        String query = MH_HospitalRESTServiceHelper.generateQuery(parameters);
        List<Hospital__c> hospitals = Database.query(query);

        return MH_HospitalRESTServiceHelper.convertDoctorsToDoctorsServiceWrapper(hospitals);
    }

    @HttpPost
    global static MH_HospitalRESTWebServiceResponse createHospital(String externalId, String name, String country, String town, String street, String email) {
//przed insertem wyłącz trigger
        System.debug('JEST W POSCIE');
        try {
            MH_HospitalRESTServiceHelper.throwErrorIfEmptyName(name);
            RestContext.response.statusCode = 201;
            //wyyłącz
            MH_HospitalRESTWebServiceResponse response = MH_HospitalRESTServiceHelper.upsertHospital(null, externalId, name, country, town, street, email);
            //włącz trigger
            return response;

        } catch (Exception e) {
            RestContext.response.statusCode = 400;
            return new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
        }
    }

    @HttpPut
    global static MH_HospitalRESTWebServiceResponse updateHospital(String id, String externalId, String name, String country, String town, String street, String email) {

        try {
            MH_HospitalRESTServiceHelper.throwErrorIfEmptyName(name);
            return MH_HospitalRESTServiceHelper.upsertHospital(id, externalId, name, country, town, street, email);
        } catch (Exception e) {
            RestContext.response.statusCode = 400;
            return new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
        }
    }

    @HttpDelete
    global static MH_HospitalRESTWebServiceResponse deleteHospital() {
        RestRequest request = RestContext.request;
        String hospitalId = request.params.get('id');
        String ExternalId = request.params.get('isIntegration');
        if (String.isBlank(hospitalId)) {
            return null;
        } else {
            try {
                Hospital__c hospital = new Hospital__c(Id = hospitalId);
                Database.DeleteResult result = Database.delete(hospital);
                return new MH_HospitalRESTWebServiceResponse(
                        hospitalId,
                        true,
                        Label.MH_Success_Message);
            } catch (Exception e) {
                RestContext.response.statusCode = 400;
                return new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
            }
        }
    }
}