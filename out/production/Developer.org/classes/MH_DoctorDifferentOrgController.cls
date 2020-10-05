public with sharing class MH_DoctorDifferentOrgController {
    public List<Doctor__c> doctors { get; set; }
    public List<MH_DoctorWebService.MH_DoctorWebServiceWrapper> soapWrappers{get;set;}
    public Doctor__c searchedDoctor { get; set; }
    public Doctor__c deletedDoctor { get; set; }
    public Doctor__c createdDoctor { get; set; }
    public MH_DoctorSOAPService soapService { get; set; }
    public MH_DoctorDifferentOrgController() {
        this.searchedDoctor = new Doctor__c();
        this.deletedDoctor = new Doctor__c();
        this.doctors = new List<Doctor__c>();
        this.soapService = new MH_DoctorSOAPService();
    }

    public void searchDoctors() {
//        doctors = soapService.getDoctors(searchedDoctor);
        soapWrappers = soapService.getDoctors(searchedDoctor);
    }

    public void clearEverything() {
        searchedDoctor = new Doctor__c();
        deletedDoctor = new Doctor__c();
        doctors.clear();
    }

    public void deleteDoctor() {
//        System.debug(deletedDoctor.Id);
//        MH_DoctorWebService.deleteDoctor(deletedDoctor.Id);
    }

    public void addDoctor() {

    }

}