import { LightningElement, track } from 'lwc';
import getSalesforcePath from '@salesforce/apex/SalesforcePathByRole.getSalesforcePath'
import genericErrorMessage_lbl from '@salesforce/label/c.GenericErrorMessage_lbl';

export default class SalesforceCertificationDetailTable extends LightningElement {
    roles;

    // error message, when set will render the error panel
    errorMsg;

    connectedCallback(){
        getSalesforcePath()
        .then(response => {
            if(response){
                this.roles = response;
            }else{

            }
        })
        .catch(error => {
            console.log('Error -->', error);
            this.errorMsg = error.body.message;
        })
    }

    get genericErrorMessage() {
        return genericErrorMessage_lbl;
    }
}