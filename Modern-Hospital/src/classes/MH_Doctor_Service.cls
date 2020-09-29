public without sharing class MH_Doctor_Service {

    public static List<Doctor__c> findDoctors(Doctor__c searchedDoctor) {

        List<String> fields = new List<String>{
                'Name',
                'Email__c',
                'Country__c'
        };

        String searchQuery =
                'SELECT Name,LastName__c,Email__c,Country__c,Full_Name__c ' +
                        'FROM Doctor__c ' +
                        'WHERE LastName__c LIKE \'' + searchedDoctor.LastName__c + '%\'';

        for (String field : fields) {

            if (field.equals('Email__c') && String.isNotBlank(String.valueOf(searchedDoctor.get('Search_Email__c')))) {
                searchQuery += ' AND ' + field + ' LIKE \'' + searchedDoctor.get('Search_Email__c') + '%\'';
            }
            if (String.isNotBlank(String.valueOf(searchedDoctor.get(field)))) {
                searchQuery += ' AND ' + field + ' LIKE \'' + searchedDoctor.get(field) + '%\'';
            }
        }
        return Database.query(searchQuery);
    }

    public static PageReference downloadCSVFile() {
        return Page.MH_Doctor_ExportCSV.setRedirect(false);
    }
    public static PageReference downloadXLSFile() {
        return Page.MH_Doctor_ExportXLS.setRedirect(false);
    }
    public static PageReference downloadJSONFile() {
        return Page.MH_Doctor_ExportJSON.setRedirect(false);
    }

    public static List<Contract__c> dismiss(String contractName, Doctor__c doctor) {
        Date today = Date.today();
        Contract__c contract = [SELECT Date_Started__c, Expire_Date__c FROM Contract__c WHERE Name LIKE :contractName];

        if (contract.Date_Started__c >= today) {
            delete contract;
        } else if (contract.Date_Started__c <= today && (contract.Expire_Date__c > today || contract.Expire_Date__c == null)) {
            contract.Expire_Date__c = today;
            update contract;
        }
        return retrieveContracts(doctor);
    }

    public static List<Contract__c> retrieveContracts(Doctor__c doctor) {
        return [SELECT Date_Started__c, Expire_Date__c, Hospital__c, Name, Status__c FROM Contract__c WHERE Doctor__c = :doctor.Id];
    }

    public static void sendEmail(String emailSubject, String emailBody, Doctor__c doctor) {

        Messaging.SingleEmailMessage singleEmail = new Messaging.SingleEmailMessage();
        String[] sendingTo = new String[]{
                doctor.Email__c
        };
        singleEmail.setToAddresses(sendingTo);
        singleEmail.setSubject(emailSubject);
        singleEmail.setPlainTextBody(emailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                singleEmail
        });
    }

    public static Set<Doctor__c> fiveRandomDoctors() {
        List<Doctor__c> doctors = [SELECT Name, LastName__c, Email__c, Work_Phone__c FROM Doctor__c];

        Set<Doctor__c> fiveRandomDoctors = new Set<Doctor__c>();

        while (fiveRandomDoctors.size() < 5) {
            Integer randomNumber = Integer.valueOf((Math.random() * (doctors.size() - 1)));
            fiveRandomDoctors.add(doctors.get(randomNumber));
        }
        return fiveRandomDoctors;
    }

    public class MH_Doctor_WrapperJSON {
        public String Name{get; set;}
        public String LastName{get; set;}
        public String Email{get; set;}
        public String Country{get; set;}

        public MH_Doctor_WrapperJSON(Doctor__c doctor) {
            this.Name = doctor.Name;
            this.LastName = doctor.LastName__c;
            this.Email = doctor.Email__c;
            this.Country = doctor.Country__c;
        }
    }

    public static List<MH_Doctor_WrapperJSON> wrapDoctors(List<Doctor__c> doctors) {
        List<MH_Doctor_WrapperJSON> wrapDoctors = new List<MH_Doctor_Service.MH_Doctor_WrapperJSON>();
        for (Doctor__c doctor : doctors) {
            wrapDoctors.add(new MH_Doctor_WrapperJSON(doctor));
        }
        return wrapDoctors;
    }
}