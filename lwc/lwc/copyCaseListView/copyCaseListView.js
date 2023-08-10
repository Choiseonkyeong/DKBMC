import { LightningElement, track,api,wire } from 'lwc';
import getCaseList from '@salesforce/apex/CopyCaseController.getCaseList'
import getOpenCases from '@salesforce/apex/CopyCaseController.getOpenCases'
import getClosedCases from '@salesforce/apex/CopyCaseController.getClosedCases'
import updateCopyCase from '@salesforce/apex/CopyCaseController.updateCopyCase'

import COPYCASE_OBJECT from '@salesforce/schema/CopyCase__c';
import TYPE_FIELD from '@salesforce/schema/CopyCase__c.Status__c';
import deleteCopyCase from '@salesforce/apex/CopyCaseController.deleteCopyCase'
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

import recordNewModal from 'c/copyCaseNew';
import recordEditModal from 'c/copyCaseEdit';



const ROW_ACTION = [
    {label: 'Edit',name: 'edit'}, 
    {label: 'Delete',name: 'delete'}


];
const columns = [
    { label: 'Name', fieldName: 'CopyCaseURL', type: 'url',editable: true,
    typeAttributes: {label: {fieldName: 'Name'}}},
    { label: 'Subject', fieldName: 'Subject__c', type: 'text',editable: true },
    { label: 'Status',fieldName: 'Status__c', type: 'picklistColumn', editable: true, typeAttributes: {
        placeholder: '---NONE---', options: { fieldName: 'pickListOptions' }, 
        value: { fieldName: 'Status' }, // 픽리스트의 기본값
        context: { fieldName: 'Id' }  // 계정 ID를 반환할 컨텍스트 변수와 연결
    }},
    { label: 'Date/Time Opend', fieldName: 'CreatedDate', type: 'date',editable: true,
    typeAttributes: {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        hour12: true
    }
},
    { label: 'Case Owner Alias', fieldName: 'OwnerName', type: 'text'},
    {label: 'Account Name ',fieldName: 'CAccountName',type: 'url',editable: true,
    typeAttributes: {label: {fieldName: 'CaccName'}}},
    {type: 'action',typeAttributes: {rowActions: ROW_ACTION}}
];
 
const OPEN_CASES = 'All Open Cases';
const CLOSED_CASES = 'All Closed Cases';
const ALL_CASES = 'All';
 
const filterOptions = [
    { value: OPEN_CASES, label: OPEN_CASES },
    { value: CLOSED_CASES, label: CLOSED_CASES },
    { value: ALL_CASES, label: ALL_CASES },
];
 
 
export default class copyCaseListView extends LightningElement {
    isShow =false;

    @track currentFilter = ALL_CASES;
    @track isExpanded = false;

    // @track pickListOptions = [];
    // @track itemsForCurrentView = allItems;
    @track isLoaded = false;
    @api recordId;
    filterOptions = filterOptions;
    columns = columns;
    lastSavedData = [];
    @track dataList=[];
    @track draftValues = [];
    @track copyCaseList = [];
    @track nameValue = '';
    @track subjectValue = '';
    @track statusValue = '';
    @track pickListOptions;
    @track Name;
    @track OwnerName;
    @track CaccName;


    connectedCallback() {
        this.isLoaded = true;
        if (this.currentFilter === ALL_CASES) {
            this.getCaseList("");
        } else if (this.currentFilter === OPEN_CASES) {
            this.getOpenCases();
        } else if (this.currentFilter === CLOSED_CASES) {
            this.getClosedCases();
        }
    }
  
    @wire(getObjectInfo, { objectApiName: COPYCASE_OBJECT })
    objectInfo;

