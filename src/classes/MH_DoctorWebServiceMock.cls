global class MH_DoctorWebServiceMock implements WebServiceMock {
    public Boolean status;

    public MH_DoctorWebServiceMock(Boolean bool){
        this.status = bool;
    }

    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
        soapSforceComSchemasClassHcsDoctor.getDoctorsResponse_element  responseElement =
                new soapSforceComSchemasClassHcsDoctor.getDoctorsResponse_element();

        responseElement.result.isSuccess = status;
        response.put('response_getDoctors', response);
    }
}