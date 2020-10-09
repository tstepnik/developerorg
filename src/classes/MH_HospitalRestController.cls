public with sharing class MH_HospitalRestController {
    public List<MH_HospitalRESTResponseWrapper> searchedHospitals { get; set; }
    public MH_HospitalRESTResponseWrapper hospitalSearchItem { get; set; }
    public MH_HospitalRESTResponseWrapper hospitalOperationItem { get; set; }
    public String operationHospitalId { get; set; }
    public String upsertOperationType { get; set; }
    public List<SelectOption> options { get; set; }
    public List<String> countries { get; set; }
    private MH_HospitalRESTHandler restService;
    public MH_HospitalRestController() {
        try {
            restService = new MH_HospitalRESTHandler();
        } catch (Exception e) {
            System.debug(e);
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, 'External Service Connection Error'));
        }
        hospitalOperationItem = new MH_HospitalRESTResponseWrapper();
        hospitalSearchItem = new MH_HospitalRESTResponseWrapper();
        searchedHospitals = new List<MH_HospitalRESTResponseWrapper>();
        upsertOperationType = '';
        getCountryListItems();
    }
    private void refreshSearchedHospitals() {
        Map<String, String> parameters = new Map<String, String>();
        if (hospitalSearchItem.name != null) {
            parameters.put('name', hospitalSearchItem.name);
        }
        if (hospitalSearchItem.country != null) {
            parameters.put('country', hospitalSearchItem.country);
        }
        if (hospitalSearchItem.town != null) {
            parameters.put('town', hospitalSearchItem.town);
        }
        if (hospitalSearchItem.street != null) {
            parameters.put('street', hospitalSearchItem.street);
        }
        searchedHospitals = restService.getHospitals(parameters);
    }
    public void searchForHospitals() {
        refreshSearchedHospitals();
    }
    public void deleteHospital() {
        String resultMessage = restService.deleteHospital(operationHospitalId);
        if (resultMessage.contains('Success')) {
            refreshSearchedHospitals();
            clearUpsertItem();
        } else {
            refreshSearchedHospitals();
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, resultMessage));
        }
    }
    public void upsertHospital() {
        if (upsertOperationType.equals('INSERT')) {
            addHospital();
        } else if (upsertOperationType.equals('UPDATE')) {
            updateHospital();
        }
    }
    public void addHospital() {
        String resultMessage = restService.addHospital(hospitalOperationItem);
        if (resultMessage.contains('Success')) {
            clearUpsertItem();
        } else {
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, resultMessage));
        }
    }
    public void updateHospital() {
        String resultMessage = restService.updateHospital(hospitalOperationItem);
        if (resultMessage.contains('Success')) {
            refreshSearchedHospitals();
            clearUpsertItem();
        } else {
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, resultMessage));
        }
    }
    public void clearUpsertItem() {
        hospitalOperationItem.Id = null;
        hospitalOperationItem.email = null;
        hospitalOperationItem.name = null;
        hospitalOperationItem.street = null;
        hospitalOperationItem.town = null;
        hospitalOperationItem.country = null;
    }
    public void clearSearchData() {
        hospitalSearchItem = new MH_HospitalRESTResponseWrapper();
        searchedHospitals.clear();
    }
    public void prepareUpdateModal() {
        upsertOperationType = 'UPDATE';
    }
    public void prepareInsertModal() {
        upsertOperationType = 'INSERT';
        clearUpsertItem();
    }
    public void sendParam() {
    }
    public List<SelectOption> getCountryListItems() {
        if (Test.isRunningTest()) {
            countries = new List<String>{
                    'PL', 'UK', 'UA'
            };
        } else {
            countries = restService.getCountryPicklistValues();
        }
        options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        if (countries != null && !countries.isEmpty()) {
            for (String country : countries) {
                String cString = country.split(';')[0];
                options.add(new SelectOption(cString, cString));
            }
        }
        return options;
    }
}