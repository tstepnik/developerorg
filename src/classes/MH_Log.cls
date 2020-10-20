global abstract class MH_Log {

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
    public Datetime requestTime { get; set; }
    public Datetime responseTime { get; set; }
    public Integer responseDuration {
        get {
            if (this.responseDuration == null) {
                countResponseDuration();
            }
            return responseDuration;
        }
        set;
    }

    public void createLog() {
        Map<String, Object> jsonMap = new Map<String, Object>();
        jsonMap.put('type', this.type);
        jsonMap.put('logGroup', logGroup);
        jsonMap.put('apexClassName', this.apexClassName);
        jsonMap.put('apexMethodName', this.apexMethodName);
        jsonMap.put('message', this.message);
        jsonMap.put('lineNumber', this.lineNumber);
        jsonMap.put('stackTrace', this.stackTrace);
        jsonMap.put('requestBody', this.requestBody);
        jsonMap.put('requestEndpoint', this.requestEndpoint);
        jsonMap.put('requestMethod', this.requestMethod);
        jsonMap.put('responseBody', this.responseBody);
        jsonMap.put('responseStatus', this.responseStatus);
        jsonMap.put('responseStatusCode', this.responseStatusCode);
        if (this.requestTime != null) {
            jsonMap.put('requestTime', this.requestTime);
        } else {
            jsonMap.put('requestTime', Datetime.now());
        }
        if (this.responseTime != null) {
            jsonMap.put('responseTime', this.responseTime);
        } else {
            jsonMap.put('responseTime', Datetime.now());
        }
        countResponseDuration();
        jsonMap.put('responseDuration', this.responseDuration);

        MH_LogRESTHandler.getLogHandler().addLog(jsonMap);
    }

    public void countResponseDuration() {
        if (responseTime != null && requestTime != null) {
            this.responseDuration = responseTime.millisecond() - requestTime.millisecond();
        }
    }
}