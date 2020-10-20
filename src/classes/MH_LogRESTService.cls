@RestResource(urlMapping = '/v1/logs/*')
global with sharing class MH_LogRESTService {

    private final static Integer STRING_MAX_LENGTH = 131072;
    @HttpPost
    global static MH_LogServiceResponse addLog(
            String type,
            String logGroup,
            String apexClassName,
            String apexMethodName,
            String message,
            Integer lineNumber,
            String stackTrace,
            String requestBody,
            String requestEndpoint,
            String requestMethod,
            String responseBody,
            String responseStatus,
            String responseStatusCode,
            Datetime requestTime,
            Datetime responseTime,
            Integer responseDuration
    ) {
        MH_LogServiceResponse response;
        try {
            Apex_Log__c log = new Apex_Log__c(
                    Type__c = type,
                    Group__c = logGroup,
                    Apex_Class_Name__c = apexClassName,
                    Apex_Method_Name__c = apexMethodName,
                    Message__c = message == null ? message : largeStringCutter(message),
                    Line_Number__c = lineNumber,
                    StackTrace__c = stackTrace == null ? stackTrace : largeStringCutter(stackTrace),
                    Request_Body__c = largeStringCutter(requestBody),
                    Request_Endpoint__c = requestEndpoint,
                    Request_Method__c = requestMethod,
                    Response_Body__c = largeStringCutter(responseBody),
                    Response_Status__c = responseStatus,
                    Response_Status_Code__c = String.valueOf(responseStatusCode),
                    Request_Time__c = requestTime,
                    ResponseTime__c = responseTime,
                    Response_duration__c = responseDuration);
            insert log;
            response = new MH_LogServiceResponse(true, 'Success', log.Id);
        } catch (Exception e) {
            System.debug('FAILED TO CREATE LOG: ' + e.getMessage());
        }
        return response;
    }


    @HttpGet
    global static List<Apex_Log__c> getLogs() {
        return [SELECT Id, Type__c, Response_Status_Code__c FROM Apex_Log__c];
    }

    @HttpDelete
    global static void deleteLogs() {
        List<Apex_Log__c> logs = [SELECT Id FROM Apex_Log__c];
        delete logs;
    }

    private static String largeStringCutter(String str) {
        Integer maxlength = STRING_MAX_LENGTH;
        if (String.isNotBlank(str)) {
            Integer stringSize = str.length();
            String cautionInfo = '...REST OF THIS MESSAGE WAS CUTTED BEACUSE IT WAS TO LARGE.';
            Integer cautionMsgLength = cautionInfo.length();
            if (maxlength > cautionMsgLength) {
                Integer acceptableLength = maxlength - cautionMsgLength - 1;
                if (stringSize > acceptableLength) {
                    return str.substring(0, acceptableLength) + cautionInfo;
                }
                return str;
            }
            return cautionInfo;
        }
        return 'EMPTY';
    }
}