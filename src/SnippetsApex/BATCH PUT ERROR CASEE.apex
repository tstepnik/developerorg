// PAMIĘTAJ BY POPRAWIC QUERY W BATCHU
//1 Dodać hospital do Siebie i Kamila
//2 Usunąć u Kamila tylko musi wyłączyć trigger
//3 zrób update u siebie z wyłączonym triggerem
//UROCHOMIC BATCH

//1
Hospital__c hospital = new Hospital__c(Name ='BatchPutErrorCase');
insert hospital;
//3
//MH_Utils.disableTrigger(Hospital__c.getSObjectType());
//hospital.Name ='BatchPutErrorCaseUPDATED';
//insert hospital;
//MH_Utils.enableTrigger(Hospital__c.getSObjectType());
