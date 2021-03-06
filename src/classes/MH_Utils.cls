public with sharing class MH_Utils {

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

    public static String generateGUID(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid =
                        h.SubString(0,8)+ '-' +
                        h.SubString(8,12) + '-' +
                        h.SubString(12,16) + '-' +
                        h.SubString(16,20) + '-' +
                        h.substring(20);
        return guid;
    }
}