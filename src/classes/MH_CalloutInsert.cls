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

    public void execute(QueueableContext context) {
        MH_HospitalRESTHandler handler = new MH_HospitalRESTHandler();
        if (method.equals('POST')) {
            for (MH_HospitalRESTResponseWrapper wrapper : wrappers) {
                MH_Utils.disableTrigger(Hospital__c.getSObjectType());
                String responseMessage = handler.addHospital(wrapper);
                if (responseMessage.contains('Success')) {
                }

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

