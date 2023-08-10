import { api,LightningElement } from 'lwc';

export default class Demolwc extends LightningElement {
    @api buttonText;

    handleclick(){
        alert("hello");
    } 
}