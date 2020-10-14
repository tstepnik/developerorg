public with sharing class MH_HospitalRESTServiceHelper {

    public static String generateQuery(Map <String, String> parameters) {

        String query = 'SELECT Id,ExternalHospitalId__c,Name,Country__c,Town__c,Street__c,Email__c FROM Hospital__c ';
        Boolean firstQuery = true;

        if (emptyParameters(parameters)) {
            return query;
        }

        Map<String, String> params = new Map<String, String>();
        params.put('id', 'Id');
        params.put('externalId', 'ExternalHospitalId__c');
        params.put('name', 'Name');
        params.put('country', 'Country__c');
        params.put('town', 'Town__c');
        params.put('street', 'Street__c');
        params.put('email', 'Email__c');

        query += 'WHERE ';

        for (String key : parameters.keySet()) {
            if (String.isNotEmpty(parameters.get(key))) {
                if (!firstQuery) {
                    if (key == 'id') {
                        query += ' AND ' + params.get(key) + ' = \'' + parameters.get(key) + '\'';

                    } else {
                        query += ' AND ' + params.get(key) + ' LIKE \'' + parameters.get(key) + '%\'';
                    }
                } else {
                    if (key == 'id') {
                        query += params.get(key) + ' = \'' + parameters.get(key) + '\'';
                    } else {
                        query += params.get(key) + ' LIKE \'' + parameters.get(key) + '%\'';
                    }
                    firstQuery = false;
                }
            }
        }

        return query;
    }

    public static Boolean checkGetFieldsEmpty(String name, String country, String town, String street, String email) {
        return String.isBlank(name) && String.isBlank(country) && String.isBlank(town) && String.isBlank(street) && String.isBlank(email);
    }
    public static void throwErrorIfEmptyBody(String id, String externalId, String name, String country, String town, String street, String email) {
        if (String.isBlank(id) &&
                String.isBlank(externalId) &&
                String.isBlank(name) &&
                String.isBlank(country) &&
                String.isBlank(town) &&
                String.isBlank(street) &&
                String.isBlank(email)
                ) {
//            throw new DmlException('Object cannot be empty.');
            throw new DmlException(Label.MH_EmptyHospital);
        }
    }
    public static void throwErrorIfEmptyName(String name) {
        if (String.isBlank(name)) {
            throw new DmlException(Label.MH_NameFieldRequired);
        }
    }

    public static Boolean checkUpsertFieldsEmpty(String id, String name, String country, String town, String street, String email) {
        return String.isBlank(id) && String.isBlank(name) && String.isBlank(country) && String.isBlank(town) && String.isBlank(street) && String.isBlank(email);
    }

    public static List<MH_HospitalRESTResponseWrapper> convertDoctorsToDoctorsServiceWrapper(List<Hospital__c> hospitals) {
        List<MH_HospitalRESTResponseWrapper> doctorsResponseWrappers = new List<MH_HospitalRESTResponseWrapper>();
        for (Hospital__c hospital : hospitals) {
            MH_HospitalRESTResponseWrapper doctorsResponseWrapper = new MH_HospitalRESTResponseWrapper(
                    hospital.Id, hospital.ExternalHospitalId__c, hospital.Name, hospital.Country__c, hospital.Town__c, hospital.Street__c, hospital.Email__c,false);
            System.debug('WRAPPER FROM DOCTOR WHICH SHOULD HAS EXTERNAL ID:');
            System.debug(doctorsResponseWrapper);
            doctorsResponseWrappers.add(doctorsResponseWrapper);
        }
        System.debug('LISTA WRAPPEROW GET:');
        for(MH_HospitalRESTResponseWrapper wrapper : doctorsResponseWrappers){
            System.debug(wrapper);
        }
        return doctorsResponseWrappers;
    }

    public static MH_HospitalRESTWebServiceResponse upsertHospital(String id, String externalId, String name, String country, String town, String street, String email, Boolean isIntegration) {

        throwErrorIfEmptyBody(id, externalId, name, country, town, street, email);

        Hospital__c hospital = new Hospital__c(Id = id,
                ExternalHospitalId__c = externalId,
                Name = name,
                Country__c = country,
                Town__c = town,
                Street__c = street,
                Email__c = email
        );

        if (isIntegration) {
            MH_Utils.disableTrigger(Hospital__c.getSObjectType());
        }

        Database.UpsertResult result = Database.upsert(hospital);

        MH_HospitalRESTWebServiceResponse webServiceResponse = new MH_HospitalRESTWebServiceResponse
                ((String) hospital.Id,
                        result.success,
                        result.success ? Label.MH_Success_Message : MH_Utils.rewordStatusMessage(result.getErrors()[0].getMessage()));
        return webServiceResponse;
    }

    public static Boolean emptyParameters(Map<String, String> parameters) {
        if (parameters.isEmpty()) {
            return true;
        }

        for (String key : parameters.keySet()) {
            if (String.isEmpty(parameters.get(key))) {
                return true;
            }
        }
        return false;
    }
}