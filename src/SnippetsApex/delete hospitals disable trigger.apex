List<Hospital__c> hospitals = [SELECT Id FROM Hospital__c];
MH_Utils.disableTrigger(Hospital__c.getSObjectType());
delete hospitals;
MH_Utils.disableTrigger(Hospital__c.getSObjectType());