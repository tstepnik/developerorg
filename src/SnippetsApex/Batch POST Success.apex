// PAMIĘTAJ BY POPRAWIC QUERY W BATCHU
/// SUCCESS CASE
//1 Dodać hospital u siebie z wyłączonym triggerem
//2 Uruchmić batch
//UROCHOMIC BATCH

//1
MH_Utils.disableTrigger(Hospital__c.getSObjectType());
Hospital__c hospital = new Hospital__c(Name ='BatchPostSuccessCase');
insert hospital;
MH_Utils.enableTrigger(Hospital__c.getSObjectType());