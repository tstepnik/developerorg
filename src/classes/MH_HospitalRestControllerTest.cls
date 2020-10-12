@IsTest
private with sharing class MH_HospitalRestControllerTest {

    @IsTest
    static void should_ReturnOK_WhenCallService() {
        //Given
        MH_HospitalRestController controller = new MH_HospitalRestController();
        Test.setMock(WebServiceMock.class, new MH_HospitalRESTServiceMock());

        

        Test.startTest();
        controller.searchForHospitals();
        Test.stopTest();

    }
}