global class MH_DoctorWebService {

    webService static MH_DoctorResponseWrapper getDoctors(String firstName,
            String lastName,
            String country,
            String town,
            String email) {
        List<Doctor__c> doctors;

        try {
            doctors = MH_Doctor_Service.soapGetDoctors(firstName,lastName,country,town,email);
            List<MH_DoctorWebServiceWrapper> wrappers = MH_Doctor_Service.fromDoctorsToWrappers(doctors);
            return buildSuccessResponse(wrappers);
        } catch (Exception e) {
            return buildErrorResponse(e.getMessage());
        }
    }

    webService static MH_DoctorResponseWrapper addDoctor(String firstName, String lastName, String country, String town, String email, String birthDate) {
        Doctor__c doctor = new Doctor__c(
                Name = firstName,
                LastName__c = lastName,
                Country__c = country,
                Email__c = email,
                Town__c = town,
                Birthday__c = Date.parse(birthDate)
        );
        Database.SaveResult result;

        try {
            result = Database.insert(doctor);
            return  buildSuccessResponse(doctor);
        } catch (Exception e) {
            return buildErrorResponse(e.getMessage());
        }
    }

    webService static MH_DoctorResponseWrapper updateDoctor(String id, String firstName, String lastName, String country, String town, String email, String birthDate) {
        Doctor__c updatedDoctor = new Doctor__c(Id = id);
        updatedDoctor.Name = firstName;
        updatedDoctor.LastName__c = lastName;
        updatedDoctor.Country__c = country;
        updatedDoctor.Email__c = email;
        updatedDoctor.Town__c = town;
        updatedDoctor.Birthday__c = Date.parse(birthDate);

        try {
            Database.SaveResult result = Database.update(updatedDoctor);
            return buildSuccessResponse(updatedDoctor);
        } catch (Exception e) {
            return buildErrorResponse(e.getMessage());

        }


    }

    webService static MH_DoctorResponseWrapper deleteDoctor(String id) {
        Doctor__c deletedDoctor = new Doctor__c(Id = id);
        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();

        try {
            Database.DeleteResult result = Database.delete(deletedDoctor);
            response.isSuccess = true;
            response.statusMessage = 'Success. Doctor is deleted.';
        } catch (Exception e) {
            response = buildErrorResponse(e.getMessage());
            response.wrappers.add(new MH_DoctorWebServiceWrapper(deletedDoctor));
        }

        return response;
    }

    global class MH_DoctorWebServiceWrapper {
        webService String id;
        webService String firstName;
        webService String lastName;
        webService String email;
        webService String country;
        webService String town;
        webService String birthdate;
        webService String licenceNumber;

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
    public static  MH_DoctorResponseWrapper buildSuccessResponse(List<MH_DoctorWebServiceWrapper> wrappers) {
        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();
        response.isSuccess = true;
        response.statusMessage = 'Success.';
        response.wrappers = wrappers;
        return response;
    }

    public static MH_DoctorResponseWrapper buildSuccessResponse(Doctor__c doctor) {
        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();
        response.isSuccess = true;
        response.statusMessage = 'Success.';
        response.wrappers.add(new MH_DoctorWebServiceWrapper(doctor));
        return response;
    }

    public static  MH_DoctorResponseWrapper buildErrorResponse(String errorMessage){
        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();
        response.isSuccess = false;
        response.statusMessage = errorMessage;
        return response;
    }
}