import { api,track } from 'lwc';
import LightningModal from 'lightning/modal';
import createCcase from '@salesforce/apex/CopyCaseController.createCcase'
import picklistOptions from '@salesforce/apex/CopyCaseController.picklistOptions'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent,getEnclosingAuraComponent } from 'lightning/actions';


export default class CopyCaseNew extends LightningModal {
    @api recordId;
    
    @track ownerValue;
    @track nameValue ='';
    @track caccountId;
    @track phoneValue='';
    @track emailValue='';
    @track subjectValue='';
    
    @track typeValue ='None';
    @track reasonValue ='None';
    @track statusValue ='None';
    @track priorityValue ='None';
    @track originValue='None';
    
    @track typeOptions=[{label : '--None--', value : 'None'}];
    @track reasonOptions =[{label : '--None--', value : 'None'}];
    @track statusOptions =[{label : '--None--', value : 'None'}];
    @track priorityOptions =[{label : '--None--', value : 'None'}];
    @track originOptions =[{label : '--None--', value : 'None'}];
    
    connectedCallback() {
        picklistOptions({})
        .then(result => {
            console.log('result1 : ' , result);

            this.typeOptions = result.Type__c;
            console.log('typeOptions. : ' , result.Type__c);
            
            this.reasonOptions = result.CopyCaseReason__c;
            console.log('reasonOptions. : ' , result.CopyCaseReason__c);
            
            this.statusOptions = result.Status__c;
            console.log('statusOptions. : ' , result.Status__c);
            
            this.priorityOptions = result.Priority__c;
            console.log('priorityOptions. : ' , result.Priority__c);
            
            this.originOptions = result.CopyCaseOrigin__c;
            console.log('originOptions. : ' , result.CopyCaseOrigin__c);

            this.typeOptions.unshift({
                label : '--None--'
                , value : 'None'
            });
            this.reasonOptions.unshift({
                label : '--None--'
                , value : 'None'
            });
            this.statusOptions.unshift({
                label : '--None--'
                , value : 'None'
            });
            this.priorityOptions.unshift({
                label : '--None--'
                , value : 'None'
            });
            this.originOptions.unshift({
                label : '--None--'
                , value : 'None'
            });
            

        })
        .catch(error => {
            // 오류 처리 로직
            console.log('[ERROR]: ', error);
        });
    }

    subjectChange(e){
        console.log('nameValue : ' , e.detail.value );
        this.subjectValue = e.detail.value;
    }

    nameChange(e){
        console.log('nameValue : ' , e.detail.value );
        this.nameValue = e.detail.value;
    }
    handleAccountChange(e){
        console.log('e' , e.target.value);
    }
    statusChange(e){
        console.log('statusValue : ' , e.detail.value );
        this.statusValue = e.detail.value;
    }
    typeChange(e){
        console.log('typeValue : ' , e.detail.value );
        this.typeValue = e.detail.value;
    }
    reasonChange(e){
        console.log('reasonValue : ' , e.detail.value );
        this.reasonValue = e.detail.value;
    }
    priorityChange(e){
        console.log('priorityValue : ' , e.detail.value );
        this.priorityValue = e.detail.value;
    }
    phoneChange(e){
       console.log('phoneValue : ' , e.target.value );
       this.phoneValue = e.target.value;
    }
    emailChange(e){
        console.log('emailValue : ' , e.detail.value );
        this.emailValue = e.detail.value;
    }
    originChange(e){
        console.log('originValue : ' , e.detail.value );
        this.originValue = e.detail.value;
    }
    subjectChange(e) {
        console.log('subjectValue : ' , e.detail.value );
        this.subjectValue = e.detail.value;
    }
    

    handleSave() {
        console.log('클릭됨');
        
        const ccaseData ={ 
            Name: this.nameValue,
            CaccountId__c : this.caccountId,
            Type__c : this.typeValue =='None' ? '' : this.typeValue,
            CopyCaseReason__c: this.reasonValue=='None' ? '' :this.reasonValue,
            Status__c: this.statusValue=='None' ? '' :this.statusValue,
            Priority__c: this.priorityValue =='None' ? '' :this.priorityValue,
            CcontactPhone__c: this.phoneValue,
            CcontactEmail__c: this.emailValue,
            CopyCaseOrigin__c: this.originValue =='None' ? '' :this.originValue,
            Subject__c : this.subjectValue == 'None' ? '' : this.subjectValue
           
        };
        console.log('타입 확인',  typeof(ccaseData));
        createCcase({ ccaseData : JSON.stringify(ccaseData) })
            .then(result => {
                console.log('result data',result);           
                const toastEvent = new ShowToastEvent({
                    title: 'Success',
                    message: 'New CopyCase record created',
                    variant: 'success'
                });
                this.dispatchEvent(toastEvent);
    
                // Close the modal or navigate to another page
                window.location.href = '/lightning/r/CopyCase__c/' + result.Id + '/view';
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error => {
                console.error('CopyCase creation error:', error);

                // Show an error toast message
                const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: 'An error occurred while creating the CopyCase__c record',
                    variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        });
    }

    handleCancle(e){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}