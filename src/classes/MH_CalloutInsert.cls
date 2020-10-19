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
Integer calloutCounter = 0;
        MH_HospitalRESTHandler handler = new MH_HospitalRESTHandler();

        if (method.equals('POST')) {
            MH_HospitalRESTWebServiceResponse responseWrapper;
            while(calloutCounter<3 && !responseWrapper.isSuccess){
                responseWrapper = handler.addHospital(wrapper);
                calloutCounter++;
            }
            Hospital__c hospital = new Hospital__c(Id = wrapper.Id);
            if(responseWrapper.isSuccess){
                hospital.Integrated__c = true;
                hospital.ExternalHospitalId__c = responseWrapper.hospitalId;
            }
            MH_Utils.disableTrigger(Hospital__c.getSObjectType());
            Database.UpsertResult resDatabase = Database.upsert(hospital);
            if(!resDatabase.isSuccess()){

            }
            MH_Utils.enableTrigger(Hospital__c.getSObjectType());
        } else if (method.equals('UPDATE')) {
            String responseMessage = handler.updateHospital(wrapper);
            MH_Utils.enableTrigger(Hospital__c.getSObjectType());
        } else if (method.equals('DELETE')) {
            String responseMessage = handler.deleteHospital(wrapper.id, 'true');
            MH_Utils.enableTrigger(Hospital__c.getSObjectType());
        }
    }
}

