import { LightningElement, api, track } from 'lwc';

import caccCconRelatedList from '@salesforce/apex/CaccountListController.caccCconRelatedList';
import deleteCcontact from '@salesforce/apex/CaccountListController.deleteCcontact';
import recordNewModal from "c/caccCconNew1";



// const 

export default class CaccCconRelatedList extends LightningElement {


    @api recordId;

    @track caccId;

    @track cconList = [];

    isModalOpen = false;

    // TableColumns = TableColumns;

    TableColumns = [
        {label:'lastName' , fieldName:'Name', type: 'text',  cellAttributes: { alignment: 'center' }},
        {label:'Email' , fieldName:'Email__c', type: 'text',   cellAttributes: { alignment: 'center' }},
        { type: 'action', typeAttributes:{rowActions: this.actions},cellAttributes: { alignment: 'left' }}
    ];

    connectedCallback(){
        
       this.initData();
    }

    initData(){
        caccCconRelatedList({ recordId: this.recordId })
        .then(result => {
           console.log('result ' , result);
           this.cconList = result;
       
        })
        .catch(error => {
            console.log('error: ', error);
        }); 
    }
 
   
    
    get actions(){
        let actionAttributes = [];
   
        actionAttributes.push({label:'Edit', name: 'show_details'});
                
        actionAttributes.push({label:'Delete', name: 'delete'})
            
        return actionAttributes;
    }



    newhandler(e){
        recordNewModal.open({

        });
    }

    handleRowAction(e){
        const actionName = e.detail.action.name;
        const row = e.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            case 'show_details':
                this.showRowDetails(row);
                break;
            default:
                break;
        }
    }


    deleteId = '';
    deleteRow(row){
        console.log('row',row.Id);

        this.isModalOpen = true;
        this.deleteId = row.Id;
    }


    closeModal(){
        this.isModalOpen = false;
    }

    deletehandler(){

        deleteCcontact({ CconId: this.deleteId })
                .then(result => {
                    
                    console.log('ㅇㅇㅋ');
               
                })
                .catch(error => {
                    console.log('error: ', error);
                });

        this.initData();
        this.isModalOpen = false;

     
    }

}