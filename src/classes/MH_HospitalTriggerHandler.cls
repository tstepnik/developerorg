/**
 * Created by BRITENET on 13.10.2020.
 */

public with sharing class MH_HospitalTriggerHandler extends TriggerHandler {
    private List<Hospital__c> newList;
    private List<Hospital__c> oldList;
    private Map<Id, Hospital__c> newMap;
    private Map<Id, Hospital__c> oldMap;

    public MH_HospitalTriggerHandler() {
        this.newList = (List<Hospital__c>) Trigger.New;
        this.oldList = (List<Hospital__c>) Trigger.Old;
        this.newMap = (Map<Id, Hospital__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Hospital__c>) Trigger.oldMap;
    }

    public void runTrigger(){

            run(); //todo configuration

    }

    protected override void beforeInsert() {
    }

    protected override void beforeUpdate() {

    }

    protected override void beforeDelete() {
    }

    protected override void afterInsert() {
        MH_HospitalCalloutTriggerHandler.getInstance().afterInsert(newList);
    }

    protected override void afterUpdate() {
        MH_HospitalCalloutTriggerHandler instance = new MH_HospitalCalloutTriggerHandler();
        instance.afterUpdate(oldList);
    }

    protected override void afterDelete() {
        MH_HospitalCalloutTriggerHandler instance = new MH_HospitalCalloutTriggerHandler();
        instance.afterDelete(newList);
    }

}