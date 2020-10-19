public abstract class MH_Log {

    private final Integer STRING_MAX_LENGTH = 131072;

    public String type { get; set; }
    public String logGroup { get; set; }
    public String apexClassName { get; set; }
    public String apexMethodName { get; set; }
    public String message { get; set; }
    public Integer lineNumber { get; set; }
    public String stackTrace { get; set; }
    public String requestBody { get; set; }
    public String requestEndpoint { get; set; }
    public String requestMethod { get; set; }
    public String responseBody { get; set; }
    public String responseStatus { get; set; }
    public Integer responseStatusCode { get; set; }

    public void createLog() {
        System.debug('JEST W CREATE LOG');
        try {
            if (
                    (Limits.getDmlRows() < Limits.getLimitDmlRows()) &&
                            (Limits.getDmlStatements() < Limits.getLimitDmlStatements())
                    ) {
                Apex_Log__c apexLog = new Apex_Log__c(
                        Type__c = type,
                        Group__c = logGroup,
                        Apex_Class_Name__c = apexClassName,
                        Apex_Method_Name__c = apexMethodName,
                        Line_Number__c = lineNumber,
                        Message__c = message == null ? message : largeStringCutter(message),
                        StackTrace__c = stackTrace == null ? stackTrace : largeStringCutter(stackTrace),
                        Request_Body__c = largeStringCutter(requestBody),
                        Request_Endpoint__c = requestEndpoint,
                        Request_Method__c = requestMethod,
                        Response_Body__c = largeStringCutter(responseBody),
                        Response_Status__c = responseStatus,
                        Response_Status_Code__c = String.valueOf(responseStatusCode)
                );
                System.debug('INSERTUJE LOGA W CREATE LOG');
                insert apexLog;
            } else {
                System.debug('The Governor Limits have already been exhausted and hence failed to create a Log.');
            }

        } catch (DmlException e) {
            System.debug('Something bad has ocure and hence failed to create a Log! Error: ' + e.getMessage());
        }
    }

    private String largeStringCutter(String str) {
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