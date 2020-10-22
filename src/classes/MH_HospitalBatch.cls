global class MH_HospitalBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    String emailMessage = Label.MH_BatchErrorMessage + ' ';
    global Iterable<SObject> start(Database.BatchableContext batchableContext) {
        Set<String> malformedObjects = new Set<String>{
                'a057R000011DCiMQAW',
                'a057R000011DC1VQAW',
                'a057R000011DCWsQAO',
                'a057R000011DCZ3QAO',
                'a057R000011DCbzQAG',
                'a057R000011DCkNQAW',
                'a057R000011DCMOQA4',
                'a057R000011DCZ8QAO',
                'a057R000011DCVuQAO',
                'a057R000011DCT5QAO',
                'a057R000011DCbuQAG',
                'a057R000011DC1LQAW',
                'a057R000011DC1QQAW',
                'a057R000011DCY5QAO',
                'a057R000011DCgaQAG',
                'a057R000011DCeeQAG',
                'a057R000011DCgVQAW',
                'a057R000011DCiRQAW',
                'a057R000011DCiWQAW',
                'a057R000011DCeZQAW',
                'a057R000011DCTAQA4',
                'a057R000011DCbpQAG',
                'a057R000011DCeUQAW',
                'a057R000011DCZDQA4',
                'a057R000011DCgfQAG'
        };
        List<Hospital__c> hospitals = [
                SELECT Id,
                        isdeleted,
                        ExternalHospitalId__c,
                        Name,
                        Country__c,
                        Town__c,
                        Street__c,
                        Email__c,
                        Integrated__c,
                        Integration_Try_Number__c
                FROM Hospital__c
                WHERE Id NOT IN :malformedObjects AND Integrated__c = false AND Integration_Try_Number__c < 3
                LIMIT 99 all rows];
        return hospitals;
    }

    global void execute(Database.BatchableContext batchableContext, List<Hospital__c> scope) {
        for (Hospital__c hospital : scope) {
            System.debug('Name: ' + hospital.Name + ' Id: ' + hospital.Id + ' isDeleted: ' + hospital.isDeleted);
        }
        List<Hospital__c> hospitalsForEmail = new List<Hospital__c>();
        List<Hospital__c> hospitalsToDB = new List<Hospital__c>();
        if (!scope.isEmpty()) {

            List<Hospital__c> postHospitals = new List<Hospital__c>();
            List<Hospital__c> updateHospitals = new List<Hospital__c>();
            List<Hospital__c> deleteHospitals = new List<Hospital__c>();
            for (Hospital__c hospital : scope) {

                if (hospital.isDeleted == true) {
                    if (String.isNotBlank(hospital.ExternalHospitalId__c)) {
                        deleteHospitals.add(hospital);
                    }
                } else if (String.isBlank(hospital.ExternalHospitalId__c)) {
                    postHospitals.add(hospital);
                } else{
                    updateHospitals.add(hospital);
                }
            }

            MH_HospitalRESTHandler service = new MH_HospitalRESTHandler();
            if (!postHospitals.isEmpty() && postHospitals != null) {
                for (Hospital__c hospital : postHospitals) {
                    MH_HospitalRESTResponseWrapper wrapper = new MH_HospitalRESTResponseWrapper(null, hospital.Id, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c, hospital.Email__c, true);
                    MH_HospitalRESTWebServiceResponse response = service.addHospital(wrapper);
                    if (response.statusMessage.equals('Success')) {
                        hospital.Integrated__c = true;
                        hospital.ExternalHospitalId__c = response.hospitalId;
                        hospital.Integration_Try_Number__c = 0;
                    } else {
                        hospital.Integration_Try_Number__c = hospital.Integration_Try_Number__c + 1;
                        if (hospital.Integration_Try_Number__c == 3) {
                            emailMessage += '\n Record: ' + hospital + '\n issue: ' + response.statusMessage;
                            hospitalsForEmail.add(hospital);
                        }
                    }
                }
            }
            if (!updateHospitals.isEmpty() && updateHospitals != null) {

                for (Hospital__c hospital : updateHospitals) {

                    MH_HospitalRESTResponseWrapper wrapper = new MH_HospitalRESTResponseWrapper(hospital.ExternalHospitalId__c, hospital.Id, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c, hospital.Email__c, true);

                    MH_HospitalRESTWebServiceResponse response = service.updateHospital(wrapper);

                    if (response.statusMessage.contains('Success')) {
                        hospital.Integrated__c = true;
                        hospital.Integration_Try_Number__c = 0;
                    } else {
                        hospital.Integration_Try_Number__c = hospital.Integration_Try_Number__c + 1;
                        if (hospital.Integration_Try_Number__c == 3) {
                            emailMessage += '\n Record: ' + hospital + '\n issue: ' + response.statusMessage;
                            hospitalsForEmail.add(hospital);
                        }
                    }
                }
            }

            for (Hospital__c hospital : deleteHospitals) {
                MH_HospitalRESTResponseWrapper wrapper = new MH_HospitalRESTResponseWrapper(hospital.ExternalHospitalId__c, hospital.Id, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c, hospital.Email__c, true);
                MH_HospitalRESTWebServiceResponse updateResponse = service.updateHospital(wrapper);
                String updateStatusMsg = updateResponse.statusMessage;
                String responseMsg = service.deleteHospital(wrapper.id, 'true');
                if (responseMsg.contains('Success')) {
                    hospital.Integrated__c = true;
                    hospital.Integration_Try_Number__c = 0;
                } else {
                    hospital.Integration_Try_Number__c = hospital.Integration_Try_Number__c + 1;
                    if (hospital.Integration_Try_Number__c == 3) {
                        emailMessage += '\n Record: ' + hospital + '\n issue: ' + responseMsg;
                        hospitalsForEmail.add(hospital);
                    }
                }
            }

            if (!hospitalsForEmail.isEmpty()) {
                MH_Utils.sendEmailToGroup('Admins Group', 'Group Mail test subject',emailMessage);
            }

            hospitalsToDB.addAll(postHospitals);
            hospitalsToDB.addAll(updateHospitals);
            MH_Utils.disableTrigger(Hospital__c.sObjectType);
            Database.undelete(deleteHospitals);
            Database.update(deleteHospitals, false);
            Database.delete(deleteHospitals);
            List<Database.SaveResult> updateResults = Database.update(hospitalsToDB, false);
            MH_Utils.enableTrigger(Hospital__c.sObjectType);

        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}
