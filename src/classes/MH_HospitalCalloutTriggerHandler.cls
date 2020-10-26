
public with sharing class MH_HospitalCalloutTriggerHandler {

    private static MH_HospitalCalloutTriggerHandler instance;

    public static MH_HospitalCalloutTriggerHandler getInstance() {
        if (instance == null) {
            return new MH_HospitalCalloutTriggerHandler();
        } else {
            return instance;
        }
    }

    public List<MH_HospitalRESTResponseWrapper> convertToRequestWrappers(List<Hospital__c> hospitals) {

        List<MH_HospitalRESTResponseWrapper> wrappers = new List<MH_HospitalRESTResponseWrapper>();

        for (Hospital__c hospital : hospitals) {
            wrappers.add(new MH_HospitalRESTResponseWrapper(hospital.Id, hospital.Id, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c, hospital.Email__c, true));
        }
        return wrappers;
    }
    public List<MH_HospitalRESTResponseWrapper> convertToUpdateWrappers(List<Hospital__c> hospitals) {

        List<MH_HospitalRESTResponseWrapper> wrappers = new List<MH_HospitalRESTResponseWrapper>();

        for (Hospital__c hospital : hospitals) {
            wrappers.add(new MH_HospitalRESTResponseWrapper(hospital.ExternalHospitalId__c, hospital.Id, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c, hospital.Email__c, true));
        }
        return wrappers;
    }

    public void afterInsert(List<Hospital__c> hospitals) {
        List<MH_HospitalRESTResponseWrapper> wrappersToInsert = convertToRequestWrappers(hospitals);
        for (MH_HospitalRESTResponseWrapper wrapper : wrappersToInsert) {
            System.enqueueJob(new MH_CalloutInsert(wrapper, 'POST'));
        }
    }

    public void afterUpdate(List<Hospital__c> hospitals) {
        List<MH_HospitalRESTResponseWrapper> wrappersToInsert = convertToUpdateWrappers(hospitals);
        for (MH_HospitalRESTResponseWrapper wrapper : wrappersToInsert) {
            System.enqueueJob(new MH_CalloutInsert(wrapper, 'UPDATE'));
        }
    }

    public void afterDelete(List<Hospital__c> hospitals) {
        List<MH_HospitalRESTResponseWrapper> wrappersToInsert = convertToUpdateWrappers(hospitals);
        for (MH_HospitalRESTResponseWrapper wrapper : wrappersToInsert) {
            System.enqueueJob(new MH_CalloutInsert(wrapper, 'DELETE'));
        }
    }

    public void afterUndelete(List<Hospital__c> hospitals){
        List<MH_HospitalRESTResponseWrapper> wrappersToInsert = convertToUpdateWrappers(hospitals);
        for (MH_HospitalRESTResponseWrapper wrapper : wrappersToInsert) {
            System.enqueueJob(new MH_CalloutInsert(wrapper, 'UNDELETE'));
        }
    }

    public void beforeDelete(List<Hospital__c> hospitals) {
        for(Hospital__c hospital : hospitals){
            if (String.isBlank(hospital.ExternalHospitalId__c)) {
                hospital.Integrated__c = true;
            }
        }
        MH_Utils.disableTrigger(Hospital__c.getSObjectType());
        update hospitals;
        MH_Utils.enableTrigger(Hospital__c.getSObjectType());
    }

}