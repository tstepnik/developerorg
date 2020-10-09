global class MH_HospitalRESTWebServiceResponse {

    global String hospitalId { get; set; }
    global Boolean isSuccess { get; set; }
    global String statusMessage { get; set; }

    global MH_HospitalRESTWebServiceResponse(String id, Boolean isSuccess, String statusMessage) {
        this.hospitalId = id;
        this.isSuccess = isSuccess;
        this.statusMessage = statusMessage;
    }
}