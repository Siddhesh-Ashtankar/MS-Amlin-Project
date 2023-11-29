public with sharing class ApplicantController {
   
  
    @AuraEnabled
    public static List<Applicant_Details__c> searchAppplicant(Date fromdate , Date todate, String user){
        try {
            return [Select Id,  Name, Last_Name__c, Email_Id__c, Date_Of_Birth__c, CreatedDate, CreatedById From Applicant_Details__c Where CreatedDate >: fromdate and CreatedDate <: todate];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}