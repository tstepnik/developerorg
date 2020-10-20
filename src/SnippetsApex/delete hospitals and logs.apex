List<Hospital__c> hospitals = [SELECT Id FROM Hospital__c];
delete  hospitals;

List<Apex_Log__c> logs = [SELECT  Id FROM Apex_Log__c];
delete logs;