// PAMIĘTAJ BY POPRAWIC QUERY W BATCHU
// DODAJ ALL ROWS
//1 Dodać hospital do siebie i Kamila
//2 Usunąć u Siebie z wyłączonym triggerem
//UROCHOMIC BATCH

//1
//Hospital__c hospital = new Hospital__c(Name ='BatchDeleteSuccessCase');
//insert hospital;


//2
MH_Utils.disableTrigger(Hospital__c.getSObjectType());
Hospital__c deleteHosp = [SELECT Id, Name FROM Hospital__c WHERE Name Like 'BatchDeleteSuccessCase' LIMIT 1];
//deleteHosp.Integrated__c = false;
//update deleteHosp;
delete deleteHosp;
MH_Utils.enableTrigger(Hospital__c.getSObjectType());




