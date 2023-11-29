/*
Create a batch class to update all the applicants status checkbox to inactive ,if applicant havent purchased 
anything (if applicant does not have any asset records.) Applicant created month should be last month.
*/

global class ApplicantToAssetBatchClass implements database.Batchable<Sobject> {
    
    Set<String> successRecordsSet = new Set<String>();
    Set<String> failedRecordsSet = new Set<String>();
    
    global database.QueryLocator start(database.batchableContext BC){
        return database.getQueryLocator('select Id,Name,Active_Applicant__c,CreatedDate,(select Id,Name from Assets__r) from Applicant_Details__c where ( CreatedDate < 2023-12-30T01:02:03Z and CreatedDate > 2023-12-01T01:02:03Z )');
    }
    global void execute(database.batchableContext BC,List<Applicant_Details__c> lstApp){
        if(!lstApp.IsEmpty()){
            for(Applicant_Details__c objApp:lstApp){
                List<Asset> lstAss=objApp.Assets__r;
                if(lstAss.size()>1){
                    objApp.Active_Applicant__c=true;
                }
                else{
                    objApp.Active_Applicant__c=false;
                }
            }
            Database.SaveResult[] result =  Database.update(lstApp, false); //Success=48, Fail=3            
            Integer index=0;
            
            for(Database.SaveResult sr : result){//2
                if(sr.isSuccess()){
                    System.debug('Success = '+lstApp[index].Name);
                    successRecordsSet.add(lstApp[index].Name);
                    index++;
                }
                else{
                    System.debug('Failed = '+lstApp[index].Name);
                    failedRecordsSet.add(lstApp[index].Name);
                    index++;
                }                
                System.debug('#SUCCESS='+successRecordsSet);
                System.debug('#FAILED='+failedRecordsSet);
            }
        }
    }
    global void finish(database.batchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'siddheshashtankar11@gmail.com'});
        mail.setSenderDisplayName('Silver Micro');
        mail.setSubject('Contact Updation List');
        mail.setPlainTextBody('Success '+successRecordsSet+'\n Failed= '+failedRecordsSet);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
    
}