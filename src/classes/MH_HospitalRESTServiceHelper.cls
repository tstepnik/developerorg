/**
 * Created by BRITENET on 08.10.2020.
 */

public with sharing class MH_HospitalRESTServiceHelper {
    public static String generateQuery(Map <String, String> parameters) {
        Map<String, Schema.SObjectField> objectsTypes = Schema.getGlobalDescribe().get('Hospital__c').getDescribe().fields.getMap();
        String query = 'SELECT Id, Name, Country__c, Town__c, Street__c, Email__c, Phone_Number_1__c FROM Hospital__c WHERE ';
        Set<String> queryParameters = new Set<String>();
        for (String field : objectsTypes.keySet()){
            for (String param : parameters.keySet()){
                if(objectsTypes.get(field).getDescribe().label.toLowerCase().contains(param.toLowerCase())){
                    if (objectsTypes.get(field).getDescribe().getType() == DisplayType.STRING || objectsTypes.get(field).getDescribe().getType() == DisplayType.EMAIL || objectsTypes.get(field).getDescribe().getType() == DisplayType.URL) {
                        queryParameters.add(objectsTypes.get(field).getDescribe().name+' LIKE \''+parameters.get(param)+'%\'');
                    }else if(objectsTypes.get(field).getDescribe().getType() == DisplayType.PHONE){
                        queryParameters.add(objectsTypes.get(field).getDescribe().name+' LIKE \'+'+parameters.get(param).trim()+'%\'');
                    }
                    else{
                        queryParameters.add(objectsTypes.get(field).getDescribe().name+' = \''+parameters.get(param)+'\'');
                    }
                }
            }
        }
        query += String.join((Iterable<String>)queryParameters,' AND ');
        System.debug(query);
        return query;
    }

    public static Boolean checkGetFieldsEmpty(String firstName, String lastName, String email, String country){
        return String.isBlank(firstName) && String.isBlank(lastName) && String.isBlank(email) && String.isBlank(country);
    }

    public static Boolean checkUpsertFieldsEmpty(String id, String firstName, String lastName, String email, String country, String street, String city){
        return String.isBlank(id) && String.isBlank(firstName) && String.isBlank(lastName) && String.isBlank(email) && String.isBlank(country) && String.isBlank(street) && String.isBlank(city);
    }

    public static List<MH_HospitalRESTResponseWrapper> convertDoctorsToDoctorsServiceWrapper(List<Doctor__c> doctors){
        List<MH_HospitalRESTResponseWrapper> doctorsResponseWrappers = new List<MH_HospitalRESTResponseWrapper>();
        for(Doctor__c doctor : doctors){
            MH_HospitalRESTResponseWrapper doctorsResponseWrapper = new MH_HospitalRESTResponseWrapper(doctor.Id, doctor.FirstName__c, doctor.LastName__c, doctor.Country__c, doctor.Email__c);
            doctorsResponseWrappers.add(doctorsResponseWrapper);
        }
        return doctorsResponseWrappers;
    }

    public static MH_HospitalRESTWebServiceResponse upsertDoctor(String id, String firstName, String lastName, String email, String country, String street, String city, String externalId){
        Doctor__c doctor;
        if(!String.isBlank(externalId)) {
            List<Doctor__c> doctors = [SELECT Id, FirstName__c, LastName__c, Email__c, Country__c, Street__c, City__c, ExternalDoctorId__c FROM Doctor__c WHERE ExternalDoctorId__c = :externalId];
            if (doctors.isEmpty()) {
                doctor = new Doctor__c(FirstName__c = firstName, LastName__c = lastName, Email__c = email, Country__c = country, Street__c = street, City__c = city, ExternalDoctorId__c = externalId);
            } else {
                doctor = doctors[0];
                doctor.FirstName__c = firstName;
                doctor.LastName__c = lastName;
                doctor.Email__c = email;
                doctor.Country__c = country;
                doctor.City__c = city;
            }
        }
        else{
            doctor = new Doctor__c(Id = id, FirstName__c = firstName, LastName__c = lastName, Email__c = email, Country__c = country, Street__c = street, City__c = city, ExternalDoctorId__c = externalId);
        }
        Database.UpsertResult result = Database.upsert(doctor);
        MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse(doctor.Id, result.success, result.success ? '': result.getErrors()[0].getMessage());
        return webServiceResponse;
    }

}