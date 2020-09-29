trigger MH_Contract_Overlapping on Contract__c (before insert, before update) {

    String errorMessage = System.Label.MH_Contract_Error_Message2;

    Set<Doctor__c> doctorsFromTriggerContracts = new Set<Doctor__c>();
    Set<Hospital__c> hospitalsFromTriggerContracts = new Set<Hospital__c>();
    Set<Contract__c> oldContracts;
    Set<Contract__c> newContracts = new Set<Contract__c>(Trigger.new);
    Map<String, List<Contract__c>> oldContractsHospitalDoctor = new Map<String, List<Contract__c>>();
    Map<String, List<Contract__c>> newContractsHospitalDoctor = new Map<String, List<Contract__c>>();

    for (Contract__c contract : Trigger.new) {
        doctorsFromTriggerContracts.add(new Doctor__c(Id = contract.Doctor__c));
        hospitalsFromTriggerContracts.add(new Hospital__c(Id = contract.Hospital__c));
    }

    oldContracts = new Set<Contract__c>(
    [
            SELECT Id, Date_Started__c, Expire_Date__c, Doctor__r.Name, Hospital__r.Name
            FROM Contract__c
            WHERE Doctor__c IN :doctorsFromTriggerContracts OR Hospital__c IN :hospitalsFromTriggerContracts
    ]);


    oldContractsHospitalDoctor = MH_Contract_Service.createContractListsFromSet(oldContracts);
    newContractsHospitalDoctor = MH_Contract_Service.createContractListsFromSet(newContracts);

    for (String keyMap : newContractsHospitalDoctor.keySet()) {

        Boolean isOld = false;
        if (oldContractsHospitalDoctor.containsKey(keyMap)) {
            Set<Contract__c> oldContracts = new Set<Contract__c>(oldContractsHospitalDoctor.get(keyMap));
            isOld = true;
        }

        List<Contract__c> newContracts = newContractsHospitalDoctor.get(keyMap);

        for (Contract__c contract : newContracts) {
            if (isOld) {
                MH_Contract_Service.catchOverlappedContracts(contract, oldContracts);
            }
            List<Contract__c> copyNewList = new List<Contract__c>(newContracts);
            Boolean removeFirst = true;

            Integer howManySameContracts = 0;
            for (Integer i = 0; i < copyNewList.size(); i++) {
                if (howManySameContracts < 1 && (Date.valueOf(copyNewList.get(i).Expire_Date__c) == Date.valueOf(contract.Expire_Date__c)) && (Date.valueOf(copyNewList.get(i).Date_Started__c) == Date.valueOf(contract.Date_Started__c))) {
                    copyNewList.remove(i);
                    howManySameContracts++;
                }
                if (howManySameContracts > 1) {
                }
            }

            MH_Contract_Service.catchOverlappedContracts(contract, new Set<Contract__c>(copyNewList));
        }
    }
}