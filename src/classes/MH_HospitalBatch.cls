global class MH_HospitalBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    global Iterable<SObject> start(Database.BatchableContext batchableContext) {
        String query = 'SELECT Id, isdeleted, ExternalHospitalId__c, Name, Country__c, Town__c, Street__c, Email__c, Integrated__c, Integration_Try_Number__c FROM Hospital__c WHERE Integrated__c = false AND Name LIKE \'UPDATEDTomek%\' AND Integration_Try_Number__c < 3 LIMIT 99  all rows ';
        List<Hospital__c> hospitals = Database.query(query);
        return hospitals;
    }

    global void execute(Database.BatchableContext batchableContext, List<Hospital__c> scope) {
        for(Hospital__c hospital : scope){
            System.debug('Name : ' + hospital.Name + ' Id: ' + hospital.Id + ' externalId: ' + hospital.ExternalHospitalId__c);
        }

        List<Hospital__c> hospitalsToDB = new List<Hospital__c>();
        if (!scope.isEmpty()) {

            List<Hospital__c> postHospitals = new List<Hospital__c>();
            List<Hospital__c> updateHospitals = new List<Hospital__c>();
            List<Hospital__c> deleteHospitals = new List<Hospital__c>();
            for (Hospital__c hospital : scope) {

                if (hospital.isDeleted == true) {
                    deleteHospitals.add(hospital);
                } else if (hospital.ExternalHospitalId__c == null && !hospital.isDeleted) {
                    postHospitals.add(hospital);
                } else if(!hospital.isDeleted) {
                    updateHospitals.add(hospital);
                }
            }

            MH_HospitalRESTHandler service = new MH_HospitalRESTHandler();
            if (!postHospitals.isEmpty() && postHospitals != null) {
                for (Hospital__c hospital : postHospitals) {
                    MH_HospitalRESTResponseWrapper wrapper = new MH_HospitalRESTResponseWrapper(null, hospital.Id, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c, hospital.Email__c, true);
                    MH_HospitalRESTWebServiceResponse response = service.addHospital(wrapper);
                    System.debug('RESPONSE');
                    System.debug(response);
                    if (response.statusMessage.equals('Success')) {
                        hospital.Integrated__c = true;
                        hospital.ExternalHospitalId__c = response.hospitalId;
                        hospital.Integration_Try_Number__c = 0;
                    } else {
                        hospital.Integration_Try_Number__c = hospital.Integration_Try_Number__c + 1;
                        if (hospital.Integration_Try_Number__c == 3) {
                            MH_Utils.sendEmailToGroup('Admins Group', 'Group Mail test subject', 'Hospital with name: ' + hospital.Name + 'from external service has been tried inserted 3 times but without success. That record will not be inserted any more.');
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
                            MH_Utils.sendEmailToGroup('Admins Group', 'Group Mail test subject', 'Hospital with name: ' + hospital.Name + 'from external service has been tried updated 3 times but without success. That record will not be updated any more.');
                        }
                    }
                }
            }

            System.debug('DELETE BATCH');
            for (Hospital__c hospital : deleteHospitals) {
                System.debug('WCHODZI DO DELETE BATCH');
                System.debug(hospital);
                MH_HospitalRESTResponseWrapper wrapper = new MH_HospitalRESTResponseWrapper(hospital.ExternalHospitalId__c, hospital.Id, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c, hospital.Email__c, true);

                System.debug('name: ' + wrapper.name + ' id: ' + wrapper.id + ' external id: ' + wrapper.externalId);

                String responseMsg = service.deleteHospital(wrapper.id, 'true');
                System.debug(responseMsg);
                if (responseMsg.contains('Success')) {
                    hospital.Integrated__c = true;
                    hospital.Integration_Try_Number__c = 0;
                } else {
                    hospital.Integration_Try_Number__c = hospital.Integration_Try_Number__c + 1;
                    if (hospital.Integration_Try_Number__c == 3) {
                        MH_Utils.sendEmailToGroup('Admins Group', 'Group Mail test subject', 'Hospital with name: ' + hospital.Name + 'from external service has been tried deleted 3 times but without success. That record will not be deleted any more.');

                    }
                }
            }


            hospitalsToDB.addAll(postHospitals);
            hospitalsToDB.addAll(updateHospitals);
            MH_Utils.disableTrigger(Hospital__c.sObjectType);
            Database.undelete(deleteHospitals);
            Database.update(deleteHospitals);
            Database.delete(deleteHospitals);
            List<Database.SaveResult> updateResults = Database.update(hospitalsToDB, false);
            MH_Utils.enableTrigger(Hospital__c.sObjectType);
            //TODO check updateResults
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}
