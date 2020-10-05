public with sharing class MH_DoctorSOAPService {

    public soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebService soapDoctorWebService { get; set; }

    public soapSforceComSchemasClassHcsDoctor.SessionHeader_element header { get; set; }


    public MH_DoctorSOAPService() {
        soapDoctorWebService = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebService();
        header = new soapSforceComSchemasClassHcsDoctor.SessionHeader_element();
        header.sessionId = getSessionId();
        soapDoctorWebService.SessionHeader = header;
    }




    public static String getSessionId() {
        ExternalServiceCredentials__c credentials = MH_Utils.getExternalServiceCredentials('kamilCredentials');
        partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
        partnerSoapSforceCom.LoginResult loginResult = sp.login(credentials.Username__c, credentials.Password__c);
        return loginResult.sessionId;
    }




    public List<MH_DoctorWebService.MH_DoctorWebServiceWrapper> getDoctors(Doctor__c searchItem) {
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result =
                soapDoctorWebService.getDoctors(searchItem.Name, searchItem.LastName__c, searchItem.Town__c, searchItem.Country__c, searchItem.Search_Email__c);
        List<MH_DoctorWebService.MH_DoctorWebServiceWrapper> wrappers = new List<MH_DoctorWebService.MH_DoctorWebServiceWrapper>();
        if(result.isSuccess) {
            for (soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper wrapper : result.content) {
                wrappers.add(new MH_DoctorWebService.MH_DoctorWebServiceWrapper(wrapper));
            }
            return wrappers;
        }else{//TODO what to do if failure
            return wrappers;
        }
    }
    public List<Doctor__c> getDoctors2(Doctor__c searchItem) {
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result =
                soapDoctorWebService.getDoctors(searchItem.Name, searchItem.LastName__c, searchItem.Town__c, searchItem.Country__c, searchItem.Search_Email__c);
        List<Doctor__c> doctors = new List<Doctor__c>();
        if(result.isSuccess) {
            for (soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper wrapper : result.content) {


                doctors.add(new Doctor__c(
                        Id=wrapper.Id,
                        Name = wrapper.Name,
                        LastName__c = wrapper.lastName,
                        Town__c = wrapper.town,
                        Country__c = wrapper.country,
                        Email__c = wrapper.email,
                        Birthday__c = Date.parse(wrapper.birthdate),
                        License_Number__c = Integer.valueOf(wrapper.licenseNumber)
                ));
            }
            return doctors;
        }else{//TODO what to do if failure
            return doctors;
        }
    }





    public String deleteDoctor(String doctorId) {
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result = soapDoctorWebService.deleteDoctor(doctorId);
        if(result.isSuccess) {
            return result.statusMessage;
        }else{//TODO what to do if failure
            return result.statusMessage;
        }
    }




    public String addDoctor(Doctor__c doctor) {
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result =
                soapDoctorWebService.addDoctor(doctor.Name, doctor.LastName__c, doctor.Town__c, doctor.Country__c, doctor.Email__c,
                        doctor.Birthday__c.format());
        if(result.isSuccess) {
            return result.statusMessage;
        }else{//TODO what to do if failure
            return result.statusMessage;
        }
    }



    public String updateDoctor(Doctor__c doctor) {
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result =
                soapDoctorWebService.updateDoctor(doctor.Id, doctor.Name, doctor.LastName__c, doctor.Town__c, doctor.Country__c, doctor.Email__c,
                        doctor.Birthday__c.format());
        if(result.isSuccess) {
            return result.statusMessage;
        }else{//TODO what to do if failure
            return result.statusMessage;
        }
    }


    public List<MH_DoctorWebService.MH_DoctorWebServiceWrapper> toWrappers(List<Doctor__c> doctors){
        List<MH_DoctorWebService.MH_DoctorWebServiceWrapper> wrappers = new List<MH_DoctorWebService.MH_DoctorWebServiceWrapper>();
        for(Doctor__c doctor: doctors){
            wrappers.add(new MH_DoctorWebService.MH_DoctorWebServiceWrapper(doctor));
        }
        return wrappers;
    }
}