@IsTest
private with sharing class MH_HospitalRestControllerTest {


    //GET
    @IsTest
    static void should_ReturnOK_WhenCallService() {
        //Given
        MH_HospitalRestController controller = new MH_HospitalRestController();
        controller.hospitalSearchItem.name = 'CENTRUM ONKOLOGII ZIEMI LUBELSKIEJ IM. ŚW JANA Z DUKLI';
        controller.hospitalSearchItem.town = 'Lublin';
        controller.hospitalSearchItem.country = 'NL';
        controller.hospitalSearchItem.street = 'Zdrowa';
        controller.hospitalSearchItem.email = 'centrum@gmail.com';

        String responseBody = '[{"town": "Lublin","street": "Zdrowa","name": "CENTRUM ONKOLOGII ZIEMI LUBELSKIEJ IM. ŚW JANA Z DUKLI","id": "a012X00003kPBhbQAG","email": "centrum@gmail.com","country": "NL"}]';
        Integer statusCode = 200;
        Test.setMock(HttpCalloutMock.class, new MH_HospitalRESTServiceMock(responseBody,statusCode));

        //When
        Test.startTest();
        controller.searchForHospitals();
        Test.stopTest();

        //Then
        System.assertEquals(1, controller.searchedHospitals.size());
    }

    //POST
    @IsTest
    static void should_containsSameIDAndSuccessResponse_WhenAddHospital() {
        MH_HospitalRestController controller = new MH_HospitalRestController();
        controller.hospitalOperationItem.name = 'CENTRUM ONKOLOGII ZIEMI LUBELSKIEJ IM. ŚW JANA Z DUKLI';
        controller.hospitalOperationItem.town = 'Lublin';
        controller.hospitalOperationItem.country = 'NL';
        controller.hospitalOperationItem.street = 'Zdrowa';
        controller.hospitalOperationItem.email = 'centrum@gmail.com';
        controller.operationHospitalId = 'a057R000011D2OXQA0';

        String responseBody = '{"statusMessage": "Success","isSuccess": true,"hospitalId": "a057R000011D2OXQA0"}';
        Integer statusCode = 201;
        Test.setMock(HttpCalloutMock.class, new MH_HospitalRESTServiceMock(responseBody,statusCode));

        Test.startTest();
        controller.prepareInsertModal();
        controller.upsertHospital();
        Test.stopTest();

        System.assertEquals(controller.operationHospitalId,'a057R000011D2OXQA0');
        System.assertEquals(controller.resultMessage,'Success');
    }

    //PUT
    @IsTest
    static void should_ReturnSuccess_WhenUpdateHospital(){
        MH_HospitalRestController controller = new MH_HospitalRestController();
        controller.hospitalOperationItem.name = 'CENTRUM ONKOLOGII ZIEMI LUBELSKIEJ IM. ŚW JANA Z DUKLI';
        controller.hospitalOperationItem.town = 'Lublin';
        controller.hospitalOperationItem.country = 'NL';
        controller.hospitalOperationItem.street = 'Zdrowa';
        controller.hospitalOperationItem.email = 'centrum@gmail.com';
        controller.hospitalOperationItem.id='a057R000011D2OXQA0';

        String responseBody = '{"statusMessage": "Success","isSuccess": true,"hospitalId": "a057R000011D2OXQA0"}';
        Integer statusCode = 200;
        Test.setMock(HttpCalloutMock.class, new MH_HospitalRESTServiceMock(responseBody,statusCode));

        Test.startTest();
        controller.prepareUpdateModal();
        controller.upsertHospital();
        Test.stopTest();

        System.assertEquals(controller.resultMessage,'Success');
    }

    //DELETE
    @IsTest
    static void should_ReturnSuccess_WhenDeleteHospital(){
        MH_HospitalRestController controller = new MH_HospitalRestController();
        controller.operationHospitalId = 'a057R000011D2OXQA0';

        String responseBody = '{"statusMessage": "Success","isSuccess": true,"hospitalId": "a057R000011D2OXQA0"}';
        Integer statusCode = 200;
        Test.setMock(HttpCalloutMock.class, new MH_HospitalRESTServiceMock(responseBody,statusCode));

        Test.startTest();
        controller.deleteHospital();
        Test.stopTest();

    }


    //OTHERS
    @IsTest
    static void should_ClearObjects_WhenCallClearMethod(){
        MH_HospitalRestController controller = new MH_HospitalRestController();

        controller.hospitalSearchItem.name = 'CENTRUM ONKOLOGII ZIEMI LUBELSKIEJ IM. ŚW JANA Z DUKLI';
        controller.hospitalSearchItem.town = 'Lublin';
        controller.hospitalSearchItem.country = 'NL';
        controller.hospitalSearchItem.street = 'Zdrowa';
        controller.hospitalSearchItem.email = 'centrum@gmail.com';

        Test.startTest();
        controller.clearSearchData();
        Test.stopTest();

        System.assertEquals(controller.searchedHospitals.isEmpty(),true);
        System.assertNotEquals(controller.hospitalSearchItem.name,'CENTRUM ONKOLOGII ZIEMI LUBELSKIEJ IM. ŚW JANA Z DUKLI');

    }
}