@isTest
private class MH_DoctorDifferentOrgControllerTest {

    @IsTest
    static void shouldReturnSearchedDoctorFromDoctorsList() {
        Test.setMock(WebServiceMock.class, new MH_DoctorWebServiceMock('Get'));

        soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper doctorWrapper = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper();
        MH_DoctorDifferentOrgController controller = new MH_DoctorDifferentOrgController();
        doctorWrapper.name = 'Name';
        doctorWrapper.lastName = 'Surname';
        doctorWrapper.country = 'USA';
        doctorWrapper.email = 'test@test.com';
        controller.searchedDoctor.name = doctorWrapper.name;
        controller.searchedDoctor.lastName = doctorWrapper.lastName;
        controller.searchedDoctor.country = doctorWrapper.country;
        controller.searchedDoctor.email = doctorWrapper.email;

        controller.searchDoctors();

        System.assertEquals(doctorWrapper.name, controller.searchedDoctor.Name);
        System.assertEquals(doctorWrapper.lastName, controller.searchedDoctor.lastName);
        System.assertEquals(doctorWrapper.country, controller.searchedDoctor.country);
        System.assertEquals(doctorWrapper.email, controller.searchedDoctor.email);
    }
    @IsTest
    static void shouldReturnCreatedDoctorId() {
        Test.setMock(WebServiceMock.class, new MH_DoctorWebServiceMock('create'));
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper doctorWrapper = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper();
        MH_DoctorDifferentOrgController controller = new MH_DoctorDifferentOrgController();

        doctorWrapper.Id = '12345';
        doctorWrapper.name = 'Name';
        doctorWrapper.lastName = 'Surname';
        doctorWrapper.town = 'Kielce';
        doctorWrapper.country = 'USA';
        doctorWrapper.email = 'test@test.com';
        doctorWrapper.birthdate = '11/11/2001';
        doctorWrapper.licenseNumber = '123123123';
        MH_DoctorSOAPService.MH_ExternalServiceParamWrapper upsertDoctor = new MH_DoctorSOAPService.MH_ExternalServiceParamWrapper(
                doctorWrapper.id,
                doctorWrapper.name,
                doctorWrapper.lastName,
                doctorWrapper.town,
                doctorWrapper.country,
                doctorWrapper.email,
                doctorWrapper.birthdate,
                doctorWrapper.licenseNumber
        );
        controller.upsertedDoctor = upsertDoctor;
        controller.setActionTypeToADD();
        controller.upsertDoctor();

        System.assertEquals(doctorWrapper.Id, controller.upsertedDoctor.Id, 'ids are different.');
    }
    @IsTest
    static void shouldReturnUpdatedDoctorId() {
        Test.setMock(WebServiceMock.class, new MH_DoctorWebServiceMock('Update'));

        soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper doctorWrapper = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper();
        MH_DoctorDifferentOrgController controller = new MH_DoctorDifferentOrgController();
        doctorWrapper.Id = '12345';
        doctorWrapper.name = 'Name';
        doctorWrapper.lastName = 'Surname';
        doctorWrapper.country = 'USA';
        doctorWrapper.email = 'test@test.com';
        MH_DoctorSOAPService.MH_ExternalServiceParamWrapper upsertDoctor = new MH_DoctorSOAPService.MH_ExternalServiceParamWrapper();
        upsertDoctor.id = doctorWrapper.Id;
        upsertDoctor.name = doctorWrapper.name;
        upsertDoctor.lastName = doctorWrapper.lastName;
        upsertDoctor.country = doctorWrapper.country;
        upsertDoctor.email = doctorWrapper.email;
        controller.upsertedDoctor = upsertDoctor;
        controller.setActionTypeToUPDATE();
        controller.upsertDoctor();

        System.assertEquals(doctorWrapper.Id, controller.upsertedDoctor.Id);
    }
    @IsTest
    static void shouldReturnExpectedMessageAfterDeleting() {
        Test.setMock(WebServiceMock.class, new MH_DoctorWebServiceMock('Delete'));
        soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper doctorWrapper = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorWrapper();
        MH_DoctorDifferentOrgController controller = new MH_DoctorDifferentOrgController();
        doctorWrapper.Id = '12345';
        doctorWrapper.name = 'Name';
        doctorWrapper.lastName = 'Surname';
        doctorWrapper.country = 'USA';
        doctorWrapper.email = 'test@test.com';
        controller.deletedDoctorId = doctorWrapper.Id;
        controller.deleteDoctor();

        System.assertEquals('Success', controller.statusMessage);
    }
    @IsTest
    static void shouldReturnEmptyListWhenCallClearMethod() {
        MH_DoctorDifferentOrgController controller = new MH_DoctorDifferentOrgController();
        List<MH_DoctorSOAPService.MH_ExternalServiceParamWrapper> paramWrappers = new List<MH_DoctorSOAPService.MH_ExternalServiceParamWrapper>();
        MH_DoctorSOAPService.MH_ExternalServiceParamWrapper searchedDoctor1 = new MH_DoctorSOAPService.MH_ExternalServiceParamWrapper();
        MH_DoctorSOAPService.MH_ExternalServiceParamWrapper searchedDoctor2 = new MH_DoctorSOAPService.MH_ExternalServiceParamWrapper();
        MH_DoctorSOAPService.MH_ExternalServiceParamWrapper searchedDoctor3 = new MH_DoctorSOAPService.MH_ExternalServiceParamWrapper();
        searchedDoctor3.name = 'John';
        searchedDoctor3.lastName = 'Kowalski';
        searchedDoctor3.birthdate = '11/11/2001';
        paramWrappers.add(searchedDoctor1);
        paramWrappers.add(searchedDoctor2);

        controller.searchedDoctors = paramWrappers;
        System.assertEquals(2, controller.searchedDoctors.size());

        controller.searchedDoctor = searchedDoctor3;
        System.assertNotEquals(null, controller.searchedDoctor);

        controller.clearTableAndSearchForm();
        System.assertEquals(0, controller.searchedDoctors.size());

    }
}