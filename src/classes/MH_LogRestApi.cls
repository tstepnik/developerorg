public abstract class MH_LogRestApi extends MH_Log {

    private final String GROUP_ERROR = 'ERROR';
    private final String GROUP_INFO = 'INFO';
    private final String API_TYPE = 'REST API';

    public class Error extends MH_LogRestApi {
    //POST ERROR
        public Error( String className, String methodName, Exception e, RestRequest request, RestResponse response) {
            this.type = API_TYPE;
            this.logGroup = GROUP_ERROR;
            this.apexClassName = className;
            this.apexMethodName = methodName;
            this.message = e.getMessage();
            this.lineNumber = e.getLineNumber();
            this.stackTrace = e.getStackTraceString();
            this.requestBody = request.requestBody != null ? request.requestBody.toString() : '';
            this.requestEndpoint = request.resourcePath;
            this.requestMethod = request.httpMethod;
            this.responseBody = response.responseBody != null ? response.responseBody.toString() : '';
            this.responseStatusCode = response.statusCode;
        }
    }

    public class Info extends MH_LogRestApi {
//POST SUCCESS
        public Info(String className, String methodName, RestRequest request, RestResponse response) {
            this.type = API_TYPE;
            this.logGroup = GROUP_INFO;
            this.apexClassName = className;
            this.apexMethodName = methodName;
            this.requestBody = request.requestBody != null ? request.requestBody.toString() : '';
            this.requestEndpoint = request.resourcePath;
            this.requestMethod = request.httpMethod;
            this.responseBody = response.responseBody != null ? response.responseBody.toString() : '';
            this.responseStatusCode = response.statusCode;
        }

    }
}