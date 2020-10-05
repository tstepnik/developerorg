@IsTest
private class MH_ContractOverlappingHandlerTest {

//    @IsTest
//    private static void shouldAddNewContract() {
//        SetupData setupData = new SetupData();
//        setupData.createDoctor();
//        setupData.createHospital();
//        setupData.mockTriggerCustomSetting();
//
//        Test.startTest();
//        setupData.createContract(Date.newInstance(2010,9,11),Date.newInstance(2030,1,13));
//        Test.stopTest();
//
//        System.assertEquals(1,setupData.getContracts().size());
//    }
//
//    class SetupData {
//        Doctor__c doctor;
//        Hospital__c hospital;
//        Contract__c contract;
//
//        private void createDoctor() {
//            doctor = MH_DoctorBuilder.getDoctorBuilder()
//                    .setFirstName(MH_Utils.generateRandomString(8))
//                    .setLastName(MH_Utils.generateRandomString(9))
//                    .setBirthdate(Date.newInstance(1985,11,23))
//                    .save()
//                    .getRecord();
//        }
//
//        public void createHospital() {
//            hospital = MH_HospitalBuilder.getHospitalBuilder()
//                    .setName(MH_Utils.generateRandomString(9))
//                    .save()
//                    .getRecord();
//        }
//
//        public void createContract(Date startDate, Date endDate) {
//            contract = MH_ContractBuilder.getContractBuilder()
//                    .setDateStarted(startDate)
//                    .setExpireDate(endDate)
//                    .setDoctor(doctor)
//                    .setHospital(hospital)
//                    .save()
//                    .getRecord();
//        }
//
//        private List<Contract__c> getContracts(){
//            List<Contract__c> contracts = new List<Contract__c>();
//            contracts = [
//                    SELECT Id
//                    FROM Contract__c
//                    LIMIT 100
//            ];
//            return contracts;
//        }
//
//        private void mockTriggerCustomSetting(){
//            MH_EnableTriggerConfiguration__c settings = MH_EnableTriggerConfiguration__c.getInstance();
//            settings.ContractTrigger__c = true;
//
//            upsert  settings MH_EnableTriggerConfiguration__c.Id;
//        }
//    }
}