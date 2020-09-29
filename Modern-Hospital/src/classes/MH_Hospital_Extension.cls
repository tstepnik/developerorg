public with sharing class MH_Hospital_Extension {
    public String contractId { get; set; }
    public Hospital__c hospital { get; set; }
    public Contract__c multiHireContract {
        get {
            if (multiHireContract == null) {
                multiHireContract = new Contract__c();
            }
            return multiHireContract;
        }
        set;
    }
    public Doctor__c selectedDoctor {
        get {
            if (selectedDoctor == null) {
                selectedDoctor = new Doctor__c();
            }
            return selectedDoctor;
        }
        set;
    }
    public List<Contract__c> contracts { get; set; }
    public List<Doctor__c> searchedDoctors { get; set; }
    public List<Doctor__c> selectedDoctors {
        get {
            if (selectedDoctors == null) {
                selectedDoctors = new List<Doctor__c>();
            }
            return selectedDoctors;
        }
        set;
    }
    public Doctor__c searchedDoctor {
        get {
            if (searchedDoctor == null) {
                searchedDoctor = new Doctor__c();
            }
            return searchedDoctor;
        }
        set;
    }

    public List<MH_Hospital_Service.DoctorWrapper> doctorWrappers { get; set; }

    public MH_Hospital_Service.DoctorWrapper doctorWrapper {
        get {
            if (doctorWrapper == null) {
                doctorWrapper = new MH_Hospital_Service.DoctorWrapper(new Doctor__c(), hospital);
            }
            return doctorWrapper;
        }
        set;
    }

    public MH_Hospital_Extension(ApexPages.StandardController stdController) {
        this.hospital = (Hospital__c) stdController.getRecord();
        this.contracts = [SELECT Date_Started__c, Expire_Date__c, Doctor_Full_Name__c, Name, Status__c FROM Contract__c WHERE Hospital__c = :hospital.Id];
    }

    public void dismiss() {
        System.debug('BUTTON IS CLICKED');
        contracts = MH_Hospital_Service.dismiss(contractId, hospital);
    }

    public void consoleDismiss(){
        System.debug('CONSOLE DISMISS');
    }

    public void findSearchedDoctors() {
        searchedDoctors = MH_Doctor_Service.findDoctorsForHospital(searchedDoctor);

        for (Doctor__c doctor : searchedDoctors) {
            doctor.Selected__c = '0';
        }
        update searchedDoctors;
    }

    public void clearData() {
        searchedDoctor = new Doctor__c();
        if (searchedDoctors != null) {
            searchedDoctors.clear();
        }
        for (Doctor__c doctor : searchedDoctors) {
            doctor.Selected__c = '0';
        }
        update searchedDoctors;
    }

    public void removeSelectIfClicked() {
        for (Doctor__c doctor : searchedDoctors) {
            if (doctor.Id == selectedDoctor.Id) {
                doctor.Selected__c = '2';
            }
        }
        update searchedDoctors;
    }

    public void addDoctorToList() {
        selectedDoctors.add(selectedDoctor);
        doctorWrappers = MH_Hospital_Service.doctorWrappers(selectedDoctors, hospital);
        removeSelectIfClicked();
        selectedDoctor = new Doctor__c();
    }

    public void removeDoctorFromList() {

        for (Doctor__c doctor : searchedDoctors) {
            if (doctor.Id == selectedDoctor.Id) {
                doctor.Selected__c = '0';
            }
            for (Integer i = 0; i < selectedDoctors.size(); i++) {
                if (selectedDoctors.get(i).Id == selectedDoctor.Id) {
                    selectedDoctors.remove(i);
                }
            }
            doctorWrappers = MH_Hospital_Service.doctorWrappers(selectedDoctors, hospital);
        }
        update searchedDoctors;
    }

    public void hireDoctors() {
        Set<Contract__c> contracts = new Set<Contract__c>();
        for (MH_Hospital_Service.DoctorWrapper doctorWrapper : doctorWrappers) {
            Contract__c contract = doctorWrapper.contract;
            contracts.add(contract);

        }
    }

}