List<Hospital__c> hospitals = new List<Hospital__c>();

hospitals.add(new Hospital__c(Name='BatchTest1'));
hospitals.add(new Hospital__c(Name='BatchTest2'));
hospitals.add(new Hospital__c(Name='BatchTest3'));

insert hospitals;

MH_Utils.disableTrigger(Hospital__c.getSObjectType());

MH_Utils.enableTrigger(Hospital__c.getSObjectType());