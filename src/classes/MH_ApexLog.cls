/**
 * Created by BRITENET on 15.10.2020.
 */

global class MH_ApexLog {

    public virtual class Log {
        String type;
        String apexClassName;
        String apexMethodName;
        String message;
        Integer lineNumber;
        String stackTrace;
        String requestBody;
        String requestEndpoint;
        String requestMethod;
        String responseBody;
        String responseStatus;
        Integer responseStatusCode;
    }

    public class Error extends Log {

        public Error(String type, String apexClassName, String apexMethodName, Exception e, HttpRequest request, HttpResponse response) {
            this.type = type;
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
            this.responseStatusCode = response.getStatusCode();
        }

    }

    public class Information extends Log {
        public Information(String type, String apexClassName, String apexMethodName, HttpRequest request, HttpResponse response, String StackTrace) {
            this.type = type;
            this.apexClassName = apexClassName;
            this.apexMethodName = apexMethodName;
            this.requestBody = request.getBody();
            this.requestEndpoint = request.getEndpoint();
            this.requestMethod = request.getMethod();
            this.responseBody = response.getBody();
            this.responseStatus = response.getStatus();
            this.responseStatusCode = response.getStatusCode();
        }
    }


}