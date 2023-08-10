import { LightningElement,api,track,wire } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import caccCconRelatedList from '@salesforce/apex/CaccountListController.caccCconRelatedList';
import deleteCcont from '@salesforce/apex/CcontactListController.deleteCcont';
import recordNewModal from "c/caccRelateNew";

const ROW_ACTION = [
    // {label: 'Edit',name: 'edit'}, 
    {label: 'Delete',name: 'delete'}
];
const CCOntactColumns=[
    {label: 'LastName',fieldName:"Name"},
    {label: 'Email', fieldName:"Email__c"},
    {label: 'Phone', fieldName:"Phone__c"},
    {label: 'Title', fieldName:"Title__c"},
    {type: 'action',typeAttributes: {rowActions: ROW_ACTION}}
    
]

export default class CaccRelate extends LightningElement {
   
    @track ccontactLink
    @track caccList=[]
    
    @api recordId
    @track showSecondCode = false;
    caccColumns =CCOntactColumns;
    connectedCallback() {
        this.caccCconRelatedList();
        //console.log('recordNewModal',this.recordNewModal);
        this.ccontactLink = this.generateCcontactLink();
    }
    caccCconRelatedList(){
        caccCconRelatedList({ recordId: this.recordId })
        .then(result => {
            console.log('caccCconRelatedList -> ', JSON.stringify(result));
            this.caccList = result.map(item => {
                return {
                    id: item.Id,
                    isChecked: false,
                    accountId: item.CaccountId__c,
                    Name: item.Name,
                    Email__c: item.Email__c,
                    Phone__c: item.Phone__c,
                    Title__c: item.Title__c
                };
            });
            recordNewModal.setCaccList(this.caccList);
        })
            // .then(result => {
            //     console.log('caccList -> ', JSON.stringify(result));
            //     this.caccList = result;
            //     // 결과 처리 및 로직 실행
            // })
            .catch(error => {
                // 오류 처리 로직
                console.log('[ERROR]: ', error);
            });
        }
    generateCcontactLink() {
        return this.recordId
            ? `/lightning/r/Caccount__c/${this.recordId}/related/Ccontact__r/view`
            : '';
    }
    newhandler(e){
        recordNewModal.open({
              recordId  : this.recordId
             ,label : 'test'
             ,caccList: this.caccList
        })
        .then(result => {
            console.log('modal close result => ', result);
            if(result == 'saved'){
                this.caccCconRelatedList();
            }
        });

    }
    rowactionHandler(e){
        const action = e.detail.action;
        const rowid = e.detail.row.id;
        const row = e.detail.row;
        switch (action.name) {
            case 'edit':
                console.log('edit click', JSON.parse(JSON.stringify(row)));
                // this.navigateToRecordEditPage(row);
                // this[NavigationMixin.Navigate]({
                //     type: 'standard__recordPage',
                //     attributes: {
                //         recordId:row,
                //         objectApiName: 'Opportunity',
                //         actionName: 'edit'
                //     }
                // });
                break;
            case 'delete':
                console.log('delete click', rowid);
                this.deleteCcont(rowid); //TODO : Delete 버튼 눌렀을 때
                break;     
            }

    }

    deleteCcont(rowid) {
        console.log('deleteCcont start >>>>>>>>>>');
        console.log('if start >>>>>>>>>>');
        deleteCcont({ caccId:rowid })
        .then(result => {
            this.caccCconRelatedList();
        })
        .catch(errors => {
            console.log('[Delete ERROR]: ', errors);
        });
        
    }

    
    handleEditClick(e) {
        // 편집 버튼 클릭 이벤트 처리 로직
        const itemId = e.target.dataset.id;
        // 편집할 아이템 식별 및 처리
    }
    
    toggleDropdown(e) {
        event.preventDefault();
        this.dropdownClass = 'slds-dropdown slds-dropdown_right';
    }
    
    closeDropdown() {
        this.dropdownClass = 'slds-dropdown slds-dropdown_right slds-hide';
    }
   
}