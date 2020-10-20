global class MH_HospitalBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext batchableContext) {
        String query = 'SELECT Id, ExternalHospitalId__c, Name, Country__c, Town__c, Street__c, Email__c, Integrated__c FROM Hospital__c WHERE Integrated__c = false';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext batchableContext, List<Hospital__c> scope) {
        List<Hospital__c>  hospitals = new List<Hospital__c>();
        MH_HospitalRESTHandler handler = new MH_HospitalRESTHandler();
        for (Hospital__c hospital : scope) {
            MH_HospitalRESTResponseWrapper wrapper = new MH_HospitalRESTResponseWrapper(null, hospital.Id, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c, hospital.Email__c, true);
            MH_HospitalRESTWebServiceResponse response = handler.addHospital(wrapper);
            if (response.statusMessage.equals('Success')) {
                hospital.Integrated__c = true;
                hospital.ExternalHospitalId__c = response.hospitalId;
                hospitals.add(hospital);
            }
        }
        MH_Utils.disableTrigger(Hospital__c.getSObjectType());
        update hospitals;
        MH_Utils.enableTrigger(Hospital__c.getSObjectType());
    }

    global void finish(Database.BatchableContext batchableContext) {

    }
}