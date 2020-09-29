public without sharing class MH_Contract_Service {

    public static Boolean createContact(Contract__c contract) {
        try {
            insert contract;
            return true;
        } catch (DmlException e) {
            e.setMessage(System.Label.MH_Contract_Error_Msg1);
        }
        return false;
    }

    public static Set<Contract__c> oldContracts() {
        return new Set<Contract__c>([
                SELECT Id, Date_Started__c, Expire_Date__c,Doctor__c,Hospital__c, Status__c
                FROM Contract__c
        ]);
    }

    public static void catchOverlappedContracts(Contract__c newContract, Set<Contract__c> contracts) {

        List<Contract__c> oldContracts = new List<Contract__c>();

        if (!contracts.isEmpty()) {
            for (Contract__c contract : contracts) {
                if (contract.Doctor__c.equals(newContract.Doctor__c) && contract.Hospital__c.equals(newContract.Hospital__c)) {
                    oldContracts.add(contract);
                }
            }

            String errorMessage = System.Label.MH_Contract_Error_Message2;
            Boolean isOverlapping = false;

            for (Contract__c oldContract : oldContracts) {

                Boolean newContractStartsInsideOld = newContract.Date_Started__c > oldContract.Date_Started__c && newContract.Date_Started__c < oldContract.Expire_Date__c;
                Boolean newContractEndsInsideOld = newContract.Expire_Date__c > oldContract.Date_Started__c && newContract.Expire_Date__c < oldContract.Expire_Date__c;
                Boolean newContractCoverOld = newContract.Date_Started__c <= oldContract.Date_Started__c && newContract.Expire_Date__c >= oldContract.Expire_Date__c;
                if (Date.valueOf(newContract.Expire_Date__c) > Date.valueOf('2099-12-31')) {
                }
                if (newContractEndsInsideOld || newContractStartsInsideOld || newContractCoverOld) {
                    isOverlapping = true;
                    errorMessage += ' <br>&nbsp;' + oldContract.Date_Started__c.format() + ' - ' + oldContract.Expire_Date__c.format();
                }
            }

            if (isOverlapping) {
                try {
                    newContract.addError(errorMessage);
                } catch (DmlException dmlException) {
                    dmlException.setMessage(System.Label.MH_Contract_Error_Message3);
                }
            }
        }
    }

    public static Map<String, List<Contract__c>> createContractListsFromSet(Set<Contract__c> contracts) {

        Map<String, List<Contract__c>> contractsMap = new Map<String, List<Contract__c>>();
        for (Contract__c contract : contracts) {
            String doctorId = String.valueOf(contract.Doctor__c);
            String hospitalId = String.valueOf(contract.Hospital__c);
            String mapKey = doctorId + hospitalId;
            if (contractsMap.containsKey(mapKey)) {
                List<Contract__c> contractsList = contractsMap.get(mapKey);
                contractsList.add(contract);
                contractsMap.put(mapKey, contractsList);
            } else {
                List<Contract__c> contractsList = new List<Contract__c>();
                contractsList.add(contract);
                contractsMap.put(mapKey, contractsList);
            }
        }
        return contractsMap;
    }

}