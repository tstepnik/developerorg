public with sharing class MH_HospitalRestController {

        public HD_HospitalRestServiceHandler hospitalHandler {get; set;}
        public HD_HospitalRestServiceHandler.HospitalWrapper hospitalWrapper {get; set;}
        public HD_HospitalRestServiceHandler.HospitalWrapper hospitalForCRUD {get; set;}
        public List<HD_HospitalRestServiceHandler.HospitalWrapper> searchResult {get; set;}
        public List<SelectOption> countryPickListValues {get; set;}
        public Map<String, String> params {get; set;}
        public String infoMessage {get; set;}
        public Boolean isSearchCompleted {get; set;}
        public HD_HospitalSearchRestController() {
            params = new Map<String, String>();
            hospitalHandler = new HD_HospitalRestServiceHandler();
            hospitalWrapper = new HD_HospitalRestServiceHandler.HospitalWrapper(new HD_Hospital__c());
            hospitalForCRUD = new HD_HospitalRestServiceHandler.HospitalWrapper(new HD_Hospital__c());
            countryPickListValues = new List<SelectOption>();
            if (!Test.isRunningTest()) {
                for (String selectOption : hospitalHandler.getCountryPicklistValues()) {
                    countryPickListValues.add(new SelectOption(selectOption, selectOption));
                }
            }
            infoMessage = '';
            isSearchCompleted = false;
        }
        public void clearSearchResult() {
            searchResult = new List<HD_HospitalRestServiceHandler.HospitalWrapper>();
            isSearchCompleted = false;
        }
        public void clearModalData() {
            hospitalForCRUD.HX_Id = null;
            hospitalForCRUD.name = null;
            hospitalForCRUD.email = null;
            hospitalForCRUD.town = null;
            hospitalForCRUD.country = null;
        }
        public String getModalTitle() {
            if (hospitalForCRUD.HX_Id != null) {
                return String.format(System.Label.Edit_Hospital_Name, new String[] {hospitalForCRUD.name});
            } else {
                return System.Label.New_Hospital;
            }
        }
        public void getHospitalForUpdate() {
            for (HD_HospitalRestServiceHandler.HospitalWrapper hospitalWrapper : searchResult) {
                if (hospitalWrapper.HX_Id == hospitalForCRUD.HX_Id) {
                    hospitalForCRUD.name = hospitalWrapper.name;
                    hospitalForCRUD.email = hospitalWrapper.email;
                    hospitalForCRUD.town = hospitalWrapper.town;
                    hospitalForCRUD.country = hospitalWrapper.country;
                    break;
                }
            }
        }
        public void getHospitals() {
            if (!String.isEmpty(hospitalWrapper.name)) {
                params.put('name', hospitalWrapper.name);
            } else {
                params.put('name', '');
            }
            if (!Test.isRunningTest()) {
                if (!String.isEmpty(hospitalWrapper.email)) {
                    params.put('email__c', hospitalWrapper.email);
                } else {
                    params.put('email__c', '');
                }
                if (!String.isEmpty(hospitalWrapper.town)) {
                    params.put('town__c', hospitalWrapper.town);
                } else {
                    params.put('town__c', '');
                }
                if (!String.isEmpty(hospitalWrapper.country)) {
                    params.put('country__c', hospitalWrapper.country);
                } else {
                    params.put('country__c', '');
                }
            }
            try {
                searchResult = hospitalHandler.fetchHospitalsList(hospitalHandler.getHospitals(params));
                isSearchCompleted = true;
            } catch (Exception e) {
                infoMessage = e.getMessage();
            }
        }
        public void createHospital() {
            fillFieldsWithData();
            if (!String.isEmpty(hospitalForCRUD.HX_Id)) {
                params.put('hd_id__c', hospitalForCRUD.HX_Id);
            }
            try {
                infoMessage = hospitalHandler.createHospital(params);
            } catch (Exception e) {
                infoMessage = e.getMessage();
            }
            if (isSearchCompleted) {
                getHospitals();
            }
        }
        public void updateHospital() {
            if (hospitalForCRUD.HX_Id != null) {
                fillFieldsWithData();
                try {
                    infoMessage = hospitalHandler.updateHospital(hospitalForCRUD.HX_Id, params);
                } catch (Exception e) {
                    infoMessage = e.getMessage();
                }
            }
            if (!Test.isRunningTest()) {
//            getHospitals();
            }
        }
        public void deleteHospital() {
            try {
                infoMessage = hospitalHandler.deleteHospital(hospitalForCRUD.HX_Id);
                if (!Test.isRunningTest()) {
//                getHospitals();
                }
            } catch (Exception e) {
                infoMessage = e.getMessage();
            }
        }
        public void fillFieldsWithData() {
            if (!String.isEmpty(hospitalForCRUD.name)) {
                params.put('name', hospitalForCRUD.name);
            }
            if (!String.isEmpty(hospitalForCRUD.email)) {
                params.put('email__c', hospitalForCRUD.email);
            }
            if (!String.isEmpty(hospitalForCRUD.town)) {
                params.put('town__c', hospitalForCRUD.town);
            }
            if (!String.isEmpty(hospitalForCRUD.country)) {
                params.put('country__c', hospitalForCRUD.country);
            }
        }
    }