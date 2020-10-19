public with sharing class MH_HospitalRestController {
    public List<MH_HospitalRESTResponseWrapper> searchedHospitals { get; set; }
    public MH_HospitalRESTResponseWrapper hospitalSearchItem { get; set; }
    public MH_HospitalRESTResponseWrapper hospitalOperationItem { get; set; }
    public String resultMessage { get; set; }
    public String operationHospitalId { get; set; }
    public String upsertOperationType { get; set; }
    public List<SelectOption> options { get; set; }
    public List<String> countries { get; set; }
    public MH_HospitalRESTHandler restService;

    public MH_HospitalRestController() {
        try {
            restService = new MH_HospitalRESTHandler();
        } catch (Exception e) {
            if (e instanceof MH_InvalidCredentialsException) {
                ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, e.getMessage()));

            } else {
                ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, Label.ExternalServiceError));
            }
        }
        hospitalOperationItem = new MH_HospitalRESTResponseWrapper();
        hospitalSearchItem = new MH_HospitalRESTResponseWrapper();

        searchedHospitals = new List<MH_HospitalRESTResponseWrapper>();
        upsertOperationType = '';
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
        if (hospitalSearchItem.email != null) {
            parameters.put('email', hospitalSearchItem.email);
        }
        try {
            searchedHospitals = restService.getHospitals(parameters);
        } catch (CalloutException e) {
            handleCalloutExcepiton(e);
        }
    }

    public void searchForHospitals() {
        refreshSearchedHospitals();
    }

    public void addHospital() {
        try {
            resultMessage = restService.addHospital(hospitalOperationItem).statusMessage;
            if (resultMessage.contains('Success')) {
                clearUpsertItem();
            } else {
                ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, resultMessage));
            }
        } catch (Exception e) {
            if (e instanceof CalloutException) {
                handleCalloutExcepiton((CalloutException) e);
            }
        }
    }

    public void updateHospital() {
        MH_HospitalRESTWebServiceResponse response;
        try {
//            resultMessage = restService.updateHospital(hospitalOperationItem).statusMessage;
            response = restService.updateHospital(hospitalOperationItem);

            if (response.statusMessage.contains('Success') || response.isSuccess) {
                refreshSearchedHospitals();
                clearUpsertItem();
            } else {
                ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, resultMessage));
            }
        } catch (Exception e) {
            if (e instanceof CalloutException) {
                handleCalloutExcepiton((CalloutException) e);
            }
        }
    }

    public void deleteHospital() {
        resultMessage = restService.deleteHospital(operationHospitalId, 'false');
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
    public void clearUpsertItem() {
        hospitalOperationItem.Id = null;
        hospitalOperationItem.externalId = null;
        hospitalOperationItem.email = null;
        hospitalOperationItem.name = null;
        hospitalOperationItem.street = null;
        hospitalOperationItem.town = null;
        hospitalOperationItem.country = null;
    }

    public void clearSearchData() {
        hospitalSearchItem = new MH_HospitalRESTResponseWrapper();
        if (searchedHospitals != null) {
            searchedHospitals.clear();
        }
    }
    public void prepareUpdateModal() {
        upsertOperationType = 'UPDATE';
    }
    public void prepareInsertModal() {
        upsertOperationType = 'INSERT';
        clearUpsertItem();
    }

    public void getCountryListItems() {
        if (Test.isRunningTest()) {
            countries = new List<String>{
                    'PL', 'UK', 'UA'
            };
        } else {
            try {
                countries = restService.getCountryPicklistValues();
                System.debug('COUNTRIES');
                System.debug(countries);
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, e.getMessage()));
            }
        }
        options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        if (countries != null && !countries.isEmpty()) {
            for (String country : countries) {
                String cString = country.split(';')[0];
                options.add(new SelectOption(cString, cString));
            }
        }
    }

    private void handleCalloutExcepiton(CalloutException e) {
        ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, e.getTypeName() + ': Action takes to much time. Please try again or contact support.'));
        System.debug(e.getMessage());
    }
}