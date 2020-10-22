// PAMIĘTAJ BY POPRAWIC QUERY W BATCHU

//1 Dodać hospital do Kamila
//2 Usunąć u siebie poprzez save delete
//3 dodać do siebie
//UROCHOMIC BATCH

//1
Hospital__c hospital = new Hospital__c(Name ='BatchPostErrorCase');
//insert hospital;

//2 save delete
//3
MH_Utils.disableTrigger(Hospital__c.getSObjectType());
insert hospital;
MH_Utils.enableTrigger(Hospital__c.getSObjectType());
