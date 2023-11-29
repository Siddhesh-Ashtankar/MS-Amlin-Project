import { LightningElement,api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import verifyMobile from '@salesforce/apex/ApplicantRequestAPI.verifyMobile';

export default class ApplicantMobileVerification extends LightningElement
{
    @api recordId;

   //Invoke on button click
     @api invoke(){
        console.log('Record Id ='+this.recordId);

        verifyMobile({'applicantRecordId' : this.recordId})
        .then(success=>{
            console.log(success);
            this.dispatchEvent(new CloseActionScreenEvent()); //To Close the LWC Component Automatically
            window.location.reload()
        })
        .catch(error=>{
            console.log(error);
            this.dispatchEvent(new CloseActionScreenEvent()); ////To Close the LWC Component Automatically

        })

    }
}