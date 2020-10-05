public with sharing class MH_DoctorDifferentOrgController {
    public List<Doctor__c> doctors { get; set; }
    public Doctor__c searchedDoctor { get; set; }
    public Doctor__c deletedDoctor { get; set; }
    public Doctor__c createdDoctor { get; set; }
    public MH_DoctorDifferentOrgController() {
        this.searchedDoctor = new Doctor__c();
        this.deletedDoctor = new Doctor__c();
        this.doctors = new List<Doctor__c>();

    }

    public void searchDoctors() {
        List<MH_DoctorWebService.MH_DoctorWebServiceWrapper> wrappers = MH_DoctorWebService.getDoctors(
                searchedDoctor.Name,
                searchedDoctor.LastName__c,
                searchedDoctor.Country__c,
                searchedDoctor.Town__c,
                searchedDoctor.Search_Email__c
        ).wrappers;

        doctors = MH_Doctor_Service.fromSoapWrappersToDoctorsList(wrappers);
    }

    public void clearEverything() {
        searchedDoctor = new Doctor__c();
        deletedDoctor = new Doctor__c();
        doctors.clear();
    }

    public void deleteDoctor() {
        System.debug(deletedDoctor.Id);
        MH_DoctorWebService.deleteDoctor(deletedDoctor.Id);
    }

    public void addDoctor(){
        
}

}