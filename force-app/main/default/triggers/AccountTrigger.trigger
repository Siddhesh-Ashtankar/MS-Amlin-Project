/*
Prevent Duplicate Account Name with same website Address(i.e. Website) and Phone.

self
Event-		before	
Opretion-   insert,update
Triggering object- Account
Affecting object-  Account
*/

trigger AccountTrigger on Account (before insert,before update) {
    
    //1] Create a set of duplicate finding field
    set<string> setAccPhone=new set<String>();
    set<string> setAccWebsite=new set<String>();
    if(trigger.isbefore && (trigger.isinsert || trigger.isupdate)){
        for(Account objAcc:trigger.new){
            setAccPhone.add(objAcc.Phone);
            setAccWebsite.add(objAcc.Website);
        }
    }
    
    //2] Create a map
    map<string,Account> mapPhone=new map<string,Account>();
    map<string,Account> mapWebsite=new map<string,Account>();
    if(!setAccPhone.isEmpty() && !setAccWebsite.isEmpty()){
        for(Account objAcc:[select Id,Name,Phone,Website from Account Where Phone In:setAccPhone and Website IN:setAccWebsite]){
            mapPhone.Put(objAcc.Phone,objAcc);
            mapWebsite.put(objAcc.Website,objAcc);
        }
    }
    
    if(!mapPhone.isEmpty() && !mapWebsite.isEmpty()){
        if(trigger.isbefore && (trigger.isinsert || trigger.isupdate)){
            for(Account objAcc:trigger.new){
                if(mapPhone.containsKey(objAcc.Phone) && mapWebsite.containsKey(objAcc.Website)){
                    objAcc.AddError('This Account Phone and Website are already exists...');
                }
            }
        }
    }
    
}