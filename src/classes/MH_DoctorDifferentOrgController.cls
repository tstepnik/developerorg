public with sharing class MH_DoctorDifferentOrgController {
    public static String pressedWrapperId { get; set; }
    public static Doctor__c globalDoctor { get; set; }
    public Doctor__c searchedDoctor { get; set; }
    public Doctor__c editedDoctor { get; set; }
    public MH_DoctorSOAPService soapService { get; set; }
    public Doctor__c createdDoctor { get; set; }
    public List<MH_DoctorWebService.MH_DoctorWebServiceWrapper> soapWrappers { get; set; }
    public MH_DoctorWebService.MH_DoctorWebServiceWrapper pressedDoctorWrapper { get; set; }
    public MH_DoctorDifferentOrgController() {
        this.searchedDoctor = new Doctor__c();
        this.editedDoctor = new Doctor__c();
        this.createdDoctor = new Doctor__c();
        this.pressedDoctorWrapper = new MH_DoctorWebService.MH_DoctorWebServiceWrapper();

        this.soapService = new MH_DoctorSOAPService();
    }

    public void searchDoctors() {
        soapWrappers = soapService.getDoctors(searchedDoctor);
    }

    public void addDoctor() {
        String result = soapService.addDoctor(createdDoctor);
    }

    public void editDoctor() {
        String result = soapService.updateDoctor(editedDoctor, pressedDoctorWrapper.id);
        soapWrappers = soapService.getDoctors(searchedDoctor);
    }

    public void deleteDoctor() {
        String id = pressedDoctorWrapper.id;
        String result = soapService.deleteDoctor(id);
        soapWrappers = soapService.getDoctors(searchedDoctor);
    }

    public void clearEverything() {
        searchedDoctor = new Doctor__c();
        editedDoctor = new Doctor__c();
        pressedDoctorWrapper = new MH_DoctorWebService.MH_DoctorWebServiceWrapper();
        soapWrappers = new List<MH_DoctorWebService.MH_DoctorWebServiceWrapper>();
        soapWrappers.clear();
    }

    public void fillFieldsWithLastValue() {
        editedDoctor.Name = (pressedDoctorWrapper.firstName != null) ? pressedDoctorWrapper.firstName : '';
        editedDoctor.LastName__c = (pressedDoctorWrapper.lastName != null) ? pressedDoctorWrapper.lastName : '';
        editedDoctor.Email__c = (pressedDoctorWrapper.email != null) ? pressedDoctorWrapper.email : '';
        editedDoctor.Town__c = (pressedDoctorWrapper.town != null) ? pressedDoctorWrapper.town : '';
        if (pressedDoctorWrapper.birthdate != null) {
            editedDoctor.Birthday__c = Date.parse(pressedDoctorWrapper.birthdate);
        }
        if (pressedDoctorWrapper.country != null) {
            editedDoctor.Country__c = pressedDoctorWrapper.country;
        }
    }
    public void clearAddPopup() {
        createdDoctor = new Doctor__c();
    }

    public void clearEditPopup(){
        editedDoctor = new Doctor__c();
    }

}