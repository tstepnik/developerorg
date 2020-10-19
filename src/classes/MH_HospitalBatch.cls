global class MH_HospitalBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext batchableContext) {
        String query = 'SELECT Id, Name FROM Hospital__c WHERE Integrated__c = true';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext batchableContext, List<Hospital__c> scope) {

    }

    global void finish(Database.BatchableContext batchableContext) {

    }

}