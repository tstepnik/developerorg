public abstract class MH_LogRestApi extends MH_Log {

    private final String GROUP_ERROR = 'ERROR';
    private final String GROUP_INFO = 'INFO';
    private final String API_TYPE = 'REST API';

    public MH_LogRestApi(){}

    public MH_LogRestApi(String responseStatus,RestRequest request, RestResponse response){
        this.type = API_TYPE;
        this.responseStatus = responseStatus;
        this.requestEndpoint = request.resourcePath;
        this.requestMethod = request.httpMethod;
        this.responseStatusCode = response.statusCode;
    }

    public MH_LogRestApi(String responseStatus,RestRequest request, RestResponse response, Datetime requestTime, Datetime responseTime){
        this.type = API_TYPE;
        this.responseStatus = responseStatus;
        this.requestEndpoint = request.resourcePath;
        this.requestMethod = request.httpMethod;
        this.responseStatusCode = response.statusCode;
        this.requestTime = requestTime;
        this.responseTime = responseTime;
    }

    public MH_LogRestApi(String responseStatus,RestRequest request, RestResponse response, Exception e){
        this.type = API_TYPE;
        this.responseStatus = responseStatus;
        this.requestEndpoint = request.resourcePath;
        this.requestMethod = request.httpMethod;
        this.responseStatusCode = response.statusCode;
        this.message = e.getMessage();
        this.lineNumber = e.getLineNumber();
        this.stackTrace = e.getStackTraceString();
    }

    public MH_LogRestApi(String responseStatus,RestRequest request, RestResponse response, Exception e, Datetime requestTime, Datetime responseTime){
        this.type = API_TYPE;
        this.responseStatus = responseStatus;
        this.requestEndpoint = request.resourcePath;
        this.requestMethod = request.httpMethod;
        this.responseStatusCode = response.statusCode;
        this.message = e.getMessage();
        this.lineNumber = e.getLineNumber();
        this.stackTrace = e.getStackTraceString();
        this.requestTime = requestTime;
        this.responseTime = responseTime;
    }

    public class Error extends MH_LogRestApi {

        //DELETE ERROR
        public Error(String responseStatus, RestRequest request, RestResponse response, Exception e) {
            super(responseStatus,request,response,e);
            this.logGroup = GROUP_ERROR;
        }

        public Error(String responseStatus, RestRequest request, RestResponse response, Exception e, Datetime requestTime, Datetime responseTime) {
            super(responseStatus,request,response,e,responseTime,responseTime);
            this.logGroup = GROUP_ERROR;
        }
    }

    public class Info extends MH_LogRestApi {


        public Info(String responseStatus, RestRequest request, RestResponse response) {
            super(responseStatus,request,response);
            this.logGroup = GROUP_INFO;
        }

        public Info(String responseStatus, RestRequest request, RestResponse response, Datetime requestTime, Datetime responseTime) {
            super(responseStatus,request,response, requestTime, responseTime);
            this.logGroup = GROUP_INFO;
        }

    }

    public void insertLog() {
        System.debug('JEST W CREATE LOG');
        try {
            if (
                    (Limits.getDmlRows() < Limits.getLimitDmlRows()) &&
                            (Limits.getDmlStatements() < Limits.getLimitDmlStatements())
                    ) {
                System.debug('//////////////////');
                System.debug('//////////////////');
                System.debug(requestTime);
                System.debug(responseTime);
                System.debug('//////////////////');
                System.debug('//////////////////');

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
                        Response_Status_Code__c = String.valueOf(responseStatusCode),
                        Request_Time__c = requestTime,
                        ResponseTime__c = responseTime,
                        Response_duration__c = responseTime.getTime() - requestTime.getTime()
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
    private final Integer STRING_MAX_LENGTH = 131072;

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