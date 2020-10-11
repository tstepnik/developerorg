public with sharing class MH_HospitalRESTServiceHelper {

    public static Boolean isExpectedType(DisplayType type){
        return type == DisplayType.PICKLIST
                || type == DisplayType.STRING
                || type == DisplayType.EMAIL
                || type == DisplayType.URL;
    }

    public static String generateQuery(Map <String, String> parameters) {
        System.debug('generateQuery paraeters');
        System.debug(parameters);
        Map<String, Schema.SObjectField> objectsTypes = Schema.getGlobalDescribe().get('Hospital__c').getDescribe().fields.getMap();


        String query = 'SELECT' +

                ' Id,' +
                ' Name,' +
                ' Country__c,' +
                ' Town__c,' +
                ' Street__c,' +
                ' Email__c,' +
                ' Phone_Number_1__c ' +

                'FROM Hospital__c ' +
                'WHERE ';

        Set<String> queryParameters = new Set<String>();

        for (String field : objectsTypes.keySet()) {

            for (String param : parameters.keySet()) {

                //todo
                String objType = objectsTypes.get(field).getDescribe().label.toLowerCase();
                String fieldName = objectsTypes.get(field).getDescribe().name;
                Boolean hasValidType = isExpectedType(objectsTypes.get(field).getDescribe().getType());

                if (objType.contains(param.toLowerCase()) && !fieldName.equals('Street_Number__c') && !fieldName.equals('Search_Email__c')) {

                    if (hasValidType) {

                        String x = parameters.get(param);
                        System.debug('parameters.get(param)');
                        System.debug(x);
                        queryParameters.add(fieldName + ' LIKE \'' + parameters.get(param) + '%' + '\'');
                    } else if (objectsTypes.get(field).getDescribe().getType() == DisplayType.PHONE) {
                        queryParameters.add(fieldName + ' LIKE \'+' + parameters.get(param).trim() + '%\'');
                    } else {
                        queryParameters.add(fieldName + ' = \'' + parameters.get(param) + '\'');
                    }
                }
            }
        }
        query += String.join((Iterable<String>) queryParameters, ' AND ');
        System.debug('query');
        System.debug(query);
        return query;
    }



    public static Boolean checkGetFieldsEmpty(String name, String country, String town, String street, String email) {
        return String.isBlank(name) && String.isBlank(country) && String.isBlank(town) && String.isBlank(street) && String.isBlank(email);
    }

    public static Boolean checkUpsertFieldsEmpty(String id, String name, String country, String town, String street, String email) {
        return String.isBlank(id) && String.isBlank(name) && String.isBlank(country) && String.isBlank(town) && String.isBlank(street) && String.isBlank(email);
    }

    public static List<MH_HospitalRESTResponseWrapper> convertDoctorsToDoctorsServiceWrapper(List<Hospital__c> hospitals) {
        List<MH_HospitalRESTResponseWrapper> doctorsResponseWrappers = new List<MH_HospitalRESTResponseWrapper>();
        for (Hospital__c hospital : hospitals) {
            MH_HospitalRESTResponseWrapper doctorsResponseWrapper = new MH_HospitalRESTResponseWrapper(
                    hospital.Id, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c, hospital.Email__c);
            doctorsResponseWrappers.add(doctorsResponseWrapper);
        }
        return doctorsResponseWrappers;
    }

    public static MH_HospitalRESTWebServiceResponse upsertHospital(String id, String name, String country, String town, String street, String email) {
        Hospital__c hospital;
        List<Hospital__c> hospitals = [SELECT Id, Name, Country__c, Town__c, Street__c, Email__c FROM Hospital__c WHERE Id = :id];

        if (hospitals.isEmpty()) {
            hospital = new Hospital__c(Name = name, Country__C = country, Town__c = town, Street__c = street, Email__c = email);
        } else {
            hospital = hospitals[0];
            hospital.Name = Name;
            hospital.Country__c = country;
            hospital.Town__c = town;
            hospital.Street__c = street;
            hospital.Email__c = email;
        }

        Database.UpsertResult result = Database.upsert(hospital);
        MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse
                ((String) hospital.Id,
                        result.success,
                        result.success ? '' : result.getErrors()[0].getMessage());
        return webServiceResponse;
    }

}