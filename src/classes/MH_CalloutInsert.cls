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
    public List<MH_HospitalRESTResponseWrapper> setFlagAndIdsForWrappers(List<MH_HospitalRESTResponseWrapper> wrappers) {
        List<MH_HospitalRESTResponseWrapper> wrappersWithExternalId = new List<MH_HospitalRESTResponseWrapper>();
        for (MH_HospitalRESTResponseWrapper w : wrappers) {
            MH_HospitalRESTResponseWrapper wrapperWithFlag = new MH_HospitalRESTResponseWrapper(
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
        System.debug('QUEABLE CONTEXT');
        MH_HospitalRESTHandler handler = new MH_HospitalRESTHandler();
        if (method.equals('POST')) {
            for (MH_HospitalRESTResponseWrapper wrapper : wrappers) {
                MH_HospitalRESTWebServiceResponse responseWrapper = handler.addHospital(wrapper);
                System.debug('response wrapper externalId: ' + responseWrapper.hospitalId);
                MH_Utils.disableTrigger(Hospital__c.getSObjectType());
                Hospital__c hospital = new Hospital__c(Id = wrapper.Id);
                hospital.ExternalHospitalId__c = responseWrapper.hospitalId;
                System.debug('external hospital id: ');
                System.debug(hospital.ExternalHospitalId__c);
                Database.UpsertResult resDatabase = Database.upsert(hospital);
                System.debug('external hospital id po apsercie: ');
                System.debug(hospital.ExternalHospitalId__c);
                MH_Utils.enableTrigger(Hospital__c.getSObjectType());

            }
        } else if (method.equals('UPDATE')) {
            for (MH_HospitalRESTResponseWrapper wrapper : wrappers) {
                System.debug('INSIDE CALLOUTINSERT WRAPPER');
                System.debug(wrapper);
                String responseMessage = handler.updateHospital(wrapper);
                MH_Utils.enableTrigger(Hospital__c.getSObjectType());
            }
        }

        else if (method.equals('DELETE')) {
            for (MH_HospitalRESTResponseWrapper wrapper : wrappers) {
                String responseMessage = handler.deleteHospital(wrapper.id, 'true');
                MH_Utils.enableTrigger(Hospital__c.getSObjectType());
            }
        }

    }
}

