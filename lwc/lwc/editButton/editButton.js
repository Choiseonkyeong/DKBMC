import {api, LightningElement, track, wire} from 'lwc';
import getAccList from '@salesforce/apex/CaccountListController.getAccList';
import updateAccList from '@salesforce/apex/CaccountListController.updateAccList';
import picklistOptions from '@salesforce/apex/CaccountListController.picklistOptions';

import { CloseActionScreenEvent } from 'lightning/actions';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';


export default class EditButton extends LightningElement {
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
    @track NumberOfEmployeesvalue = ''; 
    @track Sicvalue = ''; 



    @track typeValue = 'None'; 
    @track industryValue = 'None'; 
    @track ratingValue = ''; 
    @track ownerShipValue = 'None'; 
    @track typeOptions = [{label : '--None--', value : 'None'}];
    @track industryOptions = [{label : '--None--', value : 'None'}];
    @track ratingOptions = [{label : '--None--', value : 'None'}];
    @track ownerShipOptions = [{label : '--None--', value : 'None'}];

    connectedCallback() {
        setTimeout(() => {
            getAccList({ recordId: this.recordId })
                .then(result => {
                    console.log('caccList -> ', JSON.stringify(result));
                    // .then 블록 내에서 recordId 값을 사용합니다.
                    console.log('recordId:', this.recordId);
                    this.Ownervalue = result.Owner.Name; 
                    this.Namevalue = result.Name; 
                    this.Numbervalue = result.CaccountNumber__c; 
                    this.Sitevalue = result.Site__c;   
                    this.Revenuevalue = result.AnnualRevenue__c;   
                    this.Phonevalue = result.Phone__c;     
                    this.Faxvalue = result.Fax__c;     
                    this.Websitevalue = result.Website__c;     
                    this.TickerSymbolvalue = result.TickerSymbol__c;     
                    // if (NumberOfEmployeesvalue != null) {
                    //     this.NumberOfEmployeesvalue = Integer.valueOf(this.NumberOfEmployeesvalue);
                    // }
                    this.Sicvalue = result.Sic__c;     
                    this.ratingValue = result.Rating__c;
                    

                    console.log('asd',this.ratingValue);
                    // 결과 처리 및 로직 실행
                })
                .catch(error => {
                    // 오류 처리 로직
                    console.log('[ERROR]: ', error);
                });

                picklistOptions({ recordId: this.recordId })
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
        }, 10);
    }

    handleChange(e){
        //update 하기
        console.log(e.target.value);
    }

    isNumber(str) {
        return /^\d+$/.test(str);
    }


    handleAccountChange(e){
        console.log(e.target.value);
    }

    nameChange(e){
        console.log('name.value : ' , e.detail.value );
        this.Namevalue = e.detail.value;
        console.log('Namevalue : ' , this.Namevalue );
    }
    NumberChange(e){
        console.log('Numbervalue : ' , e.detail.value );
        this.Numbervalue = e.detail.value;
        console.log('Numbervalue : ' , this.Numbervalue );
    }
    SiteChange(e){
        console.log('Sitevalue : ' , e.detail.value );
        this.Sitevalue = e.detail.value;
        console.log('Sitevalue : ' , this.Sitevalue );
    }
    PhoneChange(e){
        console.log('Phonevalue : ' , e.detail.value );
        this.Phonevalue = e.detail.value;
        console.log('Phonevalue : ' , this.Phonevalue );
    }
    FaxChange(e){
        console.log('Faxvalue : ' , e.detail.value );
        this.Faxvalue = e.detail.value;
        console.log('Faxvalue : ' , this.Faxvalue );
    }
    WebsiteChange(e){
        console.log('Websitevalue : ' , e.detail.value );
        this.Websitevalue = e.detail.value;
        console.log('Websitevalue : ' , this.Websitevalue );
    }
    SymbolChange(e){
        console.log('TickerSymbolvalue : ' , e.detail.value );
        this.TickerSymbolvalue = e.detail.value;
        console.log('TickerSymbolvalue : ' , this.TickerSymbolvalue );
    }
    EmployessChange(e){
      
        if (!this.isNumber(this.NumberOfEmployeesvalue)) {
            const toastEvent = new ShowToastEvent({
                title:'',
                message: 'employ값은 숫자만 입력이 가능합니다.',
                variant:'error' 
            });
    
            this.dispatchEvent(toastEvent);

            this.NumberOfEmployeesvalue = '';
        }else{
            this.NumberOfEmployeesvalue = e.detail.value;
        }
              
    }
    SicChange(e){
        console.log('Sicvalue : ' , e.detail.value );
        this.Sicvalue = e.detail.value;
        console.log('Sicvalue : ' , this.NumberOfEmployeesvalue );
    }
    typeChange(e){
        console.log('Sicvalue : ' , e.detail.value );
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
        updateAccList({ 
            'recordId': this.recordId,
            'Namevalue': this.Namevalue,
            'Numbervalue': this.Numbervalue,
            'Sitevalue': this.Sitevalue,
            'Phonevalue': this.Phonevalue,
            'Faxvalue': this.Faxvalue,
            'Websitevalue': this.Websitevalue,
            'TickerSymbolvalue': this.TickerSymbolvalue,
            'NumberOfEmployeesvalue': this.NumberOfEmployeesvalue,
            'Sicvalue': this.Sicvalue,

            'typeValue' : this.typeValue,
            'industryValue': this.industryValue,
            'ratingValue' : this.ratingValue,
            'ownerShipValue' : this.ownerShipValue

        })
            .then(result => {
                console.log('Update successful');
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error => {
                console.error('Update error:', error);
            });
    }

    handleCancle(e){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}