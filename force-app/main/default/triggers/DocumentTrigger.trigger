/*
Prevent Duplicate document details for an applicant as per identity proof document.
That means applicant must have only one driving license.If driving licence record is also available,then prevent it.

Child to parent self
Event-				before
Opretion-			insert,update
Triggering object-	Document 
Affecting object-	Applicant
*/

trigger DocumentTrigger on Document_Details__c (before insert,before update) {
	//1] Create a set of parent Id
	
    //2] Create a parent map
    
    //3] Take trigger iteration again and check Contains key
}