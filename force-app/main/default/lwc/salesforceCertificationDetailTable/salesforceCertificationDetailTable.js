import { LightningElement, track } from 'lwc';
import getSalesforcePath from '@salesforce/apex/SalesforcePathByRole.getSalesforcePath'
import genericErrorMessage_lbl from '@salesforce/label/c.GenericErrorMessage_lbl';

export default class SalesforceCertificationDetailTable extends LightningElement {
    @track roles = undefined;

    // error message, when set will render the error panel
    @track errorMsg;

    connectedCallback(){
        getSalesforcePath()
        .then(response=>{
            if(response){
                this.roles = response;
            }else{

            }
        })
        .catch(error=>{
            console.log('Error -->'+error);
            this.errorMsg = error;
        })
    }

    get genericErrorMessage() {
        // note: you can store this in a custom label if you need
        return genericErrorMessage_lbl;
    }
}