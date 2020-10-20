public with sharing class MH_Utils {



   public static Set<SObjectType> disabledTriggers = new Set<SObjectType>();

    public static Boolean isConfigurationEnabled(String configName, String value) {
        MH_Configuration__c configuration = MH_Configuration__c.getInstance(configName);
        if (configuration == null) {
            return true;
        } else {
            return configuration.Value__c.contains(value);
        }
    }

    public static Boolean isConfigurationForCurrentUserEnabled(String configName) {
        MH_Configuration__c configuration = MH_Configuration__c.getInstance(configName);
        if (configuration == null) {
            return true;
        } else {
            List<User> users = [
                    SELECT Id,Username,Country
                    FROM User
                    WHERE Id = :UserInfo.getUserId()
            ];
            User currentUser = users[0];
            return configuration.Value__c.contains(currentUser.Country);
        }
    }

    public static String generateRandomString(Integer lengthOfString) {
        final String possibleChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randomString = '';
        while (randomString.length() < lengthOfString) {
            Integer indexOfRandomChar = Math.mod(Math.abs(Crypto.getRandomInteger()), possibleChars.length());
            randomString += possibleChars.substring(indexOfRandomChar, indexOfRandomChar + 1);
        }
        return randomString;
    }
    public static String getRandomEmail() {
        return generateRandomString(10) + '@' + generateRandomString(10) + '.com';
    }

    public static String generateGUID() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid =
                h.SubString(0, 8) + '-' +
                        h.SubString(8, 12) + '-' +
                        h.SubString(12, 16) + '-' +
                        h.SubString(16, 20) + '-' +
                        h.substring(20);
        return guid;
    }

   public static List<String> getCountriesList() {
        Schema.DescribeFieldResult picklistDescribe = Doctor__c.fields.Country__c.getDescribe();
        Schema.sObjectField picklistField = picklistDescribe.getSObjectField();
        List<PicklistEntry> picklistEntriesList = picklistField.getDescribe().getPicklistValues();
        List<String> countriesLabelValueList = new List<String>();
        for (PicklistEntry entry : picklistEntriesList) {
            countriesLabelValueList.add(entry.label);
        }
        return countriesLabelValueList;
    }

    public static MH_ExternalOauth2Credentials__c getExternalOauth2Credentials(String customSetting) {
        return MH_ExternalOauth2Credentials__c.getInstance(customSetting);
    }

    public static String getConfigurationsValue(String configName){
        return MH_Configurations__c.getInstance(configName).value__c;
    }

    public static String rewordStatusMessage(String statusMessage){
        if(statusMessage.contains('INVALID_EMAIL_ADDRESS')){
            statusMessage = System.Label.Invalid_Email_Address;
        }else if(statusMessage.contains('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST')){
            statusMessage = System.Label.Invalid_Or_Null_Picklist;
        }else if(statusMessage.contains('REQUIRED_FIELD_MISSING')){
            if(statusMessage.contains('Required fields are missing: [LastName__c]'))
                statusMessage = System.Label.Required_Field_Missing;
        }else if(statusMessage.contains('DUPLICATES_DETECTED')){
            statusMessage = System.Label.Duplicates_Detected;
        }else if(statusMessage.contains('ENTITY_IS_DELETED')) {
            statusMessage = System.Label.Entity_Is_Deleted;
        }
        return statusMessage;
    }

    public static Boolean isTriggerEnabled(Schema.sObjectType soType) {
        String triggerObject = (String) soType.getDescribe().getName();
        String searchedObject;
        if (triggerObject.substring(triggerObject.length() - 3, triggerObject.length()).equals('__c')) {
            searchedObject = triggerObject.substring(0, triggerObject.length() - 3) + 'Trigger__c';
        } else {
            searchedObject = triggerObject + 'Trigger__c';
        }
        Boolean isEnabled = false;
        try {
            isEnabled = (Boolean) MH_EnableTriggerConfiguration__c.getInstance().get(searchedObject);
        } catch (SObjectException sObjectException) {
            System.debug(sObjectException.getMessage());
        }
        return (isEnabled && !disabledTriggers.contains(soType));
    }


    public static void disableTrigger(SObjectType soType){
        disabledTriggers.add(soType);
    }

    public static void enableTrigger(SObjectType soType){
        disabledTriggers.remove(soType);
    }

    public static String fromParamsToJSON(String externalId, String name, String country, String town, String street, String email, Boolean isIntegration){
        Map<String,Object> jsonMap = new Map<String, Object>();
        jsonMap.put('externalId',externalId);
        jsonMap.put('name',name);
        jsonMap.put('country',country);
        jsonMap.put('town',town);
        jsonMap.put('street',street);
        jsonMap.put('email',email);
        jsonMap.put('isIntegration',isIntegration);
        return JSON.serialize(jsonMap);
    }

    public static String fromParamsToJSON(String id, String externalId, String name, String country, String town, String street, String email, Boolean isIntegration){
        Map<String,Object> jsonMap = new Map<String, Object>();
        jsonMap.put('Id',id);
        jsonMap.put('externalId',externalId);
        jsonMap.put('name',name);
        jsonMap.put('country',country);
        jsonMap.put('town',town);
        jsonMap.put('street',street);
        jsonMap.put('email',email);
        jsonMap.put('isIntegration',isIntegration);
        return JSON.serialize(jsonMap);
    }

    public static String getFullGetResourcePath(RestRequest request){
        if (request.params.isEmpty()) {
            return request.resourcePath;
        }
        String resourcePath = 'services/apexrest' + request.requestURI + '?';

        for(String s:request.params.keyset()){
            resourcePath=resourcePath+s+'='+RestContext.request.params.get(s)+'&';
        }
        resourcePath=resourcePath.removeEnd('&');
        return resourcePath;
    }

    public static void sendEmailToGroup(String groupName, String subject, String body) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(getEmailAddresses(groupName));
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                mail
        });
    }

    private static List<String> getEmailAddresses(String groupName) {
        List<String> idList = new List<String>();
        List<String> mailToAddresses = new List<String>();
        Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = :groupName];
        for (GroupMember gm : g.groupMembers) {
            idList.add(gm.userOrGroupId);
        }
        User[] usr = [SELECT email FROM user WHERE id IN :idList];
        for (User u : usr) {
            mailToAddresses.add(u.email);
        }
        return mailToAddresses;
    }


}