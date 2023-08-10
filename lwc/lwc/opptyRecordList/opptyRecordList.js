/**
 * @description       : 
 * @author            : yejoo00.lee@partner.samsung.com
 * @group             : 
 * @last modified on  : 02-17-2023
 * @last modified by  : sunkyung.choi@dkbmc.com
**/
import {api, LightningElement, track, wire} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import getOpptyList from '@salesforce/apex/OpptunityRecordListViewController.getOpptyList';
import deleteOppty from '@salesforce/apex/OpptunityRecordListViewController.deleteOppty';
import methodName from '@salesforce/apex/OpptunityRecordListViewController.methodName';


const ROW_ACTION = [
    {label: 'Edit',name: 'edit'}, 
    {label: 'Delete',name: 'delete'}
];
const OPPTYCOLUMNS = [
    {label: 'Name',fieldName: 'OpptyURL', type: 'url',
     typeAttributes: {label: {fieldName: 'Name'}}}, 
    {label: 'Account Name ',fieldName: 'AccountName',type: 'url',
    typeAttributes: {label: {fieldName: 'AcctName'}}}, 
    {label: 'Stage',fieldName: 'StageName',type: 'Picklist'}, 
    {label: 'Close Date',fieldName: 'CloseDate'},
     {type: 'action',typeAttributes: {rowActions: ROW_ACTION}
    }
];

// const ACCCOLUMNS = [     {label: 'Name', fieldName: 'AccountURL', type:
// 'url',     typeAttributes: {label: {fieldName: 'Name'}}},     {label:
// 'Billing State/Province', fieldName: 'BillingState', type: 'String'},
// {label: 'Type', fieldName: 'Type', type: 'Picklist'},     {label: 'Phone',
// fieldName: 'Phone', type: 'Phone'},     {type: 'action',typeAttributes:
// {rowActions: ROW_ACTION}} ];

export default class OpptyRecordList extends NavigationMixin(LightningElement) {
    //Salesforce lwc 에서 기본적으로 받아주는 api : 필요할 때만 사용됩니다
    @api recordId;
    @api objectApiName;

    //
    @track isShowSpinner = false;

    opptyColumns = OPPTYCOLUMNS; // 보여질 columns 정보
    //  accColumns = ACCCOLUMNS;  보여질 columns 정보
    opportunityList = []; // List 에 보여질 데이터
    accountList = []; // List 에 보여질 데이터

    //  @track hasAccountList =false;
    @track hasOpportunityList = false;
    @track rowCount = 0;



    connectedCallback() {
        this.isShowSpinner = true;
        this.getOpptyList();
        this.isShowSpinner = false;

        console.log('sss');

        // methodName({'recordId' : this.recordId})
        // .then(result => {
        //     console.log('return :' , result);
        // }).catch(errors => {
        //     console.log('[ERROR]: ', errors);
        // });

    }

    refreshData() {
        this.isShowSpinner = true;
        this.getOpptyList();
        this.isShowSpinner = false;

    }
    // getAccountList(){      
    //     getAccountList()      
    //     .then(result => {
    //         console.log('accountList -> ', JSON.stringify(result));          
    //         if(result !=null && result != ''){              
    //             this.hasAccountList = true;
    //             this.accountList = JSON.parse(result);              this.rowCount =
    //             this.accountList.length;              
    //             if(this.accountList){
    //                 this.accountList.forEach(item =>
    //                     item['AccountURL']='https://dkbmc-ca-dev-ed.develop.my.site.com/s/detail/' +
    //                     item['Id']);          
    //                 }          
    //             }      
    //         }).catch(errors => {
    //         console.log('[ERROR]: ', errors);      

    //     });  
    // }

    
    opptyList = [];

    getOpptyList(){ 
        getOpptyList()
        .then(result => {
                console.log('OpptyList -> ', JSON.stringify(result));

                this.opptyList = JSON.parse(result);

                for (let i = 0; i < this.opptyList.length; i++) {
                    this.opptyList[i].AcctName = i + this.opptyList[i].AcctName;
                    this.opptyList[i].CloseDate = this.opptyList[i].CloseDate.left(9);
                    
                }

                // console.log();


                if (result != null && result != '') {
                    this.hasOpportunityList = true;
                    this.opportunityList = JSON.parse(result);
                    this.rowCount = this.opportunityList.length;
                    if (this.opportunityList) {
                        this.opportunityList.forEach( item => {
                            item['OpptyURL'] ='https://dkbmc-ca-dev-ed.develop.my.site.com/s/detail/' + item['Id'];
                            item['AccountName'] = 'https://dkbmc-ca-dev-ed.develop.my.site.com/s/detail/'+item['AcctId'];
                        });
                        console.log('opportunityList -> ', this.opportunityList);
                    }
                }
            }).catch(errors => {
                console.log('[ERROR]: ', errors);
            });
        }
     
        showNewModal(){
            console.log('New Button click');
            this.navigateToNewRecordPage();
        }
    
        navigateToNewRecordPage() {
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Opportunity',
                    actionName: 'new'
                }
            });
        }
        // navigateToRecordEditPage(row){
        //     this[NavigationMixin.Navigate]({
        //         type: 'standard__recordPage',
        //         attributes: {
        //             recordId:row,
        //             objectApiName: 'Opportunity',
        //             actionName: 'edit'
        //         }
        //     });
        // }

        rowactionHandler(event) {
            const action = event.detail.action;
            const row = event.detail.row.Id;

            switch (action.name) {
                case 'edit':
                    console.log('edit click', JSON.parse(JSON.stringify(row)));
                    // this.navigateToRecordEditPage(row);
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId:row,
                            objectApiName: 'Opportunity',
                            actionName: 'edit'
                        }
                    });
                    break;
                case 'delete':
                    console.log('delete click', JSON.parse(JSON.stringify(row)));
                    this.deleteOppty(row); //TODO : Delete 버튼 눌렀을 때
                    break;     
                }
        }
        deleteOppty(row){
            this.showNewModal =true;
            this.recordId = row;
            if(recordId == this.recordId){
                deleteOppty({recordId:this.recordId})
                .then(result =>{
                    this.getOpptyList;
                }) .catch(errors => {
                    console.log('[Delte ERROR]: ', errors);
            })}
            
            // const rows = this.opportunityList;
            // const rowIndex = rows.indexOf(row);
            // rows.splice(rowIndex,1);
            // this.opportunityList =rows;
            console.log('delete opportunityList',this.opportunityList);
        }
}