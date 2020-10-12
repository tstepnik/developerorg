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
    global static MH_HospitalRESTWebServiceResponse createHospital(String name, String country, String town, String street, String email) {

        try {
            MH_HospitalRESTServiceHelper.throwErrorIfEmptyName(name);
            RestContext.response.statusCode = 201;
            return MH_HospitalRESTServiceHelper.upsertHospital(null, name, country, town, street, email);
        } catch (Exception e) {
            RestContext.response.statusCode = 400;
            return new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
        }
    }

    @HttpPut
    global static MH_HospitalRESTWebServiceResponse updateHospital(String id, String name, String country, String town, String street, String email) {

        try {
            MH_HospitalRESTServiceHelper.throwErrorIfEmptyName(name);
            Hospital__c hospital = new Hospital__c(Id = id, Name = name, Country__c = country, Town__c = town, Street__c = street, Email__c = email);
            Database.update(hospital);
            return new MH_HospitalRESTWebServiceResponse(id, true, 'Success');
        } catch (Exception e) {
            RestContext.response.statusCode = 400;
            return new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
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
                return new MH_HospitalRESTWebServiceResponse(
                        hospitalId,
                        true,
                        'Success');
            } catch (Exception e) {
                RestContext.response.statusCode = 400;
                return new MH_HospitalRESTWebServiceResponse(null, false, MH_Utils.rewordStatusMessage(e.getMessage()));
            }
        }
    }
}