public without sharing class MH_Doctor_Extension {

    public String emailSubject { get; set; }
    public String emailBody { get; set; }
    public String doctorWorkNumber { get; set; }

    public String contractName { get; set; }
    public String chosenHospitalId { get; set; }
    public Doctor__c doctor;

    public List<Contract__c> contracts { get; set; }
    public List<Hospital__c> hospitals { get; set; }
    public List<Doctor__c> randomDoctors { get; set; }

    public Contract__c contract {
        get {
            if (contract == null) {
                contract = new Contract__c();
            }
            return contract;
        }
        set;
    }
    public Hospital__c searchedHospital {
        get {
            if (searchedHospital == null) {
                searchedHospital = new Hospital__c();
            }
            return searchedHospital;
        }
        set;
    }
    public Hospital__c chosenHospital {
        get {
            if (chosenHospital == null) {
                chosenHospital = new Hospital__c();
            }
            return chosenHospital;
        }
        set;
    }

    public MH_Doctor_Extension(ApexPages.StandardController stdController) {
        this.doctor = (Doctor__c) stdController.getRecord();
        this.contracts = [SELECT Date_Started__c, Expire_Date__c, Hospital__c, Name, Status__c FROM Contract__c WHERE Doctor__c = :doctor.Id];
        this.doctorWorkNumber = doctor.Work_Phone__c;
        this.randomDoctors = new List<Doctor__c>(MH_Doctor_Service.fiveRandomDoctors());
    }

    public void dismiss() {
        contracts = MH_Doctor_Service.dismiss(contractName, doctor);
    }

    public void findHospitals() {
        hospitals = MH_Hospital_Service.findHospitals(searchedHospital);
    }

    public void clearHirePopup() {
        clearSearchAndResultSectionHirePopup();
        chosenHospital = null;
        contract = null;
    }

    public void clearSearchAndResultSectionHirePopup() {
        searchedHospital = new Hospital__c();
        if (hospitals != null) {
            hospitals.clear();
        }
    }

    public void hire() {
        contract.Hospital__c = chosenHospital.Id;
        contract.Doctor__c = doctor.Id;
        if (MH_Contract_Service.createContact(contract)){
            contract = new Contract__c();
        }
        contracts = MH_Doctor_Service.retrieveContracts(doctor);

    }

    public void sendEmail() {
        MH_Doctor_Service.sendEmail(emailSubject, emailBody, doctor);
        emailSubject = '';
        emailBody = '';
    }
}