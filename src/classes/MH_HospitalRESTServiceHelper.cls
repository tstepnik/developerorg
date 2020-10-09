public with sharing class MH_HospitalRESTServiceHelper {

    public static String generateQuery(Map <String, String> parameters) {
        System.debug('HELPER');
        System.debug('parameters');
        System.debug(parameters);
        Map<String, Schema.SObjectField> objectsTypes = Schema.getGlobalDescribe().get('Hospital__c').getDescribe().fields.getMap();


        String query = 'SELECT Id, Name, Country__c, Town__c, Street__c, Email__c, Phone_Number_1__c FROM Hospital__c WHERE ';
        Set<String> queryParameters = new Set<String>();
        for (String field : objectsTypes.keySet()) {
            for (String param : parameters.keySet()) {
                //todo
                if (objectsTypes.get(field).getDescribe().label.toLowerCase().contains(param.toLowerCase()) && !param.equals('street')) {
                    System.debug('param');
                    System.debug(param);
                    if (objectsTypes.get(field).getDescribe().getType() == DisplayType.PICKLIST || objectsTypes.get(field).getDescribe().getType() == DisplayType.STRING || objectsTypes.get(field).getDescribe().getType() == DisplayType.EMAIL || objectsTypes.get(field).getDescribe().getType() == DisplayType.URL) {
                        String x = parameters.get(param);
                        queryParameters.add(objectsTypes.get(field).getDescribe().name + ' LIKE \'' + parameters.get(param) + '%' + '\'');
                    } else if (objectsTypes.get(field).getDescribe().getType() == DisplayType.PHONE) {
                        queryParameters.add(objectsTypes.get(field).getDescribe().name + ' LIKE \'+' + parameters.get(param).trim() + '%\'');
                    } else {
                        queryParameters.add(objectsTypes.get(field).getDescribe().name + ' = \'' + parameters.get(param) + '\'');
                    }
                }
            }
        }
        query += String.join((Iterable<String>) queryParameters, ' AND ');
        System.debug('query');
        System.debug(query);
        return query;
    }

    public static Boolean checkGetFieldsEmpty(String name, String country, String email, String phone) {
        return String.isBlank(name) && String.isBlank(country) && String.isBlank(email) && String.isBlank(phone);
    }

    public static Boolean checkUpsertFieldsEmpty(String id, String name, String country, String town, String street) {
        return String.isBlank(id) && String.isBlank(name) && String.isBlank(country) && String.isBlank(town) && String.isBlank(street);
    }

    public static List<MH_HospitalRESTResponseWrapper> convertDoctorsToDoctorsServiceWrapper(List<Hospital__c> hospitals) {
        List<MH_HospitalRESTResponseWrapper> doctorsResponseWrappers = new List<MH_HospitalRESTResponseWrapper>();
        for (Hospital__c hospital : hospitals) {
            MH_HospitalRESTResponseWrapper doctorsResponseWrapper = new MH_HospitalRESTResponseWrapper(
                    hospital.Id, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c);
            doctorsResponseWrappers.add(doctorsResponseWrapper);
        }
        return doctorsResponseWrappers;
    }

    public static MH_HospitalRESTWebServiceResponse upsertHospital(String id, String name, String country, String town, String street) {
        Hospital__c hospital;
        List<Hospital__c> hospitals = [SELECT Id, Name, Country__c, Town__c, Street__c FROM Hospital__c WHERE Id = :id];

        if (hospitals.isEmpty()) {
            hospital = new Hospital__c(Name = name, Country__C = country, Town__c = town, Street__c = street);
        } else {
            hospital = hospitals[0];
            hospital.Name = Name;
            hospital.Country__c = country;
            hospital.Town__c = town;
            hospital.Street__c = street;
        }

        Database.UpsertResult result = Database.upsert(hospital);
        MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse
                ((String) hospital.Id,
                        result.success,
                        result.success ? '' : result.getErrors()[0].getMessage());
        return webServiceResponse;
    }

}