import { LightningElement } from 'lwc';
import searchApplicant from '@salesforce/apex/ApplicantController.searchAppplicant';
import { track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import Name from '@salesforce/schema/User.Name';

export default class ApplicantComponent extends LightningElement{

    objApplicant = {'sObjectType' : 'Applicant_Details__c'};
    appList;
    showTable;
    @track fromDate;
    @track toDate;
    userName;

    draftValues=[];
    appColumns = [
        {label : 'Applicantion Id', fieldName : 'Id' },
        {label : 'First Name', fieldName : 'First_Name__c'},
        {label : 'Last Name', fieldName : 'Last_Name__c'},
        {label : 'Email Id', fieldName : 'Email_Id__c'},
        {label : 'DOB', fieldName : 'Date_Of_Birth__c'},
        {label : 'Creates Date', fieldName : 'CreatedDate'}
    ];
    
    currentUserId = Id;
    @wire(getRecord, {recordId:Id, fields:[Name]})
    userDatail({error, data}){
        if(data){
            this.userName = data.fields.Name.value;
        } 
    }
    
    fromDateHandler(event){
        this.fromDate = event.target.value; 
    }

    toDateHandler(event){
        this.toDate = event.target.value;
    }

    searchButtonHandler(){
        searchApplicant({'fromdate' : this.fromDate, 'todate' : this.toDate})
        .then(result=>{
            this.showTable = true;
            console.log(result);
            this.appList = result;
        })
        .catch(error=>{
            console.log(error);
        })
    }

    closeButtonHandler(){
        this.showTable = false;
    }

}