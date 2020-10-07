public with sharing class MH_DoctorSOAPService {

    public soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebService soapDoctorWebService { get; set; }
    public soapSforceComSchemasClassHcsDoctor.SessionHeader_element header { get; set; }

    public MH_DoctorSOAPService() {
        soapDoctorWebService = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebService();
        header = new soapSforceComSchemasClassHcsDoctor.SessionHeader_element();
//        header.sessionId = getSessionId();
        soapDoctorWebService.SessionHeader = header;
    }
    public static String getSessionId() {
        if (!Test.isRunningTest()) {
            return '';
        }

        ExternalServiceCredentials__c credentials = MH_Utils.getExternalServiceCredentials('kamilCredentials');
        partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
        partnerSoapSforceCom.LoginResult loginResult = sp.login(credentials.Username__c, credentials.Password__c);
        return loginResult.sessionId;
    }

    public List<MH_ExternalServiceParamWrapper> getDoctors(MH_ExternalServiceParamWrapper searchItem) {
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult();

        try {
            result = soapDoctorWebService.getDoctors(
                    searchItem.name,
                    searchItem.lastName,
                    searchItem.town,
                    searchItem.country,
                    searchItem.email
            );
        } catch (Exception e) {
            System.debug(e);
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, e.getMessage()));
            return null;
        }
        System.debug('DOCTORSOAPSERVICE : ');
        System.debug(result);
        List<MH_ExternalServiceParamWrapper> wrappers = new List<MH_ExternalServiceParamWrapper>();
        if (result.isSuccess && result.content != null) {
            for (soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper wrapper : result.content) {
                wrappers.add(new MH_ExternalServiceParamWrapper(
                        wrapper.id,
                        wrapper.name,
                        wrapper.lastName,
                        wrapper.town,
                        wrapper.country,
                        wrapper.email,
                        wrapper.birthdate,
                        wrapper.licenseNumber
                ));
            }

        }
        return wrappers;
    }
    public String deleteDoctor(String doctorId) {

        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result;

        try {
            result = soapDoctorWebService.deleteDoctor(doctorId);
        } catch (Exception e) {
            System.debug(e);
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, e.getMessage()));
            return null;
        }
        return result.statusMessage;
    }
    public String addDoctor(MH_ExternalServiceParamWrapper doctor) {
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result;

        try {
            result = soapDoctorWebService.addDoctor(
                    doctor.name,
                    doctor.lastName,
                    doctor.town,
                    doctor.country,
                    doctor.email,
                    doctor.birthdate
            );
        } catch (Exception exc) {
            System.debug(exc.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, exc.getMessage()));
            return null;
        }
        return result.statusMessage;
    }
    public String updateDoctor(MH_ExternalServiceParamWrapper doctor) {
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result;

        try {
            result = soapDoctorWebService.updateDoctor(
                    doctor.id,
                    doctor.name,
                    doctor.lastName,
                    doctor.town,
                    doctor.country,
                    doctor.email,
                    doctor.birthdate
            );
        } catch (Exception exc) {
            System.debug(exc.getMessage());
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, exc.getMessage()));
            return null;
        }
        return result.statusMessage;
    }
    public List<String> getCountries(){
        List<String> countries;
        try{
            countries = soapDoctorWebService.getCountriesList();
        }catch (Exception e){
            System.debug(e.getMessage());
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, e.getMessage()));
        }
        return countries;
    }
    public class MH_ExternalServiceParamWrapper {
        public String id { get; set; }
        public String name { get; set; }
        public String lastName { get; set; }
        public String country { get; set; }
        public String town { get; set; }
        public String email { get; set; }
        public String birthdate { get; set; }
        public String licenseNumber { get; set; }

        public MH_ExternalServiceParamWrapper() {
        }
        public MH_ExternalServiceParamWrapper(String id) {
            this.id = id;
        }

        public MH_ExternalServiceParamWrapper(String id, String name, String lastName, String town, String country, String email, String birthdate, String licenseNumber) {
            this.id = id;
            this.name = name;
            this.lastName = lastName;
            this.town = town;
            this.country = country;
            this.email = email;
            this.birthdate = birthdate;
            this.licenseNumber = licenseNumber;
        }
    }
}