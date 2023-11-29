/*
Prevent Duplicate Contact with same email id for same account.

child to parent self
Event-				before
Opretion-			insert,update
Triggering object- Contact
Affecting object-  Contact
*/

trigger ContactTrigger on Contact (before insert,before update) {
    
    //1] Create a set 
    set<Id> setAccId=new set<Id>();
    if(trigger.isbefore && (trigger.isinsert || trigger.isupdate)){
        for(Contact objCon:trigger.new){
            setAccId.add(objCon.AccountId);
        }
    }
    
    //2] Create a aprent map
    map<Id,Account> mapAcc=new map<Id,Account>();
    if(!setAccId.isEmpty()){
        for(Account objAcc:[select Id,Name,(select Id,Name,Email from Contacts) from Account Where Id IN :setAccId]){
            mapAcc.put(objAcc.Id,objAcc);
        }
    }
    
    //3] Take trigger iteration again
    if(trigger.isbefore && (trigger.isinsert || trigger.isupdate)){
        for(Contact objCon:trigger.new){
            if(mapAcc.containsKey(objCon.AccountId)){
                List<Contact> existingContactList=mapAcc.get(objCon.AccountId).Contacts;
                
                for(Contact conObj:existingContactList){
                    if(objCon.Email==conObj.Email){
                        objCon.AddError('This Email Id already exists in another contact of this Account...');
                    }
                }
            }
        }
    }
    
}