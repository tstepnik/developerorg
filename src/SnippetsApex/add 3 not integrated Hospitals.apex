MH_Utils.disableTrigger(Hospital__c.sObjectType);
Hospital__c hospital1 = new Hospital__c(Name = 'KamilBatch1');
Hospital__c hospital2 = new Hospital__c(Name = 'KamilBatch2');
Hospital__c hospital3 = new Hospital__c(Name = 'KamilBatch3');
insert hospital1;
insert hospital2;
insert hospital3;
MH_Utils.enableTrigger(Hospital__c.sObjectType);
