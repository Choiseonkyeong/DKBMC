/**
 * @description       : 
 * @author            : yejoo00.lee@partner.samsung.com
 * @group             : 
 * @last modified on  : 02-17-2023
 * @last modified by  : yejoo00.lee@partner.samsung.com
**/
import { api, LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';//salesforce 에서 제공아는 toast event
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import getContactList from "@salesforce/apex/EmapleContactListController.getContactList";


const DEFAULT_COLUMNS = [
    
    /* TODO: 보여 줄 컬럼을 넣어주세요 */
    // 참고 : https://developer.salesforce.com/docs/component-library/bundle/lightning-datatable/documentation
    
    { label: 'Name',                        fieldName: 'contactUrl',                        type : 'url',   
            typeAttributes: {label: { fieldName: 'Name' }, value:{fieldName: 'Name'}, target: '_blank'}
    }
    , { label: 'Phone',               fieldName: 'Phone',               type : 'phone'}
    /*
    {type: 'action', typeAttributes: { rowActions: this.rowActions }} //TODO : rowaction 을 넣어 eidt 과 delete 해보기
    , ...
    */
];

export default class EmapleContactList extends NavigationMixin(LightningElement){
    
    //Salesforce lwc 에서 기본적으로 받아주는 api : 필요할 때만 사용됩니다
    @api recordId;
    @api objectApiName;

    //
    @track isShowSpinner = false;

    columns = DEFAULT_COLUMNS; // 보여질 columns 정보
    contactList = []; // List 에 보여질 데이터
    
    @track hasContactList = false;
    @track rowCount = 0;

    rowActions = [
        { label: 'Edit', name: 'edit' },
        { label: 'Delete', name: 'delete' },
    ];

    connectedCallback(){
        console.log('test');
        this.getContactList();
    }

    // 참고 : https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.apex 혹은 goole 에 lwc apex method call 요런식으로 검색, trailhead 에도 있을 텐데 찾으면 첨부해드릴게요.
    getContactList(){
        this.isShowSpinner = true;
        getContactList()
        .then(result => {
            console.log('result :' , result);
            if(result){
                this.hasContactList = true;
                this.rowCount = result.length;

                // map 사용
                this.contactList = result.map(item => {
                    let contactUrl = '/'+item.Id;
                    return {...item, contactUrl};
                });

                /*

                // forEach 사용
                this.contactList = result;
                this.contactList.forEach( item => {
                    item['contactUrl'] ='/' + item['Id'];
                });

                */

            }
        })
        .catch(errors => {
            console.log('Error ::', errors.message);
        }).finally(() => {
            this.isShowSpinner = false;
        });
    }

    refreshData(){
        this.getContactList();
    }
    
    rowactionHandler(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'edit':
                console.log('edit click', JSON.parse(JSON.stringify(row)));
                //this.navigateToRecordEditPage(row);
                break;

            case 'delete':
                console.log('delete click', JSON.parse(JSON.stringify(row)));
                //this.deleteRecord(row); //TODO : Delete 버튼 눌렀을 때
                break;     
        }
    }

    showNewModal(){
        console.log('New Button click');

        //TODO : New 버튼을 눌렀을 때 해줄 행동, 참고 해서 Edit 버튼을 눌렀을 때 행동
        // 참고 : https://developer.salesforce.com/docs/component-library/bundle/lightning-navigation/documentation
        
        this.navigateToNewRecordPage();
    }

    navigateToNewRecordPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new'
            }
        });
    }

    navigateToRecordEditPage(){
        //...
    }

}