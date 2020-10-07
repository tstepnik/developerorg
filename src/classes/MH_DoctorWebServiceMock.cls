global class MH_DoctorWebServiceMock implements WebServiceMock {
    public soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult responseWrapper;

    public MH_DoctorWebServiceMock(soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult response){
        this.responseWrapper = response;
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

        responseElement.result = responseWrapper;
        response.put('response_x', responseElement);
    }
}