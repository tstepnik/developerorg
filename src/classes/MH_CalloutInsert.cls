public with sharing class MH_CalloutInsert implements Queueable, Database.AllowsCallouts {

    public MH_HospitalRESTResponseWrapper wrapper;
    public String method;

    public MH_CalloutInsert(MH_HospitalRESTResponseWrapper wrapper, String method) {
        this.wrapper = wrapper;
        this.method = method;
    }

    public MH_HospitalRESTResponseWrapper setExternalId(MH_HospitalRESTResponseWrapper wrappers) {
        MH_HospitalRESTResponseWrapper w = new MH_HospitalRESTResponseWrapper();

        MH_HospitalRESTResponseWrapper wrapperWithExternalId = new MH_HospitalRESTResponseWrapper(
                w.id,
                w.name,
                w.country,
                w.town,
                w.street,
                w.email
        );

        return wrapperWithExternalId;
    }
    public MH_HospitalRESTResponseWrapper setFlagAndIdsForWrappers(MH_HospitalRESTResponseWrapper wrapper) {
        MH_HospitalRESTResponseWrapper w = new MH_HospitalRESTResponseWrapper();

        MH_HospitalRESTResponseWrapper wrapperWithFlag = new MH_HospitalRESTResponseWrapper(
                w.id,
                w.name,
                w.country,
                w.town,
                w.street,
                w.email,
                true
        );

        return wrapperWithFlag;
    }

    public void execute(QueueableContext context) {
        Boolean isSuccess = false;
        MH_HospitalRESTHandler handler = new MH_HospitalRESTHandler();

        if (method.equals('POST')) {
            MH_HospitalRESTWebServiceResponse responseWrapper;
                responseWrapper = handler.addHospital(wrapper);
                isSuccess = (responseWrapper.statusMessage.equals('Success')) ? true : false;
            Hospital__c hospital = new Hospital__c(Id = wrapper.externalId);
            if (responseWrapper.statusMessage.equals('Success')) {
                hospital.Integrated__c = true;
                hospital.ExternalHospitalId__c = responseWrapper.hospitalId;
            }else {
                hospital.Integrated__c = false;
            }
            MH_Utils.disableTrigger(Hospital__c.getSObjectType());
            Database.UpsertResult resDatabase = Database.upsert(hospital);
            MH_Utils.enableTrigger(Hospital__c.getSObjectType());
        }


        else if (method.equals('UPDATE')) {
            System.debug('UPDATE CALLOUT');
            System.debug(wrapper);
            MH_HospitalRESTWebServiceResponse response;
                response = handler.updateHospital(wrapper);
                isSuccess = (response.statusMessage.equals('Success')) ? true : false;
            Hospital__c hospital = new Hospital__c(Id = wrapper.externalId);
            System.debug(hospital);
            if (response.statusMessage.equals('Success')) {
                hospital.Integrated__c = true;
            }else {
                hospital.Integrated__c = false;
            }
            MH_Utils.disableTrigger(Hospital__c.getSObjectType());
            Database.upsert(hospital);
            MH_Utils.enableTrigger(Hospital__c.getSObjectType());
        }

        else if (method.equals('DELETE')) {
            System.debug('CALLOUT DELETE');
            //todo zamieniłe id z externalid
            System.debug(wrapper);
            Hospital__c hospital = new Hospital__c(Id = wrapper.externalId, ExternalHospitalId__c = wrapper.id);
            System.debug(hospital);
            String responseMessage = handler.deleteHospital(wrapper.id, 'true');
            isSuccess = (responseMessage.equals('Success')) ? true : false;
            System.debug(isSuccess);
            if (!isSuccess) {
                MH_Utils.disableTrigger(Hospital__c.getSObjectType());
                undelete hospital;
                hospital.Integrated__c = false;
                update hospital;
                delete hospital;
                MH_Utils.enableTrigger(Hospital__c.getSObjectType());
            }
//            Database.upsert(hospital);
        }
    }
}

