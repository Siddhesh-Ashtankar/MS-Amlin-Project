global class ScheduleApplicantToAssetBatchClass implements Schedulable{
    global void execute(schedulableContext SC){
        database.executeBatch(new ApplicantToAssetBatchClass());
    }
    
}