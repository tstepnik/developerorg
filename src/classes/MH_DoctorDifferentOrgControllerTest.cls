/**
 * Created by BRITENET on 07.10.2020.
 */
@isTest
private class MH_DoctorDifferentOrgControllerTest {

    @IsTest
    static void shouldReturnSearchedDoctorFromDoctorsList() {
        Test.setMock(WebServiceMock.class, new MH_DoctorWebServiceMock('Get'));
        // given
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

        // when
        controller.searchDoctors();
// then
//        System.assertEquals(doctorWrapper.name, controller.searchedDoctor.Name);
//        System.assertEquals(doctorWrapper.lastName, controller.searchedDoctor.lastName);
//        System.assertEquals(doctorWrapper.country, controller.searchedDoctor.country);
//        System.assertEquals(doctorWrapper.email, controller.searchedDoctor.email);
    }
//    @IsTest
//    static void shouldReturnCreatedDoctorId() {
//        Test.setMock(WebServiceMock.class, new MH_DoctorWebServiceMock('Create'));
//// given
//        HD_HXDoctorsSoapWebService.doctorWrapper doctorWrapper = new HD_HXDoctorsSoapWebService.doctorWrapper();
//        MH_DoctorDifferentOrgController controller = new MH_DoctorDifferentOrgController();
//        doctorWrapper.Id = '12345';
//        doctorWrapper.name = 'Name';
//        doctorWrapper.lastName = 'Surname';
//        doctorWrapper.country = 'USA';
//        doctorWrapper.email = 'test@test.com';
//        controller.doctorForCRUD = doctorWrapper;
//// when
//        controller.addDoctor();
//// then
//        System.assertEquals(doctorWrapper.Id, controller.doctorForCRUD.Id);
//    }
//    @IsTest
//    static void shouldReturnUpdatedDoctorId() {
//        Test.setMock(WebServiceMock.class, new MH_DoctorWebServiceMock('Update'));
//// given
//        HD_HXDoctorsSoapWebService.doctorWrapper doctorWrapper = new HD_HXDoctorsSoapWebService.doctorWrapper();
//        MH_DoctorDifferentOrgController controller = new MH_DoctorDifferentOrgController();
//        doctorWrapper.Id = '12345';
//        doctorWrapper.name = 'Name';
//        doctorWrapper.lastName = 'Surname';
//        doctorWrapper.country = 'USA';
//        doctorWrapper.email = 'test@test.com';
//        controller.doctorForCRUD = doctorWrapper;
//// when
//        controller.updateDoctor();
//// then
//        System.assertEquals(doctorWrapper.Id, controller.doctorForCRUD.Id);
//    }
//    @IsTest
//    static void shouldReturnExpectedMessageAfterDeleting() {
//        Test.setMock(WebServiceMock.class, new MH_DoctorWebServiceMock('Delete'));
//// given
//        HD_HXDoctorsSoapWebService.doctorWrapper doctorWrapper = new HD_HXDoctorsSoapWebService.doctorWrapper();
//        MH_DoctorDifferentOrgController controller = new MH_DoctorDifferentOrgController();
//        doctorWrapper.Id = '12345';
//        doctorWrapper.name = 'Name';
//        doctorWrapper.lastName = 'Surname';
//        doctorWrapper.country = 'USA';
//        doctorWrapper.email = 'test@test.com';
//        controller.doctorForCRUD = doctorWrapper;
//// when
//        controller.deleteDoctor();
//// then
//        System.assert(true, System.Label.Doctor_Successfully_Deleted);
//    }
}