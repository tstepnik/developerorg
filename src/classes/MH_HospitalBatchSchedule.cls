global class MH_HospitalBatchSchedule implements Schedulable{

    global void execute(SchedulableContext schedulableContext){
        MH_HospitalBatch batch = new MH_HospitalBatch();
        Id batchId = Database.executeBatch(batch,150);
    }
}