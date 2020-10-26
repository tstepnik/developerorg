
public abstract class MH_LogExternalApi extends MH_Log {
    private final String GROUP_ERROR = 'ERROR';
    private final String GROUP_INFO = 'INFO';
    private final String API_TYPE = 'EXTERNAL REST API';
    private String apexClass = MH_HospitalRESTHandler.class.getName();

    public MH_LogExternalApi() {
    }

    public MH_LogExternalApi(HttpRequest request, HttpResponse response, String methodName) {
        this.apexClassName = apexClass;
        this.apexMethodName = methodName;
        this.type = API_TYPE;
        this.requestEndpoint = request.getEndpoint();
        this.requestMethod = request.getMethod();
        this.requestBody = request.getBody();
        this.responseBody = response.getBody();
        this.responseStatus = response.getStatus();
        this.responseStatusCode = response.getStatusCode();

    }

    public MH_LogExternalApi(HttpRequest request, HttpResponse response, String methodName, Datetime requestTime, Datetime responseTime) {
        this.apexClassName = apexClass;
        this.apexMethodName = methodName;
        this.type = API_TYPE;
        this.requestEndpoint = request.getEndpoint();
        this.requestMethod = request.getMethod();
        this.requestBody = request.getBody();
        this.responseBody = response.getBody();
        this.responseStatus = response.getStatus();
        this.responseStatusCode = response.getStatusCode();
        this.requestTime = requestTime;
        this.responseTime = responseTime;
    }

    public MH_LogExternalApi(HttpRequest request, HttpResponse response, Exception e, String methodName) {
        this.apexClassName = apexClass;
        this.apexMethodName = methodName;
        this.type = API_TYPE;
        this.requestEndpoint = request.getEndpoint();
        this.requestMethod = request.getMethod();
        this.requestBody = request.getBody();
        this.responseBody = response.getBody();
        this.responseStatus = response.getStatus();
        this.responseStatusCode = response.getStatusCode();
        this.message = e.getMessage();
        this.stackTrace = e.getStackTraceString();
        this.lineNumber = e.getLineNumber();
    }

    public MH_LogExternalApi(HttpRequest request, HttpResponse response, Exception e, String methodName, Datetime requestTime, Datetime responseTime) {
        this.apexClassName = apexClass;
        this.apexMethodName = methodName;
        this.type = API_TYPE;
        this.requestEndpoint = request.getEndpoint();
        this.requestMethod = request.getMethod();
        this.requestBody = request.getBody();
        this.responseBody = response.getBody();
        this.responseStatus = response.getStatus();
        this.responseStatusCode = response.getStatusCode();
        this.message = e.getMessage();
        this.stackTrace = e.getStackTraceString();
        this.lineNumber = e.getLineNumber();
        this.requestTime = requestTime;
        this.responseTime = responseTime;
    }


    public MH_LogExternalApi(HttpRequest request, Exception e, String methodName) {
        this.apexClassName = apexClass;
        this.apexMethodName = methodName;
        this.type = API_TYPE;
        this.requestEndpoint = request.getEndpoint();
        this.requestMethod = request.getMethod();
        this.requestBody = request.getBody();
        this.message = e.getMessage();
        this.stackTrace = e.getStackTraceString();
        this.lineNumber = e.getLineNumber();
    }

    public MH_LogExternalApi(HttpRequest request, Exception e, String methodName, Datetime requestTime, Datetime responseTime) {
        this.apexClassName = apexClass;
        this.apexMethodName = methodName;
        this.type = API_TYPE;
        this.requestEndpoint = request.getEndpoint();
        this.requestMethod = request.getMethod();
        this.requestBody = request.getBody();
        this.message = e.getMessage();
        this.stackTrace = e.getStackTraceString();
        this.lineNumber = e.getLineNumber();
        this.requestTime = requestTime;
        this.responseTime = responseTime;
    }


    public class Error extends MH_LogExternalApi {

        public Error(HttpRequest request, Exception e, String methodName) {
            super(request, e, methodName);
            this.logGroup = GROUP_ERROR;
        }

        public Error(HttpRequest request, HttpResponse response, String methodName) {
            super(request, response, methodName);
            this.logGroup = GROUP_ERROR;
        }

        public Error(HttpRequest request, HttpResponse response, String methodName, Datetime requestTime, Datetime responseTime) {
            super(request, response, methodName,requestTime, responseTime);
            this.logGroup = GROUP_ERROR;
        }

        public Error(HttpRequest request, HttpResponse response, Exception e, String methodName) {
            super(request, response, e, methodName);
            this.logGroup = GROUP_ERROR;
        }
    }

    public class Info extends MH_LogExternalApi {

        public Info(HttpRequest request, HttpResponse response, String methodName) {
            super(request, response, methodName);
            this.logGroup = GROUP_INFO;
        }
        public Info(HttpRequest request, HttpResponse response, String methodName,Datetime requestTime, Datetime responseTime) {
            super(request, response, methodName,requestTime,responseTime);
            this.logGroup = GROUP_INFO;
        }
    }
}