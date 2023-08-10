import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import { CloseActionScreenEvent} from 'lightning/actions';

export default class CopyCaseEdit extends LightningModal {
    @api recordId;
    
    
    handleSave() {
        console.log('?????????????????');
        this.template.querySelector( 'lightning-record-edit-form').submit();
        this.close();
    }
    handleCancle(){
        console.log('!!!!!!!!!!!!!!!!');
        this.close();
        // this.dispatchEvent(new CloseActionScreenEvent);
    }
    
}