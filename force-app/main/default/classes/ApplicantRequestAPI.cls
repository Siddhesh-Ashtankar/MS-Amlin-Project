global with sharing class ApplicantRequestAPI {

    @AuraEnabled
    global static void verifyMobile(Id applicantRecordId){
        system.debug(applicantRecordId);

        string mobileNumber=[select Id,Mobile_Number__c from Applicant_Details__c where ID=:applicantRecordId].Mobile_Number__c;

        Http http=new Http();
        HttpRequest request=new HttpRequest();
        request.setEndpoint('https://api.veriphone.io/v2/verify?phone='+mobileNumber+'&key=9493770FAD834D73ACC5D34A3CD51EA9');
        request.setMethod('GET');

        HttpResponse response=http.send(request);

        system.debug('Response Code ='+response.getStatusCode());
        system.debug('Response Body ='+response.getBody());

        if(response.getStatusCode()==200){
            ApplicantWrapper objWrap=ApplicantWrapper.parse(response.getBody());

            Applicant_Details__c objApp=new Applicant_Details__c(Id=applicantRecordId);
            objApp.Mobile_Opretor__c=objWrap.carrier;

            if(objWrap.phone_valid){
                objApp.Mobile_Active__c=true;
            }
            else{
                objApp.Mobile_Active__c=false;
            }

            update objApp;
        }
    }
    
}