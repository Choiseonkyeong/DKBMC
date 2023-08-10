import { api,track } from 'lwc';
import LightningModal from 'lightning/modal';
import   CCONTACT_TITLE from '@salesforce/schema/Ccontact__c.Title__c';
import   CCONTACT_LASTNAME from '@salesforce/schema/Ccontact__c.Name';
import   CCONTACT_PHONE from '@salesforce/schema/Ccontact__c.Phone__c';
import   CCONTACT_EMAIL from '@salesforce/schema/Ccontact__c.Email__c';
import CCONTACT_ACCOUNT_NAME from '@salesforce/schema/Ccontact__c.CaccountId__c';
import Ccontact from '@salesforce/schema/Ccontact__c';
import isnertccont from '@salesforce/apex/CcontactListController.isnertccont';
import caccCconRelatedList from '@salesforce/apex/CaccountListController.caccCconRelatedList';
import deleteCcont from '@salesforce/apex/CcontactListController.deleteCcont';
import updateccont from '@salesforce/apex/CcontactListController.updateccont';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class CaccRelateNew extends LightningModal {
    @api recordId;
    @api caccList;
    @track contactList = [];
    objectApiName = Ccontact
    Ccontact_LASTNAME =CCONTACT_LASTNAME;
    Ccontact_PHONE = CCONTACT_PHONE;
    Ccontact_EMAIL = CCONTACT_EMAIL;
    Ccontact_TITLE = CCONTACT_TITLE;
    Ccontact_ACCOUNT_NAME = CCONTACT_ACCOUNT_NAME;
    keyIndex = 0;
   
    @track itemList = [];
    
    @track removeIdx = [];
    @track removeId = [];



    connectedCallback(){
        console.log('check recordId:', this.recordId);
        this.caccCconRelatedList(); 
        // if (this.caccCconRelatedList && this.caccCconRelatedList.length > 0) {
        //     this.itemList = this.contactList;
        // } else {
        //     this.itemList =  [
        //         {
        //             id: 0,
        //             isChecked: false
        //         }
        //     ];
        // }   
    }
    // caccCconRelatedList({ recordId: this.recordId })
    //     .then(result => {
    //         console.log('contactList -> ', result);
    //         this.contactList = result;
    //     })
    //     .catch(error => {
    //         console.log('[ERROR]: ', error);
    //     });
    // }
    caccCconRelatedList(){
        console.log('check recordId:', this.recordId);
        caccCconRelatedList({ recordId: this.recordId })
        .then(result => {
            console.log('contactList -> ', result);
            this.itemList = result;

        
        })
        .catch(error => {
            console.log('[ERROR]: ', error);
        });
    }
    
    handleCheckboxChange(event) {
        const index = parseInt(event.target.dataset.index);
        console.log('this.itemList[index].id',this.itemList[index].Id);
        this.itemList[index].isChecked = event.target.checked;
        this.removeId.push(this.itemList[index].Id);
        console.log('ghghghg',JSON.stringify(this.removeId));
        // if (this.itemList[index].isChecked) {
        //     this.removeIdx.push(index);
        // }

        // console.log('reidx' ,  this.removeIdx);

    }
    addRow() {
        ++this.keyIndex;
        let newItem = {
            'isInsert' : true,
            'isChecked': false,
            // accountId: this.recordId
            'CaccountId__c' : this.recordId
         };
         
        this.itemList.push(newItem);
        console.log('itemList' , JSON.stringify(this.itemList));
    }
    removeRow(e) {
        
        // beforeList = [];
        // const rowId= this.itemList[index].Id;

        // this.itemList.splice(0,1);
        // for (let i = 0; i < this.itemList.length; i++) {
            //     //copydata 데이터 하나 만들기
            //     this.itemList.splice(this.removeIdx[i],this.removeIdx.length);
            //     // this.removeId.push(this.itemList[this.removeIdx[i]].Id);
            // }
            
        console.log('삭제');
        console.log('itemlist' , this.itemList);
        const indicesToRemove = [];

        for (let i = this.itemList.length - 1; i >= 0; i--) {
          if (this.itemList[i].isChecked) {
            indicesToRemove.push(i);
            
          }
        }
        console.log('5252' , indicesToRemove); 
        for (const index of indicesToRemove) {
          this.itemList.splice(index, 1);
          console.log('2111221',index);
        }
       
        // console.log('1212122' ,  JSON.stringify(this.removeIdx));
        console.log('sdsddsdsd' ,  JSON.stringify(this.removeId));
        // console.log('에엥' ,   JSON.stringify(this.beforeList));

        // if (this.itemList.length >= 0) {
        //     const index = parseInt(e.target.accessKey);
            // this.itemList = this.itemList.filter(item => !item.isChecked);
           
        // }
    }
    handleSubmit() {
        // let isVal = false;
        let cconobj = [];
        let inObj = [];
        let upObj = [];
        console.log('클클' ,JSON.stringify(this.template.querySelectorAll('lightning-record-edit-form')));
        for (let i = 0; i < this.itemList.length; i++) {
            let temp = {};
            let temp2 = {};
            this.template.querySelectorAll('lightning-input-field').forEach(element => {
                // console.log('i' , i);
                // console.log('sdfsdf' , element.dataset.idx);
                if (i == parseInt(element.dataset.idx) ) {
                    if (this.itemList[i].isInsert != undefined) {
                        temp[element.fieldName] = element.value;
                        // console.log('temp in' , JSON.stringify(temp));
                        // if (!element.value) {
                        //     isVal = true;
                        //   }
                        temp['CaccountId__c'] = this.itemList[i]['CaccountId__c'];
                        
                    }else{
                        temp2[element.fieldName] = element.value;
                        // temp[this.Ccontact_ACCOUNT_NAME.fieldApiName] = this.recordId;
                        temp['CaccountId__c'] = this.itemList[i]['CaccountId__c'];
                        
                    }
                    
                }
                // console.log('temp ' , JSON.stringify(temp));
              
                
            });

            // if (!isVal) {
                upObj.push(temp2);
                cconobj.push(temp);
            //   }
            
        }

        console.log('cconobj ' , JSON.stringify(cconobj));
        
      

        if (this.removeId.length > 0) {
            deleteCcont({ caccId: this.removeId })
            .then(() => {
            
            })
            .catch(error => {
              // 오류 처리
              console.log('[deleteCcont ERROR]: ', error);
            });
        
        }
              



        if (cconobj.length > 0) {
            isnertccont({ jsonStr: JSON.stringify(cconobj)})
            .then(result => {
              this.close('saved');
            })
            .catch(error => {
              // 오류 처리
              console.log('[isnertccont ERROR]: ', error);
            });
        }


        if (upObj.length > 0) {
            updateccont({ jsonStr: JSON.stringify(this.upObj) })
            .then((result) => {
                console.log('result' , result);
            })
            .catch(error => {
              // 오류 처리
              console.log('[updateccont ERROR]: ', error);
            });
           
        }
       
        location.reload();
        console.log('sd' , JSON.stringify(cconobj));

        
        
        // isnertccont({ jsonStr: JSON.stringify(cconobj) })
        // .then(result => {
        //     //location.reload();
        //     this.close('saved');
            
        // })
        // .catch(error => {
        //     console.log('error: ', error);
        // }); 
        


    
       
        // if (isVal) {
            // this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
            //     element.submit();
            //     console.log('클클22' , element);
            // });
            //  dispatchSuccessEvent(SUCCESS_TITLE, SUCCESS_MESSAGE);
            //   Navigate to the Account home page
        // } else {
        //     dispatchErrorEvent(ERROR_TITLE,   ERROR_MESSAGE);
        // }
    }

    handleCloseModal(){
        this.close('cancel');
    }
}