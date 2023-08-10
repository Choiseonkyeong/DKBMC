import { LightningElement,api,track,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent,getEnclosingAuraComponent } from 'lightning/actions';
import createCcont from '@salesforce/apex/CcontactListController.createCcont';
import picklistOptions from '@salesforce/apex/CcontactListController.picklistOptions';

export default class CcontNewButton extends LightningElement {
    @api recordId;
    @track ownerValue ='';
    @track saluValue ='None';
    
    @track caccountNameValue ='';
    @track nameValue ='';
    @track titleValue='';
    @track deparValue='';
    @track birthDateValue ;
    @track reportValue='';
    @track leadSourceyValue='None';
    @track phoneValue=''; 
    @track otherPhoneValue=''; 
    @track homePhoneValue='';
    @track mobileValue='';
    @track faxValue='';
    @track emailValue='';
    @track assistantValue='';
    @track assPhoneValue='';

    @track caccountId = '';
    
    @track leadSourceOptions=[{label : '--None--', value : 'None'}];
    @track saluOptions =[{label : '--None--', value : 'None'}];
    
    connectedCallback() {
        picklistOptions({})
        .then(result => {
            console.log('result1 : ' , result);
            this.leadSourceOptions = result.Lead_Source__c;
            console.log('result1. : ' , result.Lead_Source__c);
            this.saluOptions = result.Salutation__c;

            this.leadSourceOptions.unshift({
                label : '--None--'
                , value : 'None'
            });
            this.saluOptions.unshift({
                label : '--None--'
                , value : 'None'
            });
            

        })
        .catch(error => {
            // 오류 처리 로직
            console.log('[ERROR]: ', error);
        });
    }

    handleAccountChange(e){
        console.log('e' , e.target.value);
    }

    handleChange(e){
        console.log(e.target.value);
    }

    nameChange(e){
        console.log('nameValue : ' , e.detail.value );
        this.nameValue = e.detail.value;
    }

    titleChange(e){
        console.log('titleValue : ' , e.detail.value );
        this.titleValue = e.detail.value;
    }

    deparChange(e){
        console.log('deparValue : ' , e.detail.value );
        this.deparValue = e.detail.value;
    }
    
   birthDateChange(e){
       console.log('birthDateValue : ' , e.target.value );
       this.birthDateValue = e.target.value;
   }
    reportChange(e){
        console.log('reportValue : ' , e.detail.value );
        this.reportValue = e.detail.value;
    }

    phoneChange(e){
        console.log('phoneValue : ' , e.detail.value );
        this.phoneValue = e.detail.value;
    }

    homePhoneChange(e){
        console.log('homePhoneValue : ' , e.detail.value );
        this.homePhoneValue = e.detail.value;
    }

    mobileChange(e){
        console.log('mobileValue : ' , e.detail.value );
        this.mobileValue = e.detail.value;
    }

    otherPhoneChange(e){
        console.log('otherPhoneValue : ' , e.detail.value );
        this.otherPhoneValue = e.detail.value;
    }

    faxChange(e){
        console.log('faxValue : ' , e.detail.value );
        this.faxValue = e.detail.value;
    }

    emailChange(e){
        console.log('emailValue : ' , e.detail.value );
        this.emailValue = e.detail.value;
    }

    assistantChange(e){
        console.log('assistantValue : ' , e.detail.value );
        this.assistantValue = e.detail.value;
    }

    assPhoneChange(e){
        console.log('assPhoneValue : ' , e.detail.value );
        this.assPhoneValue = e.detail.value;
    }

    handleSave() {
        console.log('클릭됨');
        
        const cccontData ={ 
            Name: this.nameValue,
            // Number__c: this.Numbervalue,
            CaccountId__c : this.caccountId,
            Title__c : this.titleValue,
            Department__c: this.deparValue,
            Birthdate__c: this.birthDateValue,
            ReportsToId__c: this.reportValue,
            Phone__c: this.phoneValue,
            HomePhone__c: this.homePhoneValue,
            OtherPhone__c: this.otherPhoneValue,
            Fax__c: this.faxValue,
            Email__c: this.emailValue,
            Assistant__c: this.assistantValue,
            AssistantPhone__c: this.assPhoneValue,

            Lead_Source__c : this.leadSourceyValue =='None' ? '' :this.leadSourceyValue,
            Salutation__c : this.saluValue=='None' ? '' :this.saluValue,
           
        };
        createCcont({ cccontData : JSON.stringify(cccontData) })
            .then(result => {
                console.log('result data',result);           
                const toastEvent = new ShowToastEvent({
                    title: 'Success',
                    message: 'New Ccontact__c record created',
                    variant: 'success'
                });
                this.dispatchEvent(toastEvent);
    
                // Close the modal or navigate to another page
                window.location.href = '/lightning/r/Ccontact__c/' + result.Id + '/view';
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error => {
                console.error('Ccontact creation error:', error);

                // Show an error toast message
                const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: 'An error occurred while creating the Ccontact__c record',
                    variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        });
    }

    handleCancle(e){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}