public with sharing class MH_CalloutInsert implements Queueable, Database.AllowsCallouts {

    public List<MH_HospitalRESTResponseWrapper> wrappers;
    public String method;

    public MH_CalloutInsert(List<MH_HospitalRESTResponseWrapper> wrappers, String method) {
        this.wrappers = wrappers;
        this.method = method;
    }


    public List<MH_HospitalRESTResponseWrapper> setExternalId(List<MH_HospitalRESTResponseWrapper> wrappers) {
        List<MH_HospitalRESTResponseWrapper> wrappersWithExternalId = new List<MH_HospitalRESTResponseWrapper>();
        for (MH_HospitalRESTResponseWrapper w : wrappers) {
            MH_HospitalRESTResponseWrapper wrapperWithExternalId = new MH_HospitalRESTResponseWrapper(
                    w.id,
                    w.name,
                    w.country,
                    w.town,
                    w.street,
                    w.email
            );
            wrappersWithExternalId.add(wrapperWithExternalId);
        }
        return wrappersWithExternalId;
    }
    public List<MH_HospitalRESTResponseWrapper> setFlagAndIdsForWrappers(List<MH_HospitalRESTResponseWrapper> wrappers){
        List<MH_HospitalRESTResponseWrapper> wrappersWithExternalId = new List<MH_HospitalRESTResponseWrapper>();
        for (MH_HospitalRESTResponseWrapper w : wrappers) {
            MH_HospitalRESTResponseWrapper wrapperWithFlag= new MH_HospitalRESTResponseWrapper(
                    w.id,
                    w.name,
                    w.country,
                    w.town,
                    w.street,
                    w.email,
                    true
            );
            wrappersWithExternalId.add(wrapperWithFlag);
        }
        return wrappersWithExternalId;
    }

    public void execute(QueueableContext context) {
        System.debug('WCHODZI DO QUEABLE');
        MH_HospitalRESTHandler handler = new MH_HospitalRESTHandler();
        if (method.equals('POST')) {
            for (MH_HospitalRESTResponseWrapper wrapper : wrappers) {
                //4. CALLOUT
                MH_HospitalRESTWebServiceResponse responseWrapper = handler.addHospital(wrapper);
                //9. DISABLE TRIGGER
                System.debug('9 DISABLE TRIGGER');
                System.debug('BEFORE DISABLE');
                System.debug(MH_Utils.disabledTriggers);
                MH_Utils.disableTrigger(Hospital__c.getSObjectType());
                System.debug('AFTER DISABLE');
                System.debug(MH_Utils.disabledTriggers);
                //10. UPDATE HOSPITAL
                System.debug('ID');
                System.debug(wrapper.id);
                System.debug('EXTERNAL ID');
                System.debug(responseWrapper.hospitalId);
                Hospital__c hospital = new Hospital__c(Id=wrapper.Id);
                hospital.ExternalHospitalId__c = responseWrapper.hospitalId;
                //11. ENABLE TRIGGER
                MH_Utils.enableTrigger(Hospital__c.getSObjectType());

            }
        } else if (method.equals('UPDATE')) {
            for (MH_HospitalRESTResponseWrapper wrapper : wrappers) {
                String responseMessage = handler.updateHospital(wrapper);
                if (responseMessage.contains('Success')) {
                    MH_Utils.disableTrigger(Hospital__c.getSObjectType());
                }
            }
        } else if (method.equals('DELETE')) {
            for (MH_HospitalRESTResponseWrapper wrapper : wrappers) {
                String responseMessage = handler.deleteHospital(wrapper.id);
                if (responseMessage.contains('Success')) {
                    MH_Utils.disableTrigger(Hospital__c.getSObjectType());
                }
            }
        }

    }
}

