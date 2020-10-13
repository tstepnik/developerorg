
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
            wrappers.add(new MH_HospitalRESTResponseWrapper(hospital.Id, hospital.Id, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c, hospital.Email__c));
        }
        return wrappers;
    }

    //todo external id
//    public Boolean checkAllExternalIdsNull(List<Doctor__c> doctors){
//        for(Doctor__c doctor : doctors){
//            if () {
//
//            }
//        }
//    }


    public void afterInsert(List<Hospital__c> hospitals) {
        List<MH_HospitalRESTResponseWrapper> wrappersToInsert = convertToRequestWrappers(hospitals);
        System.enqueueJob(new MH_CalloutInsert(wrappersToInsert,'POST'));
    }

    public void afterUpdate(List<Hospital__c> hospitals) {
        List<MH_HospitalRESTResponseWrapper> wrappersToInsert = convertToRequestWrappers(hospitals);
        System.enqueueJob(new MH_CalloutInsert(wrappersToInsert,'UPDATE'));
    }
    public void afterDelete(List<Hospital__c> hospitals) {
        List<MH_HospitalRESTResponseWrapper> wrappersToInsert = convertToRequestWrappers(hospitals);
        System.enqueueJob(new MH_CalloutInsert(wrappersToInsert,'DELETE'));
    }
}