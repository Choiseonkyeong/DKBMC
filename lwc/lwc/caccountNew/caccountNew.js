import { LightningElement,api,track,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent,getEnclosingAuraComponent } from 'lightning/actions';
import createAccount from '@salesforce/apex/CaccountListController.createAccount';
import picklistOptions from '@salesforce/apex/CaccountListController.picklistOptions';

export default class CaccountNew extends LightningElement {
    
    @api recordId;

    //얘네들 데이터 형태 초기화 해줘야 합니다. text면 ''으로 integer면 0으로 문자열이면 [] 이렇게
    @track Ownervalue;
    @track Namevalue = '';
    @track Numbervalue = '';
    @track Sitevalue = ''; 
    @track Revenuevalue = ''; 
    @track Phonevalue = ''; 
    @track Faxvalue = ''; 
    @track Websitevalue = ''; 
    @track TickerSymbolvalue = ''; 
    @track NumberOfEmployeesvalue = 0; 
    @track Sicvalue = ''; 



    @track typeValue = 'None'; 
    @track industryValue = 'None'; 
    @track ratingValue = 'None'; 
    @track ownerShipValue = 'None'; 
    @track typeOptions = [{label : '--None--', value : 'None'}];
    @track industryOptions = [{label : '--None--', value : 'None'}];
    @track ratingOptions = [{label : '--None--', value : 'None'}];
    @track ownerShipOptions = [{label : '--None--', value : 'None'}];
    
    connectedCallback() {
        picklistOptions({})
            .then(result => {
                console.log('result1 : ' , result);
                console.log('result1. : ' , result.Type__c);
                this.typeOptions = result.Type__c;
                this.industryOptions = result.Industry__c;
                this.ratingOptions = result.Rating__c;
                this.ownerShipOptions = result.Ownership__c;

                this.typeOptions.unshift({
                    label : '--None--'
                    , value : 'None'
                });
                this.industryOptions.unshift({
                    label : '--None--'
                    , value : 'None'
                });
                this.ratingOptions.unshift({
                    label : '--None--'
                    , value : 'None'
                });
                this.ownerShipOptions.unshift({
                    label : '--None--'
                    , value : 'None'
                });



                console.log('this.ratingOptions : ' , this.ratingOptions);

            })
            .catch(error => {
                // 오류 처리 로직
                console.log('[ERROR]: ', error);
            });
    }
   
    handleChange(e){
        console.log(e.target.value);
    }

    // isNumber(str) {
    //     return /^\d+$/.test(str);
    // }

    nameChange(e){
        console.log('name.value : ' , e.detail.value );
        this.Namevalue = e.detail.value;
    }
    NumberChange(e){
        console.log('Numbervalue : ' , e.detail.value );
        this.Numbervalue = e.detail.value;
    }
    SiteChange(e){
        console.log('Sitevalue : ' , e.detail.value );
        this.Sitevalue = e.detail.value;
    }
    PhoneChange(e){
        console.log('Phonevalue : ' , e.detail.value );
        this.Phonevalue = e.detail.value;
    }
    FaxChange(e){
        console.log('Faxvalue : ' , e.detail.value );
        this.Faxvalue = e.detail.value;
    }
    WebsiteChange(e){
        console.log('Websitevalue : ' , e.detail.value );
        this.Websitevalue = e.detail.value;
    }
    SymbolChange(e){
        console.log('TickerSymbolvalue : ' , e.detail.value );
        this.TickerSymbolvalue = e.detail.value;
    }
    EmployessChange(e){
        console.log('NumberOfEmployeesvalue : ' , e.detail.value );
        this.NumberOfEmployeesvalue = e.detail.value;
    }
    SicChange(e){
        console.log('Sicvalue : ' , e.detail.value );
        this.Sicvalue = e.detail.value;
    }
    typeChange(e){
        console.log('typeValue : ' , e.detail.value );
        this.typeValue = e.detail.value;
    }
    industryChange(e){
        console.log('industryChange : ' , e.detail.value );
        this.industryValue = e.detail.value;
    }
    ratingChange(e){
        console.log('ratingValue : ' , e.detail.value );
        this.ratingValue = e.detail.value;
    }
    ownerChange(e){
        console.log('ownerShipValue : ' , e.detail.value );
        this.ownerShipValue = e.detail.value;
    }


    handleSave() {
        console.log('클릭됨');
        const accountData ={ 
            Name: this.Namevalue,
            // Number__c: this.Numbervalue,
            Site__c: this.Sitevalue,
            Phone__c : this.Phonevalue,
            Fax__c : this.Faxvalue,
            Website__c: this.Websitevalue,
            TickerSymbol__c: this.TickerSymbolvalue,
            NumberOfEmployees__c: this.NumberOfEmployeesvalue,
            Sic__c: this.Sicvalue,

            Type__c : this.typeValue =='None' ? '' :this.typeValue,
            Rating__c : this.ratingValue=='None' ? '' :this.ratingValue,
            Industry__c : this.industryValue=='None' ? '' :this.industryValue,
            Ownership__c: this.ownerShipValue=='None' ? '' :this.ownerShipValue

        };
        createAccount({ accountData : JSON.stringify(accountData) })
        .then(result => {
            console.log('result data',result);           
            // Show a success toast message
            const toastEvent = new ShowToastEvent({
                title: 'Success',
                message: 'New Caccount__c record created',
                variant: 'success'
            });
            this.dispatchEvent(toastEvent);

            // if (result = true) {
                
            // }
            // Close the modal or navigate to another page
            window.location.href = '/lightning/r/Caccount__c/' + result.Id + '/view';
            this.dispatchEvent(new CloseActionScreenEvent());           
            console.log('창닫힘');

        })
        .catch(error => {
            console.error('Account creation error:', error);

            // Show an error toast message
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: 'An error occurred while creating the Caccount__c record',
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        });
}
    

    handleCancle(e){
        this.dispatchEvent(new CloseActionScreenEvent());
        const closeActionEvent = new CloseActionScreenEvent();
        const auraComponent = getEnclosingAuraComponent(this, 'copyAccount');
        auraComponent.dispatchEvent(closeActionEvent);
    }
}