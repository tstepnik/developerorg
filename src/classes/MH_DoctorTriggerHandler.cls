public with sharing class MH_DoctorTriggerHandler extends TriggerHandler {
    private List<Doctor__c> newList;
    private List<Doctor__c> oldList;
    private Map<Id, Doctor__c> newMap;
    private Map<Id, Doctor__c> oldMap;

    public MH_DoctorTriggerHandler() {
        this.newList = (List<Doctor__c>) Trigger.New;
        this.oldList = (List<Doctor__c>) Trigger.Old;
        this.newMap = (Map<Id, Doctor__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Doctor__c>) Trigger.oldMap;
    }

    public void runTrigger(){

            run();

    }

    protected override void beforeInsert() {
        MH_DoctorOverlappingHandler.getInstance().addNonOverlappedDoctors(newList);
    }

    protected override void beforeUpdate() {

    }

    protected override void beforeDelete() {
    }

    protected override void afterInsert() {
    }

    protected override void afterUpdate() {
    }

    protected override void afterDelete() {
    }
}