    // 픽리스트 옵션 가져오기
    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: TYPE_FIELD
    })
    wirePickList({ error, data }) {

        if (data) {
            console.log('data' , data.values);
            this.pickListOptions = data.values;
        } else if (error) {
            console.error('wirePickList:', error);
        }
    }

    // 픽리스트 옵션을 전달하여 위 메서드 호출
    @wire(getCaseList, { pickList: '$pickListOptions' })
    accountData(result) {
        this.accountData = result;
        console.log('accountData',this.accountData);
        if (result.data) {
            this.dataList = JSON.parse(JSON.stringify(result.data));
            console.log('0000>',JSON.stringify(this.dataList));
            this.dataList.forEach(ele => {
                ele.pickListOptions = this.pickListOptions;
                ele.OwnerName = ele.Owner.Name;
                ele.Name = ele.Name;
                ele.CopyCaseURL = 'https://dkbmc55-dev-ed.develop.lightning.force.com/lightning/r/CopyCase__c /'+ ele.Id + '/view';
                ele.CAccountName = 'https://dkbmc55-dev-ed.develop.lightning.force.com/lightning/r/Caccount__c/'+ele.CaccountId__c +'/view';
                ele.CaccName = ele.CaccountId__r.Name;
            })
            this.lastSavedData = JSON.parse(JSON.stringify(this.dataList));
            console.log('this.lastSavedData', this.lastSavedData);

        } else if (result.error) {
            console.error('e',result.error);
            this.dataList = undefined;
        }
    };


    handleInputChange(event) {
        const nameValue = event.target.label === 'Name' ? event.target.value : this.nameValue;
        const subjectValue = event.target.label === 'Subject' ? event.target.value : this.subjectValue;
        const statusValue = event.target.label === 'Status' ? event.target.value : this.statusValue;
    
        this.nameValue = nameValue;
        this.subjectValue = subjectValue;
        this.statusValue = statusValue;
    }
    handleSearch(e) {
       
        const searchTerm = this.getSearchTerm();
        console.log('searchTerm: ', searchTerm);
        this.getCaseList(searchTerm);
    }
    getSearchTerm() {
        const nameValue = this.nameValue ? this.nameValue.trim() : '';
        const subjectValue = this.subjectValue ? this.subjectValue.trim() : '';
        const statusValue = this.statusValue ? this.statusValue.trim() : '';
    
        if (nameValue !== '') {
            return nameValue;
        } else if (subjectValue !== '') {
            return subjectValue;
        } else if (statusValue !== '') {
            return statusValue;
        } 
    }

    
    getSearchTerm() {
        const nameValue = this.nameValue ? this.nameValue.trim() : '';
        const subjectValue = this.subjectValue ? this.subjectValue.trim() : '';
        const statusValue = this.statusValue ? this.statusValue.trim() : '';
    
        // 검색어를 확인하고, 빈 값이 아닌 필드를 우선순위로 사용합니다.
        if (nameValue !== '') {
            return nameValue;
        } else if (subjectValue !== '') {
            return subjectValue;
        } else if (statusValue !== '') {
            return statusValue;
        } else {
            return '';
        }
    }
    getCaseList(searchTerm) {
        if (searchTerm === '') {
            // 검색어가 없을 경우 모든 데이터를 가져옵니다.
            getCaseList({ searchValue: '' })
                .then(result => {
                    console.log('null getCaseList ->dfasdfsfsdaf ', JSON.stringify(result));
                    this.isLoaded = true;
                    if (result && result.length > 0) {
                        this.copyCaseList = JSON.parse(JSON.stringify( result));
                        // this.dataList = [...this.copyCaseList];
                        // console.log('11111????????',JSON.stringify(this.dataList));
                        // this.dataList.forEach(item => {
                        //     item.OwnerName = item.Owner.Name;
                        //     item.CopyCaseURL ='https://dkbmc55-dev-ed.develop.lightning.force.com/lightning/r/CopyCase__c/' + item.Id + '/view';
                        //     item.CaccName = item.CaccountId__r.Name;
                        //     item.CAccountName = 'https://dkbmc55-dev-ed.develop.lightning.force.com/lightning/r/Caccount__c/' + item.CaccountId__c + '/view';
                            
                        // });
                        this.updateDataList(this.copyCaseList);
                       
                    } else {
                        this.copyCaseList = []; // 검색 결과가 없는 경우 빈 배열로 초기화
                        this.dataList = [...this.copyCaseList];
                        console.log('222????????',this.dataList);
                    }
                })
                .catch(errors => {
                    console.log('[ERROR]: ', errors);
                });
        } else {
            // 검색어가 있을 경우 해당 검색어에 맞는 데이터를 가져옵니다.
            getCaseList({ searchValue: searchTerm })
                .then(result => {
                    console.log('not null getCaseList -> ', JSON.stringify(result));
                    this.isLoaded = true;

             

                    this.copyCaseList = JSON.parse(JSON.stringify(result));

                    this.updateDataList(this.copyCaseList);
                       
                    console.log('12121212',JSON.stringify(this.dataList));

                    // this.dataList.forEach(item => {
                    //     // item.Name =item.Name;
                    //     item.CopyCaseURL ='https://dkbmc55-dev-ed.develop.lightning.force.com/lightning/r/CopyCase__c/' + item.Id + '/view';
                    //     item.OwnerName= item.Owner.Name;
                    // });

                    console.log('33333',JSON.stringify(this.dataList));

                })
                .catch(errors => {
                    console.log('[ERROR]: ', errors);
                });
        }
    }
    // 반복되는 부분 함수로 정리
    updateDataList(data) {
        data.forEach(item => {
          item.OwnerName = item.Owner.Name;
          item.CopyCaseURL = 'https://dkbmc55-dev-ed.develop.lightning.force.com/lightning/r/CopyCase__c/' + item.Id + '/view';
          item.CaccName = item.CaccountId__r.Name;
          item.CAccountName = 'https://dkbmc55-dev-ed.develop.lightning.force.com/lightning/r/Caccount__c/' + item.CaccountId__c + '/view';
        });
        this.dataList = data;
      }
    
    
      newhandler(e){
        recordNewModal.open({
              recordId  : this.recordId
        })
        .then(result => {
            console.log('modal close result => ', result);
            if(result == 'saved'){
                this.getCaseList();
            }
        });

    }
  
    
      getOpenCases(){
        getOpenCases({})
          .then(result => {
            console.log('getOpenCases -> ', JSON.stringify(result));
            this.isLoaded = true;
            this.copyCaseList = JSON.parse(JSON.stringify(result));
            this.updateDataList(this.copyCaseList);
            // recordNewModal.setCaccList(this.copyCaseList);
          })
          .catch(errors => {
            console.log('[ERROR]: ', errors);
          });
      }

      getClosedCases(){
        getClosedCases()
        .then(result => {
          console.log('getClosedCases -> ', JSON.stringify(result));
          this.isLoaded = true;
          this.copyCaseList = JSON.parse(JSON.stringify(result));
            this.updateDataList(this.copyCaseList);
        // recordNewModal.setCaccList(this.copyCaseList);
        })
        .catch(errors => {
          console.log('[ERROR]: ', errors);
        });
      }
 
    get dropdownTriggerClass() {
        return this.isExpanded
        ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click custom_list_view slds-is-open'
        : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click custom_list_view';
    }
    
    rowactionHandler(event) {
        const action = event.detail.action;
        const row = event.detail.row.Id;
        console.log('셀선택');
        switch (action.name) {
            case 'edit':
                console.log('edit click', JSON.parse(JSON.stringify(row)));
                recordEditModal.open({ recordId: row })
                .then(result => {
                    console.log('modal close result => ', result);
                    location.reload();
                });
                break;
            case 'delete':
                console.log('delete click', JSON.parse(JSON.stringify(row)));
                this.deleteCopyCase(row); //TODO : Delete 버튼 눌렀을 때
                break;     
            }
    }

    deleteCopyCase(row){
        this.isShowSpinner =true;
            deleteCopyCase({recordId:row})
            .then(result =>{
                console.log('record id', this.recordId);
                this.getCaseList();
            }) .catch(errors => {
                console.log('[Delte ERROR]: ', errors);
        })
        
        const rows = this.copyCaseList;
        const rowIndex = rows.indexOf(row);
        rows.splice(rowIndex,1);
        this.copyCaseList =rows;
        this.dataList = this.copyCaseList;
        console.log('delete copyCaseList',this.dataList);
    }
    handelSave(e) {
        // 먼저 업데이트할 필드 값들을 가져옵니다.
        const updatedFields = e.detail.draftValues;
    
        // 업데이트할 필드 값들을 출력하여 확인합니다.
        console.log('handelSave', JSON.stringify(updatedFields));
        // 각 업데이트 필드에 대해 반복 처리합니다.
        updatedFields.forEach(item => {
            console.log('55555',item);
            // 수정된 부분: 아이템을 JSON 문자열로 변환합니다.
            const jsonStr = JSON.stringify(item);
            console.log('6666', typeof(jsonStr));
            console.log('6666',jsonStr);
            // JSON 문자열을 서버로 전달하여 업데이트 작업을 수행합니다.
            updateCopyCase({ jsonStr })
                .then(result => {
                    // 업데이트가 성공적으로 완료되면 결과를 출력합니다.
                    console.log('updateCopyCase -> ', JSON.stringify(result));
                })
                .catch(errors => {
                    // 오류 발생 시 오류 메시지를 출력합니다.
                    console.log('[updateCopyCase ERROR]: ', errors);
                });
    
        });
    
        // 모든 변경사항이 수신되면, 변경사항을 저장하고 모든 편집 요청 상태를 정리합니다.
        this.saveDraftValue =[];
        location.reload();
    }
    
    handleCancel(event) {
        //remove draftValues & revert data changes
        this.dataList = JSON.parse(JSON.stringify(this.lastSavedData));
        this.draftValues = [];
        console.log('클릭됨');
    }
    
    

 
    handleFilterChangeButton(event) {
        this.isLoaded = false;
        let filter = event.target.dataset.filter;
        this.isExpanded = !this.isExpanded;
        if (filter !== this.currentFilter) {
            this.currentFilter = filter;
            if (this.currentFilter === ALL_CASES) {
                this.getCaseList();
            } else if (this.currentFilter === OPEN_CASES) {
                this.getOpenCases();
            } else if (this.currentFilter === CLOSED_CASES) {
                this.getClosedCases();
            }
        } else {
            this.isLoaded = true;
        }
    }

 
    handleClickExtend() {
        this.isExpanded = !this.isExpanded;
    }
}