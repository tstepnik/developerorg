public with sharing class MH_CalloutInsert implements Queueable, Database.AllowsCallouts {

    public List<MH_HospitalRESTResponseWrapper> wrappers;
    public String method;

    public MH_CalloutInsert(List<MH_HospitalRESTResponseWrapper> wrappers, String method) {
        this.wrappers = wrappers;
        this.method = method;
    }

    public void execute(QueueableContext context) {
        MH_HospitalRESTHandler handler = new MH_HospitalRESTHandler();
        if (method.equals('POST')) {
            for (MH_HospitalRESTResponseWrapper wrapper : wrappers) {
                String responseMessage = handler.addHospital(wrapper);

            }
        } else if (method.equals('UPDATE')) {
            for (MH_HospitalRESTResponseWrapper wrapper : wrappers) {
                String responseMessage = handler.updateHospital(wrapper);
            }
        } else if (method.equals('UPDATE')) {
            for (MH_HospitalRESTResponseWrapper wrapper : wrappers) {
                String responseMessage = handler.deleteHospital(wrapper.id);
            }
        }

    }
}

