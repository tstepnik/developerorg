// PAMIĘTAJ BY POPRAWIC QUERY W BATCHU
//1 Dodać hospital do siebie i Kamila
//2 Usunąć u u niego poprzez save delete
//3 Usunąć u siebie normalnie
//UROCHOMIC BATCH

//1

//2
MH_Utils.disableTrigger(Hospital__c.getSObjectType());
//Hospital__c hospital = new Hospital__c(Name ='BatchDeleteErrorCase');
//insert hospital;
//3
Hospital__c deleteHosp = [SELECT Id, Name FROM Hospital__c WHERE Name Like 'BatchDeleteErrorCase' LIMIT 1];
deleteHosp.Integrated__c = false;
update deleteHosp;
delete deleteHosp;
MH_Utils.enableTrigger(Hospital__c.getSObjectType());
