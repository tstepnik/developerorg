public with sharing class MH_DoctorDifferentOrgController {

    public List<MH_DoctorSOAPService.MH_ExternalServiceParamWrapper> searchedDoctors { get; set; }
    public MH_DoctorSOAPService.MH_ExternalServiceParamWrapper searchedDoctor { get; set; }
    public MH_DoctorSOAPService.MH_ExternalServiceParamWrapper upsertedDoctor { get; set; }

    public List<String> countries { get; set; }
    public List<SelectOption> countriesOptions { get; set; }
    public MH_DoctorSOAPService soapService { get; set; }
    public String soapAction { get; set; }
    public String deletedDoctorId { get; set; }
    public String statusMessage { get; set; }

    public MH_DoctorDifferentOrgController() {

        try {
            this.soapService = new MH_DoctorSOAPService();
        } catch (Exception e) {
            System.debug(e);
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, e.getMessage()));
        }

        this.searchedDoctor = new MH_DoctorSOAPService.MH_ExternalServiceParamWrapper();
        this.upsertedDoctor = new MH_DoctorSOAPService.MH_ExternalServiceParamWrapper();
        this.searchedDoctors = new List<MH_DoctorSOAPService.MH_ExternalServiceParamWrapper>();
        this.countries = getCountries();
        this.countriesOptions = getCountriesOptions();
        soapAction = '';
    }

    private List<SelectOption> getCountriesOptions() {
        countriesOptions = new List<SelectOption>();
        countriesOptions.add(new SelectOption('', '--none--'));
        if (countries != null && !countries.isEmpty()) {
            for (String country : countries) {
                countriesOptions.add(new SelectOption(country.substring(0, 2), country.substring(0, 2)));
            }
        }
        return countriesOptions;
    }

    public List<String> getCountries() {
//        countries = soapService.getCountries();
        if (countries == null) {
            countries = new List<String>{
                    'PL', 'UK', 'UA'
            };
        }
        return countries;
    }

    public void searchDoctors() {
        searchedDoctors = soapService.getDoctors(searchedDoctor);
    }

    public void addDoctor() {
        statusMessage = soapService.addDoctor(upsertedDoctor);
        if (statusMessage.contains('Success')) {
            clearUpsertItem();
        } else {
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, statusMessage));
        }
    }

    public void editDoctor() {
        statusMessage = soapService.updateDoctor(upsertedDoctor);

        if (statusMessage.contains('Success')) {
            searchDoctors();
            clearUpsertItem();
        } else {
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, statusMessage));
        }
    }

    public void deleteDoctor() {
        statusMessage = soapService.deleteDoctor(deletedDoctorId);
        System.debug('delete Doctor status message: ');
        System.debug(statusMessage);
        if (statusMessage.contains('Success')) {
            System.debug('inside success if');
            searchDoctors();
            clearUpsertItem();
        } else {
            System.debug('inside fail else');
            searchDoctors();
            ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, statusMessage));
        }
    }

    public void upsertDoctor() {
        if (soapAction.equals('ADD')) {
            addDoctor();
        } else {
            editDoctor();
        }
    }

    public void setActionTypeToADD() {
        soapAction = 'ADD';
        clearUpsertItem();
    }

    public void setActionTypeToUPDATE() {
        soapAction = 'UPDATE';
    }

    public void clearTableAndSearchForm() {
        searchedDoctor = new MH_DoctorSOAPService.MH_ExternalServiceParamWrapper();
        searchedDoctors.clear();
    }

    public void clearUpsertItem() {
        upsertedDoctor.email = null;
        upsertedDoctor.name = null;
        upsertedDoctor.lastName = null;
        upsertedDoctor.town = null;
        upsertedDoctor.country = null;
        upsertedDoctor.birthdate = null;
        deletedDoctorId = null;
    }

    public void setSearchedDoctor(MH_DoctorSOAPService.MH_ExternalServiceParamWrapper wrapper) {
        searchedDoctor = wrapper;
    }
}