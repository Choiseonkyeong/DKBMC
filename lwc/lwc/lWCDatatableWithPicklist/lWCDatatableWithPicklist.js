import { LightningElement, track, wire } from 'lwc';
// import getCopyCaseList from '@salesforce/apex/CustomDataTableController.getCopyCaseList';
import getCaseList from '@salesforce/apex/CopyCaseController.getCaseList'
import COPYCASE_OBJECT from '@salesforce/schema/CopyCase__c';
import TYPE_FIELD from '@salesforce/schema/CopyCase__c.Status__c';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

// 행 동작
const ROW_ACTION = [
    {label: 'Edit',name: 'edit'}, 
    {label: 'Delete',name: 'delete'}
];

const columns = [
    { label: 'Name', fieldName: 'CopyCaseURL', type: 'url', editable: true,
    typeAttributes: {label: {fieldName: 'Name'}}},
    { label: 'Subject', fieldName: 'Subject__c', type: 'text', editable: true },
    {
        label: 'Status', fieldName: 'Status', type: 'picklistColumn', editable: true, typeAttributes: {
            placeholder: '상태 선택', options: { fieldName: 'pickListOptions' }, 
            value: { fieldName: 'Status' }, // 픽리스트의 기본값
            context: { fieldName: 'Id' } // 계정 ID를 반환할 컨텍스트 변수와 연결
        }
    },
    { label: 'Date/Time Opend', fieldName: 'CreatedDate', type: 'date', editable: true,
    typeAttributes: {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        hour12: true
    }
},
    { label: 'Case Owner Alias', fieldName: 'OwnerName', type: 'text', editable: true},
    {label: 'Account Name ', fieldName: 'CAccountName', type: 'url', editable: true,
    typeAttributes: {label: {fieldName: 'CaccName'}}},
    {type: 'action', typeAttributes: {rowActions: ROW_ACTION}}
];

export default class CustomDatatableDemo extends LightningElement {
    columns = columns;
    showSpinner = false;
    @track data = [];
    @track accountData;
    @track draftValues = [];
    lastSavedData = [];
    @track pickListOptions;

    @wire(getObjectInfo, { objectApiName: COPYCASE_OBJECT })
    objectInfo;

    // 픽리스트 옵션 가져오기
    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: TYPE_FIELD
    })
    wirePickList({ error, data }) {
        if (data) {
            this.pickListOptions = data.values;
            console.log('data' , data.values);
        } else if (error) {
            console.error('wirePickList:', error);
        }
    }

    // 픽리스트 옵션을 전달하여 위 메서드 호출
    @wire(getCaseList, { pickList: '$pickListOptions' })
    accountData(result) {
        this.accountData = result;
        if (result.data) {
            this.data = JSON.parse(JSON.stringify(result.data));            
            this.data.forEach(ele => {
                ele.pickListOptions = this.pickListOptions;
            })

            this.lastSavedData = JSON.parse(JSON.stringify(this.data));

        } else if (result.error) {
            console.error(result.error);
            this.data = undefined;
        }
    };

    // 데이터 값 업데이트
    updateDataValues(updateItem) {
        let copyData = JSON.parse(JSON.stringify(this.data));

        copyData.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });

        // 변경 내용을 원래 데이터에 적용
        this.data = [...copyData];
    }

    // 임시 값 업데이트
    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.draftValues];
        // 변경된 값을 저장하여
        // 저장할 때 인라인 편집을 활성화하고 표준 취소 및 저장 버튼을 표시
        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });

        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }

    // 셀 변경 처리 및 임시 값 업데이트를 위한 핸들러
    handleCellChange(event) {
        let draftValues = event.detail.draftValues;
        draftValues.forEach(ele => {
            this.updateDraftValues(ele);
        })
    }

    // 저장 버튼 핸들러
    handleSave(event) {
        this.showSpinner = true;
        this.saveDraftValues = this.draftValues;

        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        // UiRecordApi를 사용하여 레코드 업데이트
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.showToast('Success', 'Records Updated Successfully!', 'success', 'dismissable');
            this.draftValues = [];
            return this.refresh();
        }).catch(error => {
            console.log(error);
            this.showToast('Error', 'An Error Occured!!', 'error', 'dismissable');
        }).finally(() => {
            this.draftValues = [];
            this.showSpinner = false;
        });
    }

    // 취소 버튼 핸들러
    handleCancel(event) {
        // 임시 값 제거 및 데이터 변경 사항 복원
        this.data = JSON.parse(JSON.stringify(this.lastSavedData));
        this.draftValues = [];
    }

    // 토스트 메시지 표시
    showToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }

    // 데이터 업데이트 후 테이블 새로고침
    async refresh() {
        await refreshApex(this.accountData);
    }
}