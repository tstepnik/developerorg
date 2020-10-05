@IsTest
public with sharing class MH_HospitalBuilder {

    private Hospital__c record;

    private MH_HospitalBuilder() {
        this.record = new Hospital__c();
    }

    public static MH_HospitalBuilder getHospitalBuilder() {
        return new MH_HospitalBuilder();
    }

    private MH_HospitalBuilder(Hospital__c record) {
        this.record = record;
    }

    public MH_HospitalBuilder setName(String name) {
        record.Name = name;
        return this;
    }

    public MH_HospitalBuilder save() {
        upsert record;
        return this;
    }

    public Hospital__c getRecord() {
        return record;
    }
}