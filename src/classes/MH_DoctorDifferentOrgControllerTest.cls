/**
 * Created by BRITENET on 07.10.2020.
 */
@isTest
private class MH_DoctorDifferentOrgControllerTest {


    //GET
    @isTest
    static void shouldSuccessWhenRetrieveDoctorList() {
        SetupData setupData = new SetupData();
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result = setupData.createDoctorRecord();
        Test.setMock(WebServiceMock.class, new MH_DoctorWebServiceMock(result));

        MH_DoctorSOAPService.MH_ExternalServiceParamWrapper doctor = new MH_DoctorSOAPService.MH_ExternalServiceParamWrapper();
        doctor.name = '';
        doctor.lastName = '';
        doctor.country = '';
        doctor.town = '';
        doctor.email = '';

        MH_DoctorDifferentOrgController controller = new MH_DoctorDifferentOrgController();
        controller.setSearchedDoctor(doctor);

        Test.startTest();
        controller.searchDoctors();
        Test.stopTest();

        Integer size = controller.searchedDoctors.size();
        System.assertEquals(2, size, 'List is empty');

    }

    @isTest
    static void shouldReturn2WhenCheckListSize() {
//        MH_DoctorResponseWrapper response = new MH_DoctorResponseWrapper();
        SetupData setupData = new SetupData();
//        List <> = setupData.createDoctorRecord();

    }

    //ADD
    @isTest
    static void should_returnSuccess_whenDelete() {
//        SetupData setupData = new SetupData();
//        soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult result = setupData.createDoctorRecord();
//        Test.setMock(WebServiceMock.class, new MH_DoctorWebServiceMock(result));
//
//        MH_DoctorSOAPService.MH_ExternalServiceParamWrapper doctor = new MH_DoctorSOAPService.MH_ExternalServiceParamWrapper();
//        doctor.id = 'a027R00000nkR31';
//        MH_DoctorDifferentOrgController controller = new MH_DoctorDifferentOrgController();
//        controller.setDeletedDoctorId(doctor.id);
//        Test.startTest();
//        controller.deleteDoctor();
//        Test.stopTest();
//        System.debug('COntroller status message');
//        System.debug(controller.statusMessage);


    }

    class SetupData {
        public soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult createDoctorRecord() {
            soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult response = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult();
            List<soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper> wrappers = new List<soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper>();

            soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper wrapper = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper();
            wrapper.birthdate = '11/11/2001';
            wrapper.country = 'PL';
            wrapper.email = 'example1@gmail.com';
            wrapper.id = '';
            wrapper.lastName = 'Nowak';
            wrapper.name = 'Jan';
            wrapper.licenseNumber = '123123123';
            wrapper.town = 'Warszawa';
            wrappers.add(wrapper);

            soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper wrapper2 = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper();
            wrapper2.birthdate = '14/01/1995';
            wrapper2.country = 'UK';
            wrapper2.email = 'example2@gmail.com';
            wrapper2.id = '';
            wrapper2.lastName = 'Kowalski';
            wrapper2.name = 'Kamil';
            wrapper2.licenseNumber = '435435435';
            wrapper2.town = 'Kraków';
            wrappers.add(wrapper2);

            response.content = wrappers;
            response.isSuccess = true;
            response.statusMessage = 'Success';
            return response;
        }
        public soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult createDeleteResponse() {
            soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult response = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebServiceResult();
            response.isSuccess = true;
            response.statusMessage = 'Success. Doctor is deleted.';
            return response;
        }
    }

}