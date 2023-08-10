import { LightningElement,api,wire,track } from 'lwc';
import getCcontList from '@salesforce/apex/CcontactListController.getCcontList';
import updateAccList from '@salesforce/apex/CcontactListController.updateAccList';
import picklistOptions from '@salesforce/apex/CcontactListController.picklistOptions';
import { CloseActionScreenEvent } from 'lightning/actions';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class CaccEditButton extends LightningElement {
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
        setTimeout(() => {
            getCcontList({ recordId: this.recordId })
                .then(result => {
                    console.log('caccList -> ', JSON.stringify(result));
                    // .then 블록 내에서 recordId 값을 사용합니다.
                    console.log('recordId:', this.recordId);
                    this.ownerValue = result.Owner.Name; 
                    this.caccountNameValue = result.CaccountId__c; 
                    this.nameValue = result.Name; 
                    this.titleValue = result.Title__c; 
                    this.deparValue = result.Department__c; 
                    this.birthDateValue = result.Birthdate__c;   
                    this.reportValue = result.ReportsToId__c;   
                    this.phoneValue = result.Phone__c;     
                    this.homePhoneValue = result.HomePhone__c;     
                    this.mobileValue = result.Mobile__c;     
                    this.otherPhoneValue = result.OtherPhone__c;     
                    this.faxValue = result.Fax__c;     
                    this.emailValue = result.Email__c;     
                    this.assistantValue = result.Assistant__c;     
                    this.assPhoneValue = result.AssistantPhone__c;     
                    this.caccountId = result.CaccountId__c;

                    
                    // 결과 처리 및 로직 실행
                })
                .catch(error => {
                    // 오류 처리 로직
                    console.log('[ERROR]: ', error);
                });

                picklistOptions({ recordId: this.recordId })
                .then(result => {
                    console.log('result1 : ' , result);
                    console.log('result1. : ' , result.Lead_Source__c);
                    this.leadSourceOptions = result.Lead_Source__c;
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
        }, 10);
    }

    handleAccountChange(e){
        console.log('e' , e.target.value);
    }
    reportChange(e){
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
    // reportChange(e){
    //     console.log('reportValue : ' , e.detail.value );
    //     this.reportValue = e.detail.value;
    // }
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
        const birthDate = new Date(this.birthDateValue);
        updateAccList({ 
            'recordId': this.recordId,
            'nameValue': this.nameValue,
            'titleValue': this.titleValue,
            'deparValue': this.deparValue,
            'reportValue': this.reportValue,
            'phoneValue': this.phoneValue,
            'birthDateValue' :this.birthDate,
            'homePhoneValue': this.homePhoneValue,
            'mobileValue': this.mobileValue,
            'otherPhoneValue': this.otherPhoneValue,
            'faxValue': this.faxValue,
            'emailValue': this.emailValue,
            'assistantValue': this.assistantValue,
            'assPhoneValue': this.assPhoneValue
        })
            .then(result => {
                console.log('Update successful');
                this.dispatchEvent(new CloseActionScreenEvent());
                location.reload();
            })
            .catch(error => {
                console.error('Update error:', error);
            });
    }

    handleCancle(e){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}