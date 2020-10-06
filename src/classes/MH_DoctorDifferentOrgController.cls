public with sharing class MH_DoctorDifferentOrgController {
    public String soapAction { get; set; }
    public String statusMessage { get; set; }
    public String birthdateFromParam { get; set; }
    public Doctor__c searchedDoctor { get; set; }
    public Doctor__c upsertedDoctor { get; set; }
    public MH_DoctorSOAPService soapService { get; set; }
    public List<MH_DoctorWebService.MH_DoctorWebServiceWrapper> soapWrappers { get; set; }
    public MH_DoctorWebService.MH_DoctorWebServiceWrapper pressedDoctorWrapper { get; set; }
    public MH_DoctorDifferentOrgController() {
        this.searchedDoctor = new Doctor__c();
        this.upsertedDoctor = new Doctor__c();
        this.pressedDoctorWrapper = new MH_DoctorWebService.MH_DoctorWebServiceWrapper();

        this.soapService = new MH_DoctorSOAPService();
    }

    public void searchDoctors() {
        soapWrappers = soapService.getDoctors(searchedDoctor);
    }

    public void addDoctor() {
        statusMessage = soapService.addDoctor(upsertedDoctor);
        soapWrappers = soapService.getDoctors(searchedDoctor);
    }

    public void editDoctor() {
        statusMessage = soapService.updateDoctor(upsertedDoctor, pressedDoctorWrapper.id);
        soapWrappers = soapService.getDoctors(searchedDoctor);
    }


    public void setActionTypeToADD() {
        soapAction = 'ADD';
        clearUpsertPopup();
    }

    public void setActionTypeToUPDATE() {
        soapAction = 'UPDATE';
        emptyAction();
    }

    public void upsertDoctor() {
        if (soapAction == 'ADD') {
            addDoctor();
        } else {
            editDoctor();
        }
        clearUpsertPopup();
    }

    public void deleteDoctor() {
        String id = pressedDoctorWrapper.id;
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result = soapService.deleteDoctor(id);
        if (result.isSuccess) {
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, result.statusMessage));
        }
        soapWrappers = soapService.getDoctors(searchedDoctor);
        System.debug(statusMessage);
    }

    public void clearEverything() {
        searchedDoctor = new Doctor__c();
        upsertedDoctor = new Doctor__c();
        pressedDoctorWrapper = new MH_DoctorWebService.MH_DoctorWebServiceWrapper();
        soapWrappers = new List<MH_DoctorWebService.MH_DoctorWebServiceWrapper>();
        soapWrappers.clear();
    }

    public void clearUpsertPopup() {
        upsertedDoctor = new Doctor__c();
    }

    public PageReference emptyAction() {
        upsertedDoctor.Birthday__c = Date.parse(birthdateFromParam);
        return null;

    }
}