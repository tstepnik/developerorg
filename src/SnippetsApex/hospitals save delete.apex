//MH_Utils.disableTrigger(Hospital__c.getSObjectType());
List<Hospital__c> hospitals = [SELECT Id,Integrated__c, Name FROM Hospital__c];

for(Hospital__c hospital: hospitals){
    hospital.Integrated__c = true;
}

update hospitals;
delete hospitals;

List<Apex_Log__c> logs = [SELECT Id FROM Apex_Log__c];
delete logs;
//MH_Utils.enableTrigger(Hospital__c.getSObjectType());
