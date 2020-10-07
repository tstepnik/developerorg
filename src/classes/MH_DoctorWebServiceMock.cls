@IsTest
global class MH_DoctorWebServiceMock implements WebServiceMock {
    public String type;
    global MH_DoctorWebServiceMock(final String type) {
        this.type = type;
    }
    global void doInvoke(Object stub,

            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper doctorWrapper = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper();
        doctorWrapper.Id = '12345';
        doctorWrapper.name = 'Name';
        doctorWrapper.lastName = 'Surname';
        doctorWrapper.country = 'PL';
        doctorWrapper.email = 'test@test.com';
        doctorWrapper.birthdate = '11/11/1994';
        doctorWrapper.licenseNumber = '123123123';
        doctorWrapper.town = 'Kielce';

        if (type == 'Get') {
            soapSforceComSchemasClassHcsDoctor.getDoctorsResponse_element responseElement = new soapSforceComSchemasClassHcsDoctor.getDoctorsResponse_element();
            soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult responseWrapper = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult();
            List<soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper> wrappers = new List<soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper>{doctorWrapper};

            responseWrapper.content = wrappers;
            responseWrapper.isSuccess = true;
            responseElement.result = responseWrapper;
            response.put('response_x', responseElement);
        }
        if (type == 'Create') {
            soapSforceComSchemasClassHcsDoctor.addDoctorResponse_element responseElement = new soapSforceComSchemasClassHcsDoctor.addDoctorResponse_element();
            soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult responseWrapper = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult();
            List<soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper> wrappers = new List<soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper>{doctorWrapper};

            responseWrapper.content = wrappers;
            responseWrapper.isSuccess = true;
            responseWrapper.statusMessage = 'Success';
            responseElement.result = responseWrapper;
            response.put('response_x', responseElement);
        }
        if (type == 'Update') {
            soapSforceComSchemasClassHcsDoctor.updateDoctorResponse_element responseElement = new soapSforceComSchemasClassHcsDoctor.updateDoctorResponse_element();
            soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult responseWrapper = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult();
            List<soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper> wrappers = new List<soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper>{doctorWrapper};

            responseWrapper.content = wrappers;
            responseWrapper.isSuccess = true;
            responseWrapper.statusMessage = 'Success';
            responseElement.result = responseWrapper;
            response.put('response_x', responseElement);
        }
        if (type == 'Delete') {
            soapSforceComSchemasClassHcsDoctor.deleteDoctorResponse_element responseElement = new soapSforceComSchemasClassHcsDoctor.deleteDoctorResponse_element();
            soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult responseWrapper = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult();

            responseWrapper.isSuccess = true;
            responseWrapper.statusMessage= 'Success';
            responseElement.result = responseWrapper;
            response.put('response_x', responseElement);
        }
    }
}
