global class MH_DoctorWebService {

    webService static List<MH_DoctorWebServiceWrapper> getDoctors(String firstName, String lastName, String country, String email) {

        List<Doctor__c> doctors = [
                SELECT Name,LastName__c,Country__c,Email__c,Birthday__c
                FROM Doctor__c
                WHERE
                Name LIKE :firstName + '%' AND
                LastName__c LIKE :lastName + '%' AND
                Country__c LIKE :country + '%' AND
                Email__c LIKE :email + '%'
        ];

        List<MH_DoctorWebServiceWrapper> wrappers = new List<MH_DoctorWebService.MH_DoctorWebServiceWrapper>();

        for (Doctor__c doctor : doctors) {
            wrappers.add(new MH_DoctorWebServiceWrapper(doctor));
    }

        return wrappers;
    }

    webService static String addDoctor(String firstName, String lastName, String country, String email, String birthDate) {
        Doctor__c doctor = new Doctor__c(
                Name = firstName,
                LastName__c = lastName,
                Country__c = country,
                Email__c = email,
                Birthday__c = Date.parse(birthDate)
        );
        Database.SaveResult result;

        result = Database.insert(doctor);
        if (result.isSuccess()) {
            return doctor.Id;
        }
        return result.errors[0].getMessage();
    }

    webService static String updateDoctor(String id, String firstName, String lastName, String country, String email, String birthDate) {
        Doctor__c updatedDoctor = [
                SELECT Name,LastName__c,Country__c,Email__c,Birthday__c
                FROM Doctor__c
                WHERE Id = :id
        ];
        updatedDoctor.Name = firstName;
        updatedDoctor.LastName__c = lastName;
        updatedDoctor.Country__c = country;
        updatedDoctor.Email__c = email;
        updatedDoctor.Birthday__c = Date.parse(birthDate);

        Database.SaveResult result = Database.update(updatedDoctor);

        if (result.isSuccess()) {
            return 'Doctor updated successfully.';
        }
        return result.errors[0].getMessage();
    }

    webService static String deleteDoctor(String id){
        Doctor__c deletedDoctor = [
                SELECT Name,LastName__c,Country__c,Email__c,Birthday__c
                FROM Doctor__c
                WHERE Id = :id
        ];
        Database.DeleteResult result = Database.delete(deletedDoctor);
        if (result.isSuccess()) {
            return 'Doctor deleted successfully.';
        }
        return result.errors[0].getMessage();
    }

    global class MH_DoctorWebServiceWrapper{
        webService String id;
        webService String firstName;
        webService String lastName;
        webService String email;
        webService String country;
        webService String birthdate;

        public MH_DoctorWebServiceWrapper(Doctor__c doctor){
            this.id=doctor.Id;
            this.firstName = doctor.Name;
            this.lastName = doctor.LastName__c;
            this.email = doctor.Email__c;
            this.country = doctor.Country__c;
            this.birthdate = doctor.Birthday__c.format();
        }
    }
}