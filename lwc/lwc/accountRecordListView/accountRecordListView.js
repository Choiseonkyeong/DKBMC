/**
 * @description       : 
 * @author            : dawon.kim@dkbmc.com
 * @group             : 
 * @last modified on  : 02-17-2023
 * @last modified by  : yejoo00.lee@partner.samsung.com
**/
import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getAccountList from '@salesforce/apex/AccountRecordListViewController.getAccountList';
import deleteAccountRecord from '@salesforce/apex/AccountRecordListViewController.deleteAccountRecord';

const ROW_ACTION = [
    {label: 'Edit', name: 'edit'},
    {label: 'Delete', name: 'delete'}
];

export default class AccountRecordListView extends NavigationMixin(LightningElement) {
    // lwc에서 기본적으로 받아주는 api
    @api recordId;
    @api objectApiName;

    @track isLoaded = false;
    @track hasAccountList = false;
    @track rowCount = 0;

    // table 정렬 시 사용할 변수
    @track sortBy;
    @track sortDirection;

    // 화면에 띄울 데이터 List
    accountList = [];
    rowActions = ROW_ACTION;

    // Table column setting
    columns = [
        {label: 'Name', fieldName: 'AccountURL', type: 'url', sortable: true,
        typeAttributes: {label: {fieldName: 'Name'}}},
        {label: 'Billing State/Province', fieldName: 'BillingState', type: 'String', sortable: true},
        {label: 'Type', fieldName: 'Type', type: 'Picklist', sortable: true},
        {label: 'Phone', fieldName: 'Phone', type: 'Phone'},
        {
                type: 'action', 
                typeAttributes: {rowActions: this.rowActions}}
    ];

    connectedCallback(){
        this.isLoaded = true;
        this.getAccountList();
        this.isLoaded = false;
    }

    refreshAccountList(){
        this.getAccountList();
    }

    // get record list view data
    getAccountList(){
        this.isLoaded = true;
        getAccountList()
        .then(result => {
            console.log('accountList -> ', JSON.stringify(result));
            if(result != null && result != ''){
                this.hasAccountList = true;
                this.accountList = result;
                this.rowCount = this.accountList.length;
                if(this.accountList){
                    this.accountList.forEach(item =>
                        item['AccountURL']='https://dkbmc-ca-dev-ed.develop.my.site.com/dawonexcloudtest/s/detail/' + item['Id']);
                }
            }
        }) .catch(errors => {
            console.log('[ERROR]: ', errors);
        }) .finally(() => {
            this.isLoaded = false;
        });
    }

    // new record
    showNewAccountModal(){
        console.log('create new account record');
        this.navigateToNewRecordPage();
    }

    navigateToNewRecordPage(){
        // 기본 필드값 설정 (ex)Owner
        // const defaultFieldValue = encondeDefaultFieldValues({

        // });
        // 페이지 이동
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName : 'new'
            }
        })
    }

    // actionName이 edit : 레코드 편집
    // actionName이 delete : 레코드 삭제
    handleRowAction(event){
        const action = event.detail.action;
        const rowId = event.detail.row.Id;
        this.recordId = rowId;
        switch(action.name){
            case 'edit':
                console.log('Edit account record', JSON.stringify(rowId));
                this.navigateToEditRecordPage();
                break;

            case 'delete':
                console.log('Delete Account Record', JSON.stringify(rowId));
                this.deleteAccountRecord(rowId);
                break;
        }
    }

    navigateToEditRecordPage(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Account',
                actionName: 'edit'
            }
        });
    }

    deleteAccountRecord(rowId){
        this.isLoaded = true;
        this.recordId = rowId;
        const WARNING_MSG = 'Do you want to delete this account record?\n ※ if you delete this record,  you will not be able to use it.';
        if(confirm(WARNING_MSG) == true){
            deleteAccountRecord({recordId: this.recordId})
            .then(result => {
                console.log('Delete Account Record ->', this.recordId);
                this.getAccountList();
            }) .catch(errors => {
                console.log('Delete Account Record Error ->', errors);
            }). finally(() => {
                this.isLoaded = false;
            })
        } else {
            this.isLoaded = false;
            return;
        }
        
    }

    handleSortAccount(event){
        this.isLoaded = true;
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortAccountRecord(this.sortBy, this.sortDirection);
        this.isLoaded = false;
    }

    // fieldName에 따라 선택한 정렬 방식으로 정렬하게 하는 메서드
    sortAccountRecord(fieldName, direction){
        if(this.accountList != '' && this.accountList != null){
            let data = JSON.parse(JSON.stringify(this.accountList));
            // 어떤 fieldName을 정렬하는지
            let keyValue = (a) => {
                return a[fieldName];
            };
            // direction이 오름차순인지 내림차순인지 확인
            let isReverse = direction === 'asc'? 1:-1;

            // 데이터 정렬
            data.sort((x,y) => {
                x = keyValue(x) ? keyValue(x) : '';
                y = keyValue(y) ? keyValue(y) : '';

                return isReverse *((x > y)-(y > x));
            });
            // 정렬 완료된 데이터를 accountList에 담기
            this.accountList = data;
        }
    }
}