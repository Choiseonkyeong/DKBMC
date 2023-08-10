import { LightningElement,api,track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class CaseClose extends LightningElement {

    @api recordId;

    handleSave(){
        this.template.querySelector('lightning-record-edit-form').submit();
        this.dispatchEvent(new CloseActionScreenEvent);
    }
    handleCancle(){
        this.dispatchEvent(new CloseActionScreenEvent);
    }

}