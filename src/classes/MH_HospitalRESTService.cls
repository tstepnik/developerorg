@RestResource(urlMapping = '/hospitals/*')
global with sharing class MH_HospitalRESTService {

    @HttpGet
    global static List<MH_HospitalRESTResponseWrapper> getHospitals() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        Map<String, String> parameters = request.params;

        List<Hospital__c> hospitals = Database.query(MH_HospitalRESTServiceHelper.generateQuery(parameters));
        List<MH_HospitalRESTResponseWrapper> hospitalsResponseWrappers = MH_HospitalRESTServiceHelper.convertDoctorsToDoctorsServiceWrapper(hospitals);

        return hospitalsResponseWrappers;

    }


    @HttpPost
    global static MH_HospitalRESTWebServiceResponse createHospital(String name, String country,String town, String street) {
        if(MH_HospitalRESTServiceHelper.checkUpsertFieldsEmpty(null, name, country, town, street)){
            return null;
        }
        else {
            try {
                MH_HospitalRESTWebServiceResponse webServiceResponse = MH_HospitalRESTServiceHelper.upsertHospital(null, name, country, town, street);
                return webServiceResponse;
            } catch (Exception e) {
                MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse(null, false, e.getMessage());
                return webServiceResponse;
            }
        }
    }

//
    @HttpPut
    global static MH_HospitalRESTWebServiceResponse updateHospital(String id, String name, String country,String town, String street) {
        if(MH_HospitalRESTServiceHelper.checkUpsertFieldsEmpty(null, name, country, town, street)){
            return null;
        }
        else {
            try {
                MH_HospitalRESTWebServiceResponse webServiceResponse = MH_HospitalRESTServiceHelper.upsertHospital(id, name, country, town, street);
                return webServiceResponse;
            } catch (Exception e) {
                MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse(null, false, e.getMessage());
                return webServiceResponse;
            }
        }
    }


    @HttpDelete
    global static MH_HospitalRESTWebServiceResponse deleteHospital() {
        RestRequest request = RestContext.request;
        String hospitalId = request.params.get('id');
        if(String.isBlank(hospitalId)){
            return null;
        }
        else {
            try {
                Hospital__c hospital = [SELECT Id FROM Hospital__c WHERE Id = :hospitalId];
                    if(hospital == null) {
                        hospital = new Hospital__c(Id = hospitalId);
                    }

                Database.DeleteResult result = Database.delete(hospital);
                MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse(hospitalId, result.isSuccess(), result.isSuccess() ? '' : result.getErrors()[0].getMessage());
                return webServiceResponse;
            } catch (Exception e) {
                MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse(null, false, e.getMessage());
                return webServiceResponse;
            }
        }
    }
}