/**
 * Created by BRITENET on 15.10.2020.
 */

global class MH_ApexLog {

    public virtual class Log {
        String type { get; set; }
        String apexClassName { get; set; }
        String apexMethodName { get; set; }
        String message { get; set; }
        Integer lineNumber { get; set; }
        String stackTrace { get; set; }
        String requestBody { get; set; }
        String requestEndpoint { get; set; }
        String requestMethod { get; set; }
        String responseBody { get; set; }
        String responseStatus { get; set; }
        String responseStatusCode { get; set; }
    }

    public class Error extends Log {

        public Error() {
        }
        public Error(String message, Integer lineNumber, String stackTrace) {
            this.type = 'ERROR';
            this.message = message;
            this.lineNumber = lineNumber;
            this.stackTrace = stackTrace;
        }
        public Error(String apexClassName, String apexMethodName, Exception e, HttpRequest request, HttpResponse response) {
            this.type = 'ERROR';
            this.apexClassName = apexClassName;
            this.apexMethodName = apexMethodName;
            this.message = e.getMessage();
            this.lineNumber = e.getLineNumber();
            this.stackTrace = e.getStackTraceString();
            this.requestBody = request.getBody();
            this.requestEndpoint = request.getEndpoint();
            this.requestMethod = request.getMethod();
            this.responseBody = response.getBody();
            this.responseStatus = response.getStatus();
            this.responseStatusCode = String.valueOf(response.getStatusCode());
        }

    }

    public class Information extends Log {
        public Information() {
        }
        public Information(String apexClassName, String apexMethodName, HttpRequest request, HttpResponse response) {
            this.type = 'INFO';
            this.apexClassName = apexClassName;
            this.apexMethodName = apexMethodName;
            this.requestBody = request.getBody();
            this.requestEndpoint = request.getEndpoint();
            this.requestMethod = request.getMethod();
            this.responseBody = response.getBody();
            this.responseStatus = response.getStatus();
            this.responseStatusCode = String.valueOf(response.getStatusCode());
        }

        public Information(String apexClassName, String apexMethodName, RestRequest request, RestResponse response) {
            this.type = 'INFO';
            this.apexClassName = apexClassName;
            this.apexMethodName = apexMethodName;
            if (request.requestBody != null) {
                this.requestBody = request.requestBody.toString();
            }
            this.requestEndpoint = request.resourcePath;
            this.requestMethod = request.httpMethod;
            if (response.responseBody != null) {
                this.responseBody = response.responseBody.toString();
            }
            this.responseStatusCode = String.valueOf(response.statusCode);
        }
    }

    public void createLog(Log logToCreate) {
        System.debug('LOG TO CREATE ');
        System.debug(logToCreate);
        try {
            if (
                    (Limits.getDmlRows() < Limits.getLimitDmlRows()) &&
                            (Limits.getDmlStatements() < Limits.getLimitDmlStatements())
                    ) {
                Apex_Log__c apexLog = new Apex_Log__c(
                        Type__c = logToCreate.type,
                        Apex_Class_Name__c = logToCreate.apexClassName,
                        Apex_Method_Name__c = logToCreate.apexMethodName,
                        Line_Number__c = logToCreate.lineNumber,
                        Message__c = logToCreate.message,
                        StackTrace__c = logToCreate.stackTrace,
                        Request_Body__c = logToCreate.requestBody,
                        Request_Endpoint__c = logToCreate.requestEndpoint,
                        Request_Method__c = logToCreate.requestMethod,
                        Response_Body__c = logToCreate.responseBody,
                        Response_Status__c = logToCreate.responseStatus,
                        Response_Status_Code__c = logToCreate.responseStatusCode
                );
                Database.insert(apexLog, false);
            } else {
                System.debug('The Governor Limits have already been exhausted and hence failed to create a Log.');
            }
        } catch (DmlException e) {
            System.debug('Something bad has ocure and hence failed to create a Log! Error: ' + e.getMessage());
        }
    }
}