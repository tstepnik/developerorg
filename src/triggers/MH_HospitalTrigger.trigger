/**
 * Created by BRITENET on 13.10.2020.
 */

trigger MH_HospitalTrigger on Hospital__c (after insert, after update, after delete, before delete, after undelete ) {
        new MH_HospitalTriggerHandler().run();
}