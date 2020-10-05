@IsTest
public with sharing class MH_DoctorBuilder {

    private Doctor__c record;

    private MH_DoctorBuilder() {
        this.record = new Doctor__c();
    }

    public static MH_DoctorBuilder getDoctorBuilder() {
        return new MH_DoctorBuilder();
    }

    private MH_DoctorBuilder(Doctor__c record) {
        this.record = record;
    }

    public MH_DoctorBuilder setFirstName(String firstName) {
        record.Name = firstName;
        return this;
    }

    public MH_DoctorBuilder setLastName(String lastName) {
        record.LastName__c = lastName;
        return this;
    }
    public MH_DoctorBuilder setBirthdate(Date birthdate) {
        record.Birthday__c = birthdate;
        return this;
    }

    public MH_DoctorBuilder save() {
        upsert record;
        return this;
    }

    public Doctor__c getRecord() {
        return record;
    }
}