global class MH_HospitalRESTWebServiceResponse {

    String hospitalId { get; set; }
    Boolean isSuccess { get; set; }
    String statusMessage { get; set; }

    public MH_HospitalRESTWebServiceResponse(String id, Boolean isSuccess, String statusMessage) {
        this.hospitalId = id;
        this.isSuccess = isSuccess;
        this.statusMessage = statusMessage;
    }
}