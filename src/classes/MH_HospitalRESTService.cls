@RestResource(urlMapping = '/v1/hospitals/*')
global with sharing class MH_HospitalRESTService {

    @HttpGet
    global static List<MH_HospitalRESTResponseWrapper> getHospitals() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        Map<String, String> parameters = request.params;

        List<Hospital__c> hospitals = Database.query(MH_HospitalRESTServiceHelper.generateQuery(parameters));

        return MH_HospitalRESTServiceHelper.convertDoctorsToDoctorsServiceWrapper(hospitals);
    }


    @HttpPost
    global static MH_HospitalRESTWebServiceResponse createHospital(String name, String country, String town, String street) {

        if (MH_HospitalRESTServiceHelper.checkUpsertFieldsEmpty(null, name, country, town, street)) {
            return null;
        } else {
            try {
                RestContext.response.statusCode = 201;
                return MH_HospitalRESTServiceHelper.upsertHospital(null, name, country, town, street);
            } catch (Exception e) {
                RestContext.response.statusCode = 409;
                return new MH_HospitalRESTWebServiceResponse(null, false, e.getMessage());
            }
        }
    }


    @HttpPut
    global static MH_HospitalRESTWebServiceResponse updateHospital(String id, String name, String country, String town, String street) {
        if (MH_HospitalRESTServiceHelper.checkUpsertFieldsEmpty(null, name, country, town, street)) {
            return null;
        } else {
            try {
                MH_HospitalRESTWebServiceResponse webServiceResponse = MH_HospitalRESTServiceHelper.upsertHospital(id, name, country, town, street);
                return webServiceResponse;
            } catch (Exception e) {
                MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse(null, false, e.getMessage());
                RestContext.response.statusCode = 204;
                return webServiceResponse;
            }
        }
    }

    @HttpDelete
    global static MH_HospitalRESTWebServiceResponse deleteHospital() {
        RestRequest request = RestContext.request;
        String hospitalId = request.params.get('id');
        if (String.isBlank(hospitalId)) {
            return null;
        } else {
            try {
                Hospital__c hospital = new Hospital__c(Id = hospitalId);
                Database.DeleteResult result = Database.delete(hospital);
                RestContext.response.statusCode = 204;
                return new MH_HospitalRESTWebServiceResponse(
                        hospitalId,
                        result.isSuccess(),
                        result.isSuccess() ? 'Success' : result.getErrors()[0].getMessage());
            } catch (Exception e) {
                RestContext.response.statusCode = 400;
                return new MH_HospitalRESTWebServiceResponse(null, false, e.getMessage());
            }
        }
    }
}