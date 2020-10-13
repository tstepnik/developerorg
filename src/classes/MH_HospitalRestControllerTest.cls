@IsTest
private with sharing class MH_HospitalRestControllerTest {

    public static MH_HospitalRestMultiMock multiMock;


    public static void setupData() {
        String responseBody = '[{"town": "Lublin","street": "Zdrowa","name": "CENTRUM","id": "a012X00003kPBhbQAG","email": "centrum@gmail.com","country": "NL"}]';
        Integer statusCode = 200;
        MH_HospitalRESTServiceMock getMock = new MH_HospitalRESTServiceMock(responseBody, statusCode);

        responseBody = '{"statusMessage": "Success","isSuccess": true,"hospitalId": "a057R000011D2OXQA0"}';
        statusCode = 201;
        MH_HospitalRESTServiceMock postMock = new MH_HospitalRESTServiceMock(responseBody, statusCode);

        responseBody = '{"statusMessage": "Success","isSuccess": true,"hospitalId": "a057R000011D2OXQA0"}';
        statusCode = 200;
        MH_HospitalRESTServiceMock putMock = new MH_HospitalRESTServiceMock(responseBody, statusCode);

        responseBody = '{"statusMessage": "Success","isSuccess": true,"hospitalId": "a057R000011D2OXQA0"}';
        statusCode = 200;
        MH_HospitalRESTServiceMock deleteMock = new MH_HospitalRESTServiceMock(responseBody, statusCode);

        Map<String, HttpCalloutMock> responses = new Map<String, HttpCalloutMock>();
        String url = 'https://eu45.salesforce.com//services/apexrest/hcs/v1/hospitals/';
        String urlGet = 'https://eu45.salesforce.com//services/apexrest/hcs/v1/hospitals/?name=CENTRUM&country=NL&town=Lublin&street=Zdrowa&email=centrum@gmail.com';
        String urlDelete = 'https://eu45.salesforce.com//services/apexrest/hcs/v1/hospitals/?id=a057R000011D2OXQA0';
        responses.put(urlGet, getMock);
        responses.put(url, postMock);
        responses.put(url, putMock);
        responses.put(urlDelete, deleteMock);

        multiMock = new MH_HospitalRestMultiMock(responses);
    }

    //GET
    @IsTest
    static void should_ReturnOneHospital_WhenInvokeGETRequest() {
        //Given
        MH_HospitalRestController controller = new MH_HospitalRestController();
        controller.hospitalSearchItem.name = 'CENTRUM';
        controller.hospitalSearchItem.town = 'Lublin';
        controller.hospitalSearchItem.country = 'NL';
        controller.hospitalSearchItem.street = 'Zdrowa';
        controller.hospitalSearchItem.email = 'centrum@gmail.com';

        setupData();
        Test.setMock(HttpCalloutMock.class, multiMock);

        //When
        Test.startTest();
        controller.searchForHospitals();
        Test.stopTest();

        //Then
        System.assertEquals(1, controller.searchedHospitals.size());
    }

    //POST
    @IsTest
    static void should_AddHospital() {

        setupData();
        MH_HospitalRestController controller = new MH_HospitalRestController();
        controller.hospitalOperationItem.name = 'CENTRUM ONKOLOGII ZIEMI LUBELSKIEJ IM. ŚW JANA Z DUKLI';
        controller.hospitalOperationItem.town = 'Lublin';
        controller.hospitalOperationItem.country = 'NL';
        controller.hospitalOperationItem.street = 'Zdrowa';
        controller.hospitalOperationItem.email = 'centrum@gmail.com';
        controller.operationHospitalId = 'a057R000011D2OXQA0';

        Test.setMock(HttpCalloutMock.class, multiMock);

        Test.startTest();
        controller.prepareInsertModal();
        controller.upsertHospital();
        Test.stopTest();

        System.assertEquals(controller.operationHospitalId, 'a057R000011D2OXQA0');
        System.assertEquals(controller.resultMessage, 'Success');
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

        setupData();
        Test.setMock(HttpCalloutMock.class, multiMock);

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

        setupData();
        Test.setMock(HttpCalloutMock.class, multiMock);

        Test.startTest();
        controller.deleteHospital();
        Test.stopTest();

        System.assertEquals(controller.resultMessage,'Success');

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