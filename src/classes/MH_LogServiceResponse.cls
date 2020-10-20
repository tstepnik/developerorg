
global class MH_LogServiceResponse {

    global Boolean isSuccess { get; set; }
    global String message { get; set; }
    global String logId { get; set; }

    public MH_LogServiceResponse(Boolean isSuccess, String message, String id) {
        this.isSuccess = isSuccess;
        this.message = message;
        this.logId = logId;
    }
}