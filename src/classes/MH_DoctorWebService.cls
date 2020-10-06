global class MH_DoctorWebService {

    webService static MH_DoctorResponseWrapper getDoctors(String firstName,
            String lastName,
            String country,
            String town,
            String email) {
        List<Doctor__c> doctors;

        try {
            doctors = MH_Doctor_Service.soapGetDoctors(firstName, lastName, country, town, email);
            List<MH_DoctorWebServiceWrapper> wrappers = MH_Doctor_Service.fromDoctorsToWrappers(doctors);
            return buildSuccessResponse(wrappers);
        } catch (Exception e) {
            return buildErrorResponse(e.getMessage());
        }
    }

    webService static List<String> getCountriesList(){
        Schema.DescribeFieldResult picklistDescribe = Doctor__c.fields.Country__c.getDescribe();
        Schema.sObjectField picklistField = picklistDescribe.getSObjectField();
        List<PicklistEntry> picklistEntriesList = picklistField.getDescribe().getPicklistValues();
        List<String> countriesLabelValueList = new List<String>();
        for(PicklistEntry entry: picklistEntriesList){
            countriesLabelValueList.add(entry.label + ';' + entry.value);
        }
        return countriesLabelValueList;
    }

    private static MH_DoctorResponseWrapper upsertDoctor(String id, String firstName, String lastName, String country, String town, String email, String birthDate) {
        Doctor__c doctor;

        try {
            doctor = new Doctor__c(
                    Id = id,
                    Name = firstName,
                    LastName__c = lastName,
                    Country__c = country,
                    Email__c = email,
                    Town__c = town,
                    Birthday__c = Date.parse(birthDate)
            );
            Database.upsert(doctor);
            return buildSuccessResponse(doctor);
        } catch (Exception e) {
            return buildErrorResponse(e.getMessage());
        }
    }

    webService static MH_DoctorResponseWrapper addDoctor(String firstName, String lastName, String country, String town, String email, String birthDate) {
        return upsertDoctor(null, firstName, lastName, country, town, email, birthDate);
    }

    webService static MH_DoctorResponseWrapper updateDoctor(String id, String firstName, String lastName, String country, String town, String email, String birthDate) {
        return upsertDoctor(id, firstName, lastName, country, town, email, birthDate);
    }

    webService static MH_DoctorResponseWrapper deleteDoctor(String id) {
        Doctor__c deletedDoctor;
        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();

        try {
            deletedDoctor = new Doctor__c(Id = id);
            Database.DeleteResult result = Database.delete(deletedDoctor);
            response.isSuccess = true;
            response.statusMessage = 'Success. Doctor is deleted.';
        } catch (Exception e) {
            response = buildErrorResponse(e.getMessage());
        }
        return response;
    }

    global class MH_DoctorWebServiceWrapper {
        webService String id { get; set; }
        webService String firstName { get; set; }
        webService String lastName { get; set; }
        webService String email { get; set; }
        webService String country { get; set; }
        webService String town { get; set; }
        webService String birthdate { get; set; }
        webService String licenceNumber { get; set; }

        public MH_DoctorWebServiceWrapper(){}

        public MH_DoctorWebServiceWrapper(Doctor__c doctor) {
            this.id = doctor.Id;
            this.firstName = doctor.Name;
            this.lastName = doctor.LastName__c;
            this.email = doctor.Email__c;
            this.country = doctor.Country__c;
            this.town = doctor.Town__c;
            this.birthdate = doctor.Birthday__c.format();
            this.licenceNumber = String.valueOf(doctor.License_Number__c);
        }
        public MH_DoctorWebServiceWrapper(soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper soapWrapper){
            this.id = soapWrapper.Id;
            this.firstName = soapWrapper.Name;
            this.lastName = soapWrapper.lastName;
            this.email = soapWrapper.email;
            this.country = soapWrapper.country;
            this.town = soapWrapper.town;
            this.birthdate = soapWrapper.birthdate;
            this.licenceNumber = soapWrapper.licenseNumber;
        }
    }

    global class MH_DoctorResponseWrapper {
        webService Boolean isSuccess;
        webService List<MH_DoctorWebServiceWrapper> wrappers;
        webService String statusMessage;
        MH_DoctorResponseWrapper() {
            this.wrappers = new List<MH_DoctorWebServiceWrapper>();
        }
        MH_DoctorResponseWrapper(Boolean isSuccess, List<MH_DoctorWebServiceWrapper> wrapper, String statusMessage) {
            this.isSuccess = isSuccess;
            this.wrappers = wrappers;
            this.statusMessage = statusMessage;
        }
    }
    private static MH_DoctorResponseWrapper buildSuccessResponse(List<MH_DoctorWebServiceWrapper> wrappers) {
        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();
        response.isSuccess = true;
        response.statusMessage = 'Success.';
        response.wrappers = wrappers;
        return response;
    }

    private static MH_DoctorResponseWrapper buildSuccessResponse(Doctor__c doctor) {
        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();
        response.isSuccess = true;
        response.statusMessage = 'Success.';
        response.wrappers.add(new MH_DoctorWebServiceWrapper(doctor));
        return response;
    }

    private static MH_DoctorResponseWrapper buildErrorResponse(String errorMessage) {
        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();
        response.isSuccess = false;
        response.statusMessage = errorMessage;
        return response;
    }
}