// PAMIĘTAJ BY POPRAWIC QUERY W BATCHU
/// SUCCESS CASE
//1 Dodać hospital u siebie i kamila
//2 edytować u siebie z wyłączonym triggerem.
//3 uruchomić batch
//UROCHOMIC BATCH

//1
//Hospital__c hospital = new Hospital__c(Name ='BatchPutSuccessCase');
//insert hospital;

MH_Utils.disableTrigger(Hospital__c.getSObjectType());
Hospital__c hospital = [SELECT Id,Name FROM  Hospital__c WHERE Name Like 'BatchPutSuccessCaseUPDATED'];
hospital.Name='BatchPutSuccessCaseUPDATED';
hospital.Integrated__c = false;
update hospital;
MH_Utils.enableTrigger(Hospital__c.getSObjectType());