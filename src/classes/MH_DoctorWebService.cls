global class MH_DoctorWebService {

    webService static MH_DoctorResponseWrapper getDoctors(String firstName,
            String lastName,
            String country,
            String town,
            String email) {
        List<Doctor__c> doctors;

        List<String> parameters = new List<String>{
                firstName,
                email,
                country,
                lastName,
                town
        };
        List<String> fields = new List<String>{
                'Name',
                'Email__c',
                'Country__c',
                'LastName__c',
                'Town__c'
        };
        String searchQuery =
                'SELECT ' +
                        'Name,LastName__c,Country__c,Town__c,Email__c,Birthday__c,License_Number__c ' +
                        'FROM Doctor__c ';

        Boolean emptyParameters = true;
        Boolean firstTimeQuery = true;

        for (String param : parameters) {
            if (param.trim().length() > 0) {
                emptyParameters = false;
                break;
            }
        }
        if (!emptyParameters) {
            searchQuery += 'WHERE ';
            for (Integer i = 0; i < fields.size(); i++) {

                if (parameters.get(i).trim().length() > 0 && firstTimeQuery) {
                    searchQuery += fields.get(i) + ' LIKE \'%' + parameters.get(i) + '%\' ';
                    firstTimeQuery = false;
                } else if (parameters.get(i).trim().length() > 0) {
                    searchQuery += ' AND ' + fields.get(i) + ' LIKE \'%' + parameters.get(i) + '%\' ';
                }
            }
        }

        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();
        try {
            doctors = Database.query(searchQuery);
            List<MH_DoctorWebServiceWrapper> wrappers = new List<MH_DoctorWebService.MH_DoctorWebServiceWrapper>();
            for (Doctor__c doctor : doctors) {
                wrappers.add(new MH_DoctorWebServiceWrapper(doctor));
            }
            response.isSuccess = true;
            response.statusMessage = 'Success.';
            response.wrappers = wrappers;
        } catch (Exception e) {
            response.isSuccess = false;
            response.statusMessage = e.getMessage();
        }
        return response;
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
        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();

        try {
            result = Database.insert(doctor);
            response.wrappers.add(new MH_DoctorWebServiceWrapper(doctor));
            response.isSuccess = true;
            response.statusMessage = 'Success';
        } catch (Exception e) {
            response.isSuccess = false;
            response.statusMessage = e.getMessage();
        }
        return response;
    }

    webService static MH_DoctorResponseWrapper updateDoctor(String id, String firstName, String lastName, String country, String town, String email, String birthDate) {
        Doctor__c updatedDoctor = new Doctor__c(Id = id);
        updatedDoctor.Name = firstName;
        updatedDoctor.LastName__c = lastName;
        updatedDoctor.Country__c = country;
        updatedDoctor.Email__c = email;
        updatedDoctor.Town__c = town;
        updatedDoctor.Birthday__c = Date.parse(birthDate);

        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();
        try {
            Database.SaveResult result = Database.update(updatedDoctor);
            response.isSuccess = true;
            response.statusMessage = 'Success';
            response.wrappers.add(new MH_DoctorWebServiceWrapper(updatedDoctor));
        } catch (Exception e) {
            response.isSuccess = false;
            response.statusMessage = e.getMessage();
        }

        return response;
    }

    webService static MH_DoctorResponseWrapper deleteDoctor(String id) {
        Doctor__c deletedDoctor = new Doctor__c(Id = id);
        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();

        try {
            Database.DeleteResult result = Database.delete(deletedDoctor);
            response.isSuccess = true;
            response.statusMessage = 'Success. Doctor is deleted.';
        } catch (Exception e) {
            response.isSuccess = false;
            response.statusMessage = e.getMessage();
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

        public MH_DoctorWebServiceWrapper(Doctor__c doctor) {
            this.id = doctor.Id;
            this.firstName = doctor.Name;
            this.lastName = doctor.LastName__c;
            this.email = doctor.Email__c;
            this.country = doctor.Country__c;
            this.town = doctor.Town__c;
            this.birthdate = doctor.Birthday__c.format();
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


}