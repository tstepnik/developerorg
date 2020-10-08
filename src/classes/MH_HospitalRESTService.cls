@RestResource(urlMapping = '/hospitals/*')
global with sharing class MH_HospitalRESTService {

    @HttpGet
    global static List<MH_HospitalRESTResponseWrapper> getDoctors() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        Map<String, String> parameters = request.params;
        List<Doctor__c> doctors = Database.query(MH_HospitalRESTServiceHelper.generateQuery(parameters));
        List<MH_HospitalRESTResponseWrapper> doctorsResponseWrappers = MH_HospitalRESTServiceHelper.convertDoctorsToDoctorsServiceWrapper(doctors);
        return doctorsResponseWrappers;
    }

    @HttpPost
    global static MH_HospitalRESTWebServiceResponse createDoctor(String firstName, String lastName, String email, String country, String street, String city, String externalId){
        if(MH_HospitalRESTServiceHelper.checkUpsertFieldsEmpty(null, firstName, lastName, email, country, street, city)){
            return null;
        }
        else {
            try {
                MH_HospitalRESTWebServiceResponse webServiceResponse = MH_HospitalRESTServiceHelper.upsertDoctor(null, firstName, lastName, email, country, street, city, externalId);
                return webServiceResponse;
            } catch (Exception e) {
                MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse(null, false, e.getMessage());
                return webServiceResponse;
            }
        }
    }

    @HttpPut
    global static MH_HospitalRESTWebServiceResponse updateDoctor(String id, String firstName, String lastName, String email, String country, String street, String city, String externalId){
        if(MH_HospitalRESTServiceHelper.checkUpsertFieldsEmpty(null, firstName, lastName, email, country, street, city)){
            return null;
        }
        else {
            try {
                MH_HospitalRESTWebServiceResponse webServiceResponse = MH_HospitalRESTServiceHelper.upsertDoctor(id, firstName, lastName, email, country, street, city, externalId);
                return webServiceResponse;
            } catch (Exception e) {
                MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse(null, false, e.getMessage());
                return webServiceResponse;
            }
        }
    }

    @HttpDelete
    global static MH_HospitalRESTWebServiceResponse deleteDoctor() {
        RestRequest request = RestContext.request;
        String doctorId = request.params.get('id');
        String externalId = request.params.get('externalId');
        if(String.isBlank(doctorId)){
            return null;
        }
        else {
            try {
                Doctor__c doctor;
                if(String.isBlank(externalId)){
                    doctor = new Doctor__c(Id = doctorId);
                }else{
                    doctor = [SELECT Id FROM Doctor__c WHERE ExternalDoctorId__c = :externalId];
                    if(doctor == null) {
                        doctor = new Doctor__c(Id = doctorId);
                    }
                }
                Database.DeleteResult result = Database.delete(doctor);
                MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse(doctorId, result.isSuccess(), result.isSuccess() ? '' : result.getErrors()[0].getMessage());
                return webServiceResponse;
            } catch (Exception e) {
                MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse(null, false, e.getMessage());
                return webServiceResponse;
            }
        }
    }
    }