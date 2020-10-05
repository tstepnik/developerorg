@IsTest
public with sharing class MH_ContractBuilder {

    private Contract__c record;

    private MH_ContractBuilder() {
        this.record = new Contract__c();
    }

    public static MH_ContractBuilder getContractBuilder() {
        return new MH_ContractBuilder();
    }

    private MH_ContractBuilder(Contract__c record) {
        this.record = record;
    }

    public MH_ContractBuilder setDateStarted(Date dateStarted) {
        record.Date_Started__c = dateStarted;
        return this;
    }

    public MH_ContractBuilder setExpireDate(Date expiredDate) {
        record.Expire_Date__c = expiredDate;
        return this;
    }

    public MH_ContractBuilder setHospital(Hospital__c hospital) {
        record.Hospital__c = hospital.Id;
        return this;
    }

    public MH_ContractBuilder setDoctor(Doctor__c doctor) {
        record.Doctor__c = doctor.Id;
        return this;
    }

    public MH_ContractBuilder save() {
        upsert record;
        return this;
    }

    public Contract__c getRecord() {
        return record;
    }
}