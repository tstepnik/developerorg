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
            responseElement.content = new List<soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper>{
                    doctorWrapper
            };
            responseElement.isSuccess = true;
            response.put('response_x', responseElement);
        }
        if (type == 'Create') {
            soapSforceComSchemasClassHcsDoctor.addDoctorResponse_element responseElement = new soapSforceComSchemasClassHcsDoctor.addDoctorResponse_element();
            responseElement.content = new List<soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper>{
                    doctorWrapper
            };
            responseElement.isSuccess = true;
            response.put('response_x', responseElement);
        }
        if (type == 'Update') {
            soapSforceComSchemasClassHcsDoctor.updateDoctorResponse_element responseElement = new soapSforceComSchemasClassHcsDoctor.updateDoctorResponse_element();
            responseElement.content = new List<soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper>{
                    doctorWrapper
            };
            responseElement.isSuccess = true;
            response.put('response_x', responseElement);
        }
        if (type == 'Delete') {
            soapSforceComSchemasClassHcsDoctor.deleteDoctorResponse_element responseElement = new soapSforceComSchemasClassHcsDoctor.deleteDoctorResponse_element();
            responseElement.isSuccess = true;
            responseElement.statusMessage = 'Success. Doctor is deleted.';
            response.put('response_x', responseElement);
        }
    }
}