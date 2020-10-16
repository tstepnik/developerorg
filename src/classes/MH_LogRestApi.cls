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

    public class Error extends MH_LogRestApi {

        //DELETE ERROR
        public Error(String responseStatus, RestRequest request, RestResponse response, Exception e) {
            super(responseStatus,request,response,e);
            this.logGroup = GROUP_ERROR;
        }
    }

    public class Info extends MH_LogRestApi {

        //DELETE SUCCEESS
        public Info(String responseStatus, RestRequest request, RestResponse response) {
            super(responseStatus,request,response);
            this.logGroup = GROUP_INFO;
        }

    }
